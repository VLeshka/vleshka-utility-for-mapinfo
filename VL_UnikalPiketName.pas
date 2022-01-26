unit VL_UnikalPiketName;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Math,
  Dialogs, StdCtrls, Mask, Grids,VLeshka, Menus, ExtCtrls;

type
  TVLUnikalPiketName = class(TForm)
    StringGrid1: TStringGrid;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    GroupBox5: TGroupBox;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    GroupBox6: TGroupBox;
    Button6: TButton;
    Button7: TButton;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Button9: TButton;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Button10: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label17: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    PopupMenu3: TPopupMenu;
    N7: TMenuItem;
    SaveDialog1: TSaveDialog;
    N8: TMenuItem;
    N9: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure Label25Click(Sender: TObject);
    procedure Label24Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure Label14Click(Sender: TObject);
    procedure Label18Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure Make_Piket_Report;
  end;

  type WordsPik=record
       WordString:string;
       KolWord:Integer;
       end;

var
  VLUnikalPiketName: TVLUnikalPiketName;

//  kol_piketov:Array of AdressPiket;

      PiketsWithIndivid_coords:Array of AdressPiket;
                    //1.пикеты с накладывающимися координатами (имена пикеты ДО него - если есть, то +1. Иначе ищем до конца. Чтоб не искать каждый раз с самого начала, составляем список.),
                    //2.всего координат с накладывающимися пикетами (проискываем пикеты ДО выбранного пикета на предмет совпадения, если нашли - координата уже учитывается, бросаем это дело и дальше идём. Иначе ищем до конца),
      PiketsWithNakladCoords:Array of AdressPiket;
      VsegoCoordWithNakladPikets:Array of ArrayOfAdresPiket; //храним списки координат, и пикеты, имеющие эти координаты. Берём координаты, например, от первого пикеты.

  pikets_without_name:Array of AdressPiket;  //пикеты без имени

  AllPiketWithNames:Array of AdressPiket;

  AllPiketWithNamesWOWordBefore:Array of AdressPiket;
  AllPiketWithNamesWONumber:Array of AdressPiket;
  AllPiketWithNamesWOWordAfter:Array of AdressPiket;

                    //3.индивидуальных имён пикетов (надо искать ВСЕ пикеты до конца. Поиск ДО пикета = составление списка не требуется.),
      IndividNamesOfPikets:Array of AdressPiket;

      PiketsWithNoIndividualNames:Array of AdressPiket;
                    //4.с одинаковыми именами и разными координатами (поиск пикетов с одинаковыми именами до конца, и составление списка их адресов)
      IdenticalNamesAndCoords:Array of AdressPiket;
         CoordsIdenticalNamesAndCoords:Array of ArrayOfAdresPiket;

      IdenticalNamesAndDifferentCoords:Array of AdressPiket;
         CoordsIdenticalNamesAndDifferentCoords:Array of ArrayOfAdresPiket;

      kol_piketov:Integer;

      first_num,last_num,pik_num,interval_Fnum:Integer;

      KolNamesBeforePiket,KolNamesAfterPiket:Integer;

      NamesBeforePiket,NamesAfterPiket:array of WordsPik;

implementation

Uses VL_Process_pas;
{$R *.dfm}

Procedure TVLUnikalPiketName.Make_Piket_Report;
  label next_pik_num,end_individ_koord_cikl,
        end_analize_NamesBeforePiket,end_analize_NamesAfterPiket;

  var k,j,l,kp,jp,lp,kc,PikNameNum,i:Integer;
      interval_True:Boolean;
      i_pik_num:Integer;


      FoundPiketWithNakladCoords:Boolean; //Флаг, нашли ли мы "накладывающийся" пикет ? По нему определяем:
                    //1.пикеты с накладывающимися координатами (имена пикеты ДО него - если есть, то +1. Иначе ищем до конца. Чтоб не искать каждый раз с самого начала, составляем список.),
                    //2.всего координат с накладывающимися пикетами (проискываем пикеты ДО выбранного пикета на предмет совпадения, если нашли - координата уже учитывается, бросаем это дело и дальше идём. Иначе ищем до конца),
                    //количество пикетов с индивидуальными координатами
      FoundPiketWithNoindividName:Boolean;  //флаг, что мы нашли пикет не с индивидуальным именем)
