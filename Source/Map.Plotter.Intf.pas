unit Map.Plotter.Intf;

interface

uses
  Map,
  Graphics;

type
  IMapPlotter = interface
    ['{45BE724A-10FE-4A6C-BAEA-1A5C31D8F585}']
    procedure Plot(map: TMap; canvas: TCanvas);
  end;

implementation

end.
