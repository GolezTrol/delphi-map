unit Map.Projection.Tests;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TMapProjectionTests = class(TObject) 
  public
  end;

implementation


initialization
  TDUnitX.RegisterTestFixture(TMapProjectionTests);
end.
