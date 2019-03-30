unit Map.Factory.Area.Intf;

interface

uses
  Map;

type
  IAreaFactory = interface
    ['{0937ED0B-4548-49E0-A5D1-2A75EC19335B}']
    function CreateArea(Code: String; Shapes: TShapeArray): IArea;
  end;

implementation

end.
