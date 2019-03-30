unit Map.Plotter;

interface

uses
  System.Types,
  Graphics,
  Map,
  Map.Plotter.Intf,
  Map.Projection.Intf;

type
  TMapPlotter = class(TInterfacedObject, IMapPlotter)
  private
    FProjection: IMapProjection;
  public
    constructor Create(projection: IMapProjection);
    procedure Plot(map: TMap; canvas: TCanvas);
  end;

implementation

constructor TMapPlotter.Create(projection: IMapProjection);
begin
  inherited Create;
  FProjection := projection;
end;

procedure TMapPlotter.Plot(map: TMap; canvas: TCanvas);
var
  area: IArea;
  polygon: TPolygon;
  points: array of TPoint;
  x, y: Integer;
  i: Integer;

begin
  Canvas.Font.Size := 6;
  for area in map.Areas do
  begin
    x := FProjection.LatLonToPoint(area.GetShapes[0][0]).X;
    y := FProjection.LatLonToPoint(area.GetShapes[0][0]).Y;
    Canvas.TextOut(x, y, area.Code);
  end;
  for area in map.Areas do
  begin
    for polygon in area.GetShapes do
    begin
      SetLength(points, Length(polygon));
      for i := Low(polygon) to High(polygon) do
        points[i] := FProjection.LatLonToPoint(polygon[i]);
      Canvas.Polyline(points);
    end;
  end;
end;

end.
