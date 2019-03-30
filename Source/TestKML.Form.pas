unit TestKML.Form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Map, Map.IO.Intf, Map.IO.Binary, Map.IO.KML, Map.Plotter.Intf, Map.Plotter,
  Map.Projection.Ugly, Map.Projection.Orthographic,
  Map.Factory.Area;

type
  TKMLTestForm = class(TForm)
    ShowKMLMap: TCheckBox;
    ShowBinaryMap: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ShowKMLMapClick(Sender: TObject);
    procedure ShowBinaryMapClick(Sender: TObject);
  private
    FKmlMap: TMap;
    FBinMap: TMap;
  end;

var
  KMLTestForm: TKMLTestForm;

implementation

{$R *.dfm}

procedure TKMLTestForm.ShowKMLMapClick(Sender: TObject);
begin
  Invalidate;
end;

procedure TKMLTestForm.ShowBinaryMapClick(Sender: TObject);
begin
  Invalidate;
end;

procedure TKMLTestForm.FormCreate(Sender: TObject);
var
  FileName: String;
  fs: TFileStream;
  bfs: TFileStream;
  BinFileName: string;
begin
  // Look in project folder, assuming the exe is in ./Win32/Debug or so
  FileName := '..\..\pc4.kml';
  BinFileName := '..\..\pc4.bin';

  // After binary files are written, comment out from here for faster loading: {

  try
    // For speed, try to load the binary file.
    bfs := TFileStream.Create(BinFileName, fmOpenRead);
    try
      FBinMap := (TBinMapStreamReader.Create(TAreaFactory.Create) as IMapStreamReader).ReadMap(bfs);
    finally
      bfs.Free;
    end;
  except
    // If loading the binary file failed, load the KML file and save to binary.
    fs := TFileStream.Create(FileName, fmOpenRead);
    try
      FKmlMap := (TKMLMapStreamReader.Create(TAreaFactory.Create) as IMapStreamReader).ReadMap(fs);
    finally
      fs.Free;
    end;

    // Save to binary file
    bfs := TFileStream.Create(BinFileName, fmCreate);
    try
      (TBinMapStreamWriter.Create as IMapStreamWriter).WriteMap(FKmlMap, bfs);
    finally
      bfs.Free;
    end;
  end;

  ShowKMLMap.Checked := Assigned(FKmlMap);
  ShowBinaryMap.Checked := Assigned(FBinMap);

end;

procedure TKMLTestForm.FormDestroy(Sender: TObject);
begin
  FKmlMap.Free;
  FBinMap.Free;
end;

procedure TKMLTestForm.FormPaint(Sender: TObject);
var
  b: TBitmap;
  center: TLatLon;
begin
  b := TBitmap.Create;
  try
    b.Width := 1000;
    b.Height := 1000;

    // Todo: Calculate based on coordinates/bounding rect
    center.Lat := 52;
    center.Lon := 5;
    with (TMapPlotter.Create(TMapProjectionOrthographic.Create(center)) as IMapPlotter) do
    begin
      if Assigned(FBinMap) and ShowBinaryMap.Checked then
      begin
        b.Canvas.Pen.Color :=  clRed;
        Plot(FBinMap, b.Canvas);
      end;
      if Assigned(FKmlMap) and ShowKMLMap.Checked then
      begin
        b.Canvas.Pen.Color :=  clGreen;
        Plot(FKmlMap, b.Canvas);
      end;
    end;
    Canvas.Draw(0, 0, b);
  finally
    b.Free;
  end;
end;

end.
