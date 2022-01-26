unit VL_LoadCSV;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, VLeshka, MMSystem,
  ExtCtrls, Grids, DirOutln, FileCtrl;//, VLeshka;//, ShellListView1;// in 'D:\Program Files\Borland\BDS\4.0\Demos\DelphiWin32\VCLWin32\ShellControls\ShellListView1.pas'{, CommCtrl};

type
  TVLloadCSV = class(TForm)
    Button1: TButton;
    FilterComboBox1: TFilterComboBox;
    GroupBox1: TGroupBox;
    RadioGroup2: TRadioGroup;
    GroupBox2: TGroupBox;
    GroupBox4: TGroupBox;
    UpDown2: TUpDown;
    GroupBox5: TGroupBox;
    UpDown3: TUpDown;
    Label4: TLabel;
    Panel1: TPanel;
    Label6: TLabel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    StaticText1: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    ComboBox2: TComboBox;
    UpDown1: TUpDown;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label1: TLabel;
    DriveComboBox1: TDriveComboBox;
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    Label9: TLabel;
    GroupBox6: TGroupBox;
    RadioGroup3: TRadioGroup;
    GroupBox7: TGroupBox;
    UpDown4: TUpDown;
    UpDown5: TUpDown;
    Label10: TLabel;
    Label11: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    procedure ShellListView1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FilterComboBox1Click(Sender: TObject);
    procedure StringGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FileListBox1Change(Sender: TObject);
    procedure FileListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DirectoryListBox1MouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure UpDown2ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure UpDown3ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure UpDown4ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure UpDown5ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VLloadCSV: TVLloadCSV;

  File_Name_Under_Mouse:String;

implementation

{$R *.dfm}

procedure VLLoadCSVReset;
  var i:integer;
  begin
  //убираем всё выделение по щелчку по этому тексту и Opened_File_Name=nil соответственно
  For i:=0 to VLLoadCSV.FileListBox1.Items.Count-1 do
     VLLoadCSV.FileListBox1.Selected[i]:=false;
  VLloadCSV.Label6.Caption:='Выбрано файлов: '+FloatToStr(0);

  VLLoadCSV.StringGrid1.Visible:=False;
  VlloadCSV.StringGrid2.Visible:=False;
  FreeAndNil(Opened_File_Name);
  VLLoadCSV.StaticText3.Visible:=False;
  VLLoadCSV.StaticText3.Caption:='X: ';
  VLLoadCSV.StaticText4.Visible:=False;
  VLLoadCSV.StaticText4.Caption:='Y: ';

  VLLoadCSV.ComboBox2.Visible:=False;
  end;
  

function Files_Select:Boolean;
var i:integer;
begin
  result:=false;
  For i:=0 to VLLoadCSV.FileListBox1.Items.Count-1 do
     if VLLoadCSV.FileListBox1.Selected[i]=true then
       begin
       result:=true;
       exit;
       end;
end;

procedure Ocenka_Prav_VVoda_koordinate;
var miffile:TextFile;
    strdmif:String;
      string_csv_file:string;
      File_CSV:TextFile;
      Xkoord,Ykoord:extended;
begin
  //оценка правильности определения координат
  //if (VLLoadCSV.FilterComboBox1.Mask='*.mif') then
  If ExtractFileExt(Form1.Capital_leters_No(Opened_File_Name[0]))='.mif' then
      begin
      AssignFile(miffile,Opened_File_Name[VLLoadCSV.ComboBox2.ItemIndex]);
      Reset(miffile);
      Repeat
      readln(miffile,strdmif);
      If  EOF(miffile)=true then
        begin
        VLLoadCSV.StaticText3.Font.Color:=clRed;
        VLLoadCSV.StaticText3.Visible:=True;
        VLLoadCSV.StaticText3.Caption:='X: обьекты не найдены';
        VLLoadCSV.StaticText4.Font.Color:=clRed;
        VLLoadCSV.StaticText4.Visible:=True;
        VLLoadCSV.StaticText4.Caption:='Y: обьекты не найдены';
        exit;
        end;
      Until copy(strdmif,1,6)='Region';
      VLLoadCSV.StaticText3.Font.Color:=clWindowText;
      VLLoadCSV.StaticText4.Font.Color:=clWindowText;

      readln(miffile,strdmif);
      readln(miffile,strdmif);
      CloseFile(miffile);
      Form1.ExtractKoordinateFromMapInfoString(strdmif,Xkoord,Ykoord); //и вытаскиваем в него координаты
      VLLoadCSV.StaticText3.Visible:=True;
      VLLoadCSV.StaticText3.Caption:='X: '+FloatToStr(Xkoord)+' м.';
      VLLoadCSV.StaticText4.Visible:=True;
      VLLoadCSV.StaticText4.Caption:='Y: '+FloatToStr(Ykoord)+' м.';
      end;

      //If VLLoadCSV.FilterComboBox1.Mask='*.csv' then
      If (ExtractFileExt(Form1.Capital_leters_No(Opened_File_Name[0]))='.csv') or
        (ExtractFileExt(Form1.Capital_leters_No(Opened_File_Name[0]))='.txt') then
        begin
        AssignFile(File_CSV,Opened_File_Name[VLLoadCSV.ComboBox2.ItemIndex]);
        Reset(File_CSV);
        Repeat
        Readln(File_CSV,string_csv_file);
        Form1.ExtractKoordinateFromCSVString(string_csv_file,Xkoord,Ykoord);
        Until ((Xkoord<>0) and (Ykoord<>0)) or EOF(File_CSV);
        CloseFile(File_CSV);
        if (Xkoord=0) or (Ykoord=0) then
          begin
          VLLoadCSV.StaticText3.Font.Color:=clRed;
          VLLoadCSV.StaticText4.Font.Color:=clRed;
          end
          else
          begin
          VLLoadCSV.StaticText3.Font.Color:=clWindowText;
          VLLoadCSV.StaticText4.Font.Color:=clWindowText;
          end;
        VLLoadCSV.StaticText3.Visible:=True;
        VLLoadCSV.StaticText3.Caption:='X: '+FloatToStr(Xkoord)+' м.';
        VLLoadCSV.StaticText4.Visible:=True;
        VLLoadCSV.StaticText4.Caption:='Y: '+FloatToStr(Ykoord)+' м.';
        end;

