unit PiketList_pas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, VLeshka, Menus;

type
  TPiketList = class(TForm)
    StringGrid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StringGrid1MouseWheelDown(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure StringGrid1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PiketList: TPiketList;

  TabPiketListEditMode:Boolean;

implementation

{$R *.dfm}

procedure TPiketList.FormResize(Sender: TObject);
begin
//  PiketList.Width:=PiketList.StringGrid1.Width+8;
//  if PiketList.Width<(PiketList.Button1.Width+PiketList.Button2.Width+55) then
//    PiketList.Width:=(PiketList.Button1.Width+PiketList.Button2.Width+55);
  PiketList.StringGrid1.Width:=PiketList.Width-8;
  PiketList.StringGrid1.Height:=PiketList.Height-55;
  PiketList.Button1.Top:=PiketList.StringGrid1.Height+3;
  PiketList.Button1.Left:=Round(PiketList.Width/2)-PiketList.Button1.Width-3-40;
  PiketList.Button2.Top:=PiketList.StringGrid1.Height+3;
  PiketList.Button2.Left:=Round(PiketList.Width/2)+3-40;
  PiketList.Button3.Top:=PiketList.StringGrid1.Height+3;
  PiketList.Button3.Left:=Round(PiketList.Width/2)+3-40+PiketList.Button2.Width+5;
end;

procedure TPiketList.Button1Click(Sender: TObject);
begin
  Pikets_was_Changed:=True;
  PiketList.Close;
end;

procedure TPiketList.Button2Click(Sender: TObject);
begin
  PiketList.Close;
end;

procedure TPiketList.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  //PiketList.StringGrid1
//  if ACol=2 then
//    PiketList.StringGrid1.Cells[ACol,ARow]:=IntToStr(Round(Form1.String_to_FloatNum(PiketList.StringGrid1.Cells[ACol,ARow])));
  if (ACol=4) or (ACol=5) then
    PiketList.StringGrid1.Cells[ACol,ARow]:=FloatToStr(Form1.String_to_FloatNum(PiketList.StringGrid1.Cells[ACol,ARow]));
//  PiketList.StringGrid1.EditorMode:=PiketList.N1.Checked;
end;

procedure TPiketList.PopupMenu1Popup(Sender: TObject);
begin
  PiketList.N1.Checked:=TabPiketListEditMode;
end;

procedure TPiketList.N1Click(Sender: TObject);
begin
  PiketList.N1.Checked:=NOT PiketList.N1.Checked;
  TabPiketListEditMode:=PiketList.N1.Checked;
  if PiketList.N1.Checked=true then PiketList.StringGrid1.Options:=PiketList.StringGrid1.Options + [goEditing]
    else PiketList.StringGrid1.Options:=PiketList.StringGrid1.Options - [goEditing];
  PiketList.StringGrid1.EditorMode:=TabPiketListEditMode;
end;

procedure TPiketList.Button3Click(Sender: TObject);
  var tStr:tStrings;
      i:integer;
begin
  tStr:=Tstringlist.Create;
  tStr.Add('4 столбца: '+PiketList.StringGrid1.Cells[0,0]+'/имя пикета/'+
  PiketList.StringGrid1.Cells[4,0]+'/'+PiketList.StringGrid1.Cells[5,0]);
  For i:=PiketList.StringGrid1.FixedRows-1+1 to PiketList.StringGrid1.RowCount-1 do
     tStr.Add(PiketList.StringGrid1.Cells[0,i]+chr(9)+
     PiketList.StringGrid1.Cells[1,i]+PiketList.StringGrid1.Cells[2,i]+PiketList.StringGrid1.Cells[3,i]+chr(9)+
     PiketList.StringGrid1.Cells[4,i]+chr(9)+PiketList.StringGrid1.Cells[5,i]);
//добавлять пустую строку не надо, потому что итак пихает три пустые строки, почему-то
//tstr.SaveToFile('c:\1.txt');
  tStr.Add('');

  Form1.SaveDialog1.InitialDir:=put_out_documents;
  Form1.SaveDialog1.Filter := '*.txt';
  Form1.SaveDialog1.DefaultExt:='txt';
  If Form1.SaveDialog1.Execute=True then
    tStr.SaveToFile(Form1.SaveDialog1.FileName);

  tStr.SaveToFile('c:\1.txt');
  FreeAndNil(tStr);
end;

procedure TPiketList.FormActivate(Sender: TObject);
begin
//  PiketList.Button1.Enabled:=False;
end;

procedure TPiketList.StringGrid1MouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
//  beep;
end;

procedure TPiketList.StringGrid1MouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
//  beep;
end;

end.