begin

  //анализируем слова перед и после пикетов
  //так же, для начала находим минимальный и максимальный номера пикетов; удобно попутно считать пикеты, не имеющие имён, а также количество пикетов
  //, а так же определять количество совпадающихся координаты пикетов
  //пикеты могут иметь номер 0, поэтому надо сперва найти пикет, который имеет нормальный номер.

  //если пикеты были изменены, то делаем тотальный анализ
  if Pikets_was_Changed=true then
    begin

  //если first_num,last_num так и останутся =0, то значит нет пикетов с номерами
  //определяем порядки следования имён пикетов
  first_num:=0;
  last_num:=0;
  KolNamesBeforePiket:=0;
  KolNamesAfterPiket:=0;

  kol_piketov:=0;         //количество пикетов

  NamesBeforePiket:=nil;
  NamesAfterPiket:=nil;

  //пикеты с индивидуальными координатами
  PiketsWithIndivid_coords:=nil;
                    //1.пикеты с накладывающимися координатами (имена пикеты ДО него - если есть, то +1. Иначе ищем до конца. Чтоб не искать каждый раз с самого начала, составляем список.),
      PiketsWithNakladCoords:=nil;
                    //2.всего координат с накладывающимися пикетами (проискываем пикеты ДО выбранного пикета на предмет совпадения, если нашли - координата уже учитывается, бросаем это дело и дальше идём. Иначе ищем до конца),
      VsegoCoordWithNakladPikets:=nil;

  pikets_without_name:=nil;  //пикеты без имени

  AllPiketWithNames:=nil;

  AllPiketWithNamesWOWordBefore:=nil;
  AllPiketWithNamesWONumber:=nil;
  AllPiketWithNamesWOWordAfter:=nil;

                    //3.индивидуальных имён пикетов (надо искать ВСЕ пикеты до конца. Поиск ДО пикета = составление списка не требуется.),
  IndividNamesOfPikets:=nil;

  PiketsWithNoIndividualNames:=nil;
                    //4.с одинаковыми именами и разными координатами (поиск пикетов с одинаковыми именами до конца, и составление списка их адресов)
      IdenticalNamesAndCoords:=nil;
         CoordsIdenticalNamesAndCoords:=nil;
      IdenticalNamesAndDifferentCoords:=nil;
         CoordsIdenticalNamesAndDifferentCoords:=nil;

  //готовим полосу выполнения задания подсчёта
  VLProcess.Label1.Caption:='Операция:';
  VLProcess.Label2.Caption:='Анализ пикетов.';
  VLProcess.ProgressBar1.Min:=Low(VLMassive_Baza);
  VLProcess.ProgressBar1.Max:=Round(Ceil(VLProcess.ProgressBar1.Width/10));
  //готовим
  VLProcessStep:=Length(VLMassive_Baza)/VLProcess.ProgressBar1.Max;
  VLProcessStepPosition:=0;
  VLProcess.ProgressBar1.Step:=1; //для формальности
  VLProcess.ProgressBar1.Position:=0;
  //VLProcess.ShowModal;
  VLProcess.Visible:=True;
  VLProcess.Refresh;

  For k:=Low(VLMassive_Baza) to High(VLMassive_Baza) do
     begin
     if k>=VLProcessStepPosition then
       begin
       VLProcessStepPosition:=VLProcessStepPosition+VLProcessStep;
       VLProcess.ProgressBar1.Position:=Round((k+1)/Length(VLMassive_Baza)*VLProcess.ProgressBar1.Max);
       VLProcess.Refresh;
       end;

     For j:=low(VLMassive_Baza[k].Pikets_Massiva) to High(VLMassive_Baza[k].Pikets_Massiva) do
        begin
        For l:=Low(VLMassive_Baza[k].Pikets_Massiva[j]) to High(VLMassive_Baza[k].Pikets_Massiva[j]) do
           begin
           //Анализируем всего количество слов после- и до- пикета
           if VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik<>'' then
             inc(KolNamesBeforePiket);
           if VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik<>'' then
             inc(KolNamesAfterPiket);
           //Всего пикетов с именами
           if (VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik<>'') or (VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik<>'') or (VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number<>0) then
             begin
             SetLength(AllPiketWithNames,Length(AllPiketWithNames)+1);
             AllPiketWithNames[high(AllPiketWithNames)].ka:=k;
             AllPiketWithNames[high(AllPiketWithNames)].ja:=j;
             AllPiketWithNames[high(AllPiketWithNames)].la:=l;
             if VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik='' then
               begin
               SetLength(AllPiketWithNamesWOWordBefore,Length(AllPiketWithNamesWOWordBefore)+1);
               AllPiketWithNamesWOWordBefore[high(AllPiketWithNamesWOWordBefore)].ka:=k;
               AllPiketWithNamesWOWordBefore[high(AllPiketWithNamesWOWordBefore)].ja:=j;
               AllPiketWithNamesWOWordBefore[high(AllPiketWithNamesWOWordBefore)].la:=l;
               end;
             if VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number=0 then
               begin
               SetLength(AllPiketWithNamesWONumber,Length(AllPiketWithNamesWONumber)+1);
               AllPiketWithNamesWONumber[high(AllPiketWithNamesWONumber)].ka:=k;
               AllPiketWithNamesWONumber[high(AllPiketWithNamesWONumber)].ja:=j;
               AllPiketWithNamesWONumber[high(AllPiketWithNamesWONumber)].la:=l;
               end;
             if VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik='' then
               begin
               SetLength(AllPiketWithNamesWOWordAfter,Length(AllPiketWithNamesWOWordAfter)+1);
               AllPiketWithNamesWOWordAfter[high(AllPiketWithNamesWOWordAfter)].ka:=k;
               AllPiketWithNamesWOWordAfter[high(AllPiketWithNamesWOWordAfter)].ja:=j;
               AllPiketWithNamesWOWordAfter[high(AllPiketWithNamesWOWordAfter)].la:=l;
               end;
             end;

           //#Дальше, сделаем в одном проходе до конца всех пикетов в памяти поиск совпадающих по координатам пикетов, и анализ их.
           //Чтоб не делать поиск до начала, сохраняем списки совпадающих пикетов в списке. Это пикеты, которые нашли, ища с самого начала.
           //сохраняем в памяти:
           //1.пикеты с накладывающимися координатами (имена пикеты ДО него - если есть, то +1. Иначе ищем до конца. Чтоб не искать каждый раз с самого начала, составляем список.),
           //2.всего координат с накладывающимися пикетами (проискываем пикеты ДО выбранного пикета на предмет совпадения, если нашли - координата уже учитывается, бросаем это дело и дальше идём. Иначе ищем до конца),
           //3.индивидуальных имён пикетов (надо искать ВСЕ пикеты до конца. Поиск ДО пикета = составление списка не требуется.),
           //4.с одинаковыми именами и разными координатами (поиск пикетов с одинаковыми именами до конца, и составление списка их адресов)

           //и считаем пикеты с неповторяющимися больше ни у кого координатами

           //Сперва ищем повторяющиеся координаты ДО пикета. Если найдём - значит, это пикет с накладывающимися координатами, и ставим флаг FoundPiketWithNakladCoords в ok.. значит, всего таких координат искать не надо (учли)
           //Учёт делаем по списку найденных пикетов с накладывающимися координатами
           FoundPiketWithNakladCoords:=false;
           For i:=Low(PiketsWithNakladCoords) to high(PiketsWithNakladCoords) do
              if Hypot(VLMassive_Baza[PiketsWithNakladCoords[i].ka].Pikets_Massiva[PiketsWithNakladCoords[i].ja,PiketsWithNakladCoords[i].la].Coordinate.X-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.X,VLMassive_Baza[PiketsWithNakladCoords[i].ka].Pikets_Massiva[PiketsWithNakladCoords[i].ja,PiketsWithNakladCoords[i].la].Coordinate.Y-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.Y)<Minimal_dist_betv_pikets then
                begin
                SetLength(PiketsWithNakladCoords,Length(PiketsWithNakladCoords)+1);
                PiketsWithNakladCoords[high(PiketsWithNakladCoords)].ka:=k;
                PiketsWithNakladCoords[high(PiketsWithNakladCoords)].ja:=j;
                PiketsWithNakladCoords[high(PiketsWithNakladCoords)].la:=l;
                FoundPiketWithNakladCoords:=True;
                //Делаем поиск только по найденным пикетам, при этом только увеличивается количество совпадающих по одной к.-л. координате

                For kc:=Low(VsegoCoordWithNakladPikets) to high(VsegoCoordWithNakladPikets) do
                   if Hypot(VLMassive_Baza[VsegoCoordWithNakladPikets[kc,Low(VsegoCoordWithNakladPikets[kc])].ka].Pikets_Massiva[VsegoCoordWithNakladPikets[kc,Low(VsegoCoordWithNakladPikets[kc])].ja,VsegoCoordWithNakladPikets[kc,Low(VsegoCoordWithNakladPikets[kc])].la].Coordinate.X-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.X,VLMassive_Baza[VsegoCoordWithNakladPikets[kc,Low(VsegoCoordWithNakladPikets[kc])].ka].Pikets_Massiva[VsegoCoordWithNakladPikets[kc,Low(VsegoCoordWithNakladPikets[kc])].ja,VsegoCoordWithNakladPikets[kc,Low(VsegoCoordWithNakladPikets[kc])].la].Coordinate.Y-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.Y)<Minimal_dist_betv_pikets then
                     begin
                     SetLength(VsegoCoordWithNakladPikets[kc],Length(VsegoCoordWithNakladPikets[kc])+1);
                     VsegoCoordWithNakladPikets[kc,high(VsegoCoordWithNakladPikets[kc])].ka:=k;
                     VsegoCoordWithNakladPikets[kc,high(VsegoCoordWithNakladPikets[kc])].ja:=j;
                     VsegoCoordWithNakladPikets[kc,high(VsegoCoordWithNakladPikets[kc])].la:=l;
                     break;
                     end;

                break;
                end;
           //так же, имем повторяющиеся имена ДО пикета. Если найдём - значит, флаг
           //учёт делаем по списку пикетов с неиндивидуальными именами
           FoundPiketWithNoindividName:=False;
           if (VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik<>'') or
              (VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number<>0) or
              (VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik<>'') then
           For i:=Low(PiketsWithNoIndividualNames) to High(PiketsWithNoIndividualNames) do
              if (VLMassive_Baza[PiketsWithNoIndividualNames[i].ka].Pikets_Massiva[PiketsWithNoIndividualNames[i].ja,PiketsWithNoIndividualNames[i].la].WordBeforePik=VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik) and
                 (VLMassive_Baza[PiketsWithNoIndividualNames[i].ka].Pikets_Massiva[PiketsWithNoIndividualNames[i].ja,PiketsWithNoIndividualNames[i].la].Pik_Number=VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number) and
                 (VLMassive_Baza[PiketsWithNoIndividualNames[i].ka].Pikets_Massiva[PiketsWithNoIndividualNames[i].ja,PiketsWithNoIndividualNames[i].la].WordAfterPik=VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik) then
                begin              //PiketsWithSovpadNames[i].
                SetLength(PiketsWithNoIndividualNames,Length(PiketsWithNoIndividualNames)+1);
                PiketsWithNoIndividualNames[high(PiketsWithNoIndividualNames)].ka:=k;
                PiketsWithNoIndividualNames[high(PiketsWithNoIndividualNames)].ja:=j;
                PiketsWithNoIndividualNames[high(PiketsWithNoIndividualNames)].la:=l;
                if Hypot(VLMassive_Baza[PiketsWithNoIndividualNames[i].ka].Pikets_massiva[PiketsWithNoIndividualNames[i].ja,PiketsWithNoIndividualNames[i].la].Coordinate.X-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.X,VLMassive_Baza[PiketsWithNoIndividualNames[i].ka].Pikets_massiva[PiketsWithNoIndividualNames[i].ja,PiketsWithNoIndividualNames[i].la].Coordinate.Y-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.Y)<Minimal_dist_betv_pikets then
                  begin
                  SetLength(IdenticalNamesAndCoords,length(IdenticalNamesAndCoords)+1);
                  IdenticalNamesAndCoords[high(IdenticalNamesAndCoords)].ka:=k;
                  IdenticalNamesAndCoords[high(IdenticalNamesAndCoords)].ja:=j;
                  IdenticalNamesAndCoords[high(IdenticalNamesAndCoords)].la:=l;
                For kc:=Low(CoordsIdenticalNamesAndCoords) to high(CoordsIdenticalNamesAndCoords) do
                   if Hypot(VLMassive_Baza[CoordsIdenticalNamesAndCoords[kc,Low(CoordsIdenticalNamesAndCoords[kc])].ka].Pikets_Massiva[CoordsIdenticalNamesAndCoords[kc,Low(CoordsIdenticalNamesAndCoords[kc])].ja,CoordsIdenticalNamesAndCoords[kc,Low(CoordsIdenticalNamesAndCoords[kc])].la].Coordinate.X-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.X,VLMassive_Baza[CoordsIdenticalNamesAndCoords[kc,Low(CoordsIdenticalNamesAndCoords[kc])].ka].Pikets_Massiva[CoordsIdenticalNamesAndCoords[kc,Low(CoordsIdenticalNamesAndCoords[kc])].ja,CoordsIdenticalNamesAndCoords[kc,Low(CoordsIdenticalNamesAndCoords[kc])].la].Coordinate.Y-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.Y)<Minimal_dist_betv_pikets then
                     begin
                     SetLength(CoordsIdenticalNamesAndCoords[kc],Length(CoordsIdenticalNamesAndCoords[kc])+1);
                     CoordsIdenticalNamesAndCoords[kc,high(CoordsIdenticalNamesAndCoords[kc])].ka:=k;
                     CoordsIdenticalNamesAndCoords[kc,high(CoordsIdenticalNamesAndCoords[kc])].ja:=j;
                     CoordsIdenticalNamesAndCoords[kc,high(CoordsIdenticalNamesAndCoords[kc])].la:=l;
                     break;
                     end;
                  end
                  else
                  begin
                  SetLength(IdenticalNamesAndDifferentCoords,length(IdenticalNamesAndDifferentCoords)+1);
                  IdenticalNamesAndDifferentCoords[high(IdenticalNamesAndDifferentCoords)].ka:=k;
                  IdenticalNamesAndDifferentCoords[high(IdenticalNamesAndDifferentCoords)].ja:=j;
                  IdenticalNamesAndDifferentCoords[high(IdenticalNamesAndDifferentCoords)].la:=l;
                For kc:=Low(CoordsIdenticalNamesAndDifferentCoords) to high(CoordsIdenticalNamesAndDifferentCoords) do
                   if Hypot(VLMassive_Baza[CoordsIdenticalNamesAndDifferentCoords[kc,Low(CoordsIdenticalNamesAndDifferentCoords[kc])].ka].Pikets_Massiva[CoordsIdenticalNamesAndDifferentCoords[kc,Low(CoordsIdenticalNamesAndDifferentCoords[kc])].ja,CoordsIdenticalNamesAndDifferentCoords[kc,Low(CoordsIdenticalNamesAndDifferentCoords[kc])].la].Coordinate.X-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.X,VLMassive_Baza[CoordsIdenticalNamesAndDifferentCoords[kc,Low(CoordsIdenticalNamesAndDifferentCoords[kc])].ka].Pikets_Massiva[CoordsIdenticalNamesAndDifferentCoords[kc,Low(CoordsIdenticalNamesAndDifferentCoords[kc])].ja,CoordsIdenticalNamesAndDifferentCoords[kc,Low(CoordsIdenticalNamesAndDifferentCoords[kc])].la].Coordinate.Y-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.Y)<Minimal_dist_betv_pikets then
                     begin
                     SetLength(CoordsIdenticalNamesAndDifferentCoords[kc],Length(CoordsIdenticalNamesAndDifferentCoords[kc])+1);
                     CoordsIdenticalNamesAndDifferentCoords[kc,high(CoordsIdenticalNamesAndDifferentCoords[kc])].ka:=k;
                     CoordsIdenticalNamesAndDifferentCoords[kc,high(CoordsIdenticalNamesAndDifferentCoords[kc])].ja:=j;
                     CoordsIdenticalNamesAndDifferentCoords[kc,high(CoordsIdenticalNamesAndDifferentCoords[kc])].la:=l;
                     break;
                     end;
                  end;
                FoundPiketWithNoindividName:=True;
                break;
                end;

           For kp:=k to High(VLMassive_Baza) do
              For jp:=low(VLMassive_Baza[kp].Pikets_Massiva) to High(VLMassive_Baza[kp].Pikets_Massiva) do
                 For lp:=Low(VLMassive_Baza[kp].Pikets_Massiva[jp]) to High(VLMassive_Baza[kp].Pikets_Massiva[jp]) do
                    begin
                    if kp=k then //учитываем пикеты до выбранного пикта
                      begin
                      if jp<j then continue
                        else
                        if lp<=l then continue;
                      end;
                    //1.пикеты с накладывающимися координатами (имена пикеты ДО него - если есть, то +1. Иначе ищем до конца. Чтоб не искать каждый раз с самого начала, составляем список.),
                    //2.всего координат с накладывающимися пикетами (проискываем пикеты ДО выбранного пикета на предмет совпадения, если нашли - координата уже учитывается, бросаем это дело и дальше идём. Иначе ищем до конца),
                    //поиск по координатам
                    //для определения пикетов с индивидуальными координатами имеем флаг FoundPiketIndividCoords
                    if FoundPiketWithNakladCoords=false then
                      begin
                      //1.пикеты с накладывающимися координатами - поиск ДО и ПОСЛЕ. Просто добаваляем ещё один пикет. ДО) уже поискали.
                      if Hypot(VLMassive_Baza[kp].Pikets_Massiva[jp,lp].Coordinate.X-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.X,VLMassive_Baza[kp].Pikets_Massiva[jp,lp].Coordinate.Y-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.Y)<Minimal_dist_betv_pikets then //если нашли пикет после него, имеющий такие же координаты, то считаем его как повторяющийся, заканчиваем с эти пикетом и анализируем след. пикет)
                        begin
                        //так как мы не нашли совпадающих пикетов ДО этого, то считаем, что, кроме самого пикета, нашли координату совпадающих пикетов
                        SetLength(PiketsWithNakladCoords,Length(PiketsWithNakladCoords)+1);
                        PiketsWithNakladCoords[high(PiketsWithNakladCoords)].ka:=k;
                        PiketsWithNakladCoords[high(PiketsWithNakladCoords)].ja:=j;
                        PiketsWithNakladCoords[high(PiketsWithNakladCoords)].la:=l;
                        SetLength(VsegoCoordWithNakladPikets,Length(VsegoCoordWithNakladPikets)+1); //новая координата
                        SetLength(VsegoCoordWithNakladPikets[high(VsegoCoordWithNakladPikets)],Length(VsegoCoordWithNakladPikets[high(VsegoCoordWithNakladPikets)])+1); //записываем пикет этой новой координаты
                        VsegoCoordWithNakladPikets[high(VsegoCoordWithNakladPikets),high(VsegoCoordWithNakladPikets[high(VsegoCoordWithNakladPikets)])].ka:=k;
                        VsegoCoordWithNakladPikets[high(VsegoCoordWithNakladPikets),high(VsegoCoordWithNakladPikets[high(VsegoCoordWithNakladPikets)])].ja:=j;
                        VsegoCoordWithNakladPikets[high(VsegoCoordWithNakladPikets),high(VsegoCoordWithNakladPikets[high(VsegoCoordWithNakladPikets)])].la:=l;
                        FoundPiketWithNakladCoords:=True;
                        end;
                      end;

                    //3.индивидуальных имён пикетов (надо искать ВСЕ пикеты до конца. Поиск ДО пикета = составление списка не требуется.),
                    //4.с одинаковыми именами и разными координатами (поиск пикетов с одинаковыми именами до конца, и составление списка их адресов)
                    //анализируем, поиск по именам.
                    if FoundPiketWithNoindividName=false then
                      if (VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik<>'') or
                         (VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number<>0) or
                         (VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik<>'') then
                        if (VLMassive_Baza[kp].Pikets_Massiva[jp,lp].WordBeforePik=VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik) and
                           (VLMassive_Baza[kp].Pikets_Massiva[jp,lp].Pik_Number=VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number) and
                           (VLMassive_Baza[kp].Pikets_Massiva[jp,lp].WordAfterPik=VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik) then
                      begin              //PiketsWithSovpadNames[i].
                      SetLength(PiketsWithNoIndividualNames,Length(PiketsWithNoIndividualNames)+1);
                      PiketsWithNoIndividualNames[high(PiketsWithNoIndividualNames)].ka:=k;
                      PiketsWithNoIndividualNames[high(PiketsWithNoIndividualNames)].ja:=j;
                      PiketsWithNoIndividualNames[high(PiketsWithNoIndividualNames)].la:=l;
                        if Hypot(VLMassive_Baza[kp].Pikets_massiva[jp,lp].Coordinate.X-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.X,VLMassive_Baza[kp].Pikets_massiva[jp,lp].Coordinate.Y-VLMassive_Baza[k].Pikets_Massiva[j,l].Coordinate.Y)<Minimal_dist_betv_pikets then
                          begin
                          SetLength(IdenticalNamesAndCoords,length(IdenticalNamesAndCoords)+1);
                          IdenticalNamesAndCoords[high(IdenticalNamesAndCoords)].ka:=k;
                          IdenticalNamesAndCoords[high(IdenticalNamesAndCoords)].ja:=j;
                          IdenticalNamesAndCoords[high(IdenticalNamesAndCoords)].la:=l;
                          SetLength(CoordsIdenticalNamesAndCoords,length(CoordsIdenticalNamesAndCoords)+1);
                          SetLength(CoordsIdenticalNamesAndCoords[high(CoordsIdenticalNamesAndCoords)],length(CoordsIdenticalNamesAndCoords[high(CoordsIdenticalNamesAndCoords)])+1);
                          CoordsIdenticalNamesAndCoords[high(CoordsIdenticalNamesAndCoords),high(CoordsIdenticalNamesAndCoords[high(CoordsIdenticalNamesAndCoords)])].ka:=k;
                          CoordsIdenticalNamesAndCoords[high(CoordsIdenticalNamesAndCoords),high(CoordsIdenticalNamesAndCoords[high(CoordsIdenticalNamesAndCoords)])].ja:=j;
                          CoordsIdenticalNamesAndCoords[high(CoordsIdenticalNamesAndCoords),high(CoordsIdenticalNamesAndCoords[high(CoordsIdenticalNamesAndCoords)])].la:=l;
                          end
                          else
                          begin
                          SetLength(IdenticalNamesAndDifferentCoords,length(IdenticalNamesAndDifferentCoords)+1);
                          IdenticalNamesAndDifferentCoords[high(IdenticalNamesAndDifferentCoords)].ka:=k;
                          IdenticalNamesAndDifferentCoords[high(IdenticalNamesAndDifferentCoords)].ja:=j;
                          IdenticalNamesAndDifferentCoords[high(IdenticalNamesAndDifferentCoords)].la:=l;
                          SetLength(CoordsIdenticalNamesAndDifferentCoords,length(CoordsIdenticalNamesAndDifferentCoords)+1);
                          SetLength(CoordsIdenticalNamesAndDifferentCoords[high(CoordsIdenticalNamesAndDifferentCoords)],length(CoordsIdenticalNamesAndDifferentCoords[high(CoordsIdenticalNamesAndDifferentCoords)])+1);
                          CoordsIdenticalNamesAndDifferentCoords[high(CoordsIdenticalNamesAndDifferentCoords),high(CoordsIdenticalNamesAndDifferentCoords[high(CoordsIdenticalNamesAndDifferentCoords)])].ka:=k;
                          CoordsIdenticalNamesAndDifferentCoords[high(CoordsIdenticalNamesAndDifferentCoords),high(CoordsIdenticalNamesAndDifferentCoords[high(CoordsIdenticalNamesAndDifferentCoords)])].ja:=j;
                          CoordsIdenticalNamesAndDifferentCoords[high(CoordsIdenticalNamesAndDifferentCoords),high(CoordsIdenticalNamesAndDifferentCoords[high(CoordsIdenticalNamesAndDifferentCoords)])].la:=l;
                          end;
                      FoundPiketWithNoindividName:=True;
                      end;
                    end; //For lp:=Low(VLMassive_Baza[kp].Pikets_Massiva[jp]) to High(VLMassive_Baza[kp].Pikets_Massiva[jp]) do


           if FoundPiketWithNakladCoords=false then
             begin
             SetLength(PiketsWithIndivid_coords,Length(PiketsWithIndivid_coords)+1);
             PiketsWithIndivid_coords[high(PiketsWithIndivid_coords)].ka:=k;
             PiketsWithIndivid_coords[high(PiketsWithIndivid_coords)].ja:=j;
             PiketsWithIndivid_coords[high(PiketsWithIndivid_coords)].la:=l;
             end;
           if FoundPiketWithNoindividName=false then
             if (VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik<>'') or
                (VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number<>0) or
                (VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik<>'') then
             begin
             SetLength(IndividNamesOfPikets,Length(IndividNamesOfPikets)+1);
             IndividNamesOfPikets[high(IndividNamesOfPikets)].ka:=k;
             IndividNamesOfPikets[high(IndividNamesOfPikets)].ja:=j;
             IndividNamesOfPikets[high(IndividNamesOfPikets)].la:=l;
             end;

           //составляем список слов перед..