end;

Procedure VLListSelectedFiles;
var i:integer;
    sf:string;
begin
  //сохраняем то, что выделено в "Оценка правильности ввода координат", для сохранения этого же имени файла при сохранении его в списке выделенных файлов
  if ExtractFileExt(VLLoadCSV.ComboBox2.Text)=VLLoadCSV.FilterComboBox1.Mask then
    sf:=VLLoadCSV.ComboBox2.Text;

  //перебираем файлы из списка файлов в каталоге ShellListView1.Items
  //Сперва составляем список файлов для анализа, Opened_File_Name. Лучше сделать правило - держать Opened_File_Name не равным nil, только если его Count>0
  //Подготовка...
  Opened_File_Name:=Tstringlist.Create;
  VLLoadCSV.ComboBox2.Items:=Tstringlist.Create;
  //Составляем
  While VLloadCSV.ComboBox2.Items.Count<>0 do VLloadCSV.ComboBox2.Items.Delete(VLloadCSV.ComboBox2.Items.Count-1); //лучше так сделаю - Clear, бывает, глючит
  For i:=0 to VLLoadCSV.FileListBox1.Items.Count-1 do
     if VLLoadCSV.FileListBox1.Selected[i]=true then
       begin
       Opened_File_Name.Add(VLLoadCSV.FileListBox1.Items[i]);
       VLLoadCSV.ComboBox2.Items.Add(ExtractFileName(VLLoadCSV.FileListBox1.Items[i]));
       //Список выбранных файлов для анализа правильности введения координат
       if VLLoadCSV.ComboBox2.ItemIndex<>-1 then   //если пока не поставлено имя файла
         if VLLoadCSV.ComboBox2.Items[VLLoadCSV.ComboBox2.Items.Count-1]=sf then
           VLLoadCSV.ComboBox2.ItemIndex:=VLLoadCSV.ComboBox2.Items.Count-1;
       end;  //For i:=0 to ...
  if Opened_File_Name.Count=0 then FreeAndNil(Opened_File_Name);

  //Что показывать списку выбранных файлов для анализа правильности введения координат
  if VLLoadCSV.ComboBox2.ItemIndex=-1 then
      begin
      if Opened_File_Name<>nil then
        begin
        VLLoadCSV.ComboBox2.Visible:=True;
        VLLoadCSV.ComboBox2.ItemIndex:=0;
        end
    else
        VLLoadCSV.ComboBox2.Visible:=False;
      end;

//  SetCurrentDir(VLloadCSV.DirectoryListBox1.GetNamePath);
end;

Procedure VLTabAnalizAndKol_Reg;
  var i:integer;
      midfile,miffile:TextFile;
      strdmid,strdmif:String;
      integer_tmp:Integer;

      Kol_Reg:Integer; //количество регионов, анализируем

      //вспомогательный массив данных из MapInfo-файла; динамический..
      InfoUchastokMapInfo:Array of string;
begin

      Kol_Reg:=0; //количество объектов
      VLloadCSV.StringGrid1.RowCount:=2;    //вводим 0 столбец - номера, и 3 столбца данных
      //сперва заполняем таблицы (они невидимы для начала) данными, для случая если выбран mif-файл
      //пока анализирует только сразу все файлы
      //Если выбираемые файлы - MapInfo,
//      If VLLoadCSV.FilterComboBox1.Mask='*.mif' then
      If ExtractFileExt(Form1.Capital_leters_No(Opened_File_Name[0]))='.mif' then
        begin
        VLLoadCSV.StringGrid2.Top:=17;//30; //подготовился к выводу ещё информации о проекции и единицах измерения в файле
        VLLoadCSV.Label5.Font.Color:=clWindowText; //1-й столбец
        VLLoadCSV.Label7.Font.Color:=clWindowText; //2-й
        VLLoadCSV.Label8.Font.Color:=clWindowText; //2-й

//        VLLoadCSV.Label4.Refresh;
        //то открываем их
        For i:=0 to Opened_File_Name.Count-1 do //список файлов - в Opened_File_Name
           begin
           AssignFile(miffile,Opened_File_Name[i]);
           AssignFile(midfile,copy(Opened_File_Name[i],1,length(Opened_File_Name[i])-3)+'mid');
           Reset(midfile);
           Reset(miffile);
           //читаем количество колонок в MapInfo-файле .mid
           //слизал из модуля VLeshka из процетуры LoadInfoFromMapInfo
           Repeat
           Readln(miffile,strdmif);
           until copy(strdmif,1,8)='CoordSys';  //ищем ключевое слово CoordSys (система координат), после него Columns (число колонок в таблице)
