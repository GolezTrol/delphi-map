unit Map.Projection.Ugly;

interface

uses
  Map,
  Map.Projection.Intf;

type
  TMapProjectionUgly = class(TInterfacedObject, IMapProjection)
    function LatLonToPoint(latlon: TLatLon): TPoint;
  end;

implementation

function TMapProjectionUgly.LatLonToPoint(latlon: TLatLon): TPoint;

  function ToPixel(Value, VStart, VRange: Double; PStart, PRange: Integer): Integer; inline;
  begin
    Result := Round((Value - VStart) * PRange / VRange + PStart);
  end;

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

end.