//           if VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik<>'' then
             begin
             if (NamesBeforePiket=nil) then
               begin
               SetLength(NamesBeforePiket,Length(NamesBeforePiket)+1);
               inc(NamesBeforePiket[high(NamesBeforePiket)].KolWord);
               NamesBeforePiket[high(NamesBeforePiket)].WordString:=VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik;
               end
               else
               begin
               For PikNameNum:=Low(NamesBeforePiket) to High(NamesBeforePiket) do  //из-за изменяющегося значения i выбрал Repeat ... until
               if form1.Capital_leters_No(NamesBeforePiket[PikNameNum].WordString)=form1.Capital_leters_No(VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik) then
                 begin
                 inc(NamesBeforePiket[PikNameNum].KolWord);
                 goto end_analize_NamesBeforePiket;
                 end;
               SetLength(NamesBeforePiket,Length(NamesBeforePiket)+1);
               inc(NamesBeforePiket[high(NamesBeforePiket)].KolWord);
               NamesBeforePiket[high(NamesBeforePiket)].WordString:=VLMassive_Baza[k].Pikets_Massiva[j,l].WordBeforePik;
               end_analize_NamesBeforePiket:
               end;
             end;
           //..и после пикетов
//           if VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik<>'' then
             begin
             if NamesAfterPiket=nil then
               begin
               SetLength(NamesAfterPiket,Length(NamesAfterPiket)+1);
               inc(NamesAfterPiket[high(NamesAfterPiket)].KolWord);
               NamesAfterPiket[high(NamesAfterPiket)].WordString:=VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik;
               end
               else
               begin
               For PikNameNum:=Low(NamesAfterPiket) to high(NamesAfterPiket) do
                  if form1.Capital_leters_No(NamesAfterPiket[PikNameNum].WordString)=form1.Capital_leters_No(VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik) then
                    begin
                    inc(NamesAfterPiket[PikNameNum].KolWord);
                    goto end_analize_NamesAfterPiket;
                    end;
               SetLength(NamesAfterPiket,Length(NamesAfterPiket)+1);
               inc(NamesAfterPiket[high(NamesAfterPiket)].KolWord);
               NamesAfterPiket[high(NamesAfterPiket)].WordString:=VLMassive_Baza[k].Pikets_Massiva[j,l].WordAfterPik;
               end_analize_NamesAfterPiket:
               end
             end;
           //ищем номера
           if VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number<>0 then
             begin
             if First_num=0 then
               begin
               First_num:=VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number;
               last_num:=first_num;
               end
               else
               begin
               if First_num>VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number then First_num:=VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number;
               if last_num<VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number then last_num:=VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number;
               end;
             end
             else //if VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number<>0 then .. else
             begin
             SetLength(pikets_without_name,Length(pikets_without_name)+1);
             pikets_without_name[high(pikets_without_name)].ka:=k;
             pikets_without_name[high(pikets_without_name)].ja:=j;
             pikets_without_name[high(pikets_without_name)].la:=l;
             end;
           end;
        kol_piketov:=kol_piketov+Length(VLMassive_Baza[k].Pikets_Massiva[j]);
        end;  //For j:=low(VLMassive_Baza[k].Pikets_Massiva) to High(VLMassive_Baza[k].Pikets_Massiva) do

     end; //For k:=Low(VLMassive_Baza) to High(VLMassive_Baza) do
  Pikets_was_Changed:=False;

  VLProcess.Label1.Caption:='Операция:';
  VLProcess.Label2.Caption:='Подождите немного.';