//           if pos(strdmif,' Earth ') <>0 then
           if pos(' NonEarth ',strdmif)=0 then
             //VLLoadCSV.Label3.Caption:='В файле '+Opened_File_Name[i]+' проекция не план-схема.'
             ShowMessage('В файле '+Opened_File_Name[i]+' проекция не план-схема.')
             else
             if pos(' "m" ',strdmif)=0 then
               //VLLoadCSV.Label3.Caption:='В файле '+Opened_File_Name[i]+' единица измерения не метры.';
               ShowMessage('В файле '+Opened_File_Name[i]+' единица измерения не метры.');

           //в KolumnsMapInfo, глобальной переменной, хранятся все данные о колонках открытого файла
           Readln(miffile,strdmif);
           SetLength(KolumnsMapInfo,Round(VLeshka.Form1.String_to_FloatNum(strdmif)));
           SetLength(infouchastokMapInfo,Length(KolumnsMapInfo)); //считаем количество колонок
           //
           VLloadCSV.StringGrid2.ColCount:=Length(KolumnsMapInfo)+1; //количество колонок в таблице = количество колонок в MapInfo-файле +1
           //далее - читаем названия колонок и их типы
           Readln(miffile,strdmif);
           integer_tmp:=0;
           While copy(strdmif,1,4)<>'Data' do
                begin
                While strdmif[1]=' ' do Delete(strdmif,1,Pos(' ',strdmif));
                KolumnsMapInfo[integer_tmp].Name_Column:=Copy(strdmif,1,pos(' ',strdmif));
                Delete(strdmif,1,pos(' ',strdmif));
                If copy(strdmif,1,4)='Char'  then KolumnsMapInfo[integer_tmp].Tip_Column:='Char'
                  else KolumnsMapInfo[integer_tmp].Tip_Column:=strdmif;
                Readln(miffile,strdmif);
                integer_tmp:=integer_tmp+1;
                end;

           //Заполняем таблицы. Сперва их не делаем видимыми, для уменьшения траты мощности компьютера на дисплей
           VLloadCSV.StringGrid2.Cells[0,0]:='Тип';
           VLloadCSV.StringGrid2.Cells[0,1]:='Имя';
           VLloadCSV.StringGrid2.RowCount:=3;
           VLloadCSV.StringGrid2.FixedRows:=2;
           VLloadCSV.StringGrid2.ColWidths[0]:=33; //уменьшаем ширину первого столбца - не надо такой широкий

           //заполняем в таблице информацию о типах колонок в mapinfo-файле
           For integer_tmp:=Low(KolumnsMapInfo) to High(KolumnsMapInfo) do
              begin
              VLloadCSV.StringGrid2.Cells[integer_tmp+1,0]:=KolumnsMapInfo[integer_tmp].Tip_Column;
              VLloadCSV.StringGrid2.Cells[integer_tmp+1,1]:=KolumnsMapInfo[integer_tmp].Name_Column;
              end;

           //заполняем таблицу информацией об объектах; перебираем mapinfo .mif-файл
           while ((not eof(miffile)) and (not eof(midfile))) do
                begin
                Readln(miffile,strdmif);
                if ((copy(strdmif,1,6)='Region') or //учитываем, что при чтении(пропуске) любого объекта в .mif-файле надо так же читать(пропускать) информацию по нему в .mid-файле
                    (copy(strdmif,1,6)='Ellips') or
                    (copy(strdmif,1,6)='Pline ') or
                    (copy(strdmif,1,6)='Point ') or
                    (copy(strdmif,1,5)='Line ')) then
                  Readln(midfile,strdmid);
                if copy(strdmif,1,6)='Region' then          //Поиск регионов
                  begin
                  Kol_Reg:=Kol_Reg+1;  //счётчик объектов
                  If Kol_Reg<>1 then
                    begin
                    VLloadCSV.StringGrid2.RowCount:=VLloadCSV.StringGrid2.RowCount+1; //счётчик строк в таблице //т.к. сперва число строк доложно быть хотя бы на 1 больше числа неподвижных строк (сделано на 1 больше), учитываем в начале эту пустую строку
                    VLloadCSV.StringGrid1.RowCount:=VLloadCSV.StringGrid1.RowCount+1;
                    end;
                  for integer_tmp:=Low(KolumnsMapInfo) to High(KolumnsMapInfo) do
                     infouchastokMapInfo[integer_tmp]:=VLeshka.Form1.GetFromColumnMapInfo(integer_tmp,strdmid); //вытаскиваем информацию в отсортированном виде
                  //заполняем данными по-порядку: номер, и столбцы
                  VLloadCSV.StringGrid2.Cells[0,Kol_Reg+1]:=FloatToStr(Kol_Reg);  //номер объекта-массива
                  For integer_tmp:=Low(KolumnsMapInfo) to High(KolumnsMapInfo) do
                     VLloadCSV.StringGrid2.Cells[integer_tmp+1,Kol_Reg+1]:=infouchastokMapInfo[integer_tmp];

//      for integer_tmp:=2 to VLloadCSV.StringGrid2.RowCount-1 do       //1-й столбец
         begin
         if MapInfoTo1Kol=0 then VLloadCSV.StringGrid1.Cells[1,VLloadCSV.StringGrid1.RowCount-1]:=copy(ExtractFileName(Opened_File_Name[i]),1,Length(ExtractFileName(Opened_File_Name[i]))-Length(ExtractFileExt(Opened_File_Name[i])))
           else
         if VLloadCSV.StringGrid2.ColCount-1>=MapInfoTo1Kol then
           begin
           if MapInfoTo1Kol>VLloadCSV.UpDown2.Min then
             VLloadCSV.StringGrid1.Cells[1,VLloadCSV.StringGrid1.RowCount-1]:=VLloadCSV.StringGrid2.Cells[MapInfoTo1Kol,VLloadCSV.StringGrid2.RowCount-1]
             else VLloadCSV.StringGrid1.Cells[1,VLloadCSV.StringGrid1.RowCount-1]:='';
           end
           else
           begin
           VLLoadCSV.Label5.Font.Color:=clRed;
           VLloadCSV.StringGrid1.Cells[1,VLloadCSV.StringGrid1.RowCount-1]:='';
           end;
         end;

