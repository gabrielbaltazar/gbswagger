unit GBSwagger.Model.Path;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.PathMethod,
  Web.HTTPApp,
  System.Generics.Collections;

type TGBSwaggerModelPath = class(TInterfacedObject, IGBSwaggerPath)

  private
    [Weak]
    FParent: IGBSwagger;
    FName: string;
    FTags: TList<String>;
    FMethods: TList<IGBSwaggerPathMethod>;

    function AddMethod(Summary, Description: String): IGBSwaggerPathMethod;

  protected
    function Name(Value: String): IGBSwaggerPath; overload;
    function Name: string; overload;

    function Tag(Value: String): IGBSwaggerPath;
    function Tags: TArray<String>;

    function GET(Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
    function POST(Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
    function PUT(Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
    function DELETE(Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
    function PATCH(Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;

    function Methods: TArray<IGBSwaggerPathMethod>;

    function &End: IGBSwagger;

  public
    constructor create(Parent: IGBSwagger);
    class function New(Parent: IGBSwagger): IGBSwaggerPath;
    destructor Destroy; override;

end;

implementation

{ TGBSwaggerModelPath }

function TGBSwaggerModelPath.AddMethod(Summary, Description: String): IGBSwaggerPathMethod;
begin
  result := TGBSwaggerModelPathMethod.New(Self)
              .Summary(Summary)
              .Description(Description);

  FMethods.Add(result);
end;

constructor TGBSwaggerModelPath.create(Parent: IGBSwagger);
begin
  FParent  := Parent;
  FTags    := TList<String>.create;
  FMethods := TList<IGBSwaggerPathMethod>.Create;
end;

function TGBSwaggerModelPath.DELETE(Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
begin
  result := AddMethod(Summary, Description)
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
  result := FParent;
end;

function TGBSwaggerModelPath.GET(Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
begin
  result := AddMethod(Summary, Description)
              .MethodType(mtGet);
end;

function TGBSwaggerModelPath.Methods: TArray<IGBSwaggerPathMethod>;
begin
  Result := FMethods.ToArray;
end;

function TGBSwaggerModelPath.Name: string;
begin
  result := FName;
end;

function TGBSwaggerModelPath.Name(Value: String): IGBSwaggerPath;
begin
  Result := Self;
  FName  := Value;
end;

class function TGBSwaggerModelPath.New(Parent: IGBSwagger): IGBSwaggerPath;
begin
  result := Self.create(Parent);
end;

function TGBSwaggerModelPath.PATCH(Summary, Description: string): IGBSwaggerPathMethod;
begin
  result := AddMethod(Summary, Description)
              .MethodType(mtPatch);
end;

function TGBSwaggerModelPath.POST(Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
begin
  result := AddMethod(Summary, Description)
              .MethodType(mtPost);
end;

function TGBSwaggerModelPath.PUT(Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
begin
  result := AddMethod(Summary, Description)
              .MethodType(mtPUT);
end;

function TGBSwaggerModelPath.Tag(Value: String): IGBSwaggerPath;
begin
  result := Self;
  if not FTags.Contains(Value) then
    FTags.Add(Value);
end;

function TGBSwaggerModelPath.Tags: TArray<String>;
begin
  Result := FTags.ToArray;
end;

end.
