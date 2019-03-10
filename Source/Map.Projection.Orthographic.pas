unit Map.Projection.Orthographic;

interface

uses
  Map,
  Map.Projection.Intf;

type
  TMapProjectionOrthographic = class(TInterfacedObject, IMapProjection)
  private
    FCenterRad: TLatLon;
    FRadius: Integer;
  public
    constructor Create(center: TLatLon);//, bc1, bc2: TLatLon; bp1, bp2: TPoint);
    function LatLonToPoint(latlon: TLatLon): TPoint;
  end;

implementation

uses
  Math;

constructor TMapProjectionOrthographic.Create(center: TLatLon); //, bc1, bc2: TLatLon; bp1, bp2: TPoint);
begin
  inherited Create;
  FCenterRad.Lat := DegToRad(center.Lat);
  FCenterRad.Lon := DegToRad(center.Lon);
  // Todo: Determine the proper radius for fitting the map area snugly inside the viewport
  FRadius := 17000;
end;

function TMapProjectionOrthographic.LatLonToPoint(latlon: TLatLon): TPoint;
var
  x, y: Double;
  la, lo: Double;
begin
  // Formula: https://en.wikipedia.org/wiki/Orthographic_projection_in_cartography#Mathematics
  la := DegToRad(latlon.Lat);
  lo := DegToRad(latlon.Lon);
  x := FRadius * Cos(la) * Sin(lo - FCenterRad.Lon);
  y := FRadius * (Cos(FCenterRad.Lat) * Sin(la) - Sin(FCenterRad.Lat) * Cos(la) * Cos(lo - FCenterRad.Lon));
  // Todo: Center based on viewport sizes
  Result := TPoint.Create(Round(x+500), Round(-y+500));
end;

end.