//  VLProcess.Visible:=False;
  end;
      
  //Выводим информацию на экран
  VLUnikalPiketName.Label3.Caption:='Всего пикетов: '+FloatToStr(kol_piketov);

  VLUnikalPiketName.Label7.Caption:='Пикетов с индивидуальными координатами: '+IntToStr(Length(PiketsWithIndivid_coords))+'.';
  VLUnikalPiketName.Label8.Caption:='Пикетов с накладывающимися координатами: '+IntToStr(Length(PiketsWithNakladCoords))+',';
  VLUnikalPiketName.Label4.Caption:='всего таких координат наклад-ся пикетов: '+IntToStr(Length(VsegoCoordWithNakladPikets))+'.';

  VLUnikalPiketName.Label12.Caption:='Всего пикетов без имён: '+IntToStr(Length(pikets_without_name))+'.';

  VLUnikalPiketName.Label10.Caption:='Всего пикетов с именами: '+IntToStr(Length(AllPiketWithNames))+',';
  VLUnikalPiketName.Label13.Caption:='из них пикетов без слов перед номерами: '+IntToStr(Length(AllPiketWithNamesWOWordBefore))+',';
  VLUnikalPiketName.Label14.Caption:='пикетов без номеров: '+IntToStr(Length(AllPiketWithNamesWONumber))+',';
  VLUnikalPiketName.Label18.Caption:='пикетов без слов после номеров: '+IntToStr(Length(AllPiketWithNamesWOWordAfter))+'.';

  VLUnikalPiketName.Label9.Caption:='Пикетов с индивидуальными имёнами: '+IntToStr(Length(IndividNamesOfPikets))+'.';
  VLUnikalPiketName.Label25.Caption:='Пикетов с неиндивидуальными имёнами: '+IntToStr(Length(PiketsWithNoIndividualNames))+'.';
  VLUnikalPiketName.Label24.Caption:='из них с один. именами и коорд-тами: '+IntToStr(Length(IdenticalNamesAndCoords))+',';
  VLUnikalPiketName.Label5.Caption:='всего таких координат: '+IntToStr(Length(CoordsIdenticalNamesAndCoords))+';';
  VLUnikalPiketName.Label11.Caption:='с один. именами и разными коорд-ми: '+IntToStr(Length(IdenticalNamesAndDifferentCoords))+',';
  VLUnikalPiketName.Label6.Caption:='всего таких координат: '+IntToStr(Length(CoordsIdenticalNamesAndDifferentCoords))+'.';

  //пишем минимальный и максимальный номера пикетов
  if First_num=0 then
    begin
    VLUnikalPiketName.Label1.Caption:='Миним. номер пикета: нет пикетов с номерами.';
    VLUnikalPiketName.Label2.Caption:='Максим. номер пикета: нет пикетов с номерами.';
    VLUnikalPiketName.StringGrid1.Cells[0,0]:='все пикеты без имён';
    end
    else
    begin
    VLUnikalPiketName.Label1.Caption:='Минимальный номер пикета: '+FloatToStr(First_num)+'.';
    VLUnikalPiketName.Label2.Caption:='Максимальный номер пикета: '+FloatToStr(last_num)+'.';
    end;

  VLUnikalPiketName.Label15.Caption:='Встречающихся слов перед номером пикета: '+FloatToStr(KolNamesBeforePiket)+'.';
  VLUnikalPiketName.Label16.Caption:='Встречающихся слов после номера пикета: '+FloatToStr(KolNamesAfterPiket)+'.';

  //пишем, столько имён перед пикетами
  VLUnikalPiketName.StringGrid2.Cells[0,0]:='Имя';
  VLUnikalPiketName.StringGrid2.Cells[1,0]:='Пикетов';
  VLUnikalPiketName.StringGrid2.ColWidths[0]:=77;
  VLUnikalPiketName.StringGrid2.ColWidths[1]:=77;
  if NamesBeforePiket=nil then
    begin
    VLUnikalPiketName.Label22.Visible:=True;
    VLUnikalPiketName.StringGrid2.Visible:=False;
    end
    else
    begin
    VLUnikalPiketName.Label22.Visible:=False;
    VLUnikalPiketName.StringGrid2.Visible:=True;
    VLUnikalPiketName.StringGrid2.RowCount:=Length(NamesBeforePiket)+1; //количество строк в таблице = количеству разновидностей слов перед пикетами + заголовок
    for PikNameNum:=low(NamesBeforePiket) to high(NamesBeforePiket) do
       begin
       if NamesBeforePiket[PikNameNum].WordString='' then VLUnikalPiketName.StringGrid2.Cells[0,PikNameNum+1]:='[без слов]'
         else
         VLUnikalPiketName.StringGrid2.Cells[0,PikNameNum+1]:=NamesBeforePiket[PikNameNum].WordString;
       VLUnikalPiketName.StringGrid2.Cells[1,PikNameNum+1]:=IntToStr(NamesBeforePiket[PikNameNum].KolWord);
       end;
    end;

  //пишем, сколько имён после пикетов
  VLUnikalPiketName.StringGrid3.Cells[0,0]:='Имя';
  VLUnikalPiketName.StringGrid3.Cells[1,0]:='Пикетов';
  VLUnikalPiketName.StringGrid3.ColWidths[0]:=77;
  VLUnikalPiketName.StringGrid3.ColWidths[1]:=77;
  if NamesAfterPiket=nil then
    begin
    VLUnikalPiketName.Label23.Visible:=True;
    VLUnikalPiketName.StringGrid3.Visible:=False;
    end
    else
    begin
    VLUnikalPiketName.Label23.Visible:=False;
    VLUnikalPiketName.StringGrid3.Visible:=True;
    VLUnikalPiketName.StringGrid3.RowCount:=Length(NamesAfterPiket)+1; //количество строк в таблице = количеству разновидностей слов перед пикетами + заголовок
    for PikNameNum:=Low(NamesAfterPiket) to high(NamesAfterPiket) do
       begin
       if NamesAfterPiket[PikNameNum].WordString='' then VLUnikalPiketName.StringGrid3.Cells[0,PikNameNum+1]:='[без слов]'
         else
         VLUnikalPiketName.StringGrid3.Cells[0,PikNameNum+1]:=NamesAfterPiket[PikNameNum].WordString;
       VLUnikalPiketName.StringGrid3.Cells[1,PikNameNum+1]:=FloatToStr(NamesAfterPiket[PikNameNum].KolWord);
       end;
    end;

  //#проверяем на линейность возрастания номеров пикетов; создаём таблицу линейности возрастания пикетов
  interval_Fnum:=First_num; //номер первого пикета в интервале
  pik_num:=interval_Fnum+1;  //pik_num - следующий номер, наличие которого проверяем в проекте
  interval_True:=True;  //что закончился интервал
  VLUnikalPiketName.StringGrid1.RowCount:=VLUnikalPiketName.StringGrid1.FixedRows+1; VLUnikalPiketName.StringGrid1.Cells[0,0]:='';//обновляем ведь таблицу
  VLUnikalPiketName.StringGrid1.ColWidths[0]:=133;
  for i_pik_num:=first_num to last_num-1 do
     begin
     For k:=Low(VLMassive_Baza) to High(VLMassive_Baza) do
        For j:=low(VLMassive_Baza[k].Pikets_Massiva) to High(VLMassive_Baza[k].Pikets_Massiva) do
           For l:=Low(VLMassive_Baza[k].Pikets_Massiva[j]) to High(VLMassive_Baza[k].Pikets_Massiva[j]) do
              if VLMassive_Baza[k].Pikets_Massiva[j,l].Pik_Number=pik_num then //если номер пикета продолжается, то продолжаем
                begin
                if interval_True=false then interval_Fnum:=pik_num;
                interval_True:=True;
                goto next_pik_num;
                end;
     if interval_True=True then //если не нашли номер пикета, то пишем в таблицу сколько интервал
       begin
       if VLUnikalPiketName.StringGrid1.RowCount-VLUnikalPiketName.StringGrid1.FixedRows=1 then         //если это первая строка только, то,
         begin
         if VLUnikalPiketName.StringGrid1.Cells[0,VLUnikalPiketName.StringGrid1.FixedRows]<>'' then      //если она не пустая,
           VLUnikalPiketName.StringGrid1.RowCount:=VLUnikalPiketName.StringGrid1.RowCount+1;             //то добавляем новую пустую строку
         end
         else
         VLUnikalPiketName.StringGrid1.RowCount:=VLUnikalPiketName.StringGrid1.RowCount+1;
       if interval_Fnum<>pik_num-1 then
         VLUnikalPiketName.StringGrid1.Cells[0,VLUnikalPiketName.StringGrid1.RowCount-1]:=FloatToStr(interval_Fnum)+'-'+FloatToStr(pik_num-1)
         else
         VLUnikalPiketName.StringGrid1.Cells[0,VLUnikalPiketName.StringGrid1.RowCount-1]:=FloatToStr(interval_Fnum);
       end;
     interval_True:=False;
     next_pik_num:
     pik_num:=pik_num+1;
     end;
  if interval_True=True then   //учитываем случай, когда всё состоит из одной цепочки
    begin
    if VLUnikalPiketName.StringGrid1.RowCount-VLUnikalPiketName.StringGrid1.FixedRows=1 then         //если это первая строка только, то,
      begin
      if VLUnikalPiketName.StringGrid1.Cells[0,VLUnikalPiketName.StringGrid1.FixedRows]<>'' then      //если она не пустая,
        VLUnikalPiketName.StringGrid1.RowCount:=VLUnikalPiketName.StringGrid1.RowCount+1;             //то добавляем новую пустую строку
      end
      else
      VLUnikalPiketName.StringGrid1.RowCount:=VLUnikalPiketName.StringGrid1.RowCount+1;
    if interval_Fnum<>last_num then  //на всякий случай, так и напишу) - по идее, может быть случай когда только 1 пикет с именем, другие без имени
      VLUnikalPiketName.StringGrid1.Cells[0,VLUnikalPiketName.StringGrid1.RowCount-1]:=FloatToStr(interval_Fnum)+'-'+FloatToStr(last_num)
      else
      VLUnikalPiketName.StringGrid1.Cells[0,VLUnikalPiketName.StringGrid1.RowCount-1]:=FloatToStr(interval_Fnum);
    end;
  VLProcess.Visible:=False;
  //VLProcess.Close;
