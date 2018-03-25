unit MainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Kompas6Constants_TLB, ksAPI7, StdCtrls;

type
  TMainForm = class(TForm)
    StartButton: TButton;
    EditL1: TEdit;
    EditL2: TEdit;
    EditL3: TEdit;
    LabelL1: TLabel;
    LabelL3: TLabel;
    LabelL2: TLabel;
    LabelD1: TLabel;
    LabelD2: TLabel;
    LabelD3: TLabel;
    EditD1: TEdit;
    EditD2: TEdit;
    EditD3: TEdit;
    procedure StartButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.StartButtonClick(Sender: TObject);
var
  KP: IApplication; { ��������� �� ���������� ������ }
  KD: IKompasDocument; { ��������� �� ����� ������ }
  LLines: ILineSegments; { ��������� ������ ����� }
  LArcs: IArcs; { ��������� �� ������ ��� }
  LDims: ILineDimensions; { ��������� �� ������ �������� }
  Line: ILineSegment; { ��������� ����� }
  L1, L2, L3: Extended; { ����� �������� ���� }
  D1, D2, D3: Extended; { �������� �������� ���� }
  X0, Y0: Extended; { ���������� ������ ����, �������� ����� ��� ���������� }
begin

  // �������� �������� ������������� ������
  try
    L1 := StrToFloat(EditL1.Text);
    L2 := StrToFloat(EditL2.Text);
    L3 := StrToFloat(EditL3.Text);
    D1 := StrToFloat(EditD1.Text);
    D2 := StrToFloat(EditD2.Text);
    D3 := StrToFloat(EditD3.Text);
  except
    // ��������� ��������� �� ������, ���� ������� �� �����
    on E: EConvertError do
    begin
      E.Message := '�������� � ���������� ����� �� �������� �������';
      raise;
    end;
  end;

  // ��������� ������
  KP := Co_Application.Create;

  // ������� ���������� �������
  KP.Visible := True;

  // ������ ����� �������� (�����)
  KD := KP.Documents.Add(ksDocumentDrawing, True);

  // ��� ����� �������� ��������� �� �������� ��������,
  // ���� ������ ��������� ��� ��� �������� ���������.
  // � ������ ������, ��������� �� KD � ��� ��� ����,
  // ��� ��� ��� ������.
  // KD := KP.ActiveDocument;

  // ����������� ������ � ������ �����
  KD.LayoutSheets.Item[0].Format.Format := ksFormatUser;
  KD.LayoutSheets.Item[0].Format.FormatWidth := 594;
  KD.LayoutSheets.Item[0].Format.FormatHeight := 420;
  KD.LayoutSheets.Item[0].Update;

  // �������� ��������� �� ������� �����, ��� � ��������
  LLines := ((KD as IDrawingDocument).ViewsAndLayersManager.Views.ActiveView as IDrawingContainer)
    .LineSegments;
  LArcs := ((KD as IDrawingDocument).ViewsAndLayersManager.Views.ActiveView as
    IDrawingContainer).Arcs;
  LDims := ((KD as IDrawingDocument).ViewsAndLayersManager.Views.ActiveView as ISymbols2DContainer)
    .LineDimensions;

  // ��������� ������ ��������� ��� �������� �����
  X0 := KD.LayoutSheets.Item[0].Format.FormatWidth / 2;
  Y0 := KD.LayoutSheets.Item[0].Format.FormatHeight / 2;

  // ������ ���

  // ������ �������

  // � ������ ����� ��������� ����� �������
  Line := LLines.Add;
  // ����� ���������� �������
  // (X1, Y1) - ������ �������
  // (X2, Y2) - ����� �������
  Line.X1 := X0 - (L2 / 2);
  Line.Y1 := Y0 + (D1 / 2);
  Line.X2 := Line.X1 - L1;
  Line.Y2 := Line.Y1;
  // ��� ����� - �������, ��� ������
  // ������, ������, �������, ���� ������� ���� ������
  // ����� �������� ctrl+���.��.���� �� ksCSNormal
  Line.Style := ksCSNormal;
  // ��������� ������� �� ����
  Line.Update;

  // ����� ���������� ������ �� ��������� �������������� ��������� ����������
  with LLines.Add do
  begin
    X1 := X0 - (L2 / 2) - L1;
    Y1 := Y0 + (D1 / 2);
    X2 := X1;
    Y2 := Y1 - D1;
    Style := ksCSNormal;
    Update;
  end;

  with LLines.Add do
  begin
    X1 := X0 - (L2 / 2) - L1;
    Y1 := Y0 + (D1 / 2) - D1;
    X2 := X1 + L1;
    Y2 := Y1;
    Style := ksCSNormal;
    Update;
  end;

  // ������ �������
  with LLines.Add do
  begin
    X1 := X0 + (L2 / 2);
    Y1 := Y0 + (D2 / 2);
    X2 := X1 - L2;
    Y2 := Y1;
    Style := ksCSNormal;
    Update;
  end;

  with LLines.Add do
  begin
    X1 := X0 + (L2 / 2) - L2;
    Y1 := Y0 + (D2 / 2);
    X2 := X1;
    Y2 := Y1 - D2;
    Style := ksCSNormal;
    Update;
  end;

  with LLines.Add do
  begin
    X1 := X0 + (L2 / 2) - L2;
    Y1 := Y0 + (D2 / 2) - D2;
    X2 := X1 + L2;
    Y2 := Y1;
    Style := ksCSNormal;
    Update;
  end;

  with LLines.Add do
  begin
    X1 := X0 + (L2 / 2);
    Y1 := Y0 + (D2 / 2) - D2;
    X2 := X1;
    Y2 := Y1 + D2;
    Style := ksCSNormal;
    Update;
  end;

  // ������ �������
  with LLines.Add do
  begin
    X1 := X0 + (L2 / 2);
    Y1 := Y0 + (D3 / 2);
    X2 := X1 + L3;
    Y2 := Y1;
    Style := ksCSNormal;
    Update;
  end;

  with LLines.Add do
  begin
    X1 := X0 + (L2 / 2) + L3;
    Y1 := Y0 + (D3 / 2);
    X2 := X1;
    Y2 := Y1 - D3;
    Style := ksCSNormal;
    Update;
  end;

  with LLines.Add do
  begin
    X1 := X0 + (L2 / 2) + L3;
    Y1 := Y0 + (D3 / 2) - D3;
    X2 := X1 - L3;
    Y2 := Y1;
    Style := ksCSNormal;
    Update;
  end;

  // ������ ������ �����
  // ����� ������� ksCSAxial, ����� 5 �� �� ������� ����
  with LLines.Add do
  begin
    X1 := X0 - (L2 / 2) - L1 - 5;
    Y1 := Y0;
    X2 := X0 + (L2 / 2) + L3 + 5;
    Y2 := Y1;
    Style := ksCSAxial;
    Update;
  end;

  // ����������� �������� �������
  // (X1, Y1) � (X2, Y2) - �����, ��� ���������� �������� �����
  // (X3, Y3) - ���������� ������ �������, ��������� �������� �������������� ����
  // ����� ������ 10 �� �� ������� ����
  with LDims.Add do
  begin
    X1 := X0 - (L2 / 2);
    Y1 := Y0 + (D1 / 2);
    X2 := X1 + L2;
    Y2 := Y1;
    X3 := (X2 + X1) / 2;
    Y3 := Y0 + (D2 / 2) + 10;
    Update;
  end;

  with LDims.Add do
  begin
    X1 := X0 - (L2 / 2);
    Y1 := Y0 + (D1 / 2);
    X2 := X1 - L1;
    Y2 := Y1;
    X3 := (X2 + X1) / 2;
    Y3 := Y0 + (D1 / 2) + 10;
    Update;
  end;

  with LDims.Add do
  begin
    X1 := X0 + (L2 / 2);
    Y1 := Y0 + (D1 / 2);
    X2 := X1 + L3;
    Y2 := Y1;
    X3 := (X2 + X1) / 2;
    Y3 := Y0 + (D3 / 2) + 10;
    Update;
  end;

  // ����������� ������������� �������
  with LDims.Add do
  begin
    X1 := X0 - (L2 / 2) - L1;
    Y1 := Y0 + (D1 / 2);
    X2 := X1;
    Y2 := Y1 - D1;
    X3 := X1 - 10;
    Y3 := Y0;
    Update;
  end;

  with LDims.Add do
  begin
    X1 := X0;
    Y1 := Y0 + (D2 / 2);
    X2 := X1;
    Y2 := Y0 - D2 / 2;
    X3 := X1 - 10;
    Y3 := Y0 + D2 / 4;
    Update;
  end;

  with LDims.Add do
  begin
    X1 := X0 + (L2 / 2) + L3;
    Y1 := Y0 + (D3 / 2);
    X2 := X1;
    Y2 := Y1 - D3;
    X3 := X1 + 10;
    Y3 := Y0;
    Update;
  end;

end;

end.