//      for VLloadCSV.StringGrid2.RowCount:=2 to VLloadCSV.StringGrid2.RowCount-1 do       //2-й столбец
         begin
         if MapInfoTo2Kol=0 then VLloadCSV.StringGrid1.Cells[2,VLloadCSV.StringGrid1.RowCount-1]:=copy(ExtractFileName(Opened_File_Name[i]),1,Length(ExtractFileName(Opened_File_Name[i]))-Length(ExtractFileExt(Opened_File_Name[i])))
           else
           if VLloadCSV.StringGrid2.ColCount-1>=MapInfoTo2Kol then
             begin
             if MapInfoTo2Kol>VLloadCSV.UpDown3.Min then
               VLloadCSV.StringGrid1.Cells[2,VLloadCSV.StringGrid1.RowCount-1]:=VLloadCSV.StringGrid2.Cells[MapInfoTo2Kol,VLloadCSV.StringGrid2.RowCount-1]
               else VLloadCSV.StringGrid1.Cells[2,VLloadCSV.StringGrid1.RowCount-1]:='';
             end
           else
             begin
             VLLoadCSV.Label7.Font.Color:=clRed;
             VLloadCSV.StringGrid1.Cells[2,VLloadCSV.StringGrid1.RowCount-1]:='';
             end;
         end;

//      for VLloadCSV.StringGrid2.RowCount:=2 to VLloadCSV.StringGrid2.RowCount-1 do       //3-й столбец
         begin
         if MapInfoTo3Kol=0 then VLloadCSV.StringGrid1.Cells[3,VLloadCSV.StringGrid1.RowCount-1]:=copy(ExtractFileName(Opened_File_Name[i]),1,Length(ExtractFileName(Opened_File_Name[i]))-Length(ExtractFileExt(Opened_File_Name[i])))
           else
         if VLloadCSV.StringGrid2.ColCount-1>=MapInfoTo3Kol then
           begin
           if MapInfoTo3Kol>VLloadCSV.UpDown1.Min then
             VLloadCSV.StringGrid1.Cells[3,VLloadCSV.StringGrid1.RowCount-1]:=VLloadCSV.StringGrid2.Cells[MapInfoTo3Kol,VLloadCSV.StringGrid2.RowCount-1]
             else VLloadCSV.StringGrid1.Cells[3,VLloadCSV.StringGrid1.RowCount-1]:='';
           end
           else
           begin
           VLloadCSV.StringGrid1.Cells[3,VLloadCSV.StringGrid1.RowCount-1]:='';
           VLLoadCSV.Label8.Font.Color:=clRed;
           end;
         end;

                  end;  //if copy(strdmif,1,6)='Region' then          //Поиск регионов
                end;  //while ((not eof(miffile)) and (not eof(midfile))) do
           CloseFile(midfile);
           CloseFile(miffile);
        end; //For i:=0 to Opened_File_Name.Count-1 do

      //далее, переносим данные из таблицы анализа в таблицу данных согласно настройкам ввода Mapinfo-файлов

      for integer_tmp:=2 to VLloadCSV.StringGrid2.RowCount-1 do       //
         VLloadCSV.StringGrid1.Cells[0,integer_tmp-1]:=FloatToStr(integer_tmp-1);
      end;  //If FilterComboBox1.Mask='*.mif' then

//      If VLLoadCSV.FilterComboBox1.Mask='*.csv' then
      if (ExtractFileExt(Form1.Capital_leters_No(Opened_File_Name[0]))='.csv') or
         (ExtractFileExt(Form1.Capital_leters_No(Opened_File_Name[0]))='.txt') then
        begin
        VLLoadCSV.StringGrid2.Top:=17;

        VLloadCSV.StringGrid2.Cells[0,0]:='';
        VLloadCSV.StringGrid2.Cells[1,0]:='Имя файла';

        VLloadCSV.StringGrid2.ColCount:=2; //количество колонок в таблице =0+1
        VLloadCSV.StringGrid2.RowCount:=2;
        VLloadCSV.StringGrid2.FixedRows:=1;

        //слизал из модуля VLeshka из процетуры Load_CSV_Files
        For i:=0 to Opened_File_Name.Count-1 do
           Begin
           Kol_Reg:=Kol_Reg+1;
           VLloadCSV.StringGrid2.Cells[1,Kol_Reg]:=Copy(ExtractFileName(Opened_File_Name[i]),1,
                                                        Length(ExtractFileName(Opened_File_Name[i]))-Length(ExtractFileExt(Opened_File_Name[i])));
           VLloadCSV.StringGrid2.Cells[0,Kol_Reg]:=FloatToStr(Kol_Reg);
           If Kol_Reg<>1 then VLloadCSV.StringGrid2.RowCount:=VLloadCSV.StringGrid2.RowCount+1; //т.к. сперва число строк дложно быть хотя бы на 1 больше числа неподвижных строк (сделано на 1 больше), учитываем в начале эту пустую строку
           end;


        //далее, переносим данные из таблицы анализа в таблицу данных согласно настройкам ввода Mapinfo-файлов
        VLloadCSV.StringGrid1.RowCount:=VLloadCSV.StringGrid2.RowCount;
        for integer_tmp:=1 to VLloadCSV.StringGrid2.RowCount-1 do       //
           VLloadCSV.StringGrid1.Cells[1,integer_tmp]:=VLloadCSV.StringGrid2.Cells[1,integer_tmp];
        for integer_tmp:=1 to VLloadCSV.StringGrid2.RowCount-1 do       //
           VLloadCSV.StringGrid1.Cells[0,integer_tmp]:=FloatToStr(integer_tmp);

        end; //if FilterComboBox1.Mask='.csv' then
    //И открываем информацию об открытых файлах
    VLloadCSV.Label1.Caption:='Найдено объектов: '+FloatToStr(Kol_Reg);
    VLloadCSV.StringGrid1.ColWidths[0]:=33;
    VLloadCSV.StringGrid1.ColWidths[2]:=200;
    VLloadCSV.StringGrid1.Cells[1,0]:=top_name_1_kolumn_tab_list_massivov;   //'Наименование_объекта';
    VLloadCSV.StringGrid1.Cells[2,0]:=top_name_2_kolumn_tab_list_massivov;   //'Тип_объекта';
    VLloadCSV.StringGrid1.Cells[3,0]:=top_name_3_kolumn_tab_list_massivov;   //'Пользователь';
    VLloadCSV.StringGrid1.Visible:=True;

    VLloadCSV.Label1.Visible:=True;
    VLloadCSV.StringGrid2.Visible:=True;

