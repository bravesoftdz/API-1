Unit TFlatBeltUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, GearClassesUnit,
  GearTypesUnit, Gost;

//������� ��������� ��� �������������� ��������
type
  TInput = record
    P1: extended; {�������� �� ������� �����}
    n1: extended; {����� �������� �������� �����}
    up: extended; {��������� ������������ �����}
    d1: extended; {������� ������ �����}
    Q: word; {���� ������� �������� � ���������}
    Tip_nat: boolean; {��������� �����}
    Cp: extended; {����������� ������ ������}
    a: extended; {��������� ����������, ��; 0 - �����}
    Fdelta: extended; {������� �����}
    Tip_pl: word;
    alfa_min: extended; {���������� ���������� ���� �������}
    nyu_max: extended; {����������� ���������� ����� ��������}
    V_max: extended; {����������� ���������� �������� �����}
    f_pr: extended; {����������� ����������� ������}
  end;

type
  TOutput = record
    a: extended; {����������� ��������� ���������� ��������}
    d2: extended; {������� �������� �����}
    alfa: extended; {���� ������ ������ �������� �����}
    Vol: extended; {����� ��������}
    d1: extended; {������� ������ �����}
    Lh: extended; {�������������}
    Fb: extended; {�������� �� ��� �� ��������� ������ �����}
    l: extended; {����� �����}
    bs: extended; {������ �����}
    u: extended; {����������� ������������ �����}
    n2: extended; {����� �������� �������� �����}
    V: extended; {�������� �������� �����}
    Fdelta: extended; {������� �����}
    nyu: extended; {����� �������� ����� � �������}
    Ft: extended; {�������� ������ � ��������}
    F0: extended; {���� ���������������� ��������� �����}
    z: extended; {����� ����� ���������}
    b: extended; {������ �����}
    constructor Create(val: integer);
  end;

type
  TFlatBeltOutputs = array of TOutput;

type
  TFlatBelt = class(TBelt)
  private
    FInput: TInput;
    //1 �������� ��� ������ �������� ������ ��� ���������
    Output: TOutput;
    //1 ����, �������� ��������� �������� ������
    FGears: TFlatBeltOutputs;
    function Thickness: TOutput;
    function Diameter: TOutput;
    function Kinematic: TOutput;
    function Forces: TOutput;
    function Wheel: TOutput;

    function Geometric: TOutput;
    //procedure Checking;
    function GetGears(Index: integer): TOutput;
    procedure SetGears(Index: integer; const Value: TOutput);
    function Calculate: TOutput;

  public

    constructor Create(Input: TInput);

    //1 �������� ��� ������ ������� ������ ��� ���������
    property Input: TInput read FInput;
    property Gears[Index: integer]: TOutput read GetGears
      write SetGears; default;
    //1 ������� ���������� �������� � ���������
    function Add(Gear: TOutput): integer;
    //1  ����� ������� ���������� ��������� � ���������
    function Count: integer; override;
    //1 ������� ��������� ��������� �������
    function Collect: integer;
    //1 ����� ������� ���������
    procedure Clear; override;
    //1 ����� ������� ������ ������� ���������
    function First: TOutput;
    //1  ����� ������� ��������� ������� ���������
    function Last: TOutput;
    //1 ������� ������� ��� ����� (����� ����� � SectionIndex)
    function Section(SectionIndex: integer): String; override;
  end;

implementation


{constructor TInput.Create(val: integer);
begin
  P1 := val;
  n1 := val;
  up := val;
  d1 := val;
  Q := val;
  Tip_nat := false;
  Cp := val;
  a := val;
  Fdelta := val;
  Tip_pl := val;
  alfa_min := val;
  nyu_max := val;
  V_max := val;
  f_pr := val;
end;}

constructor TOutput.Create;
begin
  a := 0; {����������� ��������� ���������� ��������}
  d2 := 0; {������� �������� �����}
  alfa := 0; {���� ������ ������ �������� �����}
  Vol := 0; {����� ��������}
  d1 := 0; {������� ������ �����}
  Lh := 0; {�������������}
  Fb := 0; {�������� �� ��� �� ��������� ������ �����}
  l := 0; {����� �����}
  bs := 0; {������ �����}
  u := 0; {����������� ������������ �����}
  n2 := 0; {����� �������� �������� �����}
  V := 0; {�������� �������� �����}
  Fdelta := 0; {������� �����}
  nyu := 0; {����� �������� ����� � �������}
  Ft := 0; {�������� ������ � ��������}
  F0 := 0; {���� ���������������� ��������� �����}
  z := 0; {����� ����� ���������}
  b := 0; {������ �����}
end;

