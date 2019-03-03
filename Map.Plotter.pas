unit Map.Plotter;

interface

uses
  System.Types,
  Graphics,
  Map,
  Map.Plotter.Intf;

type
  TMapPlotter = class(TInterfacedObject, IMapPlotter)
    procedure Plot(map: TMap; canvas: TCanvas);
  end;

implementation

procedure TMapPlotter.Plot(map: TMap; canvas: TCanvas);
var
  area: TArea;
  polygon: TPolygon;
  points: array of TPoint;
  x, y: Integer;
  i: Integer;

  function ToPixel(Value, VStart, VRange: Double; PStart, PRange: Integer): Integer; inline;
  begin
    Result := Round((Value - VStart) * PRange / VRange + PStart);
  end;

  function LatLonToPoint(latlon: TLatLon): TPoint;
  begin
    // Translate the bounding box (lon 3+4=7, Lat 54-4=50) to pixel coordinates
    // TODO: Figure out a decent projection, that ..
    //       basically centers the given map based on the points in it, and
    //       draw it using an orthographic projection. That should give pretty
    //       decent results for anything up to reasonable sized countries.
    // TODO: Dynamic ranges for these boxes.
    // TODO: Option to center/fill map in canvas. Keep proportions.
    Result.X := round(ToPixel(latlon.Lon, 3, 4, 0, 1000) / 1.8);
    Result.Y := ToPixel(latlon.Lat, 54, -4, 0, 1000);
  end;

begin
  Canvas.Font.Size := 6;
  for area in map.Areas do
  begin
    x := LatLonToPoint(area.Shapes[0][0]).X;
    y := LatLonToPoint(area.Shapes[0][0]).Y;
    Canvas.TextOut(x, y, area.Code);
  end;
  for area in map.Areas do
  begin
    for polygon in area.Shapes do
    begin
      SetLength(points, Length(polygon));
      for i := Low(polygon) to High(polygon) do
        points[i] := LatLonToPoint(polygon[i]);
      Canvas.Polyline(points);
    end;
  end;
end;

end.
