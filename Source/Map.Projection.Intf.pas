unit Map.Projection.Intf;

interface

uses
  Map,
  Types;

type
  TPoint = Types.TPoint;
type
  IMapProjection = interface
    ['{DB920D73-8A51-4147-A270-B04BA7C14058}']
    function LatLonToPoint(latlon: TLatLon): TPoint;
  end;

implementation

end.
