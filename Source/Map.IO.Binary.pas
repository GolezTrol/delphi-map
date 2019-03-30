unit Map.IO.Binary;

interface

uses
  Classes,
  Map,
  Map.IO.Intf,
  Map.Factory.Area.Intf;

type
  TBinMapStreamReader = class(TInterfacedObject, IMapStreamReader)
  protected
    FAreaFactory: IAreaFactory;
    function ReadMap(Stream: TStream): TMap;
  public
    constructor Create(AreaFactory: IAreaFactory);
  end;

  TBinMapStreamWriter = class(TInterfacedObject, IMapStreamWriter)
  protected
    procedure WriteMap(Map: TMap; Stream: TStream);
  end;

implementation

constructor TBinMapStreamReader.Create(AreaFactory: IAreaFactory);
begin
  FAreaFactory := AreaFactory;
end;

function TBinMapStreamReader.ReadMap(Stream: TStream): TMap;
var
  r: TReader;
  a: Integer;
  p: Integer;
  len: Integer;
  code: String;
  shapes: TShapeArray;
  l: Integer;
begin
  Result := TMap.Create;
  try
    r := TReader.Create(Stream, 4096);
    try
      // Check header and version
      if r.ReadStr <> 'JVIMAP' then raise EStreamError.Create('Invalid header');
      if r.ReadInteger <> 1 then raise EStreamError.Create('Unsupported version');

      SetLength(Result.Areas, r.ReadInteger);
      for a := 0 to High(Result.Areas) do
      begin
        code := r.ReadString;
        len := r.ReadInteger;
        SetLength(shapes, len);
        for p := 0 to High(shapes) do
        begin
          len := r.ReadInteger;
          SetLength(shapes[p], len);
          for l := 0 to len - 1 do
          begin
            shapes[p][l].Lat := r.ReadDouble;
            shapes[p][l].Lon := r.ReadDouble;
          end;
        end;
        Result.Areas[a] := FAreaFactory.CreateArea(Code, shapes);
      end;
    finally
      r.Free;
    end;

  except
    Result.Free;
    raise;
  end;
end;

procedure TBinMapStreamWriter.WriteMap(Map: TMap; Stream: TStream);
var
  w: TWriter;
  area: IArea;
  polygon: TPolygon;
  latlon: TLatLon;
begin
  w := TWriter.Create(Stream, 4096);
  try
    w.WriteStr('JVIMAP');
    w.WriteInteger(Integer(1));
    w.WriteInteger(Length(Map.Areas));
    for area in Map.Areas do
    begin
      w.WriteString(area.GetCode);
      w.WriteInteger(Length(area.GetShapes));
      for polygon in area.GetShapes do
      begin
        w.WriteInteger(Length(polygon));
        // TODO: Figure out why read after write failed (AV) using.. w.Write(polygon[0], Length(polygon)*SizeOf(LatLong))
        for latlon in polygon do
        begin
          w.WriteDouble(latlon.Lat);
          w.WriteDouble(latlon.Lon);
        end;
      end;
    end;
  finally
    w.Free;
  end;
end;

end.
