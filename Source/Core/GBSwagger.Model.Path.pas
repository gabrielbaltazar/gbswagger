unit GBSwagger.Model.Path;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.PathMethod,
  Web.HTTPApp,
  System.Generics.Collections;

type
  TGBSwaggerModelPath = class(TInterfacedObject, IGBSwaggerPath)
  private
    [Weak]
    FParent: IGBSwagger;
    FName: string;
    FTags: TList<string>;
    FMethods: TList<IGBSwaggerPathMethod>;

    function AddMethod(ASummary, ADescription: string): IGBSwaggerPathMethod;
  protected
    function Name(AValue: string): IGBSwaggerPath; overload;
    function Name: string; overload;

    function Tag(AValue: string): IGBSwaggerPath;
    function Tags: TArray<string>;

    function GET(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
    function POST(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
    function PUT(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
    function DELETE(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
    function PATCH(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;

    function Methods: TArray<IGBSwaggerPathMethod>;
    function &End: IGBSwagger;
  public
    constructor Create(AParent: IGBSwagger);
    class function New(AParent: IGBSwagger): IGBSwaggerPath;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerModelPath }

function TGBSwaggerModelPath.AddMethod(ASummary, ADescription: string): IGBSwaggerPathMethod;
begin
  Result := TGBSwaggerModelPathMethod.New(Self)
    .Summary(ASummary)
    .Description(ADescription);

  FMethods.Add(Result);
end;

constructor TGBSwaggerModelPath.Create(AParent: IGBSwagger);
begin
  FParent := AParent;
  FTags := TList<string>.Create;
  FMethods := TList<IGBSwaggerPathMethod>.Create;
end;

function TGBSwaggerModelPath.DELETE(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
begin
  Result := AddMethod(ASummary, ADescription)
    .MethodType(mtDelete);
end;

destructor TGBSwaggerModelPath.Destroy;
begin
  FMethods.Free;
  FTags.Free;
  inherited;
end;

function TGBSwaggerModelPath.&End: IGBSwagger;
begin
  Result := FParent;
end;

function TGBSwaggerModelPath.GET(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
begin
  Result := AddMethod(ASummary, ADescription)
    .MethodType(mtGet);
end;

function TGBSwaggerModelPath.Methods: TArray<IGBSwaggerPathMethod>;
begin
  Result := FMethods.ToArray;
end;

function TGBSwaggerModelPath.Name: string;
begin
  Result := FName;
end;

function TGBSwaggerModelPath.Name(AValue: string): IGBSwaggerPath;
begin
  Result := Self;
  FName := AValue;
end;

class function TGBSwaggerModelPath.New(AParent: IGBSwagger): IGBSwaggerPath;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerModelPath.PATCH(ASummary, ADescription: string): IGBSwaggerPathMethod;
begin
  Result := AddMethod(ASummary, ADescription)
    .MethodType(mtPatch);
end;

function TGBSwaggerModelPath.POST(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
begin
  Result := AddMethod(ASummary, ADescription)
    .MethodType(mtPost);
end;

function TGBSwaggerModelPath.PUT(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
begin
  Result := AddMethod(ASummary, ADescription)
    .MethodType(mtPUT);
end;

function TGBSwaggerModelPath.Tag(AValue: string): IGBSwaggerPath;
begin
  Result := Self;
  if not FTags.Contains(AValue) then
    FTags.Add(AValue);
end;

function TGBSwaggerModelPath.Tags: TArray<string>;
begin
  Result := FTags.ToArray;
end;

end.