end;

procedure VLAnalizSelectedFiles;  //процедура анализа выделенных файлов
                                  //Всего лишь запускает три остальные процедуры, с вывесом сколько файлов выделено
begin
  //Сперва составляем список файлов для анализа
  VLListSelectedFiles;

  //хз, сделал так.
  if Opened_File_Name<>nil then //тут придерживаюсь правила - держать Opened_File_Name не равным nil, только если его Count>0
    begin
    VLloadCSV.Label6.Caption:='Выбрано файлов: '+FloatToStr(Opened_File_Name.Count);

    //Если выбран определённый тип файла для выбора, то анализируем их содержимое
    //Делаем анализ списка файлов - вставляем данные из всех выбранных файлов в таблицы, выводим данные Kol_Reg
    //сперва заполняем таблицы (они невидимы для начала) данными в завсимости от mif или csv, и открываем информацию
    //Выводим так же кроме таблицы статистику: количества регионов масивов-объектов Kol_Reg
    VLTabAnalizAndKol_Reg;
    //Оценка правильного чтения координат
    Ocenka_Prav_VVoda_koordinate;
    end; //if (Opened_File_Name.Count>0) then

end;

procedure TVLloadCSV.ShellListView1Click(Sender: TObject);
begin
  //help-а нет, документации нет по ShellListView - методом тыка и дедукцией -_-
//  VLAnalizSelectedFiles;  //процедура анализа выделенных файлов
end;

procedure TVLloadCSV.Button1Click(Sender: TObject);
begin
  VLLoadCSV.Close;
end;

procedure TVLloadCSV.FormCreate(Sender: TObject);
begin
  //убираем глюки с TUpDown
  VLLoadCSV.UpDown1.ControlStyle:=VLLoadCSV.UpDown1.ControlStyle-[csCaptureMouse];
  VLLoadCSV.UpDown2.ControlStyle:=VLLoadCSV.UpDown2.ControlStyle-[csCaptureMouse];
  VLLoadCSV.UpDown3.ControlStyle:=VLLoadCSV.UpDown3.ControlStyle-[csCaptureMouse];
  VLLoadCSV.UpDown4.ControlStyle:=VLLoadCSV.UpDown4.ControlStyle-[csCaptureMouse];
  VLLoadCSV.UpDown5.ControlStyle:=VLLoadCSV.UpDown5.ControlStyle-[csCaptureMouse];
end;

procedure TVLloadCSV.RadioGroup2Click(Sender: TObject);
begin
  csvRazdKol:=VLloadCSV.RadioGroup2.ItemIndex;
  //учёт настройки по разделителю колонки
  razdelitel:='';   //во избежание появления warning Variable 'razdelitel' migth not have been initialaized
  Case csvRazdKol of
      0:razdelitel:='.';
      1:razdelitel:=',';
      2:razdelitel:=';';
      3:razdelitel:=' ';
      4:razdelitel:=chr(9);  //пока, это Tab
  end;
  if Files_Select=true then VLAnalizSelectedFiles
    else VLLoadCSVReset;
end;

procedure TVLloadCSV.Label6Click(Sender: TObject);
begin
  VLloadCSVReset;
end;

procedure TVLloadCSV.FormResize(Sender: TObject);
begin
  //подбираем ширину окон выбора файлов
//  VLloadCSV.ShellComboBox1.Width:=VLloadCSV.Width-VLloadCSV.ShellComboBox1.Left-8;
//  VLloadCSV.ShellTreeView1.Width:=VLloadCSV.Width-VLloadCSV.ShellTreeView1.Left-8;
//  VLloadCSV.ShellListView1.Width:=VLloadCSV.Width-VLloadCSV.ShellListView1.Left-8;
  VLloadCSV.FileListBox1.Height:=VLloadCSV.Height-VLloadCSV.FileListBox1.Top-27;
  //делим нижнюю часть поровну между анализируемым и загружаемыми данными
  VLloadCSV.Label3.Top:=Round(VLloadCSV.Height/2)-5;
  VLloadCSV.StringGrid1.Top:=Round(VLloadCSV.Height/2)+10;
  VLloadCSV.StringGrid1.Height:=VLloadCSV.Height-VLLoadCSV.StringGrid1.Top-27-90;//27;
  VLloadCSV.StringGrid1.Width:=VLloadCSV.Width-VLLoadCSV.StringGrid1.Left-8;

  VLloadCSV.StringGrid2.Height:=VLloadCSV.Label3.Top+5-27;
  VLloadCSV.StringGrid2.Width:=VLloadCSV.Width-VLLoadCSV.StringGrid2.Left-8;
