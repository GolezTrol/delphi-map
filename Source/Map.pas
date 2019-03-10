unit Map;

interface

type
  TLatLon = record
    Lat, Lon: Double;
  end;
  TPolygon = array of TLatLon;
  TShapeArray = array of TPolygon;
  TArea = record
    Code: String;
    Shapes: TShapeArray;
  end;
  TAreas = array of TArea;
  TMap = class
    Areas: TAreas;
  end;

implementation

end.
