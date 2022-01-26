unit VL_Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask,
  VLeshka, ComCtrls, CheckLst;

type
  TVLOptions = class(TForm)
    RadioGroup1: TRadioGroup;
    Edit1: TEdit;
    RadioGroup2: TRadioGroup;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox6: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    CheckBox3: TCheckBox;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    MaskEdit3: TMaskEdit;
    MaskEdit4: TMaskEdit;
    MaskEdit5: TMaskEdit;
    Button3: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VLOptions: TVLOptions;

implementation

uses VLFormACAD_podpisi;

{$R *.dfm}

procedure TVLOptions.Button2Click(Sender: TObject);
begin
  VLForm_ACAD_podpis.ShowModal;
end;

procedure TVLOptions.Button1Click(Sender: TObject);
begin
  VLOptions.Close;
end;

end.
