unit MSWord_KatKoordOptions_pas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus;

type
  TMSWordKatKoordOptions = class(TForm)
    GroupBox1: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    Button1: TButton;
    CheckBox1: TCheckBox;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    PopupMenu4: TPopupMenu;
    PopupMenu5: TPopupMenu;
    PopupMenu6: TPopupMenu;
    PopupMenu7: TPopupMenu;
    PopupMenu8: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MSWordKatKoordOptions: TMSWordKatKoordOptions;

implementation

uses VLeshka;

{$R *.dfm}

procedure TMSWordKatKoordOptions.Button1Click(Sender: TObject);
begin
  MSWordKatKoordOptions.Close;
end;

procedure TMSWordKatKoordOptions.N1Click(Sender: TObject);
begin
  MSWordKatKoordOptions.LabeledEdit1.Text:=Form1.GetStringMask(MSWordKatKoordOptions.LabeledEdit1.Text);
end;

end.