end;

procedure TVLloadCSV.ComboBox2Change(Sender: TObject);
begin
  Ocenka_Prav_VVoda_koordinate;
end;

procedure TVLloadCSV.FilterComboBox1Click(Sender: TObject);
//var s:TRoot;
begin

  //Далее, что можно ли выделять несколько файлов в зависимости от типа открываемого файла
  //Почему-то, при присвоении значения VLLoadCSV.ShellListView1.MultiSelect сбивается каталог на root-значение ShellTreeView1.
  //Сама возможность присвоения зачению root строки-пути каталога зависит от настройки типа его каталогов.
  //Приходится запоминать его, после присвоения приходится возвращать его.
//  s:='C:\';//'F:\Delphi\VLeshka MapInfo каталог координат, autocad и многое другое';//'rfDesktop';//VLloadCSV.ShellTreeView1.Path; //запоминаем каталог
//  VLLoadCSV.ShellTreeView1.Root:=s;
//  s:=VLloadCSV.ShellTreeView1.Root;
//  VLLoadCSV.ShellCombobox1.Root:=VLloadCSV.ShellTreeView1.Path;
//  VLLoadCSV.ShellListView1
  if VLLoadCSV.FilterComboBox1.Mask<>'*.*' then VLLoadCSV.FileListBox1.MultiSelect:=True
    else VLLoadCSV.FileListBox1.MultiSelect:=False;
  if VLLoadCSV.FilterComboBox1.Mask<>'*.mif' then VLLoadCSV.GroupBox1.Visible:=True
    else VLLoadCSV.GroupBox1.Visible:=False;
//  VLLoadCSV.ShellCombobox1.Root:=ExtractFileDrive(VLloadCSV.ShellTreeView1.Path);
//  VLloadCSV.ShellTreeView1.Root:=s; //возвращаем каталог
  VLAnalizSelectedFiles;  //процедура анализа выделенных файлов
  VLLoadCSV.FileListBox1.Refresh;
end;

procedure TVLloadCSV.StringGrid1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  VLloadCSV.ActiveControl:=StringGrid1;
end;

procedure TVLloadCSV.FileListBox1Change(Sender: TObject);
begin
  VLAnalizSelectedFiles;  //процедура анализа выделенных файлов
end;

procedure TVLloadCSV.FileListBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  var i:integer;
  StringFilter,StringMask,UnderMouseFileName:String;
begin
  if VLloadCSV.FileListBox1.ItemAtPos(Point(X,Y),true)<0 then exit;

  if Files_Select=true then exit;

  try
  UnderMouseFileName:=VLloadCSV.FileListBox1.Items[VLloadCSV.FileListBox1.ItemAtPos(Point(X,Y),true)];
  except
  on EStringlistError do exit;
  end;

  If File_Name_Under_Mouse=UnderMouseFileName then exit;

  File_Name_Under_Mouse:=UnderMouseFileName;
  StringFilter:=VLLoadCSV.FilterComboBox1.Filter;

  if VLLoadCSV.FilterComboBox1.Mask='*.*' then
    For i:=0 to VLloadCSV.FilterComboBox1.Items.Count-1 do
       begin
       Delete(StringFilter,1,Pos('|',StringFilter));
       if i=VLloadCSV.FilterComboBox1.Items.Count-1 then StringMask:=Copy(StringFilter,2,Length(StringFilter)-1)
         else StringMask:=Copy(StringFilter,2,Pos('|',StringFilter)-2);
       if StringMask<>'.*' then
         If Form1.Capital_leters_No(StringMask)=ExtractFileExt(Form1.Capital_leters_No(UnderMouseFileName)) then
           begin
           While VLloadCSV.ComboBox2.Items.Count<>0 do VLloadCSV.ComboBox2.Items.Delete(VLloadCSV.ComboBox2.Items.Count-1); //лучше так сделаю - Clear, бывает, глючит
           VLloadCSV.ComboBox2.Items.Add(ExtractFileName(UnderMouseFileName));
           VLloadCSV.ComboBox2.ItemIndex:=VLloadCSV.ComboBox2.Items.Count-1;
           Opened_File_Name:=Tstringlist.Create;
           Opened_File_Name.Add(UnderMouseFileName);
           VLTabAnalizAndKol_Reg;
           VLLoadCSV.Label6.Caption:='Выбрано: '+FloatToStr(0)+' файл(а,ов)';
           Ocenka_Prav_VVoda_koordinate;
           FreeAndNil(Opened_File_Name);
           end;
       Delete(StringFilter,1,Pos('|',StringFilter));
       end;
  VLloadCSV.ActiveControl:=FileListBox1;
end;

procedure TVLloadCSV.DirectoryListBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  VLloadCSV.ActiveControl:=DirectoryListBox1;
end;

procedure TVLloadCSV.Panel1Click(Sender: TObject);
begin
  VLLoadCSVReset;
end;

procedure TVLloadCSV.Label1Click(Sender: TObject);
begin
  VLLoadCSVReset;
end;

