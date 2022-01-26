unit VL_Process_pas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TVLProcess = class(TForm)
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VLProcess: TVLProcess;
  VLProcessStep,VLProcessStepPosition:extended;

implementation

{$R *.dfm}

end.
