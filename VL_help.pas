unit VL_help;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls;

type
  TVL_help = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label7: TLabel;
    Label8: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VLhelp: TVL_help;

implementation

uses VLRekvizits_pas;
{$R *.dfm}

procedure TVL_help.Button2Click(Sender: TObject);
begin
  VLhelp.Close;
end;

procedure TVL_help.Button1Click(Sender: TObject);
begin
//  ShowMessage('Реквизит лицевого счёта Сбербанка РФ:'+#13#10+
//              '        40817810175021505390'+#13#10+
//              'отпишитесь на емейл кто сделал денежный перевод !');
  VLRekvizits.ShowModal;
end;

end.