procedure TVLloadCSV.UpDown2ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  //MapInfoToXKol=0 - вводим имя файла. <0 - не вводим ничего

  //updNone, updUp, updDown
  if Direction=updNone then
     playsound(PChar('SYSTEMHAND'), 0, SND_ASYNC); //MessageBeep;//ShowMessage(BoolToStr(AllowChange)+' '+FloatToStr(NewValue)+' updNone');
  if (NewValue>=VLLoadCSV.UpDown2.Min+2) and(NewValue<=VLLoadCSV.UpDown2.Max) then
    VLLoadCSV.Label5.Caption:='из '+FloatToStr(NewValue)+'-й колонки'
    else
    if (NewValue=VLLoadCSV.UpDown2.Min+1) then VLLoadCSV.Label5.Caption:='имя файла'
      else VLLoadCSV.Label5.Caption:='не вводим';

  if (NewValue>=VLLoadCSV.UpDown2.Min) and(NewValue<=VLLoadCSV.UpDown2.Max) then
    MapInfoTo1Kol:=NewValue;

  if Files_Select=true then VLAnalizSelectedFiles
    else VLLoadCSVReset;
{
  if (MapInfoTo1Kol=0) then VLLoadCSV.Label5.Caption:='имя файла'
    else
    if (MapInfoTo1Kol<=MapInfoTo1Kol>VLLoadCSV.UpDown2.Min) or(MapInfoTo1Kol>VLLoadCSV.UpDown2.Max) then
      VLLoadCSV.Label5.Caption:='не вводим'
      else VLLoadCSV.Label5.Caption:='из '+FloatToStr(MapInfoTo1Kol)+'-й колонки';

  if (MapInfoTo2Kol=0) then VLLoadCSV.Label7.Caption:='имя файла'
    else
    if (MapInfoTo2Kol<=MapInfoTo2Kol>VLLoadCSV.UpDown3.Min) or(MapInfoTo2Kol>VLLoadCSV.UpDown3.Max) then
      VLLoadCSV.Label7.Caption:='не вводим'
      else VLLoadCSV.Label7.Caption:='из '+FloatToStr(MapInfoTo2Kol)+'-й колонки';

  if (MapInfoTo3Kol=0) then VLLoadCSV.Label8.Caption:='имя файла'
    else
    if (MapInfoTo3Kol<=VLLoadCSV.UpDown1.Min) or(MapInfoTo3Kol>VLLoadCSV.UpDown1.Max) then
      VLLoadCSV.Label8.Caption:='не вводим'
      else VLLoadCSV.Label8.Caption:='из '+FloatToStr(MapInfoTo3Kol)+'-й колонки';
}
end;

procedure TVLloadCSV.UpDown3ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  if Direction=updNone then
     playsound(PChar('SYSTEMHAND'), 0, SND_ASYNC); //MessageBeep;//ShowMessage(BoolToStr(AllowChange)+' '+FloatToStr(NewValue)+' updNone');
  if (NewValue>=VLLoadCSV.UpDown3.Min+2) and(NewValue<=VLLoadCSV.UpDown3.Max) then
    VLLoadCSV.Label7.Caption:='из '+FloatToStr(NewValue)+'-й колонки'
    else
    if (NewValue=VLLoadCSV.UpDown3.Min+1) then VLLoadCSV.Label7.Caption:='имя файла'
      else VLLoadCSV.Label7.Caption:='не вводим';
 if (NewValue>=VLLoadCSV.UpDown3.Min) and(NewValue<=VLLoadCSV.UpDown3.Max) then
    MapInfoTo2Kol:=NewValue;

  if Files_Select=true then VLAnalizSelectedFiles
    else VLLoadCSVReset;
end;

procedure TVLloadCSV.UpDown1ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  if Direction=updNone then
     playsound(PChar('SYSTEMHAND'), 0, SND_ASYNC); //MessageBeep;//ShowMessage(BoolToStr(AllowChange)+' '+FloatToStr(NewValue)+' updNone');
  if (NewValue>=VLLoadCSV.UpDown1.Min+2) and(NewValue<=VLLoadCSV.UpDown1.Max) then
    VLLoadCSV.Label8.Caption:='из '+FloatToStr(NewValue)+'-й колонки'
    else
    if (NewValue=VLLoadCSV.UpDown1.Min+1) then VLLoadCSV.Label8.Caption:='имя файла'
      else
      VLLoadCSV.Label8.Caption:='не вводим';

  if (NewValue>=VLLoadCSV.UpDown1.Min) and(NewValue<=VLLoadCSV.UpDown1.Max) then
    MapInfoTo3Kol:=NewValue;

  if Files_Select=true then VLAnalizSelectedFiles
    else VLLoadCSVReset;
end;

procedure TVLloadCSV.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{
//сохранение параметров
  //\\\\\\\\\\\\\\\\\Настройки начала нового пректа/////////////////
  //#Настройки загрузки csv-файлов
  //X - в первой колонке, 2, автоматически
  SaveIni('csvXYreplace',csvXYreplace);
  //разделитель между колонками
  SaveIni('csvRazdKol',csvRazdKol);

  //#Настройки загрузки в колонки
  //В первую колонку
  SaveIni('MapInfoTo1Kol',MapInfoTo1Kol);
  //из какой колоки данных загружаемого файла загружать во вторую колнку таблицы данных
  SaveIni('MapInfoTo2Kol',MapInfoTo2Kol);
  //из какой колоки данных загружаемого файла загружать в третью колонку таблицы данных
  SaveIni('MapInfoTo3Kol',MapInfoTo3Kol);
}
end;

