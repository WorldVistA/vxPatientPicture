{
tscap32 - Delphi Video Capture Component
Copyright (C) 1996-2003 Thomas Stuefe

contact: tstuefe@users.sourceforge.net
web:     http://tscap32.sourceforge.net


This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
}


unit tscap32_dt;

interface

  uses tscap32_rt,
  Classes, Dialogs, Forms,
  DesignIntf, DesignEditors;

type

  TtsCap32DriverProperty = class;
  TtsCap32FilenameProperty = class;
  TtsCap32AboutProperty = class;
  TtsCap32AudioParameterProperty = class;
  TtsCap32PreviewRateProperty = class;
  TtsCap32CaptureSettingsProperty = class;
  TtsCap32AdvCaptureSettingsProperty = class;


  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32DriverProperty
  //  Diese Klasse stellt einen Property-Editor zur Treiberauswahl im
  //  Entwurfsmodus dar.
  //  Liest die Liste der im System vorhandenen Treiber ein und läßt den User aus
  //  einem Pulldown-feld auswählen
  //////////////////////////////////////////////////////////////////////////////
  }
  TtsCap32DriverProperty=class(TOrdinalProperty)
  public
    function GetValue: string; override;
    procedure SetValue(const val: string);override;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32FilenameProperty
  //  Einfacher Propertyeditor zur Auswahl eines Filenames
  //////////////////////////////////////////////////////////////////////////////
  }
  TtsCap32FilenameProperty=class(TStringProperty)
  protected
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32AudioParameterProperty
  //  Propertyeditor für Audio parameter
  //////////////////////////////////////////////////////////////////////////////
  }
  TtsCap32AudioParameterProperty=class(TClassProperty)
  protected
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32PreviewRateProperty
  //  Propertyeditor für Preview Rate
  //////////////////////////////////////////////////////////////////////////////
  }
  TtsCap32PreviewRateProperty=class(TIntegerProperty)
  protected
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32AboutProperty
  //  zeigt aboutdialog
  //////////////////////////////////////////////////////////////////////////////
  }
  TtsCap32AboutProperty=class(TStringProperty)
  protected
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32CaptureSettingsProperty
  //  zeigt aboutdialog
  //////////////////////////////////////////////////////////////////////////////
  }
  TtsCap32CaptureSettingsProperty = class(TIntegerProperty)
  protected
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32AdvCaptureSettingsProperty
  //  zeigt aboutdialog
  //////////////////////////////////////////////////////////////////////////////
  }
  TtsCap32AdvCaptureSettingsProperty = class(TIntegerProperty)
  protected
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;



  {
  //////////////////////////////////////////////////////////////////////////////
  //  globale Funktionen
  //
  //////////////////////////////////////////////////////////////////////////////
  }

 {Registrierung}
  procedure Register;


implementation

{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32DriverProperty                            }
{                                                                            }
{****************************************************************************}

function TtsCap32DriverProperty.GetValue: string;
begin
  inherited GetValue;
  with GetComponent(0) as TtsCap32 do begin
    if FAutomaticSearchForDriver then
      Result := 'automatic'
    else
      Result := FDriverNameList[FDriverNo];
  end;
end;

procedure TtsCap32DriverProperty.SetValue(const val:string);
begin
  inherited SetValue(Value);
  with GetComponent(0) as TtsCap32 do
  begin
    if not Connected then
    begin
      if val = 'automatic' then
        FAutomaticSearchForDriver := TRUE
      else begin
        FAutomaticSearchForDriver := FALSE;
        SetOrdValue(FDriverNameList.IndexOf(val));
      end;
    end;
  end;
end;

function TtsCap32DriverProperty.GetAttributes:TPropertyAttributes;
begin
  inherited GetAttributes;
  Result:=[paValueList, paAutoUpdate, PaReadOnly];
end;

procedure TtsCap32DriverProperty.GetValues(Proc: TGetStrProc);
var
  i: integer;
begin
  Proc('automatic');
  with GetComponent(0) as TtsCap32 do
    for i:=0 to 9 do
      Proc(FDriverNameList[i]);
end;






{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32FilenameProperty                          }
{                                                                            }
{****************************************************************************}


procedure TtsCap32FilenameProperty.Edit;
type
  TtsFileType = (avi, bmp);
