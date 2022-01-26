unit ACAD_CAP_options_pas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids;

type
  TACAD_CAP_options = class(TForm)
    Button1: TButton;
    RadioGroup5: TRadioGroup;
    Button2: TButton;
    LabeledEdit1: TLabeledEdit;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Button3: TButton;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure RadioGroup5Click(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ACAD_CAP_options: TACAD_CAP_options;

implementation

uses VLeshka;

{$R *.dfm}

procedure Proverka;
begin
  if VLMassive_Baza<>nil then
    ACAD_CAP_options.Edit1.Text:=Form1.GetStringInfo(ACAD_CAP_options.LabeledEdit1.Text,ACAD_CAP_options.ComboBox1.ItemIndex);
end;

procedure TACAD_CAP_options.FormCreate(Sender: TObject);
begin
  ACAD_CAP_options.ActiveControl:=LabeledEdit1;
end;

procedure TACAD_CAP_options.Button1Click(Sender: TObject);
begin
  ACAD_CAP_options.Close;
end;

procedure TACAD_CAP_options.Button2Click(Sender: TObject);
begin
//  ACAD_CAP_options
  ACAD_CAP_options.Close;
end;

procedure TACAD_CAP_options.Button3Click(Sender: TObject);
Var i:integer;
begin
  i:=ACAD_CAP_options.LabeledEdit1.SelStart;  //запоминаем, где стоит курсор, чтобы вернуть его
  ACAD_CAP_options.LabeledEdit1.Text:=copy(ACAD_CAP_options.LabeledEdit1.Text,1,ACAD_CAP_options.LabeledEdit1.SelStart)+'[['+IntToStr(ACAD_CAP_options.RadioGroup5.ItemIndex+1)+']]'+copy(ACAD_CAP_options.LabeledEdit1.Text,ACAD_CAP_options.LabeledEdit1.SelStart+1,length(ACAD_CAP_options.LabeledEdit1.Text)-(ACAD_CAP_options.LabeledEdit1.SelStart+1));
  ACAD_CAP_options.LabeledEdit1.SelStart:=i;
  Proverka;
  ACAD_CAP_options.ActiveControl:=LabeledEdit1;
end;

procedure TACAD_CAP_options.RadioGroup5Click(Sender: TObject);
begin
  ACAD_CAP_options.ActiveControl:=LabeledEdit1;
end;

procedure TACAD_CAP_options.ComboBox1Click(Sender: TObject);
begin
  ACAD_CAP_options.ActiveControl:=LabeledEdit1;
end;

procedure TACAD_CAP_options.FormActivate(Sender: TObject);
var k:integer;
begin
//  ShowMessage('TACAD_CAP_options.FormActivate');
  If VLMassive_Baza<>nil then
    begin
    ACAD_CAP_options.ComboBox1.Items.Clear;
    for k:=Low(VLMassive_Baza) to high(VLMassive_Baza) do
       ACAD_CAP_options.ComboBox1.Items.Add(VLMassive_Baza[k].Massive_Name);
    ACAD_CAP_options.Label2.Visible:=False;
    ACAD_CAP_options.ComboBox1.Visible:=True;
    ACAD_CAP_options.Edit1.Visible:=True;
    end
    else
    begin
    ACAD_CAP_options.Label2.Visible:=True;
    ACAD_CAP_options.ComboBox1.Visible:=False;
    ACAD_CAP_options.Edit1.Visible:=False;
    end;
  If GetInfoStringItemSelected<=ACAD_CAP_options.ComboBox1.Items.Count then
    ACAD_CAP_options.ComboBox1.ItemIndex:=GetInfoStringItemSelected
    else ACAD_CAP_options.ComboBox1.ItemIndex:=ACAD_CAP_options.ComboBox1.Items.Count;
  Proverka;
  ACAD_CAP_options.ActiveControl:=LabeledEdit1;
end;

procedure TACAD_CAP_options.ComboBox1Select(Sender: TObject);
begin
  Proverka;
  GetInfoStringItemSelected:=ACAD_CAP_options.ComboBox1.ItemIndex+1;
end;

procedure TACAD_CAP_options.LabeledEdit1Change(Sender: TObject);
begin
  Proverka;
end;

end.
