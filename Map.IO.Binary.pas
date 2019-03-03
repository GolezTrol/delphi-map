unit Map.IO.Binary;

interface

uses
  Classes,
  Map,
  Map.IO.Intf;

type
  TBinMapStreamReader = class(TInterfacedObject, IMapStreamReader)
    function ReadMap(Stream: TStream): TMap;
  end;

  TBinMapStreamWriter = class(TInterfacedObject, IMapStreamWriter)
    procedure WriteMap(Map: TMap; Stream: TStream);
  end;

implementation

function TBinMapStreamReader.ReadMap(Stream: TStream): TMap;
var
  r: TReader;
  a: Integer;
  p: Integer;
  len: Integer;
  area: ^TArea;
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
        area := @Result.Areas[a];
        area.Code := r.ReadString;
        len := r.ReadInteger;
        SetLength(area.Shapes, len);
        for p := 0 to High(area.Shapes) do
        begin
          len := r.ReadInteger;
          SetLength(area.Shapes[p], len);
          for l := 0 to len - 1 do
          begin
            area.Shapes[p][l].Lat := r.ReadDouble;
            area.Shapes[p][l].Lon := r.ReadDouble;
          end;
        end;
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
  area: TArea;
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
      w.WriteString(area.Code);
      w.WriteInteger(Length(area.Shapes));
      for polygon in area.Shapes do
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