constructor TFlatBelt.Create(Input: TInput);
begin
  FFullName := '������� ������� ��������';
  FBeltType := btFlat;

  FInput.n1 := Input.n1;
  FInput.P1 := Input.P1;
  FInput.up := Input.up;
  FInput.d1 := Input.d1;
  FInput.a := Input.a;
  FInput.Q := Input.Q;
  FInput.Tip_nat := Input.Tip_nat;
  FInput.Cp := Input.Cp;
  FInput.Tip_pl := Input.Tip_pl;
  FInput.Fdelta := Input.Fdelta;
  FInput.alfa_min := Input.alfa_min;
  FInput.nyu_max := Input.nyu_max;
  FInput.V_max := Input.V_max;
  FInput.f_pr := Input.f_pr;
end;

function TFlatBelt.GetGears(Index: integer): TOutput;
begin
  if Index < Count then
    Result := FGears[Index]
  else
    raise EListError.Create
      ('[TFlatBelt.GetGears] ������� ���������� � �������� � ������� ������ �������������');
end;

procedure TFlatBelt.SetGears(Index: integer; const Value: TOutput);
begin
  if Index < Count then
    Gears[Index] := Value
  else
    raise EListError.Create
      ('[TFlatBelt.SetGears] ������� �������� ������ � �������� � ������� ������ �������������');
end;

function TFlatBelt.First: TOutput;
begin
  if Count > 0 then
    Result := Gears[0]
  else
    raise EListError.Create
      ('[TFlatBelt.First] ������� ������� ������ �������� � ������ ���������');
end;

function TFlatBelt.Section(SectionIndex: integer): String;
begin
  inherited;

  if SectionIndex <= High(PClinT) then
    Result := PClinT[SectionIndex]
  else
    raise EAccessViolation.Create
      ('[TFlatBelt.GetSection] ����������� ����� ����� ������� (SectionIndex)');
end;

function TFlatBelt.Last: TOutput;
begin
  if Count > 0 then
    Result := Gears[High(FGears)]
  else
    raise EListError.Create
      ('[TFlatBelt.Last] ������� ������� ��������� �������� � ������ ���������');
end;

procedure TFlatBelt.Clear;
begin
  if Count <> 0 then
    SetLength(FGears, 0);
end;

function TFlatBelt.Count: integer;
begin
  Result := Length(FGears);
end;

function TFlatBelt.Add(Gear: TOutput): integer;
begin
  SetLength(FGears, Length(FGears) + 1);
  FGears[High(FGears)] := Gear;
  Result := Length(FGears);
end;

function TFlatBelt.Collect: integer;
var
  newBelt: TOutput;
  h: extended;
  StartDiam, StartDelta, UserDist: extended;
  z: extended;
begin
  //z := 0;
  case Input.Tip_pl of
    0:
      h := 1.5;
    1:
      h := 1.5;
    2:
      h := 1.5;
    3:
      h := 1.3;
    4:
      h := 1.4;
    5:
      h := 1.5;
    6:
      h := 1.5;
  end;

  if StartDelta = 0 then
  begin
    z := 3;
    Output.Fdelta := h * z;
  end;

  repeat
    Output.d1 := Input.d1;
    repeat
//     newBelt.a := Input.a;
//      newBelt.z := z;
      newBelt := Calculate;

      Add(newBelt);
      Output.d1 := Output.d1 * 1.25;
    until (Output.d2 >= TArrayD[38]);

    if Input.Fdelta = 0 then
    begin
      z := z + 1;
      newBelt.Fdelta := h * z;
    end;

  until (StartDelta <> 0) or (z > 6.1);

//  Clear;
  Result := 0;
end; //??????????

//procedure TFlatBelt.Checking;
//begin
//inherited;
//end;

{------------- ������ �������� -------------}
function TFlatBelt.Calculate: TOutput;
begin
  inherited;

  Thickness;
  Wheel;
  Diameter;
  Geometric;
  Kinematic;
  Forces;
  Result := Output;
end;

function TFlatBelt.Thickness: TOutput;
var
  h: extended;

begin
  {----------------- ������ ������� ����� ----------------------}
  case Input.Tip_pl of
    0:
      h := 1.5;
    1:
      h := 1.5;
    2:
      h := 1.5;
    3:
      h := 1.3;
    4:
      h := 1.4;
    5:
      h := 1.5;
    6:
      h := 1.5;
  end;

  Output.z := round(Input.Fdelta / h);

  if Output.z < 3 then
    Output.z := 3;

  if Output.z > 6 then
    Output.z := 6;

  Output.Fdelta := Output.z * h;

end; {---------����� �������  ������� �����-----------------}

function TFlatBelt.Wheel: TOutput;
{------------- ������ ������ �����, ��������� ����� ------------}
var
  p0, C_alfa, C_V, C_Q: extended;
  ib: integer;