end;

procedure TVLUnikalPiketName.FormActivate(Sender: TObject);
begin
  VLUnikalPiketName.Label3.Hint:='Всего пикетов в проекте';

  VLUnikalPiketName.Label7.Hint:='Всего в проекте пикетов, имеющие неповторяющиеся, как у всех других пикетов, координаты';
  VLUnikalPiketName.Label8.Hint:='Всего в проекте пикетов, имеющие общие с какими-либо другими пикетами координаты';
  VLUnikalPiketName.Label4.Hint:='Всего в проекте разных координат пикетов, имеющие общие с какими-либо другими пикетами координаты';

  VLUnikalPiketName.Label12.Hint:='Всего в проекте пикетов без имён (т.е. не имеющие ни слова перед номером, ни номера, ни слова после номера)';

  VLUnikalPiketName.Label10.Hint:='Всего в проекте пикетов с именем';
  VLUnikalPiketName.Label13.Hint:='Всего в проекте пикетов с именем, имя которых не содержит номер';
  VLUnikalPiketName.Label14.Hint:='Всего в проекте пикетов с именем, имя которых не содержит слово перед номером';
  VLUnikalPiketName.Label18.Hint:='Всего в проекте пикетов с именем, имя которых не содержит слово после номера';

  VLUnikalPiketName.Label9.Hint:='Всего в проекте пикетов, имеющие неповторяющиеся, как у всех других пикетов, имена';
  VLUnikalPiketName.Label25.Hint:='Всего в проекте пикетов, имеющие общие с какими-либо другими пикетами имена';
  VLUnikalPiketName.Label24.Hint:='Всего в проекте пикетов, имеющие общие с какими-либо другими пикетами такие же имена и координаты';
  VLUnikalPiketName.Label5.Hint:='Всего в проекте разных координат пикетов, имеющие общие с какими-либо другими пикетами такие же имена и координаты';
  VLUnikalPiketName.Label11.Hint:='Всего в проекте пикетов, имеющие общие с какими-либо другими пикетами такие же имена, но разные координаты';
  VLUnikalPiketName.Label6.Hint:='Всего в проекте разных координат пикетов, имеющие общие с какими-либо другими пикетами такие же имена, но разные координаты';

  VLUnikalPiketName.Label1.Hint:='Минимальный встречающийся номер, принадлежащий какому-либо пикету, в проекте';
  VLUnikalPiketName.Label2.Hint:='Максимальный встречающийся номер, принадлежащий какому-либо пикету, в проекте';

  VLUnikalPiketName.Label15.Hint:='Всего в проекте пикетов, имеющие перед своим номером слово';
  VLUnikalPiketName.Label16.Hint:='Всего в проекте пикетов, имеющие после своего номера слово';