var
  CallingClass: TClass;
  CallingTtsCap32: TtsCap32;
  CallingTtsCap32Parameter: TtsCap32Parameter;
  tsFileType: TtsFileType;
  DefaultFileName: string;
  TmpFileRequester: TSaveDialog;
  s: String;
begin
  inherited Edit;

  CallingClass := TObject;

  //aufrufendes Objekt
  if TObject(GetComponent(0)) is TtsCap32 then begin
    CallingTtsCap32 := TtsCap32(GetComponent(0));
    CallingClass := TtsCap32;
  end;
  if TObject(GetComponent(0)) is TtsCap32Parameter then begin
    CallingTtsCap32Parameter := TtsCap32Parameter(GetComponent(0));
    CallingClass := TtsCap32Parameter;
  end;

  //Welche Property wird editiert?
  s := GetName;

  //Welche Methode übernimmt editierten String?
  tsFileType := bmp;
  if CallingClass = TtsCap32 then begin
    if s = 'SaveAsBMP' then begin
      tsFileType := bmp;
      DefaultFileName := CallingTtsCap32.SaveAsBMP;
    end;
  end;
  if CallingClass = TtsCap32Parameter then begin
    if s = 'SaveFile' then begin
      tsFileType := avi;
      DefaultFileName := CallingTtsCap32Parameter.SaveFile;
    end;
    if s = 'BufferFile' then begin
      tsFileType := avi;
      DefaultFileName := CallingTtsCap32Parameter.BufferFile;
    end;
  end;

  //Requester schaffen
  TmpFileRequester := TSaveDialog.Create(Application);

  //Eigenschaften einstellen
  with TmpFileRequester do begin
    FileName := DefaultFileName;
    Title := s;
    Filterindex := 1;
    case tsFileType of
      bmp: begin
        Filter := 'Windows-Bitmap (*.bmp)|*.bmp|Alle Dateien (*.*)|*.*';
        DefaultExt := 'bmp';
      end;
      avi: begin
        Filter := 'AVI-Video (*.avi)|*.avi|Alle Dateien (*.*)|*.*';
        DefaultExt := 'avi';
      end;
    end;
    Options := [ofOverwritePrompt, ofPathMustExist];
  end;

  //Requester ausführen
  if TmpFileRequester.Execute then SetStrValue(TmpFileRequester.FileName);

  //Requester killen
  TmpFileRequester.Free;

end;

function TtsCap32FilenameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;



{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32AboutProperty                             }
{                                                                            }
{****************************************************************************}


procedure TtsCap32AboutProperty.Edit;
type
  TtsFileType = (avi, bmp);
var
  TmpDlg: TtsCap32Dialogs;
  CallingObject: TComponent;
begin
  inherited Edit;
  CallingObject := TComponent(GetComponent(0));
  with CallingObject as TtsCap32 do begin
    TmpDlg := TtsCap32Dialogs.Create(CallingObject);
    TmpDlg.AttachedTsCap32 := TtsCap32(CallingObject);
    TmpDlg.AboutDlg := TRUE;
    TmpDlg.Free;
  end;
end;

function TtsCap32AboutProperty.GetAttributes: TPropertyAttributes;
begin
  Result := (inherited GetAttributes) + [paDialog];
end;




{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32AudioParameterProperty                    }
{                                                                            }
{****************************************************************************}

procedure TtsCap32AudioParameterProperty.Edit;
var
  TmpDlg: TtsCap32Dialogs;
  CallingObject: TComponent;
begin
  inherited Edit;
  CallingObject := TComponent(GetComponent(0));
  with CallingObject as TtsCap32 do begin
    TmpDlg := TtsCap32Dialogs.Create(CallingObject);
    TmpDlg.AttachedTsCap32 := TtsCap32(CallingObject);
    TmpDlg.AudioParameterDlg := TRUE;
    TmpDlg.Free;
  end;
end;

function TtsCap32AudioParameterProperty.GetAttributes: TPropertyAttributes;
begin
  Result := (inherited GetAttributes) + [paDialog];
end;


{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32CaptureSettingsProperty                   }
{                                                                            }
{****************************************************************************}

procedure TtsCap32CaptureSettingsProperty.Edit;
var
  TmpDlg: TtsCap32Dialogs;
  CallingObject: TtsCap32;
