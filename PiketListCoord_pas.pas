unit PiketListCoord_pas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, VLeshka, Menus, ExtCtrls;

type
  TPiketListCoord = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ComboBox1: TComboBox;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    ScrollBox1: TScrollBox;
    StringGrid1: TStringGrid;
    Label2: TLabel;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure N2Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Type TabPik=record
     StringGrid1:TStringGrid;
     Label2:TLabel;
     end;

var
  PiketListCoord: TPiketListCoord;

  //удобоваримые данные для вложенной таблицы пикетов
  ArrayOfSendArrayListPiket:Array of ArrayOfAdresPiket;
  //результат, изменили или нет таблицу при просматривании пикетов
  ResultChanged:Boolean;
  TabPiketListCoordEditMode:boolean;

  ArrayTabPik: array of TabPik;

implementation

uses PiketList_pas, VL_Process_pas;

{$R *.dfm}

procedure TPiketListCoord.Button1Click(Sender: TObject);
begin
  Pikets_was_Changed:=True;
  PiketListCoord.Close;
end;

procedure TPiketListCoord.Button2Click(Sender: TObject);
begin
  PiketListCoord.Close;
end;

procedure TPiketListCoord.FormResize(Sender: TObject);
begin
//  PiketListCoord.Width:=PiketListCoord.StringGrid1.Width+8;
//  PiketListCoord.StringGrid1.Height:=PiketListCoord.Height-87;
  PiketListCoord.GroupBox1.Height:=PiketListCoord.Height-119;//100;
  PiketListCoord.GroupBox1.Width:=PiketListCoord.Width-9;
  PiketListCoord.ScrollBox1.Height:=PiketListCoord.GroupBox1.Height-16;
  PiketListCoord.ScrollBox1.Width:=PiketListCoord.GroupBox1.Width-15;
  PiketListCoord.Button1.Top:=PiketListCoord.GroupBox1.Height+50;
  PiketListCoord.Button2.Top:=PiketListCoord.GroupBox1.Height+50;
  PiketListCoord.Button3.Top:=PiketListCoord.GroupBox1.Height+50;
  PiketList.Button1.Left:=Round(PiketListCoord.Width/2)-PiketListCoord.Button1.Width-3-40;
  PiketList.Button2.Left:=Round(PiketListCoord.Width/2)+3-40;
  PiketList.Button3.Left:=Round(PiketListCoord.Width/2)+3-40+PiketListCoord.Button2.Width+5;

end;

procedure TPiketListCoord.N1Click(Sender: TObject);
begin
  if Form1.PiketListEdit(ArrayOfSendArrayListPiket[PiketListCoord.StringGrid1.Row-1])=true then
    begin
    ResultChanged:=True;
    PiketListCoord.Close;
    end;
end;

procedure TPiketListCoord.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  PiketListCoord.StringGrid1.Cells[ACol,ARow]:=FloatToStr(Form1.String_to_FloatNum(PiketListCoord.StringGrid1.Cells[ACol,ARow]));
  PiketListCoord.StringGrid1.EditorMode:=PiketListCoord.StringGrid1.EditorMode;
end;

procedure TPiketListCoord.N2Click(Sender: TObject);
var i:integer;
begin
  PiketListCoord.N2.Checked:=NOT PiketListCoord.N2.Checked;
  TabPiketListCoordEditMode:=PiketListCoord.N2.Checked;
  if PiketListCoord.N2.Checked=true then
    begin
    PiketListCoord.StringGrid1.Options:=PiketListCoord.StringGrid1.Options + [goEditing];
    for i:=Low(ArrayTabPik) to high(ArrayTabPik) do
       ArrayTabPik[i].StringGrid1.Options:=ArrayTabPik[i].StringGrid1.Options + [goEditing];
    end
    else
    begin
    PiketListCoord.StringGrid1.Options:=PiketListCoord.StringGrid1.Options - [goEditing];
    for i:=Low(ArrayTabPik) to high(ArrayTabPik) do
       ArrayTabPik[i].StringGrid1.Options:=ArrayTabPik[i].StringGrid1.Options - [goEditing];
    end;
  PiketListCoord.StringGrid1.EditorMode:=PiketListCoord.N2.Checked;
  for i:=Low(ArrayTabPik) to high(ArrayTabPik) do
     ArrayTabPik[i].StringGrid1.EditorMode:=PiketListCoord.N2.Checked;
end;

procedure TPiketListCoord.PopupMenu1Popup(Sender: TObject);
begin
  PiketListCoord.N2.Checked:=TabPiketListCoordEditMode;
end;

procedure TPiketListCoord.Button3Click(Sender: TObject);
  var tStr:tStrings;
      i,j:integer;
begin
  tStr:=Tstringlist.Create;
  tStr.Add('4 столбца: '+PiketListCoord.StringGrid1.Cells[0,0]+'/имя пикета/'+
  PiketListCoord.StringGrid1.Cells[4,0]+'/'+PiketListCoord.StringGrid1.Cells[5,0]);
//  tStr.Add('');
  tStr.Add(PiketListCoord.Label2.Caption);
  For i:=PiketListCoord.StringGrid1.FixedRows-1+1 to PiketListCoord.StringGrid1.RowCount-1 do
     tStr.Add(PiketListCoord.StringGrid1.Cells[0,i]+chr(9)+
     PiketListCoord.StringGrid1.Cells[1,i]+PiketListCoord.StringGrid1.Cells[2,i]+PiketListCoord.StringGrid1.Cells[3,i]+chr(9)+
     PiketListCoord.StringGrid1.Cells[4,i]+chr(9)+PiketListCoord.StringGrid1.Cells[5,i]);
//tstr.SaveToFile('c:\1.txt');
  tStr.Add('');
  For j:=low(ArrayTabPik) to High(ArrayTabPik) do
     begin
     tStr.Add(ArrayTabPik[j].Label2.Caption);
     For i:=ArrayTabPik[j].StringGrid1.FixedRows-1+1 to ArrayTabPik[j].StringGrid1.RowCount-1 do
     tStr.Add(ArrayTabPik[j].StringGrid1.Cells[0,i]+chr(9)+
     ArrayTabPik[j].StringGrid1.Cells[1,i]+ArrayTabPik[j].StringGrid1.Cells[2,i]+ArrayTabPik[j].StringGrid1.Cells[3,i]+chr(9)+
     ArrayTabPik[j].StringGrid1.Cells[4,i]+chr(9)+ArrayTabPik[j].StringGrid1.Cells[5,i]);
     tStr.Add('');
     end;

  Form1.SaveDialog1.InitialDir:=put_out_documents;
  Form1.SaveDialog1.Filter := '*.txt';
  Form1.SaveDialog1.DefaultExt:='txt';
  If Form1.SaveDialog1.Execute=True then
    tStr.SaveToFile(Form1.SaveDialog1.FileName);

//  tStr.SaveToFile('c:\1.txt');
  FreeAndNil(tStr);
end;

procedure TPiketListCoord.FormActivate(Sender: TObject);
begin
  VLProcess.Visible:=False;
//  PiketListCoord.Button1.Enabled:=False;
end;

end.
