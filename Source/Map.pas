unit Map;

interface

type
  TLatLon = record
    Lat, Lon: Double;
  end;
  TPolygon = array of TLatLon;

  TShapeArray = array of TPolygon;

  IArea = interface
    function GetCode: String;
    function GetShapes: TShapeArray;
  end;

  TAreas = array of IArea;
  TMap = class
    Areas: TAreas;
  end;

implementation


end.