begin
  inherited Edit;
  CallingObject := TtsCap32Parameter(GetComponent(0)).Dad;
  with CallingObject do begin
    TmpDlg := TtsCap32Dialogs.Create(CallingObject);
    TmpDlg.AttachedTsCap32 := TtsCap32(CallingObject);
    TmpDlg.CaptureSettingsDlg := TRUE;
    TmpDlg.Free;
  end;
end;

function TtsCap32CaptureSettingsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := (inherited GetAttributes) + [paDialog];
end;

{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32AdvCaptureSettingsProperty                   }
{                                                                            }
{****************************************************************************}

procedure TtsCap32advCaptureSettingsProperty.Edit;
var
  TmpDlg: TtsCap32Dialogs;
  CallingObject: TtsCap32;
begin
  inherited Edit;
  CallingObject := TtsCap32Parameter(GetComponent(0)).Dad;
  with CallingObject do begin
    TmpDlg := TtsCap32Dialogs.Create(CallingObject);
    TmpDlg.AttachedTsCap32 := TtsCap32(CallingObject);
    TmpDlg.AdvCaptureSettingsDlg := TRUE;
    TmpDlg.Free;
  end;
end;

function TtsCap32AdvCaptureSettingsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := (inherited GetAttributes) + [paDialog];
end;

{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32PreviewRateProperty                       }
{                                                                            }
{****************************************************************************}

procedure TtsCap32PreviewRateProperty.Edit;
var
  TmpDlg: TtsCap32Dialogs;
  CallingObject: TtsCap32;
begin
  inherited Edit;
  CallingObject := TtsCap32Parameter(GetComponent(0)).Dad;
  TmpDlg := TtsCap32Dialogs.Create(CallingObject);
  TmpDlg.AttachedTsCap32 := CallingObject;
  TmpDlg.PreviewRateDlg := TRUE;
  TmpDlg.Free;
end;

function TtsCap32PreviewRateProperty.GetAttributes: TPropertyAttributes;
begin
  Result := (inherited GetAttributes) + [paDialog];
end;



{****************************************************************************}
{    Registrierungen                                                         }
{****************************************************************************}

procedure Register;
begin
  RegisterComponents('tsTech', [TtsCap32]);
  RegisterPropertyEditor(TypeInfo(LongInt), TtsCap32, 'Driver', TtsCap32DriverProperty);
  RegisterPropertyEditor(TypeInfo(TtsFileName), TtsCap32, '', TtsCap32FilenameProperty);
  RegisterPropertyEditor(TypeInfo(TtsFileName), TtsCap32Parameter, '', TtsCap32FilenameProperty);
  RegisterPropertyEditor(TypeInfo(string), TtsCap32, 'AboutAuthor', TtsCap32AboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TtsCap32, 'AboutVersion', TtsCap32AboutProperty);
  RegisterPropertyEditor(TypeInfo(TtsCap32AudioParameter), TtsCap32, '', TtsCap32AudioParameterProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TtsCap32Parameter, 'PreviewRate_fps', TtsCap32PreviewRateProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TtsCap32Parameter, 'PreviewRate_mspf', TtsCap32PreviewRateProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TtsCap32Parameter, 'TimeLimit', TtsCap32CaptureSettingsProperty);
  RegisterPropertyEditor(TypeInfo(LongInt), TtsCap32Parameter, 'CaptureRate_fps', TtsCap32CaptureSettingsProperty);
  RegisterPropertyEditor(TypeInfo(LongInt), TtsCap32Parameter, 'CaptureRate_uspf', TtsCap32CaptureSettingsProperty);
  RegisterPropertyEditor(TypeInfo(LongInt), TtsCap32Parameter, 'IndexSize', TtsCap32AdvCaptureSettingsProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TtsCap32Parameter, 'ChunkGranularity', TtsCap32AdvCaptureSettingsProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TtsCap32Parameter, 'NumAudioRequested', TtsCap32AdvCaptureSettingsProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TtsCap32Parameter, 'NumVideoRequested', TtsCap32AdvCaptureSettingsProperty);
  RegisterPropertyEditor(TypeInfo(LongInt), TtsCap32Parameter, 'AudioBufferSize', TtsCap32AdvCaptureSettingsProperty);
  RegisterPropertyEditor(TypeInfo(Integer), TtsCap32Parameter, 'PercentDropForError', TtsCap32AdvCaptureSettingsProperty);

  RegisterComponents('tsTech', [TtsCap32PopupMenu]);

  RegisterComponents('tsTech', [TtsCap32Dialogs]);
end;


end.
