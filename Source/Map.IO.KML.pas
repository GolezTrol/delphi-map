unit Map.IO.KML;

interface

uses
  Classes, SysUtils,
  XMLDoc, Xml.XMLIntf, XMLDom, Xml.omnixmldom,
  Map,
  Map.IO.Intf,
  Map.Factory.Area.Intf;

type
  TKMLMapStreamReader = class(TInterfacedObject, IMapStreamReader)
  protected
    FAreaFactory: IAreaFactory;
    function LoadArea(node: IDOMNode): IArea;
    function ParsePolygon(coordinates: string): TPolygon;
  protected //IMapStreamReader
    function ReadMap(Stream: TStream): TMap;
  public
    constructor Create(AreaFactory: IAreaFactory);
  end;

implementation

constructor TKMLMapStreamReader.Create(AreaFactory: IAreaFactory);
begin
  FAreaFactory := AreaFactory;
end;

function TKMLMapStreamReader.LoadArea(node: IDOMNode): IArea;
var
  select: IDOMNodeSelect;
  postalcode: String;
  polygonNodes: IDOMNodeList;
  shapes: TShapeArray;
  i: Integer;
  pn: IDOMNode;
begin
  select := (node as IDOMNodeSelect);
  // TODO: Specific PC4, either get rid of it, or name the class accordingly.
  postalcode := (select.selectNode('ExtendedData/SchemaData/SimpleData[@name="PC4"]') as IDOMNodeEx).text;
  polygonNodes := select.selectNodes('MultiGeometry/Polygon');

  setLength(shapes, polygonNodes.length);
  for i := 0 to polygonNodes.length - 1 do
  begin
    select := (polygonNodes[i] as IDOMNodeSelect);
    pn := select.selectNode('.//outerBoundaryIs/LinearRing/coordinates');
    shapes[i] := ParsePolygon(
      (pn as IDOMNodeEx).text);
  end;

  Result := FAreaFactory.CreateArea(postalcode, shapes);
end;

function TKMLMapStreamReader.ParsePolygon(coordinates: string): TPolygon;
var
  sl: TStringList;
  s: String;
  point: TLatLon;
  i: Integer;
begin
  sl := TStringList.Create;
  try
    sl.Delimiter := ' ';
    sl.StrictDelimiter := True;
    sl.DelimitedText := coordinates;

    SetLength(Result, sl.Count);

    for i := 0 to sl.Count - 1 do
    begin
      s := sl[i];
      point.Lon := StrToFloat(Copy(s, 1, Pos(',', s)-1), TFormatSettings.Invariant);
      point.Lat := StrToFloat(Copy(s, Pos(',', s)+1, Length(s)), TFormatSettings.Invariant);
      Result[i] := point;
    end;
  finally
    sl.Free;
  end;
end;

function TKMLMapStreamReader.ReadMap(Stream: TStream): TMap;
var
  doc: IXMLDocument;
  places: IDOMNodeList;
  select: IDomNodeSelect;
  i: Integer;
begin
  Result := TMap.Create;
  try
    // MS XML doesn't handle // searches very well in namespaced documents.
    DefaultDOMVendor := sOmniXmlVendor;

    doc := TXMLDocument.Create(nil);
    doc.LoadFromStream(Stream);
    select := doc.DocumentElement.DOMNode as IDOMNodeSelect;

    places := select.selectNodes('//kml/Document/Folder/Placemark');

    setlength(Result.Areas, places.length);
    for i := 0 to places.length - 1 do
      Result.Areas[i] := LoadArea(places.item[i]);
  except
    Result.Free;
  end;
end;

end.