//  Make_Piket_Report;  если форма активная другая, вылетает
//  ShowMessage(':-)');
end;

procedure TVLUnikalPiketName.Button2Click(Sender: TObject);
begin
//  VLeshka.Form1.Unikal_All_Piket_Name(insert_before_piket,First_number_of_piket,insert_after_piket,make_individ_koord_piket);
  VLeshka.Form1.DrawMap;
  Make_Piket_Report;
  ShowMessage('Выполнено. Данные обновлены.');
end;

procedure TVLUnikalPiketName.CheckBox1Click(Sender: TObject);
begin
//  make_individ_koord_piket:=VLUnikalPiketName.CheckBox1.Checked;
end;

procedure TVLUnikalPiketName.Button1Click(Sender: TObject);
var k,j,l:integer;
begin
  for k:=low(VLMassive_Baza) to high(VLMassive_Baza) do
     for j:=low(VLMassive_Baza[k].Pikets_massiva) to high(VLMassive_Baza[k].Pikets_massiva) do
        for l:=low(VLMassive_Baza[k].Pikets_massiva[j]) to high(VLMassive_Baza[k].Pikets_massiva[j]) do
           begin
           VLMassive_Baza[k].Pikets_massiva[j,l].WordBeforePik:='';
           VLMassive_Baza[k].Pikets_massiva[j,l].Pik_Number:=0;
           VLMassive_Baza[k].Pikets_massiva[j,l].WordAfterPik:='';
           end;
  VLeshka.Form1.DrawMap;
  Pikets_was_Changed:=True;
  Make_Piket_Report;
  ShowMessage('Выполнено. Данные обновлены.');
end;

procedure TVLUnikalPiketName.Button3Click(Sender: TObject);
var k,j,l:integer;
begin
  for k:=low(VLMassive_Baza) to high(VLMassive_Baza) do
     for j:=low(VLMassive_Baza[k].Pikets_massiva) to high(VLMassive_Baza[k].Pikets_massiva) do
        for l:=low(VLMassive_Baza[k].Pikets_massiva[j]) to high(VLMassive_Baza[k].Pikets_massiva[j]) do
           VLMassive_Baza[k].Pikets_massiva[j,l].Pik_Number:=0;
  VLeshka.Form1.DrawMap;
  Pikets_was_Changed:=True;
  Make_Piket_Report;
  ShowMessage('Выполнено. Данные обновлены.');
end;

procedure TVLUnikalPiketName.Button4Click(Sender: TObject);
var k,j,l:integer;
begin
  for k:=low(VLMassive_Baza) to high(VLMassive_Baza) do
     for j:=low(VLMassive_Baza[k].Pikets_massiva) to high(VLMassive_Baza[k].Pikets_massiva) do
        for l:=low(VLMassive_Baza[k].Pikets_massiva[j]) to high(VLMassive_Baza[k].Pikets_massiva[j]) do
           VLMassive_Baza[k].Pikets_massiva[j,l].WordBeforePik:='';
  VLeshka.Form1.DrawMap;
  Pikets_was_Changed:=True;
  Make_Piket_Report;
  ShowMessage('Выполнено. Данные обновлены.');
end;

procedure TVLUnikalPiketName.Button5Click(Sender: TObject);
var k,j,l:integer;
begin
  for k:=low(VLMassive_Baza) to high(VLMassive_Baza) do
     for j:=low(VLMassive_Baza[k].Pikets_massiva) to high(VLMassive_Baza[k].Pikets_massiva) do
        for l:=low(VLMassive_Baza[k].Pikets_massiva[j]) to high(VLMassive_Baza[k].Pikets_massiva[j]) do
           VLMassive_Baza[k].Pikets_massiva[j,l].WordAfterPik:='';
  VLeshka.Form1.PaintBox1.Refresh;
  Pikets_was_Changed:=True;
  Make_Piket_Report;
  ShowMessage('Выполнено. Данные обновлены.');
end;

procedure TVLUnikalPiketName.Button6Click(Sender: TObject);
begin
  form1.SynchronizeFromMapInfoMif;
  VLeshka.Form1.DrawMap;
  Make_Piket_Report;
  ShowMessage('Выполнено. Данные обновлены.');
