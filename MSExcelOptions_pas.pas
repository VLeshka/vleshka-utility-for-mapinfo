unit MSExcelOptions_pas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TMSExcelOptions = class(TForm)
    LabeledEdit1: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MSExcelOptions: TMSExcelOptions;

implementation

uses VLeshka;

{$R *.dfm}

procedure TMSExcelOptions.Button2Click(Sender: TObject);
begin
  MSExcelOptions.Close;
end;

procedure TMSExcelOptions.Button1Click(Sender: TObject);
begin
  if MSExcelOptions.OpenDialog1.Execute=true then
    MSExcelOptions.LabeledEdit1.Text:=MSExcelOptions.OpenDialog1.FileName;
end;

procedure TMSExcelOptions.FormActivate(Sender: TObject);
begin
  MSExcelOptions.LabeledEdit1.Text:=XLS_File_Shablon_name;
end;

procedure TMSExcelOptions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  XLS_File_Shablon_name:=MSExcelOptions.LabeledEdit1.Text;
end;

end.
