unit Map.IO.Intf;

interface

uses
  Classes,
  Map;

type
  IMapStreamReader = interface
    ['{155F9D0A-E2F3-4AD3-9DD1-C6187ADA4952}']
    function ReadMap(Stream: TStream): TMap;
  end;

  IMapStreamWriter = interface
    ['{2F8D31EC-58EA-425C-98C3-2D93779F7A1D}']
    procedure WriteMap(Map: TMap; Stream: TStream);
  end;

implementation

end.