end;

procedure TVLUnikalPiketName.Button7Click(Sender: TObject);
begin
  Form1.SynchronizeFromTxt;
  VLeshka.Form1.DrawMap;
  Make_Piket_Report;
  ShowMessage('Выполнено. Данные обновлены.');
end;

procedure TVLUnikalPiketName.Button9Click(Sender: TObject);
begin
  Form1.DrawMap;
  VLUnikalPiketName.Close;
end;

procedure TVLUnikalPiketName.Button10Click(Sender: TObject);
var toFromNum,toToNum:integer;
    variants_Words_Before_Pik,variants_Words_After_Pik:tstrings;
    s:string;
begin
  toFromNum:=Round(Form1.String_to_FloatNum(VLUnikalPiketName.StringGrid1.Cols[0][0]));
  s:=VLUnikalPiketName.StringGrid1.Cols[0][VLUnikalPiketName.StringGrid1.Cols[0].Count-1];
  s:=copy(s,pos('-',s)+1,length(s)-pos('-',s));
  toToNum:=Round(Form1.String_to_FloatNum(s));

  variants_Words_Before_Pik:=Tstringlist.Create;
  variants_Words_Before_Pik.AddStrings(VLUnikalPiketName.StringGrid2.Cols[0]);
  variants_Words_Before_Pik.Delete(0);

  variants_Words_After_Pik:=Tstringlist.Create;
  variants_Words_After_Pik.AddStrings(VLUnikalPiketName.StringGrid3.Cols[0]);
  variants_Words_After_Pik.Delete(0);
{
//[\\\\\\\\\\\\\\\\\\\\\\\\\\\В пункте меню "Данные_проекта" - "Присвоить имена пикетам"///////////////////]

//[\\\\\\\\\\\\\\\\\\\\\\Выбирать пикеты, имеющие//////////////////////////////////////]

//[слово перед пикетом]
//[пункт меню комбинированного списка, номер сверху, начиная с нуля]
  prisv_slovo_pered_piketom;

//[все ли номера пикетов обрабатывать]
//[пункт меню комбинированного списка, номер сверху, начиная с нуля]
  prisv_vse_li_nomera;

//[номера от]
//[число]
//[если равен нулю, то все номера]
  IntToStr(prisv_nomera_ot);

//[номера до]
//[число]
//[если равен нулю, то все номера]
  IntToStr(prisv_nomera_do);

  //[Не присваивать пикету номер, который есть у других пикетов]
  //[ok/no]
  ne_prisvpiketnumber_kotestudrugihpiketov;

//[слово после пикета]
//пункт меню комбинированного списка, номер сверху, начиная с нуля
  prisv_slovo_posle_piketa;

//[\\\\\\\\\\\\\\\\\\\\\\присваивать пикетам следующее///////////////////////////////////]

//не присваивать номера пикетам
//ok/no
  ne_prisvaivat_piknumbers

//присваивать номера от
//если равен нулюЮ то все номера
  First_number_of_piket);

//присваивать номера до
//число
//если равно нулю, то до бесконечности
  last_number_of_piket);

//[не присваивать пикету номер, если такой номер уже есть у других пикетов]
//ok/no
  ne_prisv_piknum_if_not_individual);

  //[не присваивать слово перед пикетом]
  //[ok/no]
  ne_prisvaivatslovoperedpikitom);

//слово перед пикетом
//слово
  insert_before_piket);

//[не присваивать слово после пикета]
//[ok/no]
  ne_prisvaivatslovoposlepiketa);

  //слово после пикета
  //слово
  insert_after_piket);

  //пикетам с одинаковыми координатами - одинаковые имена, ok/no
  make_individ_koord_piket);

//[спрашивать, какой пикет менять, если два - с одинаковыми координатами]
//[ok/no]
  sprashivat_kakoy_menat_if2ident);
}

  //всё запохабено, переменные по недосмотру дублируются... но так и оставлено
  //VLUnikalPiketNameMake_toWordPreComboBox1ItemIndex - combobox1.itemindex  prisv_slovo_pered_piketom
  //toFromNum First_number_of_piket
  //toToNum last_number_of_piket
  //VLUnikalPiketNameMake_NumComboBox3ItemIndex prisv_vse_li_nomera
  //VLUnikalPiketNameMake_toWordAftComboBox2ItemIndex prisv_slovo_posle_piketa
  //VLUnikalPiketNameMake_toMakeIndividNum ne_prisvpiketnumber_kotestudrugihpiketov
  //VLUnikalPiketName_individ_koord_name make_individ_koord_piket
  //VLUnikalPiketNameMake_insPikWorsPre insert_before_piket
  // prisv_nomera_ot
  // prisv_nomera_do
  // insert_after_piket
  if VLeshka.Form1.Unikal_All_Piket_Name(variants_Words_Before_Pik, prisv_slovo_pered_piketom,
                                         First_number_of_piket, last_number_of_piket, prisv_vse_li_nomera,
                                         variants_Words_After_Pik, prisv_slovo_posle_piketa, ne_prisvpiketnumber_kotestudrugihpiketov,
                                         make_individ_koord_piket,insert_before_piket,
                                         prisv_nomera_ot,prisv_nomera_do,insert_after_piket,
                                         ne_prisvaivatslovoperedpikitom, ne_prisvaivat_piknumbers, ne_prisvaivatslovoposlepiketa, sprashivat_kakoy_menat_if2ident)
                                         =true then
    begin
    VLeshka.Form1.DrawMap;
    Make_Piket_Report;
    ShowMessage('Выполнено. Данные обновлены.');
    end;
end;

procedure TVLUnikalPiketName.Label3Click(Sender: TObject);
begin
//  if Form1.PiketListEdit(kol_piketov)=true then
//    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label12Click(Sender: TObject);
begin
  if Form1.PiketListEdit(pikets_without_name)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label10Click(Sender: TObject);
begin
  if Form1.PiketListEdit(AllPiketWithNames)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label13Click(Sender: TObject);
begin
  if Form1.PiketListEdit(AllPiketWithNamesWOWordBefore)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label14Click(Sender: TObject);
begin
  if Form1.PiketListEdit(AllPiketWithNamesWONumber)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label18Click(Sender: TObject);
begin
  if Form1.PiketListEdit(AllPiketWithNamesWOWordAfter)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label9Click(Sender: TObject);
begin
  if Form1.PiketListEdit(IndividNamesOfPikets)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label25Click(Sender: TObject);
begin
  if Form1.PiketListEdit(PiketsWithNoIndividualNames)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label24Click(Sender: TObject);
begin
  if Form1.PiketListEdit(IdenticalNamesAndCoords)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label5Click(Sender: TObject);
begin
  if Form1.PiketListEdit(CoordsIdenticalNamesAndCoords)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label11Click(Sender: TObject);
begin
  if Form1.PiketListEdit(IdenticalNamesAndDifferentCoords)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label6Click(Sender: TObject);
begin
  if Form1.PiketListEdit(CoordsIdenticalNamesAndDifferentCoords)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label4Click(Sender: TObject);
begin
  if Form1.PiketListEdit(VsegoCoordWithNakladPikets)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label8Click(Sender: TObject);
begin
  if Form1.PiketListEdit(PiketsWithNakladCoords)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.Label7Click(Sender: TObject);
begin
  if Form1.PiketListEdit(PiketsWithIndivid_coords)=true then
    Make_Piket_Report;
end;

procedure TVLUnikalPiketName.N7Click(Sender: TObject);
begin
  VLUnikalPiketName.SaveDialog1.InitialDir:=put_out_documents;
  VLUnikalPiketName.SaveDialog1.Filter := '*.txt';
  VLUnikalPiketName.SaveDialog1.DefaultExt:='txt';
  If VLUnikalPiketName.SaveDialog1.Execute=True then
    VLUnikalPiketName.StringGrid1.Cols[0].SaveToFile(VLUnikalPiketName.SaveDialog1.FileName);
end;

procedure TVLUnikalPiketName.N1Click(Sender: TObject);
var k,j,l:integer;
    c:string;
