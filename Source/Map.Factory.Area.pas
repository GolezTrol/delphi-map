unit Map.Factory.Area;

interface

uses
  Map,
  Map.Factory.Area.Intf;

type
  TArea = class(TInterfacedObject, IArea)
    Code: String;
    Shapes: TShapeArray;
    function GetCode: String;
    function GetShapes: TShapeArray;
  end;

  TAreaFactory = class(TInterfacedObject, IAreaFactory)
    function CreateArea(Code: String; Shapes: TShapeArray): IArea;
  end;

implementation

{ TArea }

function TArea.GetCode: String;
begin
  Result := Code;
end;

function TArea.GetShapes: TShapeArray;
begin
  Result := Shapes;
end;

{ TAreaFactory }

function TAreaFactory.CreateArea(Code: String; Shapes: TShapeArray): IArea;
var
  area: TArea;
begin
  area := TArea.Create;
  area.Code := Code;
  area.Shapes := Shapes;
  Result := area;
end;

end.
