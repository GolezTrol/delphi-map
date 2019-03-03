unit Map.Plotter.Intf;

interface

uses
  Map,
  Graphics;

type
  IMapPlotter = interface
    procedure Plot(map: TMap; canvas: TCanvas);
  end;

implementation

end.