begin
  case Input.Tip_pl of
    0:
      p0 := 3;
    1:
      p0 := 3;
    2:
      p0 := 10;
    3:
      p0 := 10;
    4:
      p0 := 13;
    5:
      p0 := 20;
    6:
      p0 := 20;
  end;
  {����������� ���� �������}
  C_alfa := 1 - 0.003 * (180 - Output.alfa);
  C_V := 1.04 - 0.0004 * Output.V * Output.V;
  if Input.Tip_nat then
    if Input.Q = 0 then {Q <= 60}
      C_Q := 1
    else if Input.Q = 1 then {60 < Q <80}
      C_Q := 0.9
    else
      C_Q := 0.8
  else
    C_Q := 1;
  Output.Ft := 19.1E6 * Input.P1 / (Input.n1 * Input.d1);
  {������ �����}
  Output.b := Output.Ft / (Output.z * p0 * C_alfa * C_V * Input.Cp * C_Q);

  TruncGOST(TArrayB, 1, 32, Output.b, Output.b, ib);
  Output.bs := TArrayB[ib + 1];
end; {------------------------------------------------}

function TFlatBelt.Diameter: TOutput;
var
  id: integer;

begin
  {----------------- ������ �������� �������� ����� -------------------}
  if Output.d1 <> 0 then
  begin
//    Output.d1:=Input.d1;
    Exit;
  end;

  Output.d1 := 1100 * exp(1 / 3 * ln(Input.P1 / Input.n1));
  try
    TruncGOST(TArrayD, 1, 35, Output.d1, Output.d1, id);
  except
    on E: Exception do
      raise Exception.Create
        ('[TFlatBelt.Calculate] �� ������� �������� ������� �������� ����� (d1) �� ���������� �������� ������������ ��������');
  end;

end; {--------- ����� ������� d1 --------------------------------------}

function TFlatBelt.Geometric: TOutput;
var
  id2: integer;

begin
  {----------------------- ������ ��������� �������� ------------------------}
  Output.d2 := Output.d1 * Input.up;
  {if Output.d2 > TArrayD[38] then
   ErrorCode := erDiam; //????}
  try
    RoundGOST(TArrayD, 1, 38, Output.d2, Output.d2, id2);
  except
    on E: Exception do
      raise Exception.Create
        ('[TFlatBelt.Calculate] �� ������� ��������� ������� �������� ����� (d2) �� ���������� �������� �� ���� �������� ��������');
  end;
  if Input.a = 0 then
    Output.a := 1.5 * (Input.d1 + Output.d2);
  Output.l := 2 * Output.a + Pi * (Input.d1 + Output.d2) / 2 +
    sqr(Output.d2 - Input.d1) / (4 * Output.a);
  Output.alfa := 180 - (Output.d2 - Input.d1) * 57 / Output.a;
  {if Output.alfa < Input.alfa_min then
   ErrorCode := erAngle; //????}

end; {------------------------------------------------------}

function TFlatBelt.Kinematic: TOutput;
{--------- ������ �������������� ���������� �������� -------}
var
  C: extended;

begin
  C := 0.99;
  Output.u := Output.d2 / (C * Input.d1);
  Output.n2 := Input.n1 * Input.d1 * C / Output.d2;
  Output.V := Pi * Input.d1 * Input.n1 / 60000;
  {if Output.V > Input.V_max then
   ErrorCode := erSpeed;}
  Output.nyu := 1000 * Output.V / Output.l;
  {if Output.nyu > Input.nyu_max then
   ErrorCode := erRunway;}

end; {-------- ����� ��������� Kinematic-----------------------}

function TFlatBelt.Forces: TOutput;
{------------------ ������ ��� ------------------------}

var
  F1, F2, alfa_c, m, Sigma_E, Q: extended;
  {F1 - ��������� ������� �����;
   F2 - ��������� ������� �����;
   Fb - �������� �� ���� �����;
   F0 - ������ ���������������� ���������;
   Ft - �������� ������ � ��������}

Const
  f = 0.25;

begin
  alfa_c := 0.7 * Output.alfa * Pi / 180;
  m := exp(Input.f_pr * alfa_c);
  F1 := m / (m - 1) * Output.Ft;
  F2 := F1 - Output.Ft;
  Output.F0 := Output.Ft / 2 * ((m + 1) / (m - 1));
  Output.Fb := sqrt(sqr(F1) + sqr(F2) + 2 * F1 * F2 * cos(Output.alfa));
  Output.Vol := (Output.b * (Pi * (sqr(Output.d1) + sqr(Output.d2)) + 4 * Input.a *
    (Output.d1 + Output.d2))) / 8 * 1E-6;
  alfa_c := 0.7 * Output.alfa * Pi / 180;
  Q := exp(f * alfa_c);
  Sigma_E := Q * Output.Ft / (Output.Fdelta * Output.b * (Q - 1)) + 90 * Output.Fdelta
    / Output.d1 + 1.2E-3 * sqr(Output.V);
  Output.Lh := 1.1E6 * Output.l / (Output.V * exp(6 * ln(Sigma_E)));
end; {------------- ����� ��������� Forces -------------------------}

end.