begin
  //если надо удалить пустое слово перед пикетом, то оно имеет значение "без слов", а этого просто нет, поэтому игнорируется; но если поставить слово перед пикетом "без слов", то оно удалится, поэтому тоже сделаем по-нормальному
  c:=VLUnikalPiketName.StringGrid2.Cells[0,VLUnikalPiketName.StringGrid2.Row];
  if c='без слов' then c:='';
  for k:=low(VLMassive_Baza) to high(VLMassive_Baza) do
     for j:=low(VLMassive_Baza[k].Pikets_massiva) to high(VLMassive_Baza[k].Pikets_massiva) do
        for l:=low(VLMassive_Baza[k].Pikets_massiva[j]) to high(VLMassive_Baza[k].Pikets_massiva[j]) do
           if VLMassive_Baza[k].Pikets_massiva[j,l].WordBeforePik=c then
              VLMassive_Baza[k].Pikets_massiva[j,l].WordBeforePik:='';
  //далее надо обновить таблицу пикетов
  Pikets_was_Changed:=true;
  Make_Piket_Report;
end;

procedure TVLUnikalPiketName.N3Click(Sender: TObject);
var k,j,l:integer;
    c:string;
begin
  c:=VLUnikalPiketName.StringGrid2.Cells[0,VLUnikalPiketName.StringGrid2.Row];
  if c='без слов' then c:='';
  for k:=low(VLMassive_Baza) to high(VLMassive_Baza) do
     for j:=low(VLMassive_Baza[k].Pikets_massiva) to high(VLMassive_Baza[k].Pikets_massiva) do
        for l:=low(VLMassive_Baza[k].Pikets_massiva[j]) to high(VLMassive_Baza[k].Pikets_massiva[j]) do
           if VLMassive_Baza[k].Pikets_massiva[j,l].WordBeforePik=c then
             begin
             VLMassive_Baza[k].Pikets_massiva[j,l].WordBeforePik:='';
             VLMassive_Baza[k].Pikets_massiva[j,l].Pik_Number:=0;
             VLMassive_Baza[k].Pikets_massiva[j,l].WordAfterPik:='';
             end;
  //далее надо обновить таблицу пикетов
  Pikets_was_Changed:=true;
  Make_Piket_Report;
end;

procedure TVLUnikalPiketName.N2Click(Sender: TObject);
var s,c:string;
   k,j,l:integer;
begin
  s:=inputbox('Введите новое значение слова перед пикетом','для '+VLUnikalPiketName.StringGrid2.Cells[VLUnikalPiketName.StringGrid2.Col,VLUnikalPiketName.StringGrid2.Row],'');
  c:=VLUnikalPiketName.StringGrid2.Cells[0,VLUnikalPiketName.StringGrid2.Row];
  if c='без слов' then c:='';
  for k:=low(VLMassive_Baza) to high(VLMassive_Baza) do
     for j:=low(VLMassive_Baza[k].Pikets_massiva) to high(VLMassive_Baza[k].Pikets_massiva) do
        for l:=low(VLMassive_Baza[k].Pikets_massiva[j]) to high(VLMassive_Baza[k].Pikets_massiva[j]) do
           if VLMassive_Baza[k].Pikets_massiva[j,l].WordBeforePik=c then
             VLMassive_Baza[k].Pikets_massiva[j,l].WordBeforePik:=s;
  //далее надо обновить таблицу пикетов
  Pikets_was_Changed:=true;
  Make_Piket_Report;
end;

procedure TVLUnikalPiketName.N8Click(Sender: TObject);
var t:tStrings;
    i:integer;
begin
  VLUnikalPiketName.SaveDialog1.InitialDir:=put_out_documents;
  VLUnikalPiketName.SaveDialog1.Filter := '*.txt';
  VLUnikalPiketName.SaveDialog1.DefaultExt:='txt';
  If VLUnikalPiketName.SaveDialog1.Execute=True then
    begin
    t:=tStringlist.Create;
    for i:=0 to VLUnikalPiketName.StringGrid2.RowCount-1 do
       t.Add( VLUnikalPiketName.StringGrid2.Cells[0,i]+Chr(9)+VLUnikalPiketName.StringGrid2.Cells[1,i]);
    t.SaveToFile(VLUnikalPiketName.SaveDialog1.FileName);
    FreeAndNil(t);
    end;
end;

procedure TVLUnikalPiketName.N4Click(Sender: TObject);
var k,j,l:integer;
    c:string;
begin
  //если надо удалить пустое слово перед пикетом, то оно имеет значение "без слов", а этого просто нет, поэтому игнорируется; но если поставить слово перед пикетом "без слов", то оно удалится, поэтому тоже сделаем по-нормальному
  c:=VLUnikalPiketName.StringGrid3.Cells[0,VLUnikalPiketName.StringGrid3.Row];
  if c='без слов' then exit;
  for k:=low(VLMassive_Baza) to high(VLMassive_Baza) do
     for j:=low(VLMassive_Baza[k].Pikets_massiva) to high(VLMassive_Baza[k].Pikets_massiva) do
        for l:=low(VLMassive_Baza[k].Pikets_massiva[j]) to high(VLMassive_Baza[k].Pikets_massiva[j]) do
           if VLMassive_Baza[k].Pikets_massiva[j,l].WordAfterPik=c then
              VLMassive_Baza[k].Pikets_massiva[j,l].WordAfterPik:='';
  //далее надо обновить таблицу пикетов
  Pikets_was_Changed:=true;
  Make_Piket_Report;
end;

procedure TVLUnikalPiketName.N5Click(Sender: TObject);
var s,c:string;
   k,j,l:integer;
begin
  s:=inputbox('Введите новое значение слова перед пикетом','для '+VLUnikalPiketName.StringGrid2.Cells[VLUnikalPiketName.StringGrid2.Col,VLUnikalPiketName.StringGrid2.Row],'');
  c:=VLUnikalPiketName.StringGrid3.Cells[0,VLUnikalPiketName.StringGrid3.Row];
  if c='без слов' then c:='';
  for k:=low(VLMassive_Baza) to high(VLMassive_Baza) do
     for j:=low(VLMassive_Baza[k].Pikets_massiva) to high(VLMassive_Baza[k].Pikets_massiva) do
        for l:=low(VLMassive_Baza[k].Pikets_massiva[j]) to high(VLMassive_Baza[k].Pikets_massiva[j]) do
           if VLMassive_Baza[k].Pikets_massiva[j,l].WordAfterPik=c then
             VLMassive_Baza[k].Pikets_massiva[j,l].WordAfterPik:=s;
  //далее надо обновить таблицу пикетов
  Pikets_was_Changed:=true;
  Make_Piket_Report;
end;

procedure TVLUnikalPiketName.N6Click(Sender: TObject);
var k,j,l:integer;
    c:string;
begin
  //если надо удалить пустое слово перед пикетом, то оно имеет значение "без слов", а этого просто нет, поэтому игнорируется; но если поставить слово перед пикетом "без слов", то оно удалится, поэтому тоже сделаем по-нормальному
  c:=VLUnikalPiketName.StringGrid3.Cells[0,VLUnikalPiketName.StringGrid3.Row];
  if c='без слов' then c:='';
  for k:=low(VLMassive_Baza) to high(VLMassive_Baza) do
     for j:=low(VLMassive_Baza[k].Pikets_massiva) to high(VLMassive_Baza[k].Pikets_massiva) do
        for l:=low(VLMassive_Baza[k].Pikets_massiva[j]) to high(VLMassive_Baza[k].Pikets_massiva[j]) do
           if VLMassive_Baza[k].Pikets_massiva[j,l].WordAfterPik=c then
             begin
             VLMassive_Baza[k].Pikets_massiva[j,l].WordBeforePik:='';
             VLMassive_Baza[k].Pikets_massiva[j,l].Pik_Number:=0;
             VLMassive_Baza[k].Pikets_massiva[j,l].WordAfterPik:='';
             end;
  //далее надо обновить таблицу пикетов
  Pikets_was_Changed:=true;
  Make_Piket_Report;
end;

procedure TVLUnikalPiketName.N9Click(Sender: TObject);
var t:tStrings;
    i:integer;
begin
  VLUnikalPiketName.SaveDialog1.InitialDir:=put_out_documents;
  VLUnikalPiketName.SaveDialog1.Filter := '*.txt';
  VLUnikalPiketName.SaveDialog1.DefaultExt:='txt';
  If VLUnikalPiketName.SaveDialog1.Execute=True then
    begin
    t:=tStringlist.Create;
    for i:=0 to VLUnikalPiketName.StringGrid3.RowCount-1 do
       t.Add( VLUnikalPiketName.StringGrid3.Cells[0,i]+Chr(9)+VLUnikalPiketName.StringGrid3.Cells[1,i]);
    t.SaveToFile(VLUnikalPiketName.SaveDialog1.FileName);
    FreeAndNil(t);
    end;
end;


end.
