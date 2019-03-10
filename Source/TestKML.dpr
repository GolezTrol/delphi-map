program TestKML;

uses
  Vcl.Forms,
  TestKML.Form in 'TestKML.Form.pas' {KMLTestForm},
  Map in 'Map.pas',
  Map.Plotter.Intf in 'Map.Plotter.Intf.pas',
  Map.Plotter in 'Map.Plotter.pas',
  Map.IO.Binary in 'Map.IO.Binary.pas',
  Map.IO.KML in 'Map.IO.KML.pas',
  Map.IO.Intf in 'Map.IO.Intf.pas',
  Map.Projection.Intf in 'Map.Projection.Intf.pas',
  Map.Projection.Ugly in 'Map.Projection.Ugly.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TKMLTestForm, KMLTestForm);
  Application.Run;
end.
