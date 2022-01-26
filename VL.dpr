program VL;

uses
  Forms,
  VLeshka in 'VLeshka.pas' {Form1},
  VLFormACAD_podpisi in 'VLFormACAD_podpisi.pas' {VLForm_ACAD_podpis},
  VL_options in 'VL_Options.pas' {VLoptions},
  VL_help in 'VL_help.pas' {VL_help},
  VL_LoadCSV in 'VL_LoadCSV.pas' {VLloadCSV},
  VL_UnikalPiketName in 'VL_UnikalPiketName.pas' {VLUnikalPiketName},
  ACAD_CAP_options_pas in 'ACAD_CAP_options_pas.pas' {ACAD_CAP_options},
  LoadVLeshka_pas in 'LoadVLeshka_pas.pas' {LoadVLeshka},
  VL_Process_pas in 'VL_Process_pas.pas' {VLProcess},
  MSWord_KatKoordOptions_pas in 'MSWord_KatKoordOptions_pas.pas' {MSWordKatKoordOptions},
  VLMakeDocument_pas in 'VLMakeDocument_pas.pas' {VLMakeDocument},
  VLLoadKadastrMassives_pas in 'VLLoadKadastrMassives_pas.pas' {VLLoadKadastrNumbers},
  MSExcelOptions_pas in 'MSExcelOptions_pas.pas' {MSExcelOptions},
  MassiveInfoHint_pas in 'MassiveInfoHint_pas.pas' {MassiveInfoHint},
  VLUnikalPiketNameMake_pas in 'VLUnikalPiketNameMake_pas.pas' {VLUnikalPiketNameMake},
  PiketList_pas in 'PiketList_pas.pas' {PiketList},
  PiketListCoord_pas in 'PiketListCoord_pas.pas' {PiketListCoord},
  VLRekvizits_pas in 'VLRekvizits_pas.pas' {VLRekvizits},
  VLSoglasheniya_pas in 'VLSoglasheniya_pas.pas' {VLSoglasheniya},
  VLM63 in 'VLM63.pas' {VLsistemkoordinay};

var
  logFile:TextFile;
  //t:tstrings;
{$R *.res}

begin
  Application.Initialize;

  LoadVLeshka := TLoadVLeshka.Create(Application); //показываем заставку
  LoadVLeshka.Show;
  LoadVLeshka.Update;

  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TVLRekvizits, VLRekvizits);
  Application.CreateForm(TVLSoglasheniya, VLSoglasheniya);
  Application.CreateForm(TVLsistemkoordinay, VLsistemkoordinay);
  AssignFile(logFile,'log.txt');

  ReWrite(logFile); Writeln(logFile,'TVLForm_ACAD_podpis'); CloseFile(logFile);
  Application.CreateForm(TVLForm_ACAD_podpis, VLForm_ACAD_podpis);

  Append(logFile); Writeln(logFile,'TVLoptions'); CloseFile(logFile);
  Application.CreateForm(TVLoptions, VLoptions);

  Append(logFile); Writeln(logFile,'TVLloadCSV'); CloseFile(logFile);
  Application.CreateForm(TVLloadCSV, VLloadCSV);

  Append(logFile); Writeln(logFile,'TVLUnikalPiketName'); CloseFile(logFile);
  Application.CreateForm(TVLUnikalPiketName, VLUnikalPiketName);

  Append(logFile); Writeln(logFile,'TVLMakeDocument'); CloseFile(logFile);
  Application.CreateForm(TVLMakeDocument, VLMakeDocument);

  Append(logFile); Writeln(logFile,'TVLLoadKadastrNumbers'); CloseFile(logFile);
  Application.CreateForm(TVLLoadKadastrNumbers, VLLoadKadastrNumbers);

  Append(logFile); Writeln(logFile,'TMSExcelOptions'); CloseFile(logFile);
  Application.CreateForm(TMSExcelOptions, MSExcelOptions);

  Append(logFile); Writeln(logFile,'TMassiveInfoHint'); CloseFile(logFile);
  Application.CreateForm(TMassiveInfoHint, MassiveInfoHint);

  Append(logFile); Writeln(logFile,'TMSWordKatKoordOptions'); CloseFile(logFile);
  Application.CreateForm(TMSWordKatKoordOptions, MSWordKatKoordOptions);

  Append(logFile); Writeln(logFile,'TVLUnikalPiketNameMake'); CloseFile(logFile);
  Application.CreateForm(TVLUnikalPiketNameMake, VLUnikalPiketNameMake);

  Append(logFile); Writeln(logFile,'TPiketList'); CloseFile(logFile);
  Application.CreateForm(TPiketList, PiketList);

  Append(logFile); Writeln(logFile,'TPiketListCoord'); CloseFile(logFile);
  Application.CreateForm(TPiketListCoord, PiketListCoord);

  Append(logFile); Writeln(logFile,'TVLProcess'); CloseFile(logFile);
  Application.CreateForm(TVLProcess, VLProcess); //создаю потом  Application.CreateForm(TVLProcess, VLProcess);

 //  заставка, не использую в работе Application.CreateForm(TLoadVLeshka, LoadVLeshka);

  Append(logFile); Writeln(logFile,'TACAD_CAP_options'); CloseFile(logFile);
  Application.CreateForm(TACAD_CAP_options, ACAD_CAP_options);

  Append(logFile); Writeln(logFile,'TVL_help'); CloseFile(logFile);
  Application.CreateForm(TVL_help, VLhelp); // хелп, пока не делаю

  LoadVLeshka.Hide;
  LoadVLeshka.Free;
  Application.Run;
end.