procedure TVLloadCSV.FormActivate(Sender: TObject);
begin
  //#применяем настройки
  VLloadCSV.FilterComboBox1.ItemIndex:=csvFileMask;
  if VLLoadCSV.FilterComboBox1.Mask<>'*.*' then VLLoadCSV.FileListBox1.MultiSelect:=True
    else VLLoadCSV.FileListBox1.MultiSelect:=False;
  if VLLoadCSV.FilterComboBox1.Mask<>'*.mif' then VLLoadCSV.GroupBox1.Visible:=True
    else VLLoadCSV.GroupBox1.Visible:=False;
  VLloadCSV.RadioGroup2.ItemIndex:=csvRazdKol;

  VLloadCSV.UpDown2.Increment:=1; //шаг изменения
  VLloadCSV.UpDown2.Min:=-1;
  VLloadCSV.UpDown2.Max:=100;
  VLloadCSV.UpDown2.Position:=MapInfoTo1Kol;

  VLloadCSV.UpDown1.Increment:=1; //шаг изменения
  VLloadCSV.UpDown1.Min:=-1;
  VLloadCSV.UpDown1.Max:=100;
  VLloadCSV.UpDown1.Position:=MapInfoTo3Kol;

  VLloadCSV.UpDown3.Increment:=1; //шаг изменения
  VLloadCSV.UpDown3.Min:=-1;
  VLloadCSV.UpDown3.Max:=100;
  VLloadCSV.UpDown3.Position:=MapInfoTo2Kol;

  VLloadCSV.UpDown4.Increment:=1; //шаг изменения
  VLloadCSV.UpDown4.Min:=1;
  VLloadCSV.UpDown4.Max:=100;
  VLloadCSV.UpDown4.Position:=Xcolonka;

  VLloadCSV.UpDown5.Increment:=1; //шаг изменения
  VLloadCSV.UpDown5.Min:=1;
  VLloadCSV.UpDown5.Max:=100;
  VLloadCSV.UpDown5.Position:=Ycolonka;

  //MapInfoToXKol=0 - вводим имя файла. <0 - не вводим ничего
  if (MapInfoTo1Kol=0) then VLLoadCSV.Label5.Caption:='имя файла'
    else
    if (MapInfoTo1Kol<=VLLoadCSV.UpDown2.Min) or(MapInfoTo1Kol>VLLoadCSV.UpDown2.Max) then
      VLLoadCSV.Label5.Caption:='не вводим'
      else VLLoadCSV.Label5.Caption:='из '+FloatToStr(MapInfoTo1Kol)+'-й колонки';

  if (MapInfoTo2Kol=0) then VLLoadCSV.Label7.Caption:='имя файла'
    else
    if (MapInfoTo2Kol<=VLLoadCSV.UpDown3.Min) or(MapInfoTo2Kol>VLLoadCSV.UpDown3.Max) then
      VLLoadCSV.Label7.Caption:='не вводим'
      else VLLoadCSV.Label7.Caption:='из '+FloatToStr(MapInfoTo2Kol)+'-й колонки';

  if (MapInfoTo3Kol=0) then VLLoadCSV.Label8.Caption:='имя файла'
    else
    if (MapInfoTo3Kol<=VLLoadCSV.UpDown1.Min) or(MapInfoTo3Kol>VLLoadCSV.UpDown1.Max) then
      VLLoadCSV.Label8.Caption:='не вводим'
      else VLLoadCSV.Label8.Caption:='из '+FloatToStr(MapInfoTo3Kol)+'-й колонки';

  //Координаты
  VLLoadCSV.Label10.Caption:='X: из '+FloatToStr(Xcolonka)+'-й колонки';
  VLLoadCSV.Label11.Caption:='Y: из '+FloatToStr(Ycolonka)+'-й колонки';
      
  File_Name_Under_Mouse:='';

  VLLoadCSV.FileListBox1.Mask:=VLLoadCSV.FilterComboBox1.Mask;

  //Обновляем диски, каталоги, файлы
  VLloadCSV.FileListBox1.Update;
  VLloadCSV.DirectoryListBox1.Update;
  VLloadCSV.DriveComboBox1.Update;
end;

procedure TVLloadCSV.FileListBox1Click(Sender: TObject);
begin
  VLAnalizSelectedFiles;  //процедура анализа выделенных файлов
end;

procedure TVLloadCSV.RadioGroup3Click(Sender: TObject);
begin
  csvRazdOb:=VLloadCSV.RadioGroup3.ItemIndex;
  if Files_Select=true then VLAnalizSelectedFiles
    else VLLoadCSVReset;
end;

procedure TVLloadCSV.UpDown4ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  if Direction=updNone then
     playsound(PChar('SYSTEMHAND'), 0, SND_ASYNC); //MessageBeep;//ShowMessage(BoolToStr(AllowChange)+' '+FloatToStr(NewValue)+' updNone');
  if (NewValue>=VLLoadCSV.UpDown4.Min) and(NewValue<=VLLoadCSV.UpDown4.Max) then
    VLLoadCSV.Label10.Caption:='Х: из '+FloatToStr(NewValue)+' колонки';//'из '+FloatToStr(NewValue)+'-й колонки'

  if (NewValue>=VLLoadCSV.UpDown4.Min) and(NewValue<=VLLoadCSV.UpDown4.Max) then
    Xcolonka:=NewValue;

  if Files_Select=true then VLAnalizSelectedFiles
    else VLLoadCSVReset;
end;

procedure TVLloadCSV.UpDown5ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  if Direction=updNone then
     playsound(PChar('SYSTEMHAND'), 0, SND_ASYNC); //MessageBeep;//ShowMessage(BoolToStr(AllowChange)+' '+FloatToStr(NewValue)+' updNone');
  if (NewValue>=VLLoadCSV.UpDown5.Min) and(NewValue<=VLLoadCSV.UpDown5.Max) then
    VLLoadCSV.Label11.Caption:='Y: из '+FloatToStr(NewValue)+' колонки';//'из '+FloatToStr(NewValue)+'-й колонки'

  if (NewValue>=VLLoadCSV.UpDown5.Min) and(NewValue<=VLLoadCSV.UpDown5.Max) then
    Ycolonka:=NewValue;

  if Files_Select=true then VLAnalizSelectedFiles
    else VLLoadCSVReset;

end;

end.
