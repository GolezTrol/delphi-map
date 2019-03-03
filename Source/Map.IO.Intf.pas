unit Map.IO.Intf;

interface

uses
  Classes,
  Map;

type
  IMapStreamReader = interface
    function ReadMap(Stream: TStream): TMap;
  end;
  IMapStreamWriter = interface
    procedure WriteMap(Map: TMap; Stream: TStream);
  end;

implementation

end.
