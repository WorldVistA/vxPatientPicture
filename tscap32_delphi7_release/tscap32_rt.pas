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








unit tscap32_rt;
{
unit tsCap32


purpose:
Capturekomponente, 32bit

März/April 97 Version 2.1
April 97 Version 3.0

neu in v2.1:
-'hCapWnd' public ro veröffentlicht (auf Wunsch eines einzelnen Herrn)
-'CaptureParameter'(CAPTUREPARMS) public rw veröffentlicht
-'pVideoFormat' nun rw
-CAPDRIVERCAPS werden gelesen, die wichtigsten Werte als ro-properties in
 der Sammelproperty DriverCaps veröffentlicht, CAPDRIVERCAPS-Struktur außerdem als
 'CaptureDriverCaps' public ro veröffentlicht
-Zugriff auf CAPSTATUS über GetCaptureStatus und ro property 'CaptureStatus'. Stati
 werden aktualisiert in OnStatusINternal und zu best. Anlässen
-Neuorganisierung Audiokram: Alle Audioparameter in Sammelproperty 'AudioParameter'
 vereinigt. Check, ob Hardware vorhanden, (ro property 'AudioHardware'). Ein- und Aus-
 schalten Audio capturing mit 'AudioCapEnabled'. Samplefrequenz, -breite und Anzahl
 Kanäle über Properties einstellbar, falls das übliche einfache Windows-PCM-Format
 verwandt wird. Ansonsten Direktzugriff auf WAVEFORMATEX-Struktur und Laden/Setzen
 der Parameter in üblicher Form mit entspr. Methoden
-Bug beseitigt: SetCaptureParameter gibt jetzt Ergebnis (succ/Fail) zurück
 (vorher nur Error-Event), die Set... - Methoden von TtsCap32Parameter wurden
 überarbeitet und setzen sich bei falscher Eingabe nun korrekt auf die tatsächlichen
 Treibereinstellungen zurück
-Zeitlimit bei Aufnahme einstellbar über neue rw - Properties
 'Parameter.TimeLimitEnabled' und 'Parameter.TimeLimit'
-UserHitToCapture-Flag veröffentlicht
-Neues Property 'fps', um 'uspf' herumgewickelt
-Neues Property 'AbortKey', entspr. vKeyAbort in CAPTUREPARMS
-Logo geschützt. Logo als festcod. Bitmap oder als festcod. WMF. WMF in Varianten, abh.
 v. Farbauflösung
-ro property CapturingNow (record in progress) = FgrabbingStarted or fCapturingNow in CAPSTATUS,
 zeigt an, ob Aufnahme (auch im manuellen Mode) läuft
 //4.5.97:ja, sch... - nur noch fCaptureingNow - das Statuscallback wird ab und zu veschluckt, da
 fällt es schwer, FGrabbingStarted zurückzusetzen. Gilt also nur noch
 für streaming capture
-gibt keine Callback-installationsschalter mehr! hatten eh keinen Sinn, jetzt
 werden definitiv ALLE Callbacks zu den internen Callbackroutinen
 durchgeschleift, die Usermethoden wie gehabt nur bei Assigned(...) = TRUE aufgerufen.
-property OnDib liefert Dib, OnBitmap ein Bitmap beim ctManualIntoMem grabbing; funktioniert nur korrekt bei
 unkomprimierten bildern, ------------------------
-neue properties in parameter: PercentDropOfError, MCIControl, MCIDeviceStep,
 MCIStartTime, MCIStopTime
-neue about-property

neu in v3.0:
-key-und Mouseevents veröffentlicht, Enabled, Tabstop, TabOrder und visible veröffentlicht
-Message-Redirecting vom Capture-Window zur Komponente: Messages gehen zur
 Application, von dort aus direkt zum Capturewindow (z.B. Mouseclicks). Prinzipiell
 möglich, sich in Application.OnMessage reinzuhängen und Fensterhandle für diese
 Botschaften auf das Handle der Komponente selbst zu verbiegen. Probleme: a) unelegant,
 da dem Benutzer Nutzung von OnMessage erschwert wird, b)muß für viele Instanzen
 funktionieren, c) muß schnell sein, auch bei Handler-ketten
 Versuche mit transparenten Fenstern zum Mausanbfangen scheiterten-
 transparente Windows unter Windows sind keine echten transparenten Windows!
  ...
-fps und uspf renamed to CaptureRate_fps resp. CaptureRate_uspf, PreviewRate
  renamed to PreviewRate_mspf, new property PreviewRate_fps
-neue property SaveAsBmp - Aktuelles Bild als Bitmap speichern
-PopupMenu veröffentlicht
-message-redirecting über messageredirecter, s.u., gilt für mouse- und Key-events,
 wenn connected und notwendig(IsMessageHookNeeded) und nicht PreventMessageHook

-neuer Capturemodus: ManualCapIntoFile
-Partnerkomponente TtsCap32PopupMenu
-neue prop: IndexSize
-Parameter.UpdateFlags() updated all Flags, die von. CAPSTATUS und CAPTUREPARMS
 abhängen (u.a. sobald Setzen eines Flags vom Treiber abgewiesen wird)
-Parameter.ExecuteAll setzt alle von CAPTUREPARMS abh. Flags zusammen. Vorher wurden
 bei Mißlingen einer Einstellung alle lokalen Flags verstellt
-Für alle Filenamen - properties jetzt einen Dateiauswahldialog
(TtsCap32FileNameProperty). (Mit einigen Kniebeugen in bezug auf Sub-properties)
-Neue Organisation des Skalierungskrames (versuchsweise) über Sammelproperty
 CapWndDimension, die zentral die Größe des CapWnd verwaltet(auch direkten Zugriff
 darauf bietet) und außerdem eine Reihe von "ScaleOrders", welche best. Einstellungen
 schnell realisieren. Scale und ScaleRatio fliegen raus.
-OnResize veröffentlicht
-Dialogfensterkomponente u. Kommunikation mit Preipheriekomp. über Messages
-Reorg. Driverkram: Einlesen der Treibernamen/Versionen in Hauptkomponente,
 neue Properties DriverName[], DriverVersion[], DrivewrNameList und FDriverVersionList.
 AutomaticSearch als Boolean ausgelagert, nicht merh vermengt mit dem Werteberewich der
 DriverNo - no more irritations about deadjusted driver numbers
 + Dlg über Dialogkomp und Eintrag im Poppmenu
8.5.97:
- OnConnected
- Neu: SuppressPreviewGrab (public): False TRUE, werden nur die Events in OnFrameInternal
  an OnDib/OnBitmap weitergeliefert, die von CapOrder := grab ausgelöst wurden (tatsächlich
  das nächste Bild, das nach OnGrab ankommt) - auf diese Weise kann OnDib einmal zum
  Verarbeiten laufend ankommender Previewbilder verwendet werden und zum anderen zum
  Verarbeiten nur der ausgelösten Bilder (ohne das Fenster verstecken zu müssen o.ä. Blödsinn)
9.5.97:
 PROBLEM: Im overlaymode funktioniert scaling (Immer noch) nicht richtig.
 Hängt ab vom vergrößerungsfaktor, den Displayeinstellungen (Auflösung) und dem Wettern in china...
-Overlay-häng-bug teilwese beseitigt durch 'schütteln', 2 Overlaymessages
  hintereinander
-neu: (und genial): bei CopyToClipboard wird jetzt OnDib und OnBitmap aufgerufen! 

---------post 300:--------
13.05.97:
-neuer Dialog für Audioparameter - gleich als propertyeditor mit eingehängt
-neuer Dialog für CaptureSettings - gleich als propertyeditor mit eingehängt
-neuer Dialog für AdvCaptureSettings - gleich als propertyeditor mit eingehängt
-OnSyncExternalCtrls
-neuer Dialog für Previewrate - gleich als propertyeditor mit eingehängt
-geändert: Indexsize = 0 jetzt defaultwert
-neu veröffentlicht: AudioBufferSize, NumVideoRequested, numAudioRequested
-neu: public SaveRequired
-CapTechnique ctStreamINtoMem
}

{$UNDEF TSCAP32_GERMAN_VERSION}
{$DEFINE TSCAP32_ENGLISH_VERSION}

{$UNDEF DEBUG}


{$UNDEF SIMULATE_NODRIVER}

//LOGOart
{$DEFINE LOGO_AS_WMF}
{$UNDEF LOGO_AS_BITMAP}

interface

                                                                       

uses
  //Delphi-Units:
  Windows, MMSystem, Messages, SysUtils, Classes, Graphics, ExtCtrls,
  dialogs, Menus, Forms, math, StdCtrls, Controls, ClipBrd,

  //eigene Units:
  tstlg,

  vfwunit,
  tsDibRel, tsMessages    

  {$IFDEF DEBUG}
  , tsDebug
  {$ENDIF}
  ;

const

  {
  interne, systemweit zu verwendende Nachrichten
  werden im Konstruktor mit RegisterWindowMessage registriert und zur
  Kommunikation der einzelnen tsCap32-Instanzen untereinander verwandt
  }

  {tsMsg_ConnectRequest wird an alle Komponenteninstanzen gesandt,
  falls Connect := TRUE bei einer Instanz von tsCap32
  Parameter: lparam: Treibernummer
  diese geben den Treiber frei (falls sie den avisierten belegen und
  RefuseDisconnect = FALSE)}
  NAME_OF_CONNECTREQUEST = 'tsMsg_ConnectRequest';

const
  {$IFDEF DEBUG}
  //Debug-version: kein logo - property, tsDebug wird mit eingebunden
  VERSION_STRING = '3.1 open debug';
  VERSION_NOTES = 'Published under LGPL';
  LAST_RELEASE_DATE_STRING = '2003-04-01';
  {$ENDIF}

  VERSION_STRING = '3.1 open';
  VERSION_NOTES = 'Published under LGPL';
  LAST_RELEASE_DATE_STRING = '2003-04-01';

  {
  Fehlerausgaben
  }
{$IFDEF TSCAP32_GERMAN_VERSION}
  {Errorstrings - Deutsche Version}
  ERRMSG_NO_VALID_DRIVER = 'kein gültiger Treiber ausgewählt';
  ERRMSG_CONNECT_FAILED = 'Verbindung zum Treiber nicht möglich (Connected vor Programmstart auf False setzen!)';
  ERRMSG_WM_CAP_GET_VIDEOFORMAT = 'GetVideoformat fehlgeschlagen';
  ERRMSG_WM_CAP_SET_VIDEOFORMAT = 'Änderung des Videoformates fehlgeschlagen - wird von Hardware nicht unterstützt.';
  ERRMSG_WM_CAP_GET_SEQUENCE_SETUP = 'Get CAPTUREPARMS fehlgeschlagen';
  ERRMSG_WM_CAP_SET_SEQUENCE_SETUP = 'Änderung der Captureparameter fehlgeschlagen.';
  ERRMSG_WM_CAP_SEQUENCE = 'Startmessage wurde nicht bearbeitet.';
  ERRMSG_WM_CAP_STOP = 'Stopmessage wurde nicht bearbeitet.';
  ERRMSG_WM_CAP_FILE_SAVEAS = 'Savemessage wurde nicht bearbeitet.';
  ERRMSG_PUFFERFILE_PATHNAME_TOO_LONG = 'Pfadname des Pufferfiles ist zu lang.';
  ERRMSG_SAVEFILENAME_TOO_LONG = 'Name der Savefiles ist zu lang.';
  ERRMSG_DLG_VIDEOFORMAT = 'Videoformat-Dialog ist fehlgeschlagen oder wird vom Treiber nicht unterstützt.';
  ERRMSG_DLG_VIDEOCOMPRESSION = 'Videokompressions-Dialog ist fehlgeschlagen oder wird vom Treiber nicht unterstützt.';
  ERRMSG_DLG_VIDEODISPLAY = 'Videodisplay-Dialog ist fehlgeschlagen oder wird vom Treiber nicht unterstützt.';
  ERRMSG_DLG_VIDEOSOURCE = 'Videosource-Dialog ist fehlgeschlagen oder wird vom Treiber nicht unterstützt.';
  ERRMSG_WM_CAP_FILE_SET_CAPTURE_FILE = 'Festlegung des Pufferfiles ist fehlgeschlagen';
  ERRMSG_WM_CAP_FILE_ALLOCATE = 'Allokierung des Pufferfiles ist fehlgeschlagen';
  ERRMSG_WM_CAP_SET_PREVIEW = 'Preview fehlgeschlagen oder wird vom Treiber nicht unterstützt';
  ERRMSG_WM_CAP_SET_OVERLAY = 'Overlay fehlgeschlagen oder wird vom Treiber nicht unterstützt';
  ERRMSG_WM_CAP_SET_PREVIEWRATE = 'Festlegung der Previewrate fehlgeschlagen';
  ERRMSG_WM_CAP_SET_SCALE = 'Scaling fehlgeschlagen oder wird vom Treiber nicht unterstützt';
  ERRMSG_WM_CAP_SET_CALLBACK_ERROR = 'Installation oder Deinstallation der Error-Callbackfunktion fehlgeschlagen';
  ERRMSG_WM_CAP_SET_CALLBACK_VIDEOSTREAM = 'Installation oder Deinstallation der Videostream-Callbackfunktion fehlgeschlagen';
  ERRMSG_WM_CAP_SET_CALLBACK_FRAME = 'Installation oder Deinstallation der Frame-Callbackfunktion fehlgeschlagen';
  ERRMSG_WM_CAP_SET_CALLBACK_YIELD = 'Installation oder Deinstallation der Yield-Callbackfunktion fehlgeschlagen';
  ERRMSG_WM_CAP_SET_CALLBACK_WAVESTREAM = 'Installation oder Deinstallation der Wavestream-Callbackfunktion fehlgeschlagen';
  ERRMSG_WM_CAP_SET_CALLBACK_STATUS = 'Installation oder Deinstallation der Status-Callbackfunktion fehlgeschlagen';
  ERRMSG_WM_CAP_SET_CALLBACK_CAPCONTROL = 'Installation oder Deinstallation der CapControl-Callbackfunktion fehlgeschlagen';
  ERRMSG_WM_CAP_GET_STATUS = 'Get Status fehlgeschlagen - es besteht keine Verbindung zu einem Capture-Treiber';
  ERRMSG_WM_CAP_SET_AUDIOFORMAT = 'SET_AUDIOFORMAT fehlgeschlagen';
  ERRMSG_WM_CAP_GET_AUDIOFORMAT = 'GET_AUDIOFORMAT fehlgeschlagen';
  ERRMSG_WM_CAP_SINGLE_FRAME_OPEN = 'SingleFrameOpen failed';
  ERRMSG_WM_CAP_SINGLE_FRAME_CLOSE = 'SingleFrameClose failed';
  ERRMSG_GENERAL_ONLY_IF_CONNECTED = 'Diese Aktion ist nur möglich, wenn die Komponente mit einem Treiber verbunden ist(Connected = TRUE)';
  ERRMSG_GENERAL_OPEN_FAILED = 'Verbindungsaufbau zum Videotreiber fehlgeschlagen';
{$ELSE}
  {Error Strings - English Version}
  ERRMSG_NO_VALID_DRIVER = 'no valid driver choosen';
//todo
  ERRMSG_CONNECT_FAILED = 'connect-message was not processed by the capture driver';
  ERRMSG_WM_CAP_GET_VIDEOFORMAT = 'GetVideoformat failed';
  ERRMSG_WM_CAP_SET_VIDEOFORMAT = 'SetVideoformat failed';
  ERRMSG_WM_CAP_GET_SEQUENCE_SETUP = 'GetCaptureparameter failed';
  ERRMSG_WM_CAP_SET_SEQUENCE_SETUP = 'SetCaptureParameter failed';
  ERRMSG_WM_CAP_SEQUENCE = 'Startmessage not confirmed';
  ERRMSG_WM_CAP_STOP = 'Stopmessage not confirmed';
  ERRMSG_WM_CAP_FILE_SAVEAS = 'Savemessage not confirmed';
  ERRMSG_PUFFERFILE_PATHNAME_TOO_LONG = 'Pathname of the bufferfile too long';
  ERRMSG_SAVEFILENAME_TOO_LONG = 'Pathname of the savefile is too long';
  ERRMSG_DLG_VIDEOFORMAT = 'Videoformat dialog failed or not supported';
  ERRMSG_DLG_VIDEOCOMPRESSION = 'Videocompression dialog failed or not supported';
  ERRMSG_DLG_VIDEODISPLAY = 'Videodisplay dialog failed or not supported';
  ERRMSG_DLG_VIDEOSOURCE = 'Videosource dialog failed or not supported';
  ERRMSG_WM_CAP_FILE_SET_CAPTURE_FILE = 'setting bufferfile failed';
  ERRMSG_WM_CAP_FILE_ALLOCATE = 'Allocation of bufferfile failed';
  ERRMSG_WM_CAP_SET_PREVIEW = 'Preview failed or not supported';
  ERRMSG_WM_CAP_SET_OVERLAY = 'Overlay failed or not supported';
  ERRMSG_WM_CAP_SET_PREVIEWRATE = 'Setting previewrate failed';
  ERRMSG_WM_CAP_SET_SCALE = 'scaling failed or not supported';
  ERRMSG_WM_CAP_SET_CALLBACK_ERROR = 'Installation or Deinstallation of Errorcallback failed';
  ERRMSG_WM_CAP_SET_CALLBACK_VIDEOSTREAM = 'Installation or Deinstallation of VideoStreamcallback failed';
  ERRMSG_WM_CAP_SET_CALLBACK_FRAME = 'Installation or Deinstallation of Framecallback failed';
  ERRMSG_WM_CAP_SET_CALLBACK_YIELD = 'Installation or Deinstallation of Yieldcallback failed';
  ERRMSG_WM_CAP_SET_CALLBACK_WAVESTREAM = 'Installation or Deinstallation of Wavestreamcallback failed';
  ERRMSG_WM_CAP_SET_CALLBACK_STATUS = 'Installation or Deinstallation of Statuscallback failed';
  ERRMSG_WM_CAP_SET_CALLBACK_CAPCONTROL = 'Installation or Deinstallation of CapControlcallback failed';
  ERRMSG_WM_CAP_GET_STATUS = 'Get Status failed - capture window is not connected to a driver';
  ERRMSG_WM_CAP_SET_AUDIOFORMAT = 'SET_AUDIOFORMAT failed';
  ERRMSG_WM_CAP_GET_AUDIOFORMAT = 'GET_AUDIOFORMAT failed';
  ERRMSG_WM_CAP_SINGLE_FRAME_OPEN = 'SingleFrameOpen failed';
  ERRMSG_WM_CAP_SINGLE_FRAME_CLOSE = 'SingleFrameClose failed';
  ERRMSG_GENERAL_ONLY_IF_CONNECTED = 'This action is possible only if component is connected to a capture driver';
  ERRMSG_GENERAL_OPEN_FAILED = 'Connect failed';

  {$ENDIF} //English Version


const
  {Stati, in denen Verbindung mit dem Treiber fehlschlägt}
  PROHIBITED_STATES=[{csReading,csWriting,csLoading}];

type
  //benötigt für Frame-Callback
  PVIDEOHDR = ^videohdr_tag;
  //Benötigt für Audio-Callback
  PWaveHdr = ^TWaveHdr;

  //interne Exception
  EtsCap32 = class(Exception);

  {
  Typendeklarationen
  }
  TtsCap32 = class;
  TtsCap32Parameter = class;
  TtsCap32DriverCaps = class;
  TtsCap32AudioParameter = class;
  TtsCap32CapWndDimensions = class;
  TtsCap32CapTechnique = (ctStreamIntoFile, ctStreamIntoMem, ctManualIntoMem, ctManualIntoFile);
  TtsCap32CapOrder = (start, stop, save, grab);
  TtsCap32ScaleOrder = (soFitIn, soFitInProportional, soFitInPower2, soDouble, soFourfould, soHalf, soFourth, soOriginalSize, soCenter, soLeftTop);
  TtsCap32MessageRedirecter = class;
  TtsCap32Dialogs = class;
  TtsCap32BufferFileFrm = class;
  TtsCap32AboutFrm = class;
  TtsCap32DriverFrm = class;


  {Callback - Eventtypen}
  TtsCap32NotifyError = procedure (Sender: TObject) of object;
  TtsCap32NotifyFrame = procedure(Sender: TObject; pVidHdr: PVIDEOHDR) of object;
  TtsCap32NotifyVideoStream = procedure(Sender: TObject; pVidHdr: PVIDEOHDR) of object;
  TtsCap32NotifyYield = procedure (Sender: TObject) of object;
  TtsCap32NotifyWaveStream = procedure(Sender: TObject; lpWHdr: PWAVEHDR) of object;
  TtsCap32NotifyStatus = procedure(Sender: TObject; nID: Integer; lpsz: PChar) of object;
  TtsCap32NotifyCapControl = procedure(Sender: TObject; nState: Integer) of object;

  TtsCap32NotifyDib = procedure(Sender: TObject; pBmi: PBITMAPINFO; pBits: PChar; msSinceFirstFrame: DWORD) of object;
  TtsCap32NotifyBitmap = procedure(Sender: TObject; Bitmap: TBitmap; msSinceFirstFrame: DWORD) of object;

  TtsCap32NotifyConnection = procedure(Sender: TObject; status: Boolean) of object;
  //Dieser Typ dient dazu, für alle Arten von Pfadnamen einen Propertyeditor
  //installieren zu können - dazu müssen diese Strings von normalen Strings unterschieden
  //werden können
  //Grund für diesen Kunstgriff: es gelingt mir nicht, einen Propertyeditor für eine
  //best. property in einem verschachteltem Objekt registrieren zu lassen
  //(z.B. Parameter.SaveFile)
  TtsFileName = string[OFS_MAXPATHNAME];


  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32Parameter
  //  Diese Klasse vereinigt unter sich viele parametereinstellungen, haupt-
  //  sächlich um die Darstellung im Objektinspektor übersichtlicher zu gestalten
  //  Wird nur innerhalb von TsCap32 verwandt
  //  Die dargestellten Parameter basieren fast alle auf der CAPTUREPARMS-Struktur,
  //  diese wird aber direkt in der TtsCap32-Klasse gehalten
  ////////////////////////////////////////////////////////////////////////////////
  }
  TtsCap32Parameter = class(TPersistent)
  public

    //Verbindung zum Eignerobjekt
    Dad: TtsCap32;

  private
  
    DummyBoolean: Boolean;
    DummyInteger: Integer;
    function DummyBoolGetFalse: Boolean;
  private
    {alle Feldinhalte ausführen - d.h. alle gepeicherten Einstellungen
    realisieren, z.B. bei Dad.Connected := TRUE}
    procedure ExecuteAll;
  private
    FBufferFile: TtsFileName;
    FBufferFileSize_Mb: integer;
    FSaveFile: TtsFileName;
    FPreview: Boolean;
    FPreviewRate_mspf: Integer;
    FOverlay: Boolean;
    FCaptureRate_uspf: LongInt;
    FAbortLeftMouseKey: Boolean;
    FAbortRightMouseKey: Boolean;
    FYield: Boolean;
    FCapTechnique: TtsCap32CapTechnique;
    FTimeLimit: Integer;
    FTimeLimitEnabled: Boolean;
    FUserHitToCapture: Boolean;
    FAbortKey: TShortCut;
    FPercentDropForError: Integer;
    FMCIControl: Boolean;
    FMCIDeviceStep: Boolean;
    FMCIStartTime: LongInt;
    FMCIStopTime: LongInt;
    FIndexSize: LongInt;
    FChunkGranularity: Integer;
    FAudioBufferSize: LongInt;
    FNumVideoRequested: Integer;
    FNumAudioRequested: Integer;

    //UpdateFlags führt Dad.GetCaptureStatus aus und aktualisiert einige Properties
    //den Werten der CAPSTATUS-Struktur entsprechend
    procedure UpdateFlags;
    procedure ShowDlgFormat(status:Boolean);
    procedure ShowDlgCompression(status:Boolean);
    procedure ShowDlgDisplay(status:Boolean);
    procedure ShowDlgSource(status:Boolean);
    procedure SetBufferFile(BufferFile: TtsFileName);
    procedure SetBufferFileSize_Mb(BufferFileSize_Mb: integer);
    procedure SetSaveFile(FileName: TtsFileName);
    procedure SetPreview(status: Boolean);
    procedure SetPreviewRate_mspf(PreviewRate_mspf: Integer);
    procedure SetPreviewRate_fps(PreviewRate_fps: Integer);
    function GetPreviewRate_fps: Integer;
    procedure SetOverlay(status: Boolean);
    procedure SetCaptureRate_uspf(CaptureRate_uspf: LongInt); //Mikrosec. per Frame
    procedure SetCaptureRate_fps(CaptureRate_fps: LongInt);
    function GetCaptureRate_fps: LongInt;
    procedure SetAbortLeftMouseKey(status: Boolean);
    procedure SetAbortRightMouseKey(status: Boolean);
    procedure SetYield(status: Boolean);
    procedure SetCapTechnique(CapTechnique: TtsCap32CapTechnique);
    procedure SetTimeLimit(TimeLimit: Integer);
    procedure SetTimeLimitEnabled(status: Boolean);
    procedure SetUserHitToCapture(status: Boolean);
    procedure SetAbortKey(AbortKey: TShortCut);
    function GetImageWidth: Integer;
    function GetImageHeight: Integer;
    procedure SetPercentDropForError(PercentDropForError: Integer);
    procedure SetMCIControl(status: Boolean);
    procedure SetMCIDeviceStep(status: Boolean);
    procedure SetMCIStartTime(MCIStartTime: LongInt);
    procedure SetMCIStopTime(MCIStopTime: LongInt);
    procedure SetIndexSize(IndexSize: LongInt);
    procedure SetChunkGranularity(ChunkGranularity: Integer);
    procedure SetAudioBufferSize(AudioBufferSize: LongInt);
    procedure SetNumVideoRequested(NumVideoRequested: Integer);
    procedure SetNumAudioRequested(NumAudioRequested: Integer);

  published
    constructor Create(Dad: TtsCap32);
    destructor Destroy; override;
    //Capturefile
    property BufferFile: TtsFileName Read FBufferFile Write SetBufferFile;
    //Size of Capturefile
    property BufferFileSize_Mb: integer Read FBufferFileSize_Mb Write SetbufferFileSize_Mb;
    //This property names the file to save the datas buffered in the capture file when CapOrder := save
    property SaveFile: TtsFileName Read FSaveFile Write SetSaveFile;
    property Preview: Boolean Read FPreview Write SetPreview default TRUE;
    property PreviewRate_mspf: Integer Read FPreviewRate_mspf Write SetPreviewRate_mspf;
    property PreviewRate_fps: Integer Read GetPreviewRate_fps Write SetPreviewRate_fps;
    property Overlay: Boolean Read FOverlay Write SetOverlay default TRUE;
    //Framerate: Microseconds per Frame
    property CaptureRate_uspf: LongInt Read FCaptureRate_uspf Write SetCaptureRate_uspf;
    //Framerate: Frames per second (Wrapped around the uspf-property)
    property CaptureRate_fps: LongInt Read GetCaptureRate_fps Write SetCaptureRate_fps;
    property AbortLeftMouseKey: Boolean Read FAbortLeftMouseKey Write SetAbortLeftMouseKey default TRUE;
    property AbortRightMouseKey: Boolean Read FAbortRightMouseKey Write SetAbortRightMouseKey default TRUE;
    property Yield: Boolean Read FYield Write SetYield default FALSE;
    property CapTechnique: TtsCap32CapTechnique Read FCapTechnique Write SetCapTechnique;
    property DlgFormat: Boolean Read DummyBoolGetFalse Write ShowDlgFormat;
    property DlgCompression: Boolean Read DummyBoolGetFalse Write ShowDlgCompression;
    property DlgSource: Boolean Read DummyBoolGetFalse Write ShowDlgSource;
    property DlgDisplay: Boolean Read DummyBoolGetFalse Write ShowDlgDisplay;
    property TimeLimit: Integer Read FTimeLimit Write SetTimeLimit;
    property TimeLimitEnabled: Boolean Read FTimeLimitEnabled Write SetTimeLimitEnabled;
    property UserHitToCapture: Boolean Read FUserHitToCapture Write SetUserHitToCapture;
    property AbortKey: TShortCut Read FAbortKey Write SetAbortKey;
    property ImageWidth: Integer Read GetImageWidth Write DummyInteger;
    property ImageHeight: Integer Read GetImageHeight Write DummyInteger;
    property PercentDropForError: Integer Read FPercentDropForError Write SetPercentDropForError default 20;
    property MCIControl: Boolean Read FMCIControl Write SetMCIControl;
    property MCIDeviceStep: Boolean Read FMCIDeviceStep Write SetMCIDeviceStep;
    property MCIStartTime: LongInt Read FMCIStartTime Write SetMCIStartTime;
    property MCIStopTime: LongInt Read FMCIStopTime Write SetMCIStopTime;
    property IndexSize: LongInt Read FIndexSize Write SetIndexSize default 0;
    property ChunkGranularity: Integer Read FChunkGranularity Write SetChunkGranularity default 0;
    property AudioBufferSize: Longint Read FAudioBufferSize Write SetAudioBufferSize default 0;
    property NumVideoRequested: Integer Read FNumVideoRequested Write SetNumVideoRequested default 0;
    property NumAudioRequested: Integer Read FNumAudioRequested Write SetNumAudioRequested default 0;
  end;

  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32DriverCaps
  //  Diese Klasse veröffentlicht die Eigenschaften des CaptureTreibers, die
  //  den Werten in der CAPDRIVERCAPS-Struktur entsprechen.
  //  Nur der Übersicht halber in eine Unterklasse verfrachtet
  //  (Im Gegensatz zu TtsCap32Parameter holt und hält sie ihre interne Basis-
  //  struktur CAPDRIVERCAPS selbst)
  ////////////////////////////////////////////////////////////////////////////////
  }
  TtsCap32DriverCaps = class(TPersistent)
  private
    //Dummies für unidir. Properties, die trotzdem im Objektinsp. erscheinen sollen
    DummyBool: Boolean;
    function DummyBoolGetFalse: Boolean;

  private
    //Verbindung zum Eignerobjekt
    Dad: TtsCap32;

  public
    constructor Create(Dad: TtsCap32);
    destructor Destroy; override;

  private
    //Basisstruktur
    FCapDriverCaps: CAPDRIVERCAPS;
    //Get... Methoden lesen nur Basisstuktur aus
    function GetHasOverlay: Boolean;
    function GetHasDlgVideoSource: Boolean;
    function GetHasDlgVideoFormat: Boolean;
    function GetHasDlgVideoDisplay: Boolean;
    function GetDriverSuppliesPalettes: Boolean;
    //Inhalt der basisstruktur updaten
    procedure UpdateShownCaps;
    //Hilfsfunktion: Struktur komplett auf FALSE setzen
    procedure SetAllFalse;

  public
    property CaptureDriverCaps: CAPDRIVERCAPS Read FCapDriverCaps;

  published
    property HasOverlay: Boolean Read GetHasOverlay Write DummyBool;
    property HasDlgVideoSource: Boolean Read GetHasDlgVideoSource Write DummyBool;
    property HasDlgVideoFormat: Boolean Read GetHasDlgVideoFormat Write DummyBool;
    property HasDlgVideoDisplay: Boolean Read GetHasDlgVideoDisplay Write DummyBool;
    property DriverSuppliesPalettes: Boolean Read GetDriverSuppliesPalettes Write DummyBool;
  end;



  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32CapWndDimensions
  ////////////////////////////////////////////////////////////////////////////////
  }
  TtsCap32CapWndDimensions = class(TPersistent)
  private
    //Verbindung zum Eignerobjekt
    Dad: TtsCap32;

  public
    constructor Create(Dad: TtsCap32);
    destructor Destroy; override;

  private

    Fx, Fy, Fw, Fh: Integer;
    FCenter: Boolean;
    FLastScaleOrder: TtsCap32ScaleOrder;
    FRecalcOnResize: Boolean;
    procedure ExecuteScaleOrder(ScaleOrder: TtsCap32ScaleOrder);
    procedure SetCenter(status: Boolean);
    procedure Setx(x: Integer);
    procedure Sety(y: Integer);
    procedure Setw(w: Integer);
    procedure Seth(h: Integer);
  public

    procedure RealizeDimensions;
    procedure ExecuteLastScaleOrder;
  published

    property x: Integer Read Fx Write SetX;
    property y: Integer Read Fy Write Sety;
    property w: Integer Read Fw Write Setw;
    property h: Integer Read Fh Write Seth;
    property ScaleOrder: TtsCap32ScaleOrder Read FLastScaleOrder Write ExecuteScaleOrder default soFitIn;
    property RecalcOnResize: Boolean Read FRecalcOnResize Write FRecalcOnResize default TRUE;
    property Center: Boolean Read FCenter Write SetCenter default TRUE;
  end;

  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32AudioParameter
  //  Klasse vereinigt alle Eigenschaften, die mit Audiocapturing zu tun haben
  //  (z.Z. AudioCapture on/off und das Setzen des Sampleformates)
  //  Direktzugriff auf Samplebreite/frequenz, in den für Standard-PCM-Format
  //  üblichen Werten. Für spezielle Wünsche kann die TPCMWaveFormat-Struktur
  //  direkt manipuliert werden
  ////////////////////////////////////////////////////////////////////////////////
  }

  //Hilfstypen
  TtsCap32AudioParameterSplFrequ = (fdefault, f8000Hz, f11025Hz, f22050Hz, f44100Hz);
  TtsCap32AudioParameterSplWidth = (wdefault, w8bit, w16bit);
  TtsCap32AudioParameterChannels = (chdefault, chMono, chStereo);

  TtsCap32AudioParameter = class(TPersistent)
  private
    //Dummies für unidir. Properties, die trotzdem im Objektinsp. erscheinen sollen
    DummyBool: Boolean;
    function DummyBoolGetFalse: Boolean;

  private
    //Verbindung zum Eignerobjekt
    Dad: TtsCap32;

  public
    constructor Create(Dad: TtsCap32);
    destructor Destroy; override;

  private
    //Zeiger auf Basisstruktur
    FpAudioFormat: PWAVEFORMATEX;
    FAudioFormatSize: Integer;
    //Schalter
    FAudioCapEnabled: Boolean;
    //zu nutzende SplFrequ
    FSplFrequ: TtsCap32AudioParameterSplFrequ;
    //zu nutzende SplBreite
    FSplWidth: TtsCap32AudioParameterSplWidth;
    //zu nutzende Kanalanzahl
    FChannels: TtsCap32AudioParameterChannels;
    {Audiohardware suchen (GetCaptureStatus und fAudioHardware-Flag auswerten)}
    function GetAudioHardware: Boolean;
    {alle Feldinhalte ausführen - d.h. alle gepeicherten Einstellungen
    realisieren, z.B. bei Dad.Connected := TRUE}
    procedure ExecuteAll;
    //AudioCap ein- oder ausschalten
    procedure SetAudioCapEnabled(status: Boolean);
    //Samplefrequ ändern (resp. Wert in FSplFrequ für spätere Änderung zwischenspeichern)
    procedure SetSplFrequ(SplFrequ: TtsCap32AudioParameterSplFrequ);
    //SampleBreite ändern (resp. Wert in FSplWidth für spätere Änderung zwischenspeichern)
    procedure SetSplWidth(SplWidth: TtsCap32AudioParameterSplWidth);
    //Anzahl Kanäle ändern (resp. Wert in FChannels für spätere Änderung zwischenspeichern)
    procedure SetChannels(Channels: TtsCap32AudioParameterChannels);

  public
    //Direktzugriff, erfordert beim Lesen vorherigen Aufruf von LoadAudioFormat und
    //zum Schreiben nachfolgendes SetAudioFormat
    property pAudioFormat: PWAVEFORMATEX Read FpAudioFormat;
    //Genutztes Audioformat vom Treiber in FAudioFormat laden
    //Geschieht bei Dad.Connected := TRUE und erfolglosen Audioformatänderungen
    procedure LoadAudioFormat;
    //In FAudioFormat enthaltenes Format dem Treiber kundtun
    //returns TRUE if function succeeded
    function SetAudioFormat: Boolean;

  published
    property AudioHardware: Boolean Read GetAudioHardware Write DummyBool;
    property AudioCapEnabled: Boolean Read FAudioCapEnabled Write SetAudioCapEnabled default TRUE;
    property SplFrequ: TtsCap32AudioParameterSplFrequ Read FSplFrequ Write SetSplFrequ;
    property SplWidth: TtsCap32AudioParameterSplWidth Read FSplWidth Write SetSplWidth;
    property Channels: TtsCap32AudioParameterChannels Read FChannels Write SetChannels;
  end;


  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32
  //  Die Komponente als solche
  ////////////////////////////////////////////////////////////////////////////////
  }
  TtsCap32 = class(TCustomPanel)
  private
    //Dummies für unidir. Properties, die trotzdem im Objektinsp. erscheinen sollen
    DummyString: string;
    DummyBoolean: Boolean;
    function DummyBoolGetFalse: Boolean;

  private
    //Paint zeigt Logo, Versionsnummer und Status (bei Connected = FALSE)
    StatusText: string;
    procedure Paint; override;

  private
    FLogo: Boolean;
    procedure SetLogo(status: Boolean);

  published
    property Logo: Boolean Read FLogo Write SetLogo;

  private
    //interner Messagecode, wird von Windows dynamisch vergeben (RegisterWindowMessage)
    ConnectRequCode: DWORD;
    InternalMessagesRegistered: Boolean;

    //die einzige Art, Messages mit dynamischem Code zu empfangen:
    procedure WndProc(var Message: TMessage); override;

  private
    //Funktion testet, ob MessageHook nötig ist
    function IsMessageHookNeeded: Boolean;
    //Über PreventMessageHook = TRUE kann die Benutzung der Application.OnMessage-Methode
    //explizit verhindert werden(auch wenn sie eigentlich nötig wäre)
    //Dies ist ein globales Flag, welches für alle Instanzen gilt
    //In diesem Fall erreichen z.B. Mausnachrichten, die an das Capturewindow
    //gesendet wurden, die Komponente nicht.
    procedure SetPreventMessageHook(status: Boolean);
    function GetPreventMessageHook: Boolean;
  published
    property PreventMessageHook: Boolean Read GetPreventMessageHook Write SetPreventMessageHook;

  published
    property TabStop;
    property Taborder;
    property Visible;
    property Enabled;

  private
    {die ...Property-Methoden sind intern auskommentiert, verbleiben
    nur zum Experimentieren}
    procedure DefineProperties(Filer: TFiler); override;
    procedure LoadProperty(Reader: TReader);
    procedure SaveProperty(Writer: TWriter);

  private
    {untergeordnete Klassen}
    FParameter: TtsCap32Parameter;
    FDriverCaps: TtsCap32DriverCaps;
    FAudioParameter: TtsCap32AudioParameter;
    FCapWndDimensions: TtsCap32CapWndDimensions;
    {alle Feldinhalte ausführen - d.h. alle gepeicherten Einstellungen
    realisieren, z.B. bei Connected := TRUE; ruft nacheinander die Methoden
    ExecuteAll der untergeordneten Klassen FParameter und FCallbacks auf}
    procedure ExecuteAll;

  private
    //Fehlerstring
    Ferror: string;
    //Fehler, txt in FError schreiben, falls ThrowExc=TRUE, Exception (incl. Messagebox)
    procedure tsError(txt: string; ThrowExc: Boolean);

  private
    //RefuseDisconnect = TRUE: andere TtsCap32-Instanzen können Komponente nicht
    //automatisch (durch das Senden der tsMsg_ConnectRequest-Message) disconnecten,
    //falls sie den Treiber benötigen
    FRefuseDisconnect: Boolean;
    FConnected: Boolean;
    //Zwischenstatus
    BufConnected: Boolean;
    procedure SetConnected(status:Boolean);

  private
    FOnConnected: TtsCap32NotifyConnection;

  published
    property OnConnected: TtsCap32NotifyConnection Read FOnConnected Write FOnConnected;

  // private
  // stuefe 2003: revise this
  public
  
    //Liste der Treiber:
    //Name
    FDriverNameList: TStringList;
    //Version
    FDriverVersionList: TStringList;
    //Treibernummer, die für das Capturewindow genutzt wird
    FDriverNo: LongInt;
    //AutomaticSearch = TRUE: Treibernummer wird bei Connected:=TRUE automatisch
    //eingestellt
    FAutomaticSearchForDriver: Boolean;

    function GetDriverName(Index: Integer): string;
    function GetDriverVersion(Index: Integer): string;
    //liest alle im System befiundl. Treiber ein
    procedure FillDriverList;
    function AutomaticSearchForDriver: Integer;

  public
    property DriverName[Index: Integer]: string Read GetDriverName;
    property DriverVersion[Index: Integer]: string Read GetDriverVersion;
    property DriverNameList: TStringList Read FDriverNameList;
    property DriverVersionList: TStringList Read FDriverVersionList;

  private
    //Handle des CaptureWindows, wird schreibgeschützt veröffentlicht
    FhCapWnd: THandle;
  public
    //Handle des CaptureWindows
    property hCapWnd: THandle Read FhCapWnd;
    function SendMessage(Code: Word; wp: WParam; lp: LParam): LRESULT;

  private
    //Kopie des Komponentenhandles - wird von MessageReDirecter benötigt
    BufHandle: THandle;
    procedure CreateWnd; override;

  private
    //OnResize
    FOnResize: TNotifyEvent;
    procedure Resize; override;

  published
    property OnResize: TNotifyEvent Read FOnResize Write FOnResize;

  private
    FScale: Boolean;
    procedure SetScale(status: Boolean);
  public
    property Scale: Boolean Read Fscale Write SetScale;

  private
      //CaptureWindow verstecken bzw. zeigen
    FCapWndHidden: boolean;
    procedure HideCapWnd(status: Boolean);

  published
    //über diese prop kann das Capturewindow verborgen werden. Macht Sinn, falls
    //zwitkritische Aufnahmen im ctManualIntoMem Mode mit Preview erfolgen
    property Hide: Boolean Read FCapWndHidden Write HideCapWnd default FALSE;


  protected
    //Captureparameter holen und setzen (holen erfolgt automatisch beim connecting,
    //setzen bei Änderung der korrespondierenden Eigenschaften
    //Struktur kann direkt manipuliert und über SetCaptureParameter dem Treiber
    //übergeben werden (auf eigenes Risiko)
    FCaptureParameter: CAPTUREPARMS;

  public
    //Direktzugriff, erfordert beim Lesen vorherigen Aufruf von GetCaptureParameter und
    //zum Schreiben nachfolgendes SetCaptureParameter
    property CaptureParameter: CAPTUREPARMS Read FCaptureParameter Write FCaptureParameter;
    //GetCaptureParameter lädt interne CAPTUREPARMS-Struktur mit den gültigen Werten des
    //angeschlossenen Treibers
    procedure GetCaptureParameter;
    //SetCaptureParameter versucht, dem Treiber die Werte der internen CAPTUREPARMS-
    //Struktur einzureden, falls es klappt, gibt die Methode TRUE zurück, sonst FALSE
    function SetCaptureParameter: Boolean;

  private
    FStartTwice: Boolean;                      
    FStartTwiceEnabled: Boolean;
  published
    property StartTwiceEnabled: Boolean read FStartTwiceEnabled Write FStartTwiceEnabled default FALSE;

  protected
    //Videoformat holen und setzen (holen erfolgt automatisch beim connecting)
    //Struktur kann direkt manipuliert und über SetVideoFormat dem Treiber
    //übergeben werden (auf eigenes Risiko)
    FpVideoFormat: PBitmapInfo;
    FpVideoFormatSize: integer;
    FpVideoFormatLoaded: Boolean;

  public
    //Direktzugriff, erfordert beim Lesen vorherigen Aufruf von GetVideoFormat und
    //zum Schreiben nachfolgendes SetVideoFormat
    property pVideoFormat: PBitmapInfo Read FPVideoFormat;
    procedure GetVideoFormat;
    procedure SetVideoFormat;

  protected
    //Zugriff auf CAPSTATUS: Muß vom User mit GetCaptureStatus angefordert werden,
    //auf die aktualisierte Struktur kann danach über die ro-Property
    //CaptureStatus zugegriffen werden
    FCaptureStatus: CAPSTATUS;
  public
    procedure GetCaptureStatus;
    property CaptureStatus: CAPSTATUS Read FCaptureStatus;

  private
    //Userhandler
    FOnError: TtsCap32NotifyError;
    FOnFrame: TtsCap32NotifyFrame;
    FOnVideoStream: TtsCap32NotifyVideoStream;
    FOnYield: TtsCap32NotifyYield;
    FOnWaveStream: TtsCap32NotifyWaveStream;
    FOnStatus: TtsCap32NotifyStatus;
    FOnCapControl: TtsCap32NotifyCapControl;
    FOnDib: TtsCap32NotifyDib;
    FOnBitmap: TtsCap32NotifyBitmap;

  private
    //preview wird im stream mode zwischengesp.
    BufPreview, BufOverlay: Boolean;
    //CapOrder bildet ein kleines, einfaches Befehlsinterface, um Standardbefehle
    //zu geben
    FCapOrder: TtsCap32CapOrder;
    procedure SetCapOrder(CapOrder: TtsCap32CapOrder);
  published
    property CapOrder: TtsCap32CapOrder Read FCapOrder Write SetCapOrder;

  private
    //GrabbingNow: Grabbing im manualmode läuft
    FGrabbingNow: Boolean;
  public
    //GrabbingNow
    property GrabbingNow: Boolean read FGrabbingNow write dummyboolean;

  private
    function GetCapturingNow: Boolean;
    function GetCapFileExists: Boolean;
  public
    //CapturingNow = CAPSTATUS.fCapturingNow
    property CapturingNow: Boolean read GetCapturingNow write dummyboolean;
    //CapFileExists = CAPSTATUS.fCapFileExists
    property CapFileExists: Boolean read GetCapFileExists write dummyboolean;

  //SaveRequired zeucht an, ob Bufferfile ungesicherte Daten enthält 
  private
    FSaveRequired: Boolean;
  public
    property SaveRequired: Boolean Read FSaveRequired Write DummyBoolean;

  private
    {ctManual Grabbing}
    hThread: THandle;
    hProcess: THandle;
    BufThreadPriority: Integer;
    BufProcessPriority: Integer;


   private
  //Falls FSuppressPreviewGrab=TRUE, werden nur die durch CapORder:=grab angeforderten Bilder
  //an OnDib/OnBitmap geliefert.
    FSuppressPreviewGrab: Boolean;
    FTheNextIsMine: Boolean;

  public
    property SuppressPreviewGrab: Boolean Read FSuppressPreviewGrab Write FSuppressPreviewGrab default TRUE;

  {Einzelbild}
    procedure PrepareManualGrab; virtual;
    procedure ManualGrab; virtual;
    procedure FinishManualGrab; virtual;


  private
  {streaming} 
    procedure StartStreamGrab;
    procedure StopStreamGrab;
    procedure SaveStreamGrab;
  protected
    //Callbacks
    //alle Callbacks installieren/deinstallieren
    procedure InstallCallbacks(status: Boolean);
    //einzelne Callbacks installieren/deinstallieren
    procedure InstallErrorCallback(status: Boolean);
    procedure InstallVideoStreamCallback(status: Boolean);
    procedure InstallFrameCallback(status: Boolean);
    procedure InstallYieldCallback(status: Boolean);
    procedure InstallCapControlCallback(status: Boolean);
    procedure InstallWaveStreamCallback(status: Boolean);
    procedure InstallStatusCallback(status: Boolean);
    {von den jeweiligen Callback-Routinen aufgerufene interne Funktionen;
    lösen ihrerseits On...-Events aus, in abgeleiteten Komponenten können
    hier Erignisse eingehäbgt werden}
    procedure OnFrameInternal(pVidHdr: PVIDEOHDR); virtual;
    procedure OnVideoStreamInternal(pVidHdr: PVIDEOHDR); virtual;
    procedure OnErrorInternal; virtual;
    procedure OnYieldInternal; virtual;
    procedure OnWaveStreamInternal(lpWHdr: PWAVEHDR); virtual;
    procedure OnStatusInternal(nID: Integer; lpsz: PChar); virtual;
    procedure OnCapControlInternal(nState: Integer); virtual;
  private
    FSaveAsBmp: TtsFileName;
    procedure SetSaveAsBmp(FileName: TtsFileName);
    procedure SetCopyToClipBoard(status: Boolean);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Loaded; override;
  published
    {Eigenschaften}
    //Sammelproperties:
    //Parameter
    property Parameter: TtsCap32Parameter Read FParameter Write FParameter ;//stored FALSE;
    //Treibereigenschaften
    property DriverCaps: TtsCap32DriverCaps Read FDriverCaps Write FDriverCaps;
    //Audoioparameter
    property AudioParameter: TtsCap32AudioParameter Read FAudioParameter Write FAudioParameter;
    //Dimensionen
    property CapWndDimensions: TtsCap32CapWndDimensions Read FCapWndDimensions Write FCapWndDimensions;

    property Driver: LongInt Read FDriverNo Write FDriverNo;
    property Connected: Boolean Read FConnected Write SetConnected default FALSE;

    //about-informationen
  private
    function GetAuthor: string;
    function GetVersion: string;
  published
    property AboutAuthor: string Read GetAuthor Write DummyString;
    property AboutVersion: string Read GetVersion Write DummyString;

  //PopupMenu
  private
    procedure SetPopupMenu(PopupMenu: TPopupMenu);
    function GetPopupMenu: TPopupMenu;
    //fordert das Popupmenu auf, sich zu synchronisieren (falls es ein TtsCap32PopupMneu ist)
    procedure SyncPopupMenu;

  published
    property PopupMenu Read GetPopupMenu Write SetPopupMenu;

  private
    FOnSyncExternalCtrls: TNotifyEvent;
    procedure SyncExternalCtrls;
  published
    property OnSyncExternalCtrls: TNotifyEvent Read FOnSyncExternalCtrls Write FOnSyncExternalCtrls;

  public
    property RefuseDisconnect: Boolean Read FRefuseDisconnect Write FRefuseDisconnect default FALSE;
  published
    property Error: string Read FError Write FError;
    property Align;
    property CopyToClipBoard: Boolean Read DummyBoolGetFalse Write SetCopyToClipBoard;
    property SaveAsBMP: TtsFileName Read FSaveAsBmp Write SetSaveAsBmp;
    //Events
    //interne Errors und Error-Callback
    property OnError: TtsCap32NotifyError Read FOnError Write FOnError;
    //alle anderen Callbacks
    property OnFrame: TtsCap32NotifyFrame Read FOnFrame Write FOnFrame;
    property OnVideoStream: TtsCap32NotifyVideoStream Read FOnVideoStream Write FOnVideoStream;
    property OnYield: TtsCap32NotifyYield Read FOnYield Write FOnYield;
    property OnWaveStream: TtsCap32NotifyWaveStream Read FOnWaveStream Write FOnWaveStream;
    property OnStatus: TtsCap32NotifyStatus Read FOnStatus Write FOnStatus;
    property OnCapControl: TtsCap32NotifyCapControl Read FOnCapControl Write FOnCapControl;
    //Dib und Bitmap aus Frame
    property OnDib: TtsCap32NotifyDib Read FOnDib Write FOnDib;
    property OnBitmap: TtsCap32NotifyBitmap Read FOnBitmap Write FOnBitmap;
    //TastaturEvents, von TWinControl geerbt
    property OnKeyDown;
    property OnKeyUp;
    property OnKeyPress;
    //MouseEvents von TControl geerbt
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
  end;


  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32MessageRedirecter
  //  hat die Aufgabe, sich auf Wunsch einer TtsCap32-instanz
  //  die Handlepaare zu merken, die in application.OnMessage vertauscht werden
  //  sollen.
  //  existiert als 1 globales Objekt.
  //  Einziger Grund, den Kram nicht als globale Procedur zu programmieren,
  //  war, daß Prozedur(zeiger) nicht an Methodenzeigertypen übergeben werden
  //  können
  ////////////////////////////////////////////////////////////////////////////////
  }

  TtsCap32MessageRedirecter = class(TObject)
  private
    //each Item of HandlePairList contains for an instance of TtsCap32:
    //the components handle in the upper 16 bit,
    //its capwndhandle in the lower 16bit
    HandlePairList: TList;
    //messageHandler, von Application.OnMessage aufzurufen
    procedure ApplicationMessageHook(var Msg: TMsg; var Handled: Boolean);
  public
    constructor Create;
    destructor Destroy;
    //RegisterHandlePair registriert ein handle-Paar,
    //und installiert, falls es das erste in der Liste ist, den ApplicationMessageHook
    procedure RegisterHandlePair(instance: TtsCap32);
    //UnRegisterHandlePair löscht ein handle-Paar,
    //und deinstalliert, falls die Liste dann leer ist, den ApplicationMessageHook
    procedure UnRegisterHandlePair(instance: TtsCap32);
    //Deinstalliert Hook(falls installiert) und löscht Liste
    procedure RemoveHook;
  end;



  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32PopupMenu
  //  Partnerkomponente für TtsCap32
  //  abgelitten von TPopupMenu, bietet einige Standardbefehle
  ////////////////////////////////////////////////////////////////////////////////
  }

  TtsCap32PopupMenu = class(TPopupMenu)
  private
    //Angeschlossenes TtsCap32-objekt
    FAttachedTsCap32: TtsCap32;
    procedure AttacheTsCap32(TsCap32: TtsCap32);

  private
    //Position des ersten intern verwalteten Items in Items
    FirstInternalItemPosition: Integer;
    FInternalItemsCreated: Boolean;
  public
    //Checkmarks und Enable-Flags gemäß dem Status des angeschl. TtsCap32-Objektes setzen
    procedure Synchronize;

  private
    FIncludeStart: Boolean;
    FIncludeStop: Boolean;
    FIncludeSave: Boolean;
    FIncludeGrab: Boolean;
    FIncludeConnect: Boolean;
    FIncludePreview: Boolean;
    FIncludeOverlay: Boolean;
    FIncludeDialogs: Boolean;
    FIncludeCopy: Boolean;
    FIncludeSaveAsBmp: Boolean;
    FIncludeBufferFile: Boolean;
    FIncludeCaptureDriver: Boolean;
    FStartCaption: string;
    FStopCaption: string;
    FSaveCaption: string;
    FGrabCaption: string;
    FConnectCaption: string;
    FPreviewCaption: string;
    FOverlayCaption: string;
    FDialogsCaption: string;
    FDialogFormatCaption: string;
    FDialogDisplayCaption: string;
    FDialogCompressionCaption: string;
    FDialogSourceCaption: string;
    FCopyCaption: string;
    FSaveAsBmpCaption: string;
    FBufferFileCaption: string;
    FCaptureDriverCaption: string;
    procedure OnStartClick(Sender: TObject);
    procedure OnStopClick(Sender: TObject);
    procedure OnSaveClick(Sender: TObject);
    procedure OnGrabClick(Sender: TObject);
    procedure OnConnectClick(Sender: TObject);
    procedure OnPreviewClick(Sender: TObject);
    procedure OnOverlayClick(Sender: TObject);
    procedure OnDialogsClick(Sender: TObject);
    procedure OnCopyClick(Sender: TObject);
    procedure OnSaveAsBmpClick(Sender: TObject);
    procedure OnBufferFileClick(Sender: TObject);
    procedure OnCaptureDriverClick(Sender: TObject);

  private
    procedure Loaded; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public-Deklarationen }

  published
    property AttachedTsCap32: TtsCap32 Read FAttachedTsCap32 Write AttacheTsCap32 default nil;
    property IncludeStart: Boolean Read FIncludeStart Write FIncludeStart default TRUE;
    property IncludeStop: Boolean Read FIncludeStop Write FIncludeStop default TRUE;
    property IncludeSave: Boolean Read FIncludeSave Write FIncludeSave default TRUE;
    property IncludeGrab: Boolean Read FIncludeGrab Write FIncludeGrab default TRUE;
    property IncludeConnect: Boolean Read FIncludeConnect Write FIncludeConnect default TRUE;
    property IncludePreview: Boolean Read FIncludePreview Write FIncludePreview default TRUE;
    property IncludeOverlay: Boolean Read FIncludeOverlay Write FIncludeOverlay default TRUE;
    property IncludeDialogs: Boolean Read FIncludeDialogs Write FIncludeDialogs default TRUE;
    property IncludeCopy: Boolean Read FIncludeCopy Write FIncludeCopy default TRUE;
    property IncludeSaveAsBmp: Boolean Read FIncludeSaveAsBmp Write FIncludeSaveAsBmp default TRUE;
    property IncludeBufferFile: Boolean Read FIncludeBufferFile Write FIncludeBufferFile default TRUE;
    property IncludeCaptureDriver: Boolean Read FIncludeCaptureDriver Write FIncludeCaptureDriver default TRUE;

    property StartCaption: string Read FStartCaption Write FStartCaption;
    property StopCaption: string Read FStopCaption Write FStopCaption;
    property SaveCaption: string Read FSaveCaption Write FSaveCaption;
    property GrabCaption: string Read FGrabCaption Write FGrabCaption;
    property ConnectCaption: string Read FConnectCaption Write FConnectCaption;
    property PreviewCaption: string Read FPreviewCaption Write FPreviewCaption;
    property OverlayCaption: string Read FOverlayCaption Write FOverlayCaption;
    property DialogsCaption: string Read FDialogsCaption Write FDialogsCaption;
    property DialogFormatCaption: string Read FDialogFormatCaption Write FDialogFormatCaption;
    property DialogDisplayCaption: string Read FDialogDisplayCaption Write FDialogDisplayCaption;
    property DialogCompressionCaption: string Read FDialogCompressionCaption Write FDialogCompressionCaption;
    property DialogSourceCaption: string Read FDialogSourceCaption Write FDialogSourceCaption;
    property CopyCaption: string Read FCopyCaption Write FCopyCaption;
    property SaveAsBmpCaption: string Read FSaveAsBmpCaption Write FSaveAsBmpCaption;
    property BufferFileCaption: string Read FBufferFileCaption Write FBufferFileCaption;
    property CaptureDriverCaption: string Read FCaptureDriverCaption Write FCaptureDriverCaption;

    { Published-Deklarationen }
  end;




  {
  //////////////////////////////////////////////////////////////////////////////
  //  Klassendeklaration TtsCap32Dialogs
  //  Partnerkomponente für TtsCap32
  //  Formulare im Schlafrock
  ////////////////////////////////////////////////////////////////////////////////
  }

  TtsCap32Dialogs = class(TComponent)
  private
    function DummyBooleanGetFalse: Boolean;

  private
    //Angeschlossenes TtsCap32-objekt
    FAttachedTsCap32: TtsCap32;
    procedure AttacheTsCap32(TsCap32: TtsCap32);
    procedure TsCap32Killed(var Msg: TMessage); message TSWM_TSCAP32_KILLED;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  protected
    procedure SetBufferFileDlg(status: Boolean);
    procedure SetAboutDlg(status: Boolean);
    procedure SetDriverDlg(status: Boolean);
    procedure SetAudioParameterDlg(status: Boolean);
    procedure SetCaptureSettingsDlg(status: Boolean);
    procedure SetPreviewRateDlg(status: Boolean);
    procedure SetAdvCaptureSettingsDlg(status: Boolean);

  published
    property AttachedTsCap32: TtsCap32 Read FAttachedTsCap32 Write AttacheTsCap32 default nil;
    property BufferFileDlg: Boolean Read DummyBooleanGetFalse Write SetBufferFileDlg;
    property AboutDlg: Boolean Read DummyBooleanGetFalse Write SetAboutDlg;
    property DriverDlg: Boolean Read DummyBooleanGetFalse Write SetDriverDlg;
    property AudioParameterDlg: Boolean Read DummyBooleanGetFalse Write SetAudioParameterDlg;
    property CaptureSettingsDlg: Boolean Read DummyBooleanGetFalse Write SetCaptureSettingsDlg;
    property PreviewRateDlg: Boolean Read DummyBooleanGetFalse Write SetPreviewRateDlg;
    property AdvCaptureSettingsDlg: Boolean Read DummyBooleanGetFalse Write SetAdvCaptureSettingsDlg;
  end;

  {
  //////////////////////////////////////////////////////////////////////////////
  //  Formulare:
  //  Klassendeklaration TtsCap32BufferFileFrm
  //////////////////////////////////////////////////////////////////////////////
  }

  TtsCap32BufferFileFrm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    FileEd: TEdit;
    DDDBn: TButton;
    OkBn: TButton;
    CancelBn: TButton;
    SaveDialog1: TSaveDialog;
    SizeEd: TEdit;
    procedure SizeEdChange(Sender: TObject);
    procedure DDDBnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  public
    BufferFileSize_Mb: Integer;
    BufferFile: string;
  end;

  {
  //////////////////////////////////////////////////////////////////////////////
  //  Formulare:
  //  Klassendeklaration TtsCap32AboutFrm
  //////////////////////////////////////////////////////////////////////////////
  }

  TtsCap32AboutFrm = class(TForm)
    OkBn: TButton;
    AuthorEd: TLabel;
    VersionEd: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Paint; override;
  public
    AboutAuthor: string;
    AboutVersion: string;
  end;


  {
  //////////////////////////////////////////////////////////////////////////////
  //  Formulare:
  //  Klassendeklaration TtsCap32DriverFrm
  //////////////////////////////////////////////////////////////////////////////
  }

  TtsCap32DriverFrm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    DriverCmbB: TComboBox;
    Label1: TLabel;
    VersionEd: TLabel;
    FDriverVersionList: TStringList;
    procedure DriverCmbBChange(Sender: TObject);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


  {
  //////////////////////////////////////////////////////////////////////////////
  //  Formulare:
  //  Klassendeklaration TtsCap32AudioParameterFrm
  //////////////////////////////////////////////////////////////////////////////
  }

  TtsCap32AudioParameterFrm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    AudioHardwareLb: TLabel;
    AudioCapEnabledCb: TCheckBox;
    swGb: TGroupBox;
    sw16bitRb: TRadioButton;
    sw8bitRb: TRadioButton;
    swDefaultRb: TRadioButton;
    sfGb: TGroupBox;
    sf11025Rb: TRadioButton;
    sf8000Rb: TRadioButton;
    sfDefaultRb: TRadioButton;
    sf22050Rb: TRadioButton;
    sf44100Rb: TRadioButton;
    chGb: TGroupBox;
    chStereoRb: TRadioButton;
    chMonoRb: TRadioButton;
    chDefaultRb: TRadioButton;
    procedure AudioCapEnabledCbClick(Sender: TObject);
    procedure swRbClick(Sender: TObject);
    procedure sfRbClick(Sender: TObject);
    procedure chRbClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Sync;
  public
    //lokale hilfsvariable, wird von Hüllkomponente gesetzt
    AudioHardware: Boolean;
    //lokale hilfsvariablen, werden von Hüllkomponente gesetzt und nach schließen des Forms ausgelesen
    SampleFrequ: TtsCap32AudioParameterSplFrequ;
    SampleWidth: TtsCap32AudioParameterSplWidth;
    Channels: TtsCap32AudioParameterChannels;
  end;



  {
  //////////////////////////////////////////////////////////////////////////////
  //  Formulare:
  //  Klassendeklaration TtsCap32CaptureSettingsFrm
  //////////////////////////////////////////////////////////////////////////////
  }

  TtsCap32CaptureSettingsFrm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    EnableTimeLimitCb: TCheckBox;
    TimeLimitLb: TLabel;
    TimeLimitEd: TEdit;
    GroupBox2: TGroupBox;
    CaptureRateEd: TEdit;
    Label1: TLabel;
    FormatDlgBn: TButton;
    CompressionDlgBn: TButton;
    AudioFormatDlgBn: TButton;
    procedure EnableTimeLimitCbClick(Sender: TObject);
    procedure FormatDlgBnClick(Sender: TObject);
    procedure CompressionDlgBnClick(Sender: TObject);
    procedure AudioFormatDlgBnClick(Sender: TObject);
    procedure CaptureRateEdChange(Sender: TObject);
    procedure TimeLimitEdChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Sync;
  public
    //Dieses Formular erfordert, daß referenz auf ttscap32 vorher
    //übergeben wird - keine sicherheitsabfragen, da eh nur in wrapperkomponente
    //benutzt
    AttachedTsCap32: TtsCap32;
    CaptureRate_fps: Integer;
    TimeLimit: Integer;
  end;


  {
  //////////////////////////////////////////////////////////////////////////////
  //  Formulare:
  //  Klassendeklaration TtsCap32PreviewRateFrm
  //////////////////////////////////////////////////////////////////////////////
  }

  TtsCap32PreviewRateFrm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    PreviewRate_fpsEd: TEdit;
    PreviewRate_mspfEd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure PreviewRate_fpsEdChange(Sender: TObject);
    procedure PreviewRate_mspfEdChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Sync;
  public
    PreviewRate_fps: LongInt;
    PreviewRate_mspf: LongInt;
  end;


 {
  //////////////////////////////////////////////////////////////////////////////
  //  Formulare:
  //  Klassendeklaration TtsCap32AdvCaptureSettingsFrm
  //////////////////////////////////////////////////////////////////////////////
  }

  TtsCap32AdvCaptureSettingsFrm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    IndexSizeCb: TCheckBox;
    IndexSizeEd: TEdit;
    GroupBox2: TGroupBox;
    AudioBufferSizeCb: TCheckBox;
    AudioBufferSizeEd: TEdit;
    GroupBox3: TGroupBox;
    NumAudioRequestedCb: TCheckBox;
    NumAudioRequestedEd: TEdit;
    GroupBox4: TGroupBox;
    ChunkGranularityCb: TCheckBox;
    ChunkGranularityEd: TEdit;
    GroupBox5: TGroupBox;
    NumVideoRequestedCb: TCheckBox;
    NumVideoRequestedEd: TEdit;
    GroupBox6: TGroupBox;
    PercentDropForErrorEd: TEdit;
    procedure CbClick(Sender: TObject);
    procedure EdChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Sync;
  public
    IndexSize: LongInt;
    AudioBufferSize: LongInt;
    NumAudioRequested: Integer;
    ChunkGranularity: Integer;
    NumVideoRequested: Integer;
    PercentDropForError: Integer;
  end;







  //Tags der internen Menuitems, zum einfachen Abfragen
const StartItem_tag = 1;
const StopItem_tag = 2;
const SaveItem_tag = 3;
const GrabItem_tag = 4;
const ConnectItem_tag = 5;
const PreviewItem_tag = 6;
const OverlayItem_tag = 7;
const DialogFormatItem_tag = 8;
const DialogDisplayItem_tag = 9;
const DialogCompressionItem_tag = 10;
const DialogSourceItem_tag = 11;
const DialogsItem_tag = 12;
const CopyItem_tag = 13;
const SaveAsBmpItem_tag = 14;
const BufferFileItem_tag = 15;
const CaptureDriverItem_tag = 16;

  {
  //////////////////////////////////////////////////////////////////////////////
  //  globale Funktionen
  //
  //////////////////////////////////////////////////////////////////////////////
  }

 {Callbacks - funktionieren als Objektmethoden nicht (?), müssen als normale
 globale Proceduren deklariert sein}
  function CallbackOnFrame(hwnd: HWND; pVidHdr: PVIDEOHDR): LRESULT; stdcall;
  function CallbackOnVideoStream(hwnd: HWND; pVidHdr: PVIDEOHDR): LRESULT; stdcall;
  function CallBackOnError(hWnd: HWND; nID: Integer; lpsz: PChar): LRESULT; stdcall;
  function CallbackOnYield(hWnd: HWND): LRESULT; stdcall;
  function CallbackOnWaveStream(hWnd: HWND; lpWHdr: PWAVEHDR): LRESULT; stdcall;
  function CallbackOnStatus(hWnd: HWND; nID: Integer; lpsz: PChar): LRESULT; stdcall;
  function CallbackOnCapControl(hWnd: HWND; nState: Integer): LRESULT; stdcall;

  {fenster zählen}
  function EnumWindowsProc(hWnd: HWND; pBcMsg: LPARAM): LongBool; stdcall;
  function EnumChildProc(hWnd: HWND; pBcMsg: LPARAM): LongBool; stdcall;
  {Broadcast an alle Windows der Klasse 'WndClassName'
  Sender kann 0 sein, falls nicht, wird an dieses Fenster keine Nachricht gesandt}
  procedure BroadcastToWindows(Sender: Hwnd; WndClassName: string; MsgCode: DWORD; wp: WPARAM; lp: LPARAM);

  //kleines Delay - aus delay.pas entnommen, 1 unit weniger zum mitschleppen
  procedure delay_ms(ms: DWORD);

  {Broadcast an periphere Komponenten}
  procedure BroadcastToPeriphericals(Sender: TObject; MsgCode: UINT; wp: WPARAM);






{****************************************************************************}
{                                                                            }
{                   Implementation                                           }
{                                                                            }
{****************************************************************************}
implementation

{$R tsCap32FormResources\tsCap32BufferFileFrm.DFM}
{$R tsCap32FormResources\tsCap32AboutFrm.DFM}
{$R tsCap32FormResources\tsCap32DriverFrm.DFM}
{$R tsCap32FormResources\tsCap32AudioParameterFrm.DFM}
{$R tsCap32FormResources\tsCap32CaptureSettingsFrm.DFM}
{$R tsCap32FormResources\tsCap32PreviewRateFrm.DFM}
{$R tsCap32FormResources\tsCap32AdvCaptureSettingsFrm.DFM}

  var
    tsCap32Instances: TList;
    tsCap32PeriphInstances: TList;
    tsCap32MessageRedirecter: TtsCap32MessageRedirecter;
    FGlobalPreventMessageHook: Boolean;





{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32Parameter                                 }
{                                                                            }
{****************************************************************************}

constructor TtsCap32Parameter.Create(Dad: TtsCap32);
begin
  inherited Create;
  self.Dad := Dad;
  FBufferFile := 'C:\Capture.avi';
  FBufferFileSize_Mb := 100;
  FSaveFile := 'C:\SaveFile.avi';
  FPreviewRate_mspf := 100;
  FCaptureRate_uspF := 66667;
  FPreview := TRUE;
  FYield := FALSE;
  FOverlay := TRUE;
  FTimeLimit := 10;
  FTimeLimitEnabled := FALSE;
  FPercentDropForError := 20;
  FIndexSize := 0;
  FChunkGranularity := 0;
  FAudioBufferSize := 0;
  FNumVideoRequested := 0;
  FNumAudioRequested := 0;
  FAbortRightMouseKey := TRUE;
  FAbortLeftMouseKey := TRUE;

end;

destructor TtsCap32Parameter.Destroy;
begin

  inherited Destroy;
end;

function TtsCap32Parameter.DummyBoolGetFalse: Boolean; begin Result:=FALSE; end;

//Beim Übergang zu Connected := TRUE: alle eingestellten Stati übernehmen
procedure TtsCap32Parameter.ExecuteAll;
var
  VKeyCode: Word;
  ShiftState: TShiftState;
begin
  //Alle Einstellungen, die von CAPTUREPARMS durchgeschliffen sind,
  //zusammen einstellen, da bei Fehltritt UodateFlags folgt,
  //damit wären die lokalen Flageinstellungen, die ja erst realisiert
  //werden sollen, hinüber:
  Dad.GetCaptureParameter;
  with Dad.Captureparameter do begin
    dwRequestMicroSecPerFrame := FCaptureRate_uspf;
    fAbortLeftMouse := LongBool(FAbortLeftMouseKey);
    fAbortRightMouse := LongBool(FAbortRightMouseKey);
    //AbortKey
    ShortCutToKey(AbortKey, VKeyCode, ShiftState);
    if ssShift in ShiftState then VKeyCode := VKeyCode or $4000;
    if ssCtrl in ShiftState then VKeyCode := VKeyCode or $8000;

    fYield := LongBool(Self.FYield);
    wTimeLimit := FTimeLimit;
    fLimitEnabled := LongBool(self.FTimeLimitEnabled);
    fMakeUserHitOkToCapture := LongBool(FUserHitToCapture);
    wPercentDropForError := FPercentDropForError;
    fMCIControl := LongBool(self.FMCIControl);
    fStepMCIDevice := FMCIDeviceStep;
    dwMCIStartTime := FMCIStartTime;
    dwMCIStopTime := FMCIStopTime;
    if FIndexSize = 34952 then
      dwIndexSize := 0
    else
      dwIndexSize := FIndexSize;
    wChunkGranularity := FChunkGranularity;
    dwAudioBufferSize := FAudioBufferSize;
    //NumVideoRequested = 0 -> defaultwert nicht verändern
    if FNumVideoRequested > 0 then
      wNumVideoRequested := FNumVideoRequested;
    //NumAudioRequested = 0 -> defaultwert nicht verändern
    if FNumAudioRequested > 0 then
      wNumAudioRequested := FNumAudioRequested;
  end;
  Dad.SetCaptureParameter;

  SetBufferFile(FBufferFile);
  SetBufferFileSize_Mb(FBufferFileSize_Mb);
  SetPreviewRate_mspf(FPreviewRate_mspf);
  SetCapTechnique(FCapTechnique);

  //Falls Preview und Overlay true sind,
  //wird immer erst versucht, overlay zu benutzen,
  //klappt dies nicht, wird preview genutzt
  if FOverlay and FPreview then begin
    SetOverlay(TRUE);
    if not Overlay then begin
      FPreview := TRUE;
      SetPreview(TRUE);
    end else
      FPreview := FALSE;
  end else begin
    //seltsame Zeilen - Grund: SetOverlay(TRUE) direkt nach SetPRev(FALSE)
    //funktioniert aus irgendeinem Grunde nicht
    if FPreview then SetPreview(TRUE);
    if FOverlay then SetOverlay(TRUE);
  end;

  //nachsehen, was hängen geblieben ist...
  UpdateFlags;
end;

//Alle Flags den tatsächlichem Status des Treibers gemäß updaten
procedure TtsCap32Parameter.UpdateFlags;
begin
  with Dad do
    if FConnected then begin
      //Aus CAPSTATUS auslesbare Stati
      GetCaptureStatus;
      with CaptureStatus do begin
        FPreview := Boolean(fLiveWindow);
        FOverlay := Boolean(fOverlayWindow);
      end;
      //Aus CAPTUREPARMS auslesbare Stati
      GetCaptureParameter;
      FCaptureRate_uspf := CaptureParameter.dwRequestMicroSecPerFrame;
      FAbortLeftMouseKey := Boolean(CaptureParameter.fAbortLeftMouse);
      FAbortRightMouseKey := Boolean(CaptureParameter.fAbortRightMouse);
      FYield := Boolean(CaptureParameter.fYield);
      FTimeLimit := CaptureParameter.wTimeLimit;
      FTimeLimitEnabled := Boolean(CaptureParameter.fLimitEnabled);
      FUserHitToCapture := Boolean(CaptureParameter.fMakeUserHitOkToCapture);
      FPercentDropForError := Captureparameter.wPercentDropForError;
      FMCIControl := Boolean(CaptureParameter.fMCIControl);
      FMCIDeviceStep := Boolean(CaptureParameter.fStepMCIDevice);
      FMCIStartTime := Captureparameter.dwMCIStartTime;
      FMCIStopTime := Captureparameter.dwMCIStopTime;
      if Captureparameter.dwIndexSize = 0 then
        FIndexSize := 34952
      else
        FIndexSize := Captureparameter.dwIndexSize;
      FChunkGranularity := CaptureParameter.wChunkGranularity;
      FAudioBufferSize := CaptureParameter.dwAudioBufferSize;
      FNumVideoRequested := CaptureParameter.wNumVideoRequested;
      FNumAudioRequested := CaptureParameter.wNumAudioRequested;
    end;
end;

procedure TtsCap32Parameter.ShowDlgFormat(status:Boolean);
begin
  with Dad do
  begin
    if status then
      if FConnected then begin
        if not LongBool(SendMessage(WM_CAP_DLG_VIDEOFORMAT, 0, 0)) then
          tsError(ERRMSG_DLG_VIDEOFORMAT, False);
        {CapStatus holen}
        GetCaptureStatus;
        Resize;
      end else
        tsError('Driver dialogs can be called only if component is connected', True);
  end;
end;

procedure TtsCap32Parameter.ShowDlgCompression(status:Boolean);
begin
  with Dad do
  begin
    if status then
      if FConnected then begin
        if not LongBool(SendMessage(WM_CAP_DLG_VIDEOCOMPRESSION, 0, 0)) then
          tsError(ERRMSG_DLG_VIDEOCOMPRESSION, False);
      end else
        tsError('Driver dialogs can be called only if component is connected', True);
  end;
end;

procedure TtsCap32Parameter.ShowDlgDisplay(status:Boolean);
begin
  with Dad do
  begin
    if status then
      if FConnected then begin
        if not LongBool(SendMessage(WM_CAP_DLG_VIDEODISPLAY, 0, 0)) then
          tsError(ERRMSG_DLG_VIDEODISPLAY, False);
      end else
        tsError('Driver dialogs can be called only if component is connected', True);
  end;
end;

procedure TtsCap32Parameter.ShowDlgSource(status:Boolean);
begin
  with Dad do
  begin
    if status then
      if FConnected then begin
        if not LongBool(SendMessage(WM_CAP_DLG_VIDEOSOURCE, 0, 0)) then
          tsError(ERRMSG_DLG_VIDEOSOURCE, False);
      end else
        tsError('Driver dialogs can be called only if component is connected', True);
  end;
end;

procedure TtsCap32Parameter.SetBufferFile(BufferFile: TtsFileName);
var
  FileName: array [0..OFS_MAXPATHNAME] of Char;
  Attempts: Integer;
begin
  with Dad do
  begin
    if FConnected then
    begin
      {Bufferfile dem Treiber bekanntgeben}
      if Length(BufferFile) >= OFS_MAXPATHNAME then
        tsError(ERRMSG_PUFFERFILE_PATHNAME_TOO_LONG, True);
      StrPCopy(@FileName, BufferFile);

      if not LongBool(SendMessage(WM_CAP_FILE_SET_CAPTURE_FILE, WPARAM(0), LPARAM(@FileName))) then
        tsError(ERRMSG_WM_CAP_FILE_SET_CAPTURE_FILE, True);

      //auf das korrekt eingerichtete Capturefile warten
 {      Attempts := 0;
      while (Attempts < 30)and not CapFileExists do begin
        inc(Attempts);
        Application.ProcessMessages;
        delay_ms(100);
      end;
      if Attempts = 20 then
        tsError(ERRMSG_WM_CAP_FILE_SET_CAPTURE_FILE, True);}

    end;
    FBufferFile := BufferFile;
  end;
end;

procedure TtsCap32Parameter.SetBufferFileSize_Mb(BufferFileSize_Mb: Integer);
var
  Attempts: Integer;
begin
  with Dad do
  begin
    if FConnected then
    begin
      if not LongBool(SendMessage(WM_CAP_FILE_ALLOCATE, WPARAM(0), LPARAM(BufferFileSize_Mb*1000000))) then
        tsError(ERRMSG_WM_CAP_FILE_ALLOCATE, True);

      //auf das korrekt eingerichtete Capturefile warten
{      Attempts := 0;
      while (Attempts < 30) and not CapFileExists do begin
        inc(Attempts);
        Application.ProcessMessages;
        delay_ms(100);
      end;
      if Attempts = 20 then
        tsError(ERRMSG_WM_CAP_FILE_ALLOCATE, True);}

    end;
    FBufferFileSize_Mb := BufferFileSize_Mb;
  end;
end;

procedure TtsCap32Parameter.SetSaveFile(Filename: TtsFileName);
begin
  FSaveFile := FileName;
  with Dad do
    if Connected then Caporder := save;
end;

procedure TtsCap32Parameter.SetPreview(status: Boolean);
begin
  with Dad do begin
    if FConnected then begin
      if not LongBool(SendMessage(WM_CAP_SET_PREVIEW, WPARAM(LongBool(status)), 0)) then
        tsError(ERRMSG_WM_CAP_SET_PREVIEW, False);
      UpdateFlags;
      if Dad.CapWndDimensions.ScaleOrder = soFitInPower2 then
        Dad.CapWndDimensions.ScaleOrder := soFitIn;
    end else
      FPreview := status;
    SyncExternalCtrls;
  end;
end;

procedure TtsCap32Parameter.SetOverlay(status: Boolean);
begin
  with Dad do begin
    if FConnected then begin
      if DriverCaps.HasOverlay then begin
        if not LongBool(SendMessage(WM_CAP_SET_OVERLAY, WPARAM(LongBool(status)), 0)) then
          tsError(ERRMSG_WM_CAP_SET_OVERLAY, False);
        UpdateFlags;
        if Dad.CapWndDimensions.ScaleOrder = soFitIn then
          Dad.CapWndDimensions.ScaleOrder := soFitInPower2;
      end else
        //KEIN Overlay
        FOverlay := FALSE;
    end else
      //kein treiber
      FOverlay := status;
    SyncExternalCtrls;
  end;
end;

procedure TtsCap32Parameter.SetPreviewRate_mspf(PreviewRate_mspf: Integer);
var
  Temp: Integer;
begin
  if PreviewRate_mspf > 0 then begin
    Temp := FPreviewRate_mspf;
    FPreviewRate_mspf := PreviewRate_mspf;
    with Dad do
      if FConnected then
        if not LongBool(SendMessage(WM_CAP_SET_PREVIEWRATE, WPARAM(PreviewRate_mspf), 0)) then begin
          tsError(ERRMSG_WM_CAP_SET_PREVIEWRATE, False);
          FPreviewRate_mspf := Temp;
        end;
  end;
end;

//Microseconds per frame
procedure TtsCap32Parameter.SetCaptureRate_uspf(CaptureRate_uspf: LongInt);
begin
  with Dad do
    if FConnected and (CaptureRate_uspf > 0) then begin
      FCaptureParameter.dwRequestMicroSecPerFrame := CaptureRate_uspf;
      if SetCaptureParameter then
        FCaptureRate_uspf := CaptureRate_uspf
      else
        UpdateFlags;
    end else
      FCaptureRate_uspf := CaptureRate_uspf;
end;

//Set/GetFps: Wrapper-methods around the uspf property
procedure TtsCap32Parameter.SetCaptureRate_fps(CaptureRate_fps: LongInt);
begin
  if CaptureRate_fps > 0 then
    CaptureRate_uspf := 1000000 div CaptureRate_fps;
end;

function TtsCap32Parameter.GetCaptureRate_fps: LongInt;
begin
  if CaptureRate_uspf > 0 then
    Result := 1000000 div CaptureRate_uspf
  else
    Result := -1;
end;

//Set/GetFps: Wrapper-methods around the PreviewRate_mspf property
procedure TtsCap32Parameter.SetPreviewRate_fps(PreviewRate_fps: Integer);
begin
  if PreviewRate_fps > 0 then
    PreviewRate_mspf := 1000 div PreviewRate_fps;
end;

function TtsCap32Parameter.GetPreviewRate_fps: Integer;
begin
  if PreviewRate_mspf > 0 then
    Result := 1000 div PreviewRate_mspf
  else
    Result := -1;
end;

procedure TtsCap32Parameter.SetAbortLeftMouseKey(status: Boolean);
begin
  with Dad do
    if FConnected then begin
      FCaptureParameter.fAbortLeftMouse := LongBool(status);
      if SetCaptureParameter then
        FAbortLeftMouseKey := status
      else
        UpdateFlags;
    end else
      FAbortLeftMouseKey := status;
end;

procedure TtsCap32Parameter.SetAbortRightMouseKey(status: Boolean);
begin
  with Dad do
    if FConnected then begin
      FCaptureParameter.fAbortRightMouse := LongBool(status);
      if SetCaptureParameter then
        FAbortRightMouseKey := status
      else
        UpdateFlags;
    end else
      FAbortRightMouseKey := status;
end;

procedure TtsCap32Parameter.SetYield(status: Boolean);
begin
  with Dad do
    if FConnected then begin
      FCaptureParameter.fYield := LongBool(status);
      if SetCaptureParameter then
        FYield := status
      else
        UpdateFlags;
    end else
      FYield := status;
end;

procedure TtsCap32Parameter.SetCapTechnique(CapTechnique: TtsCap32CapTechnique);
begin
  with Dad do
    if not FGrabbingNow and not CapturingNow then begin
      FCapTechnique := CapTechnique;
      SyncExternalCtrls;
      //in den manuellen Modes funktioniert Audiocapture nicht
      if CapTechnique <> ctStreamIntoFile then
        AudioParameter.AudioCapEnabled := FALSE;
    end;
end;

procedure TtsCap32Parameter.SetTimeLimit(TimeLimit: Integer);
begin
  with Dad do
    if FConnected then begin
      FCaptureParameter.wTimeLimit := TimeLimit;
      if SetCaptureParameter then
        FTimeLimit := TimeLimit
      else
        UpdateFlags;
    end else
      FTimeLimit := TimeLimit;
end;

procedure TtsCap32Parameter.SetTimeLimitEnabled(status: Boolean);
begin
  with Dad do
    if FConnected then begin
      FCaptureParameter.fLimitEnabled := LongBool(status);
      if SetCaptureParameter then
        FTimeLimitEnabled := status
      else
        UpdateFlags;
    end else
      FTimeLimitEnabled := status;
end;

procedure TtsCap32Parameter.SetUserHitToCapture(status: Boolean);
begin
with Dad do
     if FConnected then begin
       FCaptureParameter.fMakeUserHitOkToCapture := Longbool(status);
       if SetCaptureParameter then
         FUserHitToCapture := status
       else
         UpdateFlags;
     end else
       FUserHitToCapture := status;
end;

procedure TtsCap32Parameter.SetAbortKey(AbortKey: TShortCut);
var
  VKeyCode: Word;
  ShiftState: TShiftState;
  Msg: TMsg;
begin
with Dad do
  if FConnected then begin
    ShortCutToKey(AbortKey, VKeyCode, ShiftState);
    if ssShift in ShiftState then VKeyCode := VKeyCode or $4000;
    if ssCtrl in ShiftState then VKeyCode := VKeyCode or $8000;
    FCaptureParameter.vKeyAbort := VKeyCode;
    if SetCaptureParameter then
      FAbortKey := AbortKey
    else
      FAbortKey := 0;
  end else
    FAbortKey := AbortKey;
end;

function TtsCap32Parameter.GetImageWidth: Integer;
begin
  with Dad do
    if FConnected then begin
      GetCaptureStatus;
      Result := Integer(CaptureStatus.uiImageWidth);
    end else
      Result := 0;
end;

function TtsCap32Parameter.GetImageHeight: Integer;
begin
  with Dad do
    if FConnected then begin
      GetCaptureStatus;
      Result := Integer(CaptureStatus.uiImageHeight);
    end else
      Result := 0;
end;

procedure TtsCap32Parameter.SetPercentDropForError(PercentDropForError: Integer);
begin
  if PercentDropForError > 0 then
    with Dad do
      if FConnected then begin
        FCaptureparameter.wPercentDropForError := PercentDropForError;
        if SetCaptureParameter then
          FPercentDropForError := PercentDropForError
        else
          UpdateFlags;
      end else
        FPercentDropForError := PercentDropForError;
end;

procedure TtsCap32Parameter.SetMCIControl(status: Boolean);
begin
  if not MCIControl then begin
    MCIDeviceStep := FALSE;
    MCIStartTime := -1;
    MCIStopTime := -1;
  end else begin
    MCIStartTime := 0;
    MCIStopTime := 0;
  end;
  with Dad do
    if FConnected then begin
      FCaptureParameter.fMCIControl := LongBool(status);
      if SetCaptureParameter then
        FMCIControl := status
      else
        UpdateFlags;
    end else
      FMCIControl := status;
end;

procedure TtsCap32Parameter.SetMCIDeviceStep(status: Boolean);
begin
  if not MCIControl then exit;
  with Dad do
    if FConnected then begin
      FCaptureParameter.fStepMCIDevice := LongBool(status);
      if SetCaptureParameter then
        FMCIDeviceStep := status
      else
        UpdateFlags;
    end else
      FMCIDeviceStep := status;
end;

procedure TtsCap32Parameter.SetMCIStartTime(MCIStartTime: LongInt);
begin
  if MCIStartTime > 0 then
    with Dad do
      if FConnected then begin
        FCaptureparameter.dwMCIStartTime := MCIStartTime;
        if SetCaptureParameter then
          FMCIStartTime := MCIStartTime
        else
          UpdateFlags;
      end else
        FMCIStartTime := MCIStartTime;
end;

procedure TtsCap32Parameter.SetMCIStopTime(MCIStopTime: LongInt);
begin
  if MCIStopTime > 0 then
    with Dad do
      if FConnected then begin
        FCaptureparameter.dwMCIStopTime := MCIStopTime;
        if SetCaptureParameter then
          FMCIStopTime := MCIStopTime
        else
          UpdateFlags;
      end else
        FMCIStopTime := MCIStopTime;
end;

procedure TtsCap32Parameter.SetIndexSize(IndexSize: LongInt);
begin
  if ((IndexSize >= 1800) and (IndexSize <= 324000)) or (IndexSize = 0) then
    with Dad do
      if FConnected then begin
        FCaptureparameter.dwIndexSize := IndexSize; //default
        if SetCaptureParameter then
          FIndexSize := IndexSize
        else
          UpdateFlags;
      end else
        FIndexSize := IndexSize;
end;

procedure TtsCap32Parameter.SetChunkGranularity(ChunkGranularity: Integer);
begin
  with Dad do
    if FConnected then begin
      FCaptureparameter.wChunkGranularity := ChunkGranularity;
      if SetCaptureParameter then
        FChunkGranularity := ChunkGranularity
      else
        UpdateFlags;
    end else
      FChunkGranularity := ChunkGranularity;
end;

procedure TtsCap32Parameter.SetAudioBufferSize(AudioBufferSize: Longint);
begin
  with Dad do
    if FConnected then begin
      FCaptureparameter.dwAudioBufferSize := AudioBufferSize;
      if SetCaptureParameter then
        FAudioBufferSize := AudioBufferSize
      else
        UpdateFlags;
    end else
      FAudioBufferSize := AudioBufferSize;
end;

procedure TtsCap32Parameter.SetNumVideoRequested(NumVideoRequested: Integer);
begin
  with Dad do
    if FConnected then begin
      if NumVideoRequested > 0 then begin
        FCaptureparameter.wNumVideoRequested := NumVideoRequested;
        SetCaptureParameter;
      end;
      UpdateFlags;
    end else
      FNumVideoRequested := NumVideoRequested;
end;

procedure TtsCap32Parameter.SetNumAudioRequested(NumAudioRequested: Integer);
begin
  with Dad do
    if FConnected then begin
      if NumAudioRequested > 0 then begin
        FCaptureparameter.wNumAudioRequested := NumAudioRequested;
        SetCaptureParameter;
      end;
      UpdateFlags;
    end else
      FNumAudioRequested := NumAudioRequested;
end;

{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32DriverCaps                                }
{                                                                            }
{****************************************************************************}

constructor TtsCap32DriverCaps.Create(Dad: TtsCap32);
begin
  inherited Create;
  self.Dad := Dad;
  SetAllFalse;
end;

destructor TtsCap32DriverCaps.Destroy;
begin
 {...}
  inherited Destroy;
end;

function TtsCap32DriverCaps.DummyBoolGetFalse: Boolean; begin Result:=FALSE; end;

//Methode UpdateShownCaps holt die CAPDRIVERCAPS des Trebers, der aktuell mit
//Dad verbunden ist, und füllt seine Anzeigeflags entsprechend.
//geschieht bei Dad.Connected := TRUE
procedure TtsCap32DriverCaps.UpdateShownCaps;
begin
  with Dad do begin
    if not Connected then
      //keine Verbindung zu einem Treiber -> keine Treiberdaten können geholt werden
      SetAllFalse
    else
      //Treiberdaten holen
      if not LongBool(SendMessage(WM_CAP_DRIVER_GET_CAPS, WPARAM(SizeOf(CAPDRIVERCAPS)) ,LPARAM(@FCapDriverCaps))) then
        SetAllFalse;
  end;
end;


//Hilfsfunktionen TtsCap32DriverCaps

//setzt alle Flags der CAPDRIVERCAPS-Struktur auf FALSE
procedure TtsCap32DriverCaps.SetAllFalse;
begin
  with FCapDriverCaps do begin
    wDeviceIndex := -1;
    fHasOverlay := LongBool(FALSE);
    fHasDlgVideoSource := LongBool(FALSE);
    fHasDlgVideoFormat := LongBool(FALSE);
    fHasDlgVideoDisplay := LongBool(FALSE);
    fCaptureInitialized := LongBool(FALSE);
    fDriverSuppliesPalettes := LongBool(FALSE);
  end;
end;

//Auslesefunktionen für die korrespondierenden properties
function TtsCap32DriverCaps.GetHasOverlay: Boolean;
begin Result := Boolean(FCapDriverCaps.fHasOverlay); end;
function TtsCap32DriverCaps.GetHasDlgVideoSource: Boolean;
begin Result := Boolean(FCapDriverCaps.fHasDlgVideoSource); end;
function TtsCap32DriverCaps.GetHasDlgVideoFormat: Boolean;
begin Result := Boolean(FCapDriverCaps.fHasDlgVideoFormat); end;
function TtsCap32DriverCaps.GetHasDlgVideoDisplay: Boolean;
begin Result := Boolean(FCapDriverCaps.fHasDlgVideoDisplay); end;
function TtsCap32DriverCaps.GetDriverSuppliesPalettes: Boolean;
begin Result := Boolean(FCapDriverCaps.fDriverSuppliesPalettes); end;













{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32CapWndDimensions                          }
{                                                                            }
{****************************************************************************}


constructor TtsCap32CapWndDimensions.Create(Dad: TtsCap32);
begin
  inherited Create;
  self.Dad := Dad;
  FLastScaleOrder := soFitIn;
  FRecalcOnResize := TRUE;
  FCenter := TRUE;
end;

destructor TtsCap32CapWndDimensions.Destroy;
begin
 {...}
  inherited Destroy;
end;

procedure TtsCap32CapWndDimensions.RealizeDimensions;
begin
  with Dad do
    if Connected then
      MoveWindow(hCapWnd, Fx, Fy, Fw, Fh, TRUE);
end;

procedure TtsCap32CapWndDimensions.ExecuteScaleOrder(ScaleOrder: TtsCap32ScaleOrder);
var
  nX, nY, r: Real;
  i, j: Integer;
begin
  with Dad, Dad.Parameter do
    if Connected then begin
      case ScaleOrder of
      //x,y,w,h abh. vom gegebenen Befehl setzen
        soFitIn: begin
        //in Komponente einpassen
          Fx := 0; Fy := 0;
          Fw := Width;
          Fh := Height;
        end;
        soFitInProportional:  begin
        //In Komponente einpassen, unter Beibehaltung des Seiten-Höhen-Verhältnisses}
          nX := Width / ImageWidth;
          nY := Height / ImageHeight;
          if nX < nY then nY := nX else nX := nY;
          Fx := 0; Fy := 0;
          Fw := Round(ImageWidth * nX);
          Fh := Round(ImageHeight * nY);
        end;
        soFitInPower2:  begin
        //In Komponente einpassen (in 2^n schritten)
        //(Bei DC30 muß Breite/Höhe jeweils 2 Pixel drüberliegen (?)
        //keine Ahnung, ob das für alle overlaytreiber gilt
          r := LogN(2, Width/ImageWidth);
          i := Round(r);
          if r < i then dec(i);
          r := LogN(2, Height/ImageHeight);
          j := Round(r);
          if r < j then dec(j);
          if i > j then i := j;
          if j > i then j := i;
          Fw := Round(ImageWidth * IntPower(2, i));
          Fh := Round(ImageHeight * IntPower(2, j));
          Fx := 0;
          Fy := 0;
        end;
        soDouble:  begin
        //x*2, y*2
          Fx := 0; Fy := 0;
          Fw := ImageWidth * 2;
          Fh := ImageHeight * 2;
        end;
        soFourfould:  begin
        //x*4, y*4
          Fx := 0; Fy := 0;
          Fw := ImageWidth * 4;
          Fh := ImageHeight * 4;
        end;
        soHalf:  begin
        //x/2, y/2
          Fx := 0; Fy := 0;
          Fw := ImageWidth div 2;
          Fh := ImageHeight div 2;
        end;
        soFourth:  begin
         //x/4, y/4
          Fx := 0; Fy := 0;
          Fw := ImageWidth div 4;
          Fh := ImageHeight div 4;
        end;
        soOriginalSize:  begin
        //Originalgröße (wie Videobild)
          Fx := 0; Fy := 0;
          Fw := ImageWidth;
          Fh := ImageHeight;
        end;
        soCenter:  begin
        //Bild zentrieren
          Fx := (Width - Fw) div 2;
          Fy := (Height - Fh) div 2;
        end;
        soLeftTop:  begin
        //Bild links oben
          Fx := 0; Fy := 0;
        end;
      end;
    end;
    if ScaleOrder <> soCenter then begin
      FLastScaleOrder := ScaleOrder;
      if FCenter then
        ExecuteScaleOrder(soCenter);
    end;
    RealizeDimensions;
end;

procedure TtsCap32CapWndDimensions.Setx(x: Integer);
begin
  Fx := x;
  if Dad.Connected then
    RealizeDimensions;
end;

procedure TtsCap32CapWndDimensions.Sety(y: Integer);
begin
  Fy := y;
  if Dad.Connected then begin
    RealizeDimensions;
    if FCenter then
      ExecuteScaleOrder(soCenter);
  end;
end;

procedure TtsCap32CapWndDimensions.Setw(w: Integer);
begin
  if w <= 0 then exit;
  Fw := w;
  if Dad.Connected then begin
    RealizeDimensions;
    if FCenter then
      ExecuteScaleOrder(soCenter);
  end;
end;

procedure TtsCap32CapWndDimensions.Seth(h: Integer);
begin
  if h <= 0 then exit;
  Fh := h;
  if Dad.Connected then begin
    RealizeDimensions;
    if FCenter then
      ExecuteScaleOrder(soCenter);
  end;
end;

//Letzten ScaleOrder-BEfehl ausführen, falls
//die Werte nicht direkt eingestellt wurden -  in diesem Fall ist davon
//auszugehen, daß die erhalten bleiben sollen
procedure TtsCap32CapWndDimensions.ExecuteLastScaleOrder;
begin
  ExecuteScaleOrder(FLastScaleOrder);
end;

procedure TtsCap32CapWndDimensions.SetCenter(status: Boolean);
begin
  FCenter := status;
  if FCenter then
    ExecuteScaleOrder(soCenter);
end;

{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32AudioParameter                            }
{                                                                            }
{****************************************************************************}

constructor TtsCap32AudioParameter.Create(Dad: TtsCap32);
begin
  inherited Create;
  self.Dad := Dad;
  FAudioCapEnabled := TRUE;
  FpAudioFormat := nil;
  FAudioFormatSize := 0;
end;

destructor TtsCap32AudioParameter.Destroy;
begin
 {...}
  inherited Destroy;
  //Formatstruktur freigeben
  if FpAudioFormat <> nil then begin
    FreeMem(FpAudioFormat);
    FpAudioFormat := nil;
    FAudioFormatSize := 0;
  end;
end;

//Genutztes Audioformat des Treibers in FAudioFormat laden
procedure TtsCap32AudioParameter.LoadAudioFormat;
begin
  with Dad do
    if Connected and AudioHardware then begin
      //Alte Audioformat-Struktur freigeben
      if FpAudioFormat <> nil then begin
        FreeMem(FpAudioFormat);
        FpAudioFormat := nil;
        FAudioFormatSize := 0;
      end;
      //Größe der WAVEFORMATEX-Struktur feststellen:
      FAudioFormatSize := SendMessage(WM_CAP_GET_AUDIOFORMAT, WPARAM(0), LPARAM(0));
      if FAudioFormatSize > 0 then begin
        //Speicher reservieren und Struktur einladen
        GetMem(FpAudioFormat, FAudioFormatSize);
        SendMessage(WM_CAP_GET_AUDIOFORMAT, WPARAM(FAudioFormatSize), LPARAM(FpAudioFormat));
      end;
    end;
end;

//In FAudioFormat enthaltenes Format dem Treiber kundtun
function TtsCap32AudioParameter.SetAudioFormat: Boolean;
begin
  Result := TRUE;
  with Dad do
    if Connected and AudioHardware and (FpAudioFormat <> nil) then
      if not LongBool(SendMessage(WM_CAP_SET_AUDIOFORMAT, WPARAM(FAudioFormatSize), LPARAM(FpAudioFormat))) then begin
        tsError(ERRMSG_WM_CAP_SET_AUDIOFORMAT, FALSE);
        Result := FALSE;
      end;
end;

//SetSplFrequ: Samplefrequenz setzen, falls möglich
//Dad.Connected = FALSE: Wert in FSplFrequ für spätere Änderung zwischenspeichern
//Dad.Connected = TRUE: bei SplFrequ = fdefault passiert gar nichts
//                      Audioformat laden -> einfaches PCM-Format?
//                      ja-> Wert in FSplFrequ in WAVEFORMATEX-Struktur schreiben und AudioFormat setzen
//                      nein->  FSplFrequ := fdefault
procedure TtsCap32AudioParameter.SetSplFrequ(SplFrequ: TtsCap32AudioParameterSplFrequ);
begin
  with Dad do
    if Connected and AudioHardware then begin
      if SplFrequ <> fdefault then begin
        //aktuelles Format holen
        LoadAudioFormat;
        if FpAudioFormat <> nil then
          with FpAudioFormat^ do begin
            if wFormatTag = WAVE_FORMAT_PCM then begin
              //Samplefrequenz eintragen
              case SplFrequ of
                f8000Hz: nSamplesPerSec := 8000;
                f11025Hz: nSamplesPerSec := 11025;
                f22050Hz: nSamplesPerSec := 22050;
                f44100Hz: nSamplesPerSec := 44100;
              end;
              //Rest der Struktur neu berechnen, wo nötig
              nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
              //SplFrequ speichern
              FSplFrequ := SplFrequ;
              //Format dem Treiber kundtun
              if not SetAudioFormat then
                FSplFrequ := fdefault;
            end else begin//if wFormatTag = WAVE_FORMAT_PCM
              FSplFrequ := fdefault;
            end;
          end; //with FpAudioFormat^
      end; //if SplFrequ <> fdefault
    end else //Connected = TRUE
      FSplFrequ := SplFrequ;
end;

//SetSplWidth: Samplebreite setzen, falls möglich
//Dad.Connected = FALSE: Wert in FSplWidth für spätere Änderung zwischenspeichern
//Dad.Connected = TRUE: bei SplWidth = fdefault passiert gar nichts
//                      Audioformat laden -> einfaches PCM-Format?
//                      ja-> Wert in FSplWidth in WAVEFORMATEX-Struktur schreiben und AudioFormat setzen
//                      nein->  FSplWidth := fdefault
procedure TtsCap32AudioParameter.SetSplWidth(SplWidth: TtsCap32AudioParameterSplWidth);
begin
  with Dad do
    if Connected and AudioHardware then begin
      if SplWidth <> wdefault then begin
        //aktuelles Format holen
        LoadAudioFormat;
        if FpAudioFormat <> nil then
          with FpAudioFormat^ do begin
            if wFormatTag = WAVE_FORMAT_PCM then begin
              //Samplebreite eintragen
              case SplWidth of
                w8bit: wBitsPerSample := 8;
                w16bit: wBitsPerSample := 16;
              end;
              //Rest der Struktur neu berechnen, wo nötig
              nBlockAlign := wBitsPerSample * nChannels;
              nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
              //Samplebreite speichern
              FSplWidth := SplWidth;
              //Format dem Treiber kundtun
              if not SetAudioFormat then
                FSplWidth := wdefault;
            end else begin//if wFormatTag = WAVE_FORMAT_PCM
              FSplWidth := wdefault;
            end;
          end; //with FpAudioFormat^
      end; //if SplWidth <> fdefault
    end else //Connected = TRUE
      FSplWidth := SplWidth;
end;

//SetChannels: Anzahl der Kanäle setzen, falls möglich
//Dad.Connected = FALSE: Wert in FChannels für spätere Änderung zwischenspeichern
//Dad.Connected = TRUE: bei Channels = fdefault passiert gar nichts
//                      Audioformat laden -> einfaches PCM-Format?
//                      ja-> Wert in FChannels in WAVEFORMATEX-Struktur schreiben und AudioFormat setzen
//                      nein->  FChannels := fdefault
procedure TtsCap32AudioParameter.SetChannels(Channels: TtsCap32AudioParameterChannels);
begin
  with Dad do
    if Connected and AudioHardware then begin
      if Channels <> chdefault then begin
        //aktuelles Format holen
        LoadAudioFormat;
        if FpAudioFormat <> nil then
          with FpAudioFormat^ do begin
            if wFormatTag = WAVE_FORMAT_PCM then begin
              //Kanalanzahl eintragen
              case Channels of
                chMono: nChannels := 1;
                chStereo: nChannels := 2;
              end;
              //Rest der Struktur neu berechnen, wo nötig
              nBlockAlign := wBitsPerSample * nChannels;
              nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
              //Kanalanzahl speichern
              FChannels := Channels;
              //Format dem Treiber kundtun
              if not SetAudioFormat then
                FChannels := chdefault;
            end else begin//if wFormatTag = WAVE_FORMAT_PCM
              FChannels := chdefault;
            end;
          end; //with FpAudioFormat^
      end; //if Channels <> fdefault
    end else //Connected = TRUE
      FChannels := Channels;
end;
                       
procedure TtsCap32AudioParameter.ExecuteAll;
begin
  SetAudioCapEnabled(FAudioCapEnabled);
  SetSplFrequ(FSplFrequ);
  SetSplWidth(FSplWidth);
  SetChannels(FChannels);
end;

function TtsCap32AudioParameter.GetAudioHardware: Boolean;
begin
  with Dad do
    if not Connected then
      Result := FALSE
    else begin
      GetCaptureStatus;
      Result := Boolean(CaptureStatus.fAudioHardware);
    end;
end;

procedure TtsCap32AudioParameter.SetAudioCapEnabled(status: Boolean);
begin
  with Dad do begin
    if Connected then
      with FCaptureparameter do begin
        fCaptureAudio := LongBool(status);
        if SetCaptureParameter then
          FAudioCapEnabled := status
        else begin
          GetCaptureParameter;
          FAudioCapEnabled := Boolean(fCaptureAudio);
        end;
    end else
      FAudioCapEnabled := status;
  end;
end;

function TtsCap32AudioParameter.DummyBoolGetFalse: Boolean; begin Result:=FALSE; end;


{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32                                          }
{                                                                            }
{****************************************************************************}

constructor TtsCap32.Create(AOwner:TComponent);
var
  MsgTxt: array[0..29] of char;
begin
  inherited Create(AOwner);
  //Unterobljecte erschaffen
  FParameter := TtsCap32Parameter.Create(self);
  FDriverCaps := TtsCap32DriverCaps.Create(self);
  FAudioParameter := TtsCap32AudioParameter.Create(self);
  FCapWndDimensions := TtsCap32CapWndDimensions.Create(self);

  FAutomaticSearchForDriver := TRUE;
  FDriverNameList := TStringList.Create;
  FDriverVersionList := TStringList.Create;
  FillDriverList;

  //Messagenummer vom system besorgen, zur systemweiten Kommunikaion von
  //TTSCAP32-Fenstern
  ConnectRequCode := RegisterWindowMessage(StrPCopy(@Msgtxt, NAME_OF_CONNECTREQUEST));
  if ConnectRequCode <> 0 then
    InternalMessagesRegistered := TRUE else begin
    InternalMessagesRegistered := FALSE;
    tsError('Messageregistration failed!', FALSE);
  end;
  FError := 'No Error';
  Width := 370;
  Height := 280;
  color := clBlack;
  with Font do begin
    Color := $0078953E;
    Name := 'Arial';
    Size := 7;
  end;
  Caption := '';
  StatusText := '--DISCONNECTED--';
  BevelInner := bvNone;
  BevelOuter := bvNone;
  FConnected := FALSE;
  FRefuseDisconnect := FALSE;
  BufConnected := FALSE;
  BufHandle := 0;
  FpVideoFormat := nil;
  FpVideoFormatLoaded := FALSE;
  FCapWndHidden := FALSE;
  ControlStyle := ControlStyle + [csAcceptsControls];
  FSuppressPreviewGrab := TRUE;
  FTheNextIsMine := TRUE;
  FGrabbingNow := FALSE;
  FSaveRequired := FALSE;

  FStartTwice := FALSE;
  FStartTwiceEnabled := FALSE;

  Flogo := TRUE;

  tsCap32Instances.Add(self);

end;

destructor TtsCap32.Destroy;
begin
//!!?? warum existieren an dieser Stelle keine fenster mehr????
  if FConnected then SetConnected(FALSE);

  //Kill-Message versenden
  BroadCastToPeriphericals(self, TSWM_TSCAP32_KILLED, 0);

  //Abmeldung bei Partnerkomponenten, falls nötig
  if PopupMenu <> nil then
    if PopupMenu is TtsCap32PopupMenu then
      if TtsCap32PopupMenu(PopupMenu).AttachedTsCap32 = self then
        TtsCap32PopupMenu(PopupMenu).AttachedTsCap32 := nil;

  FDriverNameList.Free;
  FDriverVersionList.Free;
  FParameter.Free;
  FDriverCaps.Free;
  FAudioParameter.Free;
  FCapWndDimensions.Free;

  tsCap32Instances.Remove(self);
  inherited Destroy;
end;

procedure TtsCap32.Loaded;
begin
  inherited Loaded;
end;

//Resize: hides the interior capture window, recalculates it dep. from the
//prop. Scale and ScaleRatio and shows it again
procedure TtsCap32.Resize;
var
  tmp: Boolean;
begin
  tmp := Hide;
  Hide := TRUE;
  inherited Resize;
  //recalc
  if FCapWndDimensions.RecalcOnResize then
    FCapWndDimensions.ExecuteLastScaleOrder;
  Hide := tmp;
  if Assigned(FOnResize) then FOnResize(self);
end;

function TtsCap32.GetAuthor: string;
begin
  Result := Format('(c) 1997 %s', [(AUTHOR_STRING)])
end;

function TtsCap32.GetVersion: string;
begin
  Result := Format('v%s - %s', [(VERSION_STRING), (VERSION_NOTES)])
end;

{logo}
procedure TtsCap32.SetLogo(status: Boolean);
begin
  FLogo := status;
  Invalidate;
end;

//Paint draws the tstech logo and prints informations reg. author/version etc.
procedure TtsCap32.Paint;
  procedure ShowLogo;
  begin
  {$IFDEF LOGO_AS_DIB}
    FIXDIB_StretchToCanvas(Canvas, 0, 0, Width, Height);
  {$ENDIF}
  {$IFDEF LOGO_AS_WMF}
   //farbiges Logo mittig, logo abh. von aktueller Farbauflösung
   FIXWMF_DrawToCanvas(Canvas, 0, 0, Width + 2, Height + 2);
  {$ENDIF}
  end;
var
  r: TRect;
begin
  if not FConnected then begin
    with Canvas do begin
      Brush.Style := bsSolid;
      Brush.Color := clBlack;
      r := GetClientRect;
      FillRect(r);
      Brush.Style := bsClear;
      Font := Self.Font;
      if Flogo then begin
        ShowLogo;
        //Textausgabe getrennt nach Entwurfs- und Laufzeit
        if csDesigning in ComponentState then
          //Entwurfsmodus - zus. Designinfos
          with canvas do begin
            textOut(2, 2, ('tsCap32 - Delphi Video Capture Component'));
            textOut(2, 12, Format('%s 1996 - 2003', [AUTHOR_STRING]));
            textOut(2, 28, ('Design State Information:'));
            textOut(12, 38, Format('Version/Release Date: %s - %s ', [VERSION_STRING, LAST_RELEASE_DATE_STRING]));
            textOut(12, 48, Format('Release Notes: %s', [VERSION_NOTES]));
            textOut(12, 58, Format('Instance: %s', [Name]));
            textOut(12, 68, 'Status: ' + StatusText);
          end
        else
          //Runtime: kurz und knapp
          with canvas do begin
            textOut(2, 2, Format('tsCap32 v%s', [VERSION_STRING]));
            textOut(2, 12, Format('%s', [VERSION_NOTES]));
            textOut(2, 22, Format('(c) %s', [AUTHOR_STRING]));
            textOut(12, 38, 'Status: ' + StatusText);
          end;
      end; //If FLogo
    end; //with canvas
  end; //If not Connected
end;

procedure TtsCap32.CreateWnd;
begin
  inherited CreateWnd;
  //wird in MessageReDirecter verwandt
  BufHandle := Handle;

  //Fenster vorhanden. Neu verbinden
  SetConnected(BufConnected);
end;

//procedure TtsCap32Parameter.DefineProperties(Filer: TFiler);
procedure TtsCap32.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
//  Filer.DefineProperty('Parameter', LoadProperty, SaveProperty, TRUE);
end;



procedure TtsCap32.LoadProperty(Reader: TReader);
//procedure TtsCap32Parameter.LoadProperty(Reader: TReader);
begin
     with Parameter do begin
 { FBufferFile := Reader.ReadString;
  FSaveFile := Reader.ReadString;
  FBufferFileSize_Mb := Reader.ReadInteger;
  FPreviewRate := Reader.ReadInteger;
  FPreview := Reader.ReadBoolean;
  FScale := Reader.ReadBoolean;
  FOverlay := Reader.ReadBoolean;
  Reader.Read(FScaleRatio, sizeof(TtsCap32ScaleRatio));
  Fuspf := Reader.ReadInteger;
  FAudioCapture := Reader.ReadBoolean;
  FAbortLeftMouseKey := Reader.ReadBoolean;
  FAbortRightMouseKey := Reader.ReadBoolean;
  FYield := Reader.ReadBoolean;
  Reader.Read(FCapTechnique, sizeof(TtsCap32CapTechnique));}
  end;
end;

//procedure TtsCap32Parameter.SaveProperty(Writer: TWriter);
procedure TtsCap32.SaveProperty(Writer: TWriter);
begin
with Parameter do begin
 { Writer.WriteString(FBufferFile);
  Writer.WriteString(FSaveFile);
  Writer.WriteInteger(FBufferFileSize_Mb);
  Writer.WriteInteger(FPreviewRate);
  Writer.WriteBoolean(FPreview);
  Writer.WriteBoolean(FScale);
  Writer.WriteBoolean(FOverlay);
  Writer.Write(FScaleRatio, sizeof(TtsCap32ScaleRatio));
  Writer.WriteInteger(Fuspf);
  Writer.WriteBoolean(FAudioCapture);
  Writer.WriteBoolean(FAbortLeftMouseKey);
  Writer.WriteBoolean(FAbortRightMouseKey);
  Writer.WriteBoolean(FYield);
  Writer.Write(FCapTechnique, sizeof(TtsCap32CapTechnique));   [}
end;
end;

{SetConnected
 CaptureFenster öffnen resp. schließen}
procedure TtsCap32.SetConnected(status:Boolean);
var
  c: array[0..9]of Char;
begin
  //Beim Lesen der propertywerte existiert das Fenster noch nicht. Der property-
  //wert wird gespeichert und mit ihm wird nach CreateWnd SetConnected erneut aufgerufen
  if (csReading in ComponentState) then begin
    BufConnected := status;
    exit;
  end;

  if (PROHIBITED_STATES*ComponentState)<>[] then exit;

  if status then begin
    if not FConnected and IsWindow(Handle) then
    begin

      //automatische Suche nach einem Treiber:
      if FAutomaticSearchForDriver then
      try
        FDriverNo := AutomaticSearchForDriver;
      except
        //keiner gefunden: Abbruch
        MessageDlg(ERRMSG_GENERAL_OPEN_FAILED, mtError, [mbOk], 0);
        exit;
      end;

      {Capture-Window oeffnen}
      {Meldung:}
      StatusText := '--CONNECTING TO ' + FDriverNameList[FDriverNo] + '...--';
      Paint;
      {Broadcast an alle anderen TTSCAP32-Fenster, die sollen ihre Capturewindow schließen}
      BroadcastToWindows(Handle, 'TtsCap32', ConnectRequCode, FDriverNo, 0);

      StrPCopy(@c, 'TSCap32');
      FhCapWnd := 0;
      FhCapWnd := capCreateCaptureWindowA(@c, (WS_CHILD or WS_VISIBLE),
                                             0, 0, 200, 100, Handle, 0);
      if not IsWindow(FhCapWnd) then tsError('Open the Capturewindow failed', True);

      try
      {Verbindung zum Treiber herstellen}
        if not LongBool(SendMessage(WM_CAP_DRIVER_CONNECT, FDriverNo, 0)) then
          tsError(ERRMSG_CONNECT_FAILED, True) else FConnected := TRUE;
        {Drivercaps holen}
        FDriverCaps.UpdateShownCaps;
        {CapStatus holen}
        GetCaptureStatus;
        {Captureparameter holen}
        GetCaptureParameter;
        {Videoformat holen}
        GetVideoFormat;
        {AudioFormat holen}
        FAudioParameter.LoadAudioFormat;
        {Callbacks einschalten}
        InstallCallbacks(TRUE);
        InstallFrameCallback(FALSE);
        {eingestellte parameter übernehmen}
        ExecuteAll;
        {Größe d. CaptureFensters Updaten}
        Resize;
        StatusText := '--CONNECTED--';
        {Tastatur- und mouse - Messages zum CaptureWindow an Komponente weiterleiten, bitte}
        if IsMessageHookNeeded and not PreventMessageHook then
          tsCap32MessageRedirecter.RegisterHandlePair(self);
        //Userevent OnConnected
        if Assigned(FOnConnected) then FOnConnected(self, TRUE);
        //Userevent OnSync
        SyncExternalCtrls;
      except
        on E: Exception do begin
          {something was wrong. free all and disconnect}
          FConnected := FALSE;
          StatusText := '--DISCONNECTED--';
          DestroyWindow(FhCapWnd);
       	  FhCapWnd := 0;
   {$IFDEF TSCAP32_GERMAN_VERSION}
       	  tsError('Fehler bei Treiberanmeldung. Auslösende Exception meldet: '+ E.Message, True);
   {$ELSE}
       	  tsError('connect failed - exception message: '+ E.Message, True);
   {$ENDIF}
        end;
      end; //Exceptionblock
    end; //!FConnected&&IsWindow
  end //status
  else
  begin
    if FConnected then
    begin
      {Tastatur- und mouse-Message-umleitung aus}
      tsCap32MessageRedirecter.UnRegisterHandlePair(self);
      //nach außen hin ab jetzt disconnected
      FConnected:=FALSE;

      if IsWindow(hCapWnd) then begin
        {Falls Aufnahme am laufen, ausschalten}
        if CapturingNow then CapOrder := stop;
        {Callbacks ausschalten}
        InstallCallbacks(FALSE);
        {Verbindung zum Treiber abbrechen}
        if not LongBool(SendMessage(WM_CAP_DRIVER_DISCONNECT, FDriverNo, 0))then
          tsError('Disconnect failed', False);
        {Fenster killen}
        if (LongBool(DestroyWindow(FhCapWnd)) = FALSE) then
          tsError('CloseWindow failed', False);
      end;
      FSaveRequired := FALSE;
      FhCapWnd:=0;

      {Videoformat loeschen, falls gefüllt}
      if FpVideoFormat<>nil then
      begin
        FreeMem(FpVideoFormat);
        fpVideoFormat := nil;
      end;

      StatusText := '--DISCONNECTED--';
      //Userevent OnConnected
      if Assigned(FOnConnected) then FOnConnected(self, FALSE);
      //neuzeichnen
      Invalidate;
      {Drivercaps auf FALSE updaten}
      FDriverCaps.UpdateShownCaps;
      {Angeschlossenes Popupmenu synchronisieren}
      SyncExternalCtrls;
    end; //FConnected
  end; //!status
end;

procedure TtsCap32.ExecuteAll;
begin
  //Parameter
  FParameter.ExecuteAll;
  //Audioparameter
  FAudioParameter.ExecuteAll;
  //Scaling
  Scale := TRUE;
  //mitdenken: falls overlay aktiv und Bild eingebettet werden sollte (ScaleOrder soFitIn),
  //vielfaches von 2^n
  if Parameter.Overlay and (CapWndDimensions.ScaleOrder = soFitIn) then
    CapWndDimensions.ScaleOrder := soFitInPower2;
  FCapWndDimensions.ExecuteLastScaleOrder;
end;

{holt Videoformat (PBitmapinfo) vom Treiber}
procedure TtsCap32.GetVideoFormat;
var
  dwSize: Integer;
begin
  if FConnected then
  begin
    if FpVideoFormat <> nil then
    begin
      FreeMem(FpVideoFormat);
      FpVideoFormat := nil;
    end;
    {size d. Videoformates bestimmen}
    dwSize := LongInt(SendMessage(WM_CAP_GET_VIDEOFORMAT, 0, 0));
    GetMem(FpVideoFormat, dwSize);
    if Integer(SendMessage(WM_CAP_GET_VIDEOFORMAT, WPARAM(dwsize), LPARAM(FpVideoFormat))) = 0 then
    begin
      FreeMem(FpVideoFormat); FpVideoFormat := nil;
      tsError(ERRMSG_WM_CAP_GET_VIDEOFORMAT, True);
    end
    else
    begin
      FpVideoFormatLoaded := TRUE;
      FpVideoFormatSize := dwSize;
    end;
  end;
end;

{SetVideoFormat
 setzt Videoformat des Capture-Windows auf in .FpVideoFormat gespeicherte Werte}
procedure TtsCap32.SetVideoFormat;
begin
  if FConnected then
  begin
    if not FpVideoFormatLoaded then GetVideoFormat;
    if FpVideoFormat = nil then
      tsError(ERRMSG_WM_CAP_SET_VIDEOFORMAT, FALSE);
    if not LongBool(SendMessage(WM_CAP_SET_VIDEOFORMAT, WPARAM(FpVideoFormat), LPARAM(FpVideoFormat))) then
      tsError(ERRMSG_WM_CAP_SET_VIDEOFORMAT, FALSE);
  end;
end;

{GetCaptureParameter
 füllt .FCaptureParameter mit aktuellen streaming capture parameters}
procedure TtsCap32.GetCaptureParameter;
var
  Attempts: Integer;
begin
  if FConnected then begin
    Attempts := 0;
    while (Attempts < 20) and not LongBool(SendMessage(WM_CAP_GET_SEQUENCE_SETUP, WPARAM(sizeof(FCaptureParameter)), LPARAM(@FCaptureParameter))) do begin
      inc(Attempts);
      delay_ms(50);
    end;
    if Attempts = 20 then tsError(ERRMSG_WM_CAP_GET_SEQUENCE_SETUP, True);
  end;
end;

{SetCaptureParameter
 gibt Werte in .FCaptureParameter an den Treiber, returns TRUE if it succeeded}
function TtsCap32.SetCaptureParameter: Boolean;
begin
  if FConnected then
  begin
    if not LongBool(SendMessage(WM_CAP_SET_SEQUENCE_SETUP, WPARAM(sizeof(FCaptureParameter)), LPARAM(@FCaptureParameter))) then begin
      tsError(ERRMSG_WM_CAP_SET_SEQUENCE_SETUP, False);
      Result := FALSE;
    end else begin
      Result := TRUE;
      FStartTwice := TRUE;
    end;
  end;
  Result := FALSE;
end;

{GetCaptureStatus
füllt .FCaptureStatus mit aktuellen CAPSTATUS-Werten}
procedure TtsCap32.GetCaptureStatus;
begin
  if not LongBool(SendMessage(WM_CAP_GET_STATUS, WPARAM(sizeof(FCaptureStatus)), LPARAM(@FCaptureStatus))) then
    tsError(ERRMSG_WM_CAP_GET_STATUS, False);
end;

procedure TtsCap32.StartStreamGrab;
var
  attempts: Integer;
  StartMsg: Integer;
begin
  if FConnected and ((FParameter.CapTechnique = ctStreamIntoMem) or (FParameter.CapTechnique = ctStreamIntoFile)) and not CapturingNow then
  begin
    //Zu Anfang Videoformat neuladen,
    //damit, falls OnDib oder OnBitmap assigned ist, diese garantiert den
    //aktuellen Dib-Header bekommen
    GetVideoFormat;

    //Preview zwischenspeichern und, falls kein Overlay aktiv,
    //ausschalten - verhindert Aufnahme
    BufPreview := Parameter.Preview;

    if not Parameter.Overlay then begin
      while Parameter.Preview do Parameter.Preview := FALSE;
      delay_ms(10);
    end;

    //Startmessage wird höchstens 20 mal gesendet, m,it jeweils 10ms Bedenkzeit.
    //Notwendig, weil öfter Messages verschlungen bzw. nicht beachtet werden (?)
    //Unendliche Schleife ist ungeschmeidig, da so im Extremfall das Programm
    //hängenbleibt
    if Parameter.CapTechnique = ctStreamIntoFile then
      StartMsg := WM_CAP_SEQUENCE
    else
      StartMsg := WM_CAP_SEQUENCE_NOFILE;
    Attempts:=0;
    while (Attempts < 1) and not LongBool(SendMessage(StartMsg, WPARAM(0), LPARAM(0))) do begin
      inc(Attempts);
      delay_ms(100);
    end;
    //Bug umgehen: nach WM_SET_SEQUENCE_SETUP muß man (zum. DC20/30) 2x starten)
    if FStartTwiceEnabled and FStartTwice then begin
      SendMessage(StartMsg, WPARAM(0), LPARAM(0));
      FStartTwice := FALSE;
    end;

    if Attempts = 1 then
      tsError(ERRMSG_WM_CAP_SEQUENCE, FALSE)
    else
      if Parameter.CapTechnique = ctStreamIntoFile then
        FSaveRequired := TRUE;
  end;
end;

procedure TtsCap32.StopStreamGrab;
var
  Attempts: Integer;
begin
  if FConnected and ((FParameter.CapTechnique = ctStreamIntoMem) or (FParameter.CapTechnique = ctStreamIntoFile)) and CapturingNow then
  begin
    Attempts:=0;
    while (Attempts < 20) and not LongBool(SendMessage(WM_CAP_STOP, WPARAM(0), LPARAM(0))) do begin
      inc(Attempts);
      delay_ms(10);
    end;
    if Attempts = 20 then
      tsError(ERRMSG_WM_CAP_STOP, FALSE);

    //Preview zurücksetzen, falls kein Overlay verwandt wurde
    Parameter.Preview := BufPreview;

  end;
end;

{sichert gegrabtes File in FParameter.Savefile}
procedure TtsCap32.SaveStreamGrab;
var
  Name: array[0..OFS_MAXPATHNAME] of Char;
  Attempts: Integer;
begin
  if FConnected then
  begin
    if Length(FParameter.SaveFile) >= OFS_MAXPATHNAME then
      tsError(ERRMSG_SAVEFILENAME_TOO_LONG, True);
    StrPCopy(@Name, FParameter.SaveFile);

    {Film 20x zu speichern versuchen}
    Attempts:=0;
    while (Attempts<20) and not LongBool(SendMessage(WM_CAP_FILE_SAVEAS, WPARAM(0), LPARAM(@Name))) do
      begin inc(Attempts); delay_ms(100); end;
    if Attempts = 20 then
      tsError(ERRMSG_WM_CAP_FILE_SAVEAS, True)
    else begin
      FSaveRequired := FALSE;
      SyncExternalCtrls;
    end;

    {warten, das Savefile verfügbar ist}
    Attempts:=0;
    while not FileExists(Parameter.SaveFile) and (Attempts<100) do
    begin
      inc(Attempts);
      delay_ms(100);
    end;

  end;
end;

{PrepareManualGrab
 Vorbereitungen auf synchronisiertes Grabben
 Einige Flags (Preview, Callback) werden zwischengespeichert, um nach dem
Grabben den alten Zustand wieder herzustellen.}
procedure TtsCap32.PrepareManualGrab;
begin
  if Fconnected and ((FParameter.CapTechnique = ctManualIntoMem) or (FParameter.CapTechnique = ctManualIntoFile)) and not FGrabbingNow then
  begin
    BufPreview := Parameter.Preview;
    BufOverlay := Parameter.Overlay;

    //Zu Anfang Videoformat neuladen,
    //damit, falls OnDib oder OnBitmap assigned ist, diese garantiert den
    //aktuellen Dib-Header bekommen
    GetVideoFormat;
    with FParameter do
    begin
      //hier unterscheiden zw. IntoFile und IntoMem:
      //IntoFile nutzt die SINGLE_GRAB-Capturemessages
      if FParameter.CapTechnique = ctManualIntoFile then
        if not LongBool(SendMessage(WM_CAP_SINGLE_FRAME_OPEN, WPARAM(0), LPARAM(0))) then
          tsError(ERRMSG_WM_CAP_SINGLE_FRAME_OPEN, false);
{      //Prozess-Priorität auf RealTime setzen:
      hProcess := GetCurrentProcess;
      BufProcessPriority := GetPriorityClass(hProcess);
      if not LongBool(SetPriorityClass(hProcess, REALTIME_PRIORITY_CLASS)) then
        tsError('SetPriorityClass failed!', False);
      //Thread-Priorität hochsetzen
      hThread := GetCurrentThread;
      BufThreadPriority := GetThreadPriority(hThread);
      if not LongBool(SetThreadPriority(hThread, THREAD_PRIORITY_TIME_CRITICAL)) then
        tsError('SetThreadPriority failed!', False);}
      //Grabbing läuft

      //hier unterscheiden zw. IntoFile und IntoMem:
      //IntoMem nutzt den Framecallback
      if FParameter.CapTechnique = ctManualIntoMem then begin
        InstallFrameCallback(TRUE);
        FTheNextIsMine := FALSE;
      end;

      FGrabbingNow := TRUE;
      SyncExternalCtrls;
    end;
  end;
end;

{ManualIntoMemGrab
 ein einzelnes Bild grabben
 es wird die entspr. Message an den Videotreiber gesandt.
 IntoMem-Mode:
 Nach Beendigung des Grabbens wird eine Callbackroutine aufgerufen, diese ruft
 die virtuelle Methode FOnFrameInternal auf.
 Hier wird eine angeschlossene Usermethode
 OnFrame aufgerufen.
 IntoFile-Mode:
 Ein Bild wird in das Avi-Pufferfile geschrieben
 }
procedure TtsCap32.ManualGrab;
var
  Msg: UINT;
begin
  if FGrabbingNow and ((FParameter.CapTechnique = ctManualIntoMem) or (FParameter.CapTechnique = ctManualIntoFile)) then
  begin
    //Message an Treiber bestimmen...
    if FParameter.CapTechnique = ctManualIntoMem then begin
      Msg := WM_CAP_GRAB_FRAME_NOSTOP;
      FTheNextIsMine := TRUE;
    end else begin
      Msg := WM_CAP_SINGLE_FRAME;
      FSaveRequired := TRUE;
    end;
    //und senden
    if not LongBool(SendMessage(Msg, 0, 0)) then
    begin
      FGrabbingNow := FALSE;
      tsError('Grabframe failed!', False);
    end;
  end;
end;

procedure TtsCap32.FinishManualGrab;
begin
  if FGrabbingNow and ((FParameter.CapTechnique = ctManualIntoFile) or (FParameter.CapTechnique = ctManualIntoFile)) then
  begin
    FGrabbingNow := FALSE;

    //hier unterscheiden zw. IntoFile und IntoMem:
    //IntoFile nutzt die SINGLE_GRAB-Capturemessages, INtoMem den FrameCallback
    if FParameter.CapTechnique = ctManualIntoFile then
      if not LongBool(SendMessage(WM_CAP_SINGLE_FRAME_CLOSE, WPARAM(0), LPARAM(0))) then
        tsError(ERRMSG_WM_CAP_SINGLE_FRAME_CLOSE, false);

    if FParameter.CapTechnique = ctManualIntoMem then
      //Framecallback ausschalten
      InstallFrameCallback(FALSE);

{    //Prozess-Priorität zurücksetzen
    SetPriorityClass(hProcess, BufProcessPriority);
    //Thread-Priorität zurücksetzen
    SetThreadPriority(hThread, BufThreadPriority);}
         //!!

    //durch diesen Schwachsinn wird das 'hängengebliebene' overlay nach dem
    //Entfernen des Framecallback wieder gestarted
    if Parameter.Overlay then begin
      parameter.Overlay := FALSE;
      parameter.Overlay := TRUE;
    end;
     //restartet Preview, falls lokales Preview-Flag noch auf TRUE
    Parameter.Preview := BufPreview;

    SyncExternalCtrls;
   end;
end;

{SetCapOrder
 Befehlsverteiler
 TODO: Methodenzeiger nutzen (geschmeidiger)}
procedure TtsCap32.SetCapOrder(CapOrder: TtsCap32CapOrder);
begin
  if FConnected then
  begin
    //Sicherheitsmechanismus gg. Bedienerfehler:
    //Capture im Vordergrundmodus und Maustasten disabled und keyabort disabled
    //= ungeschmeidig. -> In diesem Fall Yield auf TRUE setzen
    with Parameter do
      if (CapOrder = start) and
         not Yield and
         not AbortLeftMouseKey and
         not AbortRightMouseKey and
         (AbortKey = 0) then
        Yield := TRUE;

    case FParameter.CapTechnique of
    ctStreamIntoFile,
    ctStreamIntoMem:
      case CapOrder of
        start: StartStreamGrab;
        stop: StopStreamGrab;
        save: SaveStreamGrab;
      end;
    ctManualIntoMem,
    ctManualIntoFile:
      case CapOrder of
        start: PrepareManualGrab;
        stop: FinishManualGrab;
        grab: ManualGrab;
        save: SaveStreamGrab;
      end;
    end;
  end;
end;

function TtsCap32.GetCapturingNow: Boolean;
begin
  if FConnected then begin
    GetCaptureStatus;
    Result := Boolean(CaptureStatus.fCapturingNow);
  end else
    Result := FALSE;
end;

function TtsCap32.GetCapFileExists: Boolean;
begin
  if FConnected then begin
    GetCaptureStatus;
    Result := Boolean(CaptureStatus.fCapFileExists);
  end else
    Result := FALSE;
end;

{Inhalt des Videopuffers in die Zwischenablage, als DIB}
procedure TtsCap32.SetCopyToClipBoard(status:Boolean);
var
  pBmi: PBITMAPINFO;
  pBits: PChar;
  Time: DWORD;
begin
  if status and FConnected then begin
    Time := GetTickCount;
    if not LongBool(SendMessage(WM_CAP_EDIT_COPY, WPARAM(0), LPARAM(0))) then
      tsError('Copy failed', False);

     //Aufruf von OnDib/OnBitmap, falls gewünscht
    if Assigned(FOnDib) or Assigned(FOnBitmap) then begin
      pBmi := CopyDib(PBITMAPINFO(ClipBoard.GetAsHandle(CF_DIB)), nil);
      pBits := BitsOfPackedDib(pBmi);
      //Falls Dib verlangt, zum OnDib-Hook:
      if Assigned(FOnDib) then
        FOnDib(self, pBmi, pBits, Time);
      //Falls Bitmap verlangt, dieses erzeugen und zum OnBitmap-Hook:
      if Assigned(FOnBitmap) then
         FOnBitmap(self, CreateTBitmapFromDib(pBmi, pBits), Time);
    end;

    //durch diesen Schwachsinn wird das 'hängengebliebene' overlay nach dem
    //Entfernen des Framecallback wieder gestarted
    if Parameter.Overlay then begin
      parameter.Overlay := FALSE;
      parameter.Overlay := TRUE;
    end;
  end;
end;

{Inhalt des Videopuffers als BMP-File speichern}
procedure TtsCap32.SetSaveAsBmp(FileName: TtsFileName);
var
  pTxt: PChar;
begin
  if FConnected then begin
    GetMem(pTxt, Length(FileName) + 1);
    if pTxt <> nil then begin
      StrPCopy(pTxt, FileName);
      if not LongBool(SendMessage(WM_CAP_FILE_SAVEDIB, WPARAM(0), LPARAM(pTxt))) then
        tsError('SaveAsDib failed', False)
      else
        FSaveAsBmp := FileName;
    end else
      tsError('SaveAsDib failed (Filename too long)', False);
  end else
    tsError('Not Connected', TRUE);
end;

procedure TtsCap32.OnFrameInternal(pVidHdr: PVIDEOHDR);
begin
  //OnFrame-Hook:
  if Assigned(FOnFrame) then FOnFrame(self, pVidHdr);
  if not FSuppressPreviewGrab or (FSuppressPreviewGrab and FTheNextIsMine) then begin
    FTheNextIsMine := FALSE;
    //Falls Dib verlangt, zum OnDib-Hook:
    if Assigned(FOnDib) then FOnDib(self, pVideoFormat, PChar(pVidHdr^.lpData), pVidHdr^.dwTimeCaptured);
    //Falls Bitmap verlangt, dieses erzeugen und zum OnBitmap-Hook:
    if Assigned(FOnBitmap) then FOnBitmap(self, CreateTBitmapFromDib(pVideoFormat, PChar(pVidHdr^.lpData)), pVidHdr^.dwTimeCaptured);
  end;
end;

procedure TtsCap32.OnVideoStreamInternal(pVidHdr: PVIDEOHDR);
begin
  if Assigned(FOnVideoStream) then FOnVideoStream(self, pVidHdr);
  //Falls Dib verlangt, zum OnDib-Hook:
  if Assigned(FOnDib) then FOnDib(self, pVideoFormat, PChar(pVidHdr^.lpData), pVidHdr^.dwTimeCaptured);
  //Falls Bitmap verlangt, dieses erzeugen und zum OnBitmap-Hook:
  if Assigned(FOnBitmap) then FOnBitmap(self, CreateTBitmapFromDib(pVideoFormat, PChar(pVidHdr^.lpData)), pVidHdr^.dwTimeCaptured);
end;

procedure TtsCap32.OnErrorInternal;
begin
  if Assigned(FOnError) then FOnError(self);
end;

procedure TtsCap32.OnYieldInternal;
begin
  if Assigned(FOnYield) then FOnYield(self);
end;

procedure TtsCap32.OnWaveStreamInternal(lpWHdr: PWAVEHDR);
begin
  if Assigned(FOnWaveStream) then FOnWaveStream(self, lpWHdr);
end;

procedure TtsCap32.OnStatusInternal(nID: Integer; lpsz: PChar);
begin
  //Statusänderung: einige Stati abfangen und entspr. Properties setzen
  case nID of
  IDS_CAP_END,
  IDS_CAP_OUTOFMEM: begin
    SyncExternalCtrls;
    //Preview zurücksetzen, falls kein Overlay verwandt wurde
    if not Parameter.Overlay then
      Parameter.Preview := BufPreview;
  end;
  {...}
  end; //case
  //weiterreichen an Userhook
  if Assigned(FOnStatus) then FOnStatus(self, nID, lpsz);
end;

procedure TtsCap32.OnCapControlInternal(nState: Integer);
begin
  if Assigned(FOnCapControl) then FOnCapControl(self, nState);
end;

//Callback-functions installieren
procedure TtsCap32.InstallCallbacks(status: Boolean);
begin
  InstallErrorCallback(status);
  InstallVideoStreamCallback(status);
  InstallFrameCallback(status);
  InstallYieldCallback(status);
  InstallCapControlCallback(status);
  InstallWaveStreamCallback(status);
  InstallStatusCallback(status);
end;

//Einzelne Callback-installationen
procedure TtsCap32.InstallErrorCallback(status: Boolean);
var
  param: LPARAM;
begin
  if FConnected then begin
    //Errorcallback
    if status then param := LPARAM(Addr(CallBackOnError)) else param := LPARAM(0);
    if not LongBool(SendMessage(WM_CAP_SET_CALLBACK_ERROR, 0, param)) then
      tsError(ERRMSG_WM_CAP_SET_CALLBACK_ERROR, FALSE);
  end;
end;

procedure TtsCap32.InstallVideoStreamCallback(status: Boolean);
var
  param: LPARAM;
begin
  if FConnected then begin
    //videostreamcallback
    if status then param := LPARAM(Addr(CallBackOnVideoStream)) else param := LPARAM(0);
    if not LongBool(SendMessage(WM_CAP_SET_CALLBACK_VIDEOSTREAM, 0, param)) then
      tsError(ERRMSG_WM_CAP_SET_CALLBACK_VIDEOSTREAM, FALSE);
  end;
end;

procedure TtsCap32.InstallFrameCallback(status: Boolean);
var
  param: LPARAM;
begin
  if FConnected then begin
    //framecallback
    if status then param := LPARAM(Addr(CallBackOnFrame)) else param := LPARAM(0);
    if not LongBool(SendMessage(WM_CAP_SET_CALLBACK_FRAME, 0, param)) then
      tsError(ERRMSG_WM_CAP_SET_CALLBACK_FRAME, FALSE);
  end;
end;

procedure TtsCap32.InstallYieldCallback(status: Boolean);
var
  param: LPARAM;
begin
  if FConnected then begin
    //YieldCallback
    if status then param := LPARAM(Addr(CallBackOnYield)) else param := LPARAM(0);
    if not LongBool(SendMessage(WM_CAP_SET_CALLBACK_YIELD, 0, param)) then
      tsError(ERRMSG_WM_CAP_SET_CALLBACK_YIELD, FALSE);
  end;
end;

procedure TtsCap32.InstallCapControlCallback(status: Boolean);
var
  param: LPARAM;
begin
  if FConnected then begin
    //CapControlCallback
    if status then param := LPARAM(Addr(CallBackOnCapControl)) else param := LPARAM(0);
    if not LongBool(SendMessage(WM_CAP_SET_CALLBACK_CAPCONTROL, 0, param)) then
      tsError(ERRMSG_WM_CAP_SET_CALLBACK_CAPCONTROL, FALSE);
  end;
end;

procedure TtsCap32.InstallWaveStreamCallback(status: Boolean);
var
  param: LPARAM;
begin
  if FConnected then begin
    //WaveStreamCallback
    if status then param := LPARAM(Addr(CallBackOnWaveStream)) else param := LPARAM(0);
    if not LongBool(SendMessage(WM_CAP_SET_CALLBACK_WAVESTREAM, 0, param)) then
      tsError(ERRMSG_WM_CAP_SET_CALLBACK_WAVESTREAM, FALSE);
  end;
end;

procedure TtsCap32.InstallStatusCallback(status: Boolean);
var
  param: LPARAM;
begin
  if FConnected then begin
    //StatusCallback
    if status then param := LPARAM(Addr(CallBackOnStatus)) else param := LPARAM(0);
    if not LongBool(SendMessage(WM_CAP_SET_CALLBACK_STATUS, 0, param)) then
      tsError(ERRMSG_WM_CAP_SET_CALLBACK_STATUS, FALSE);
  end;
end;


//DummyFuntionen:
function TtsCap32.DummyBoolGetFalse: Boolean; begin Result:=FALSE; end;

//Fehlerbehandlung:
procedure TtsCap32.tsError(txt: string; ThrowExc: Boolean);
begin
  FError := txt;
  OnErrorInternal;
  if ThrowExc then
    raise EtsCap32.Create(txt);
end;

//returns the first available CaptureDriver
function TtsCap32.AutomaticSearchForDriver: Integer;
var
  i: Integer;
begin
  i := 0;
  while (i < 10) and (DriverName[i] = '-') do inc(i);
{$IFDEF SIMULATE_NODRIVER}
  i := 10;                         
{$ENDIF}
  if i = 10 then
    tsError('No Driver Found', TRUE);
  Result := i;
end;

procedure TtsCap32.WndProc(var Message: TMessage);
begin
  if InternalMessagesRegistered then begin
    if Message.Msg = ConnectRequCode then begin
      if FConnected and not FRefuseDisconnect and (Message.wparam = FDriverNo) then
        Connected := FALSE;
    end;
  end;

  //Mausmessages
  if ((Message.Msg >= WM_MOUSEFIRST) and (Message.Msg <= WM_MOUSELAST)) then begin
    //vom Capturewindow?
    if (Message.lParam and $8000) = $8000 then begin
      //Yip. Bit15 loeschen und Koordinaten korrigieren
      Message.lParam := Message.lparam xor $8000;
      inc(Message.lParam, (FCapWndDimensions.x + (DWORD(FCapWndDimensions.y) shl 16)));
      //Pauspeil pändern
    //   Cursor := crSize; //poch pich pändern
    end;

    // Focus setzen, falls angeklickt
    // ( stuefe 2003: on D7, this leads to
    //  "cannot focus disabled/invisible window" ),
    // so we only do this when connected
      case Message.Msg of
        WM_LBUTTONDOWN,
        WM_RBUTTONDOWN:
        if Fconnected then
          SetFocus;
      end;

  end;
  inherited WndProc(Message);
end;

//CaptureFenster verstecken oder zeigen
procedure TtsCap32.HideCapWnd(status: Boolean);
begin
  if Fconnected then
    if status then
      ShowWindow(FhCapWnd, SW_HIDE)
    else
      ShowWindow(FhCapWnd, SW_SHOW);
  FCapWndHidden := status;
end;

{popupmenu}
procedure TtsCap32.SetPopupMenu(PopupMenu: TPopupMenu);
var
  OldPopupMenu: TPopupMenu;
begin
  if self.PopupMenu = PopupMenu then exit;

  OldPopupMenu := self.PopupMenu;
  inherited PopupMenu := Popupmenu;

  //Abmeldung bei Partnerkomponente, falls nötig
  if OldPopupMenu <> nil then
    if OldPopupMenu is TtsCap32PopupMenu then
      if TtsCap32PopupMenu(OldPopupMenu).AttachedTsCap32 = self then
        TtsCap32PopupMenu(OldPopupMenu).AttachedTsCap32 := nil;

  //Anmeldung bei Partnerkomponente, falls nötig
  if PopupMenu <> nil then
    if PopupMenu is TtsCap32PopupMenu then
      if TtsCap32PopupMenu(PopupMenu).AttachedTsCap32 <> self then
        TtsCap32PopupMenu(PopupMenu).AttachedTsCap32 := self; //Sync hier nicht nötig
end;

function TtsCap32.GetPopupMenu: TPopupMenu;
begin
  Result := inherited PopupMenu;
end;

procedure TtsCap32.SyncPopupMenu;
begin
  if PopupMenu <> nil then
    if PopupMenu is TtsCap32PopupMenu then
      TtsCap32PopupMenu(PopupMenu).Synchronize;
end;

{messagehook}
//Funktion testet, ob MessageHook nötig ist
function TtsCap32.IsMessageHookNeeded: Boolean;
begin
  Result :=
    TabStop or //Kann Focus erhalten (Aktivierung durch Klicken auf laufendes CapWnd)
    Assigned(OnMouseMove) or //soll auf Mausereignisse reagieren
    Assigned(OnMouseUp) or
    Assigned(OnMouseDown) or
    (PopupMenu <> nil); //soll über Popupmenu steuerbar sein
end;

procedure TtsCap32.SetPreventMessageHook(status: Boolean);
begin
  FGlobalPreventMessageHook := status;
end;

function TtsCap32.GetPreventMessageHook: Boolean;
begin
  Result := FGlobalPreventMessageHook;
end;

procedure TtsCap32.SetScale(status: Boolean);
begin
  if FConnected then begin
    if not LongBool(SendMessage(WM_CAP_SET_SCALE, WPARAM(LongBool(status)), 0)) then begin
      tsError(ERRMSG_WM_CAP_SET_SCALE, False);
      FScale := FALSE;
    end else
      FScale := status;
  end else
    FScale := status;
end;

{driver}
//liest alle im System befiundl. Treiber ein
procedure TtsCap32.FillDriverList;
var
  szDeviceName: array [0..79] of Char;
  szDeviceVersion: array [0..79] of Char;
  wIndex: integer;
begin
  //Listen löschen
  FDriverNameList.Clear;
  FDriverVersionList.Clear;
  //einlesen (valid indexes range from 0 to 9)
  for wIndex := 0 to 9 do
  begin
    if LongBool(capGetDriverDescriptionA(wIndex,szDeviceName, sizeof(szDeviceName), szDeviceVersion, sizeof(szDeviceVersion))) then begin
      {Namen und Versionen gefundener Treiber in Treiberliste speichern}
      FDriverNameList.Add(string(szDeviceName));
      FDriverVersionList.Add(string(szDeviceVersion));
    end else begin
      {Fehleintrag}
      FDriverNameList.Add('-');
      FDriverVersionList.Add('-');
      {dok drückt sich unklar aus, ob gültige treiber hintereinander liegen oder ob
      'fehlnummern' dazwischen liegen können.}
    end;
  end;
end;

function TtsCap32.GetDriverName(Index: Integer): string;
begin
  Result := FDriverNameList[Index];
end;

function TtsCap32.GetDriverVersion(Index: Integer): string;
begin
  Result := FDriverVersionList[Index];
end;

{onsync}
procedure TtsCap32.SyncExternalCtrls;
begin
  if not (csDestroying in ComponentState) then 
    if Assigned(FOnSyncExternalCtrls) then
      FOnSyncExternalCtrls(self);
  SyncPopupMenu;
end;

function TtsCap32.SendMessage(Code: Word; wp: WParam; lp: LParam): LRESULT;
begin
  Result := Windows.SendMessage(hCapWnd, Code, wp, lp);
end;




{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32MessageRedirecter
{                                                                            }
{****************************************************************************}


{message-redirecting}

constructor TtsCap32MessageRedirecter.Create;
begin
  inherited Create;
  HandlePairList := TList.Create;
end;

destructor TtsCap32MessageRedirecter.Destroy;
begin
  HandlePairList.Free;
  inherited Destroy;
end;

//Dieser Handler wird mit Application.OnMessage verknüpft, wenn Connected = TRUE
//Es werden alle interessierenden Botschaften, die an ein Capturewindow gerichtet
//sind, zum dazugehörigen Komponentenfenster umgeleitet
//auf diese Art können Tastatur- und Mouse-Events behandelt werden
procedure TtsCap32MessageRedirecter.ApplicationMessageHook(var Msg: TMsg; var Handled: Boolean);
var
  i: Integer;
  c: Integer;
  hOrig: THandle;
begin
  hOrig := Msg.hwnd;
  with HandlePairList do begin
    c := Count - 1;
    for i := 0 to c do
      if (LongInt(Items[i]) and $0000FFFF) = hOrig then begin
      //Fenster gefunden - falls Mousemessage, diese umbiegen
      //Falls es sich um eine Mausmessage handelt, wird Bit15 von lparam dazu
      //mißbraucht, das 'Umbiegen' anzuzeigen und die Koordinaten später
      //korrigieren zu lassen
      //daß begrenzt die max. xPos auf 7FFF, was relativ egal ist.
      //Sicherheitshalber wird die Breite der Komponente ebenfalls auf diesen Wert begrenzt
        if ((Msg.Message >= WM_MOUSEFIRST) and (Msg.Message <= WM_MOUSELAST)) then begin
          Msg.hwnd := LongInt(Items[i]) shr 16;
          Msg.lParam := Msg.lParam or $8000;
        end;
        break;
      end;
  end;
  Handled := FALSE;
end;

//RegisterHandlePair registriert ein handle-Paar,
//und installiert, falls es das erste in der Liste ist, den ApplicationMessageHook
//funktioniert nur noch solange, wie handles 16bit breit sind
procedure TtsCap32MessageRedirecter.RegisterHandlePair(instance: TtsCap32);
var
  val: LongInt;
begin
  if instance.Connected = FALSE then exit;
  val := (instance.hCapWnd and $0000FFFF) or ((LongInt(instance.Handle) shl 16) and $FFFF0000);
  with HandlePairList do begin
    Add(Pointer(val));
    if Count = 1 then
      Application.OnMessage := ApplicationMessageHook;
  end;
end;

//UnRegisterHandlePair löscht ein handle-Paar,
//und deinstalliert, falls die Liste dann leer ist, den ApplicationMessageHook
procedure TtsCap32MessageRedirecter.UnRegisterHandlePair(instance: TtsCap32);
var
  val: LongInt;
begin
  if instance.Connected = FALSE then exit;
  //BufHandle ist eine Kopie von handle, (wird in CreateWnd kopiert). es traten fehler auf, weil
  //Einträge gelöscht werden sollten, deren Fenster nicht mehr existierten (DisConnect im Destructor) -
  //!!unerklärlich, weil fenster im Destruktor noch existieren müßte
  val := (instance.hCapWnd and $0000FFFF) or ((LongInt(instance.BufHandle) shl 16) and $FFFF0000);
  with HandlePairList do begin
    Remove(Pointer(val));
    if Count = 0 then
      Application.OnMessage := nil;
  end;
end;

procedure TtsCap32MessageRedirecter.RemoveHook;
begin
  HandlePairList.Clear;
  //if Application.OnMessage = ApplicationMessageHook then (funktioniert so nicht )
  Application.OnMessage := nil;
end;


{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32PopupMenu
{                                                                            }
{****************************************************************************}

constructor TtsCap32PopupMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInternalItemsCreated := FALSE;
  FIncludeStart := TRUE;
  FIncludeStop := TRUE;
  FIncludeSave := TRUE;
  FIncludeGrab := TRUE;
  FIncludeConnect := TRUE;
  FIncludePreview := TRUE;
  FIncludeOverlay := TRUE;
  FIncludeDialogs := TRUE;
  FIncludeCopy := TRUE;
  FIncludeSaveAsBmp := TRUE;
  FIncludeBufferFile := TRUE;
  FIncludeCaptureDriver := TRUE;
  FStartCaption := 'Start';
  FStopCaption := 'Stop';
  FSaveCaption := 'Save';
  FGrabCaption := 'Grab';
  FConnectCaption := 'Connect';
  FPreviewCaption := 'Preview';
  FOverlayCaption := 'Overlay';
  FDialogsCaption := 'Driver Dialogs...';
  FDialogFormatCaption := 'Format...';
  FDialogDisplayCaption := 'Display...';
  FDialogSourceCaption := 'Source...';
  FDialogCompressionCaption := 'Compression...';
  FCopyCaption := 'Copy To Clipboard';
  FSaveAsBmpCaption := 'Save As *.Bmp';
  FBufferFileCaption := 'Buffer File ...';
  FCaptureDriverCaption := 'Capture Driver ...';

  FAttachedTsCap32 := nil;
end;

destructor TtsCap32PopupMenu.Destroy;
begin
  //Dem angeschl. Object (so vorhanden) das Ableben mitteilen
  if FAttachedTsCap32 <> nil then
    FAttachedTsCap32.PopupMenu := nil;

  inherited Destroy;
end;

procedure TtsCap32PopupMenu.Loaded;
var
  tmpItem, tmpItem2: TMenuItem;
begin
  inherited Loaded;
  //Alle internen Items nach den vom User eingebauten:
  if not (csDesigning in ComponentState)  and not FInternalItemsCreated then begin
    FirstInternalItemPosition := Items.Count;
    if FIncludeStart then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FStartCaption;
        Name := 'InternalMenuItem_Start';
        OnClick := OnStartClick;
        tag := StartItem_tag;
      end;
      Items.Add(tmpItem);
    end;
    if FIncludeStop then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FStopCaption;
        Name := 'InternalMenuItem_Stop';
        OnClick := OnStopClick;
        tag := StopItem_tag;
      end;
      Items.Add(tmpItem);
    end;
    if FIncludeSave then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FSaveCaption;
        Name := 'InternalMenuItem_Save';
        OnClick := OnSaveClick;
        tag := SaveItem_tag;
      end;
      Items.Add(tmpItem);
    end;
    if FIncludeGrab then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FGrabCaption;
        Name := 'InternalMenuItem_Grab';
        OnClick := OnGrabClick;
        tag := GrabItem_tag;
      end;
      Items.Add(tmpItem);
    end;
    if FIncludeConnect then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FConnectCaption;
        Name := 'InternalMenuItem_Connect';
        OnClick := OnConnectClick;
        tag := ConnectItem_tag;
      end;
      Items.Add(tmpItem);
    end;
    if FIncludePreview then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FPreviewCaption;
        Name := 'InternalMenuItem_Preview';
        OnClick := OnPreviewClick;
        tag := PreviewItem_tag;
      end;
      Items.Add(tmpItem);
    end;
    if FIncludeOverlay then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FOverlayCaption;
        Name := 'InternalMenuItem_Overlay';
        OnClick := OnOverlayClick;
        tag := OverlayItem_tag;
      end;
      Items.Add(tmpItem);
    end;
    if FIncludeDialogs then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FDialogsCaption;
        Name := 'InternalMenuItem_Dialogs';
        tag := DialogsItem_tag;
        tmpItem2 := TMenuItem.Create(self);
        with tmpItem2 do begin
          Caption := FDialogFormatCaption;
          Name := 'InternalMenuItem_DialogFormat';
          OnClick := OnDialogsClick;
          tag := DialogFormatItem_tag;
        end;
        Add(tmpItem2);
        tmpItem2 := TMenuItem.Create(self);
        with tmpItem2 do begin
          Caption := FDialogDisplayCaption;
          Name := 'InternalMenuItem_DialogDisplay';
          OnClick := OnDialogsClick;
          tag := DialogDisplayItem_tag;
        end;
        Add(tmpItem2);
        tmpItem2 := TMenuItem.Create(self);
        with tmpItem2 do begin
          Caption := FDialogCompressionCaption;
          Name := 'InternalMenuItem_DialogCompression';
          OnClick := OnDialogsClick;
          tag := DialogCompressionItem_tag;
        end;
        Add(tmpItem2);
        tmpItem2 := TMenuItem.Create(self);
        with tmpItem2 do begin
          Caption := FDialogSourceCaption;
          Name := 'InternalMenuItem_DialogSource';
          OnClick := OnDialogsClick;
          tag := DialogSourceItem_tag;
        end;
        Add(tmpItem2);
      end;
      Items.Add(tmpItem);
    end;
    if FIncludeCopy then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FCopyCaption;
        Name := 'InternalMenuItem_Copy';
        OnClick := OnCopyClick;
        tag := CopyItem_tag;
      end;
      Items.Add(tmpItem);
    end;
    if FIncludeSaveAsBmp then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FSaveAsBmpCaption;
        Name := 'InternalMenuItem_SaveAsBmp';
        OnClick := OnSaveAsBmpClick;
        tag := SaveAsBmpItem_tag;
      end;
      Items.Add(tmpItem);
    end;
    if FIncludeBufferFile then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FBufferFileCaption;
        Name := 'InternalMenuItem_BufferFile';
        OnClick := OnBufferFileClick;
        tag := BufferFileItem_tag;
      end;
      Items.Add(tmpItem);
    end;
    if FIncludeCaptureDriver then begin
      tmpItem := TMenuItem.Create(self);
      with tmpItem do begin
        Caption := FCaptureDriverCaption;
        Name := 'InternalMenuItem_CaptureDriver';
        OnClick := OnCaptureDriverClick;
        tag := CaptureDriverItem_tag;
      end;
      Items.Add(tmpItem);
    end;

    Synchronize;
    FInternalItemsCreated := TRUE;
  end;
end;

procedure TtsCap32PopupMenu.AttacheTsCap32(TsCap32: TtsCap32);
var
  OldTsCap32: TtsCap32;
begin
  if FAttachedTsCap32 = TsCap32 then exit;

  OldTsCap32 := FAttachedTsCap32;
  FAttachedTsCap32 := TsCap32;

  //Dem ehem. Partner die Partnerschaft aufkündigen, falls es von der Trennung
  //noch nichts weiß
  if OldTsCap32 <> nil then
    if OldTsCap32.PopupMenu = self then
      OldTsCap32.PopupMenu := nil;

  //Dem angeschl. Object die partnerschaft mitteilen, falls es von der Ehre
  //noch nichts weiß
  //(dieses trifft bei Rückfrage schon auf aktualisiertes FAttachedTsCap32)
  if FAttachedTsCap32 <> nil then
    if FAttachedTsCap32.PopupMenu <> self then
      FAttachedTsCap32.PopupMenu := self;

  Synchronize;
end;

procedure TtsCap32PopupMenu.Synchronize;
procedure SyncInternal(MenuItem: TMenuItem);
var
  i: Integer;
begin
  //rek. Aufruf, um Untermenus zu erfassen
  with MenuItem do
  if Count > 0 then
    For i := 0 to Count - 1 do
      SyncInternal(Items[i]);

  case MenuItem.tag of
    StartItem_tag:
      MenuItem.Enabled := FAttachedTsCap32.Connected;
    StopItem_tag:
      MenuItem.Enabled := FAttachedTsCap32.Connected;
    SaveItem_tag: begin
      MenuItem.Enabled := FAttachedTsCap32.Connected;
    end;
    GrabItem_tag:
      MenuItem.Enabled := FAttachedTsCap32.Connected and not (FAttachedTsCap32.Parameter.CapTechnique = ctStreamIntoFile);
    ConnectItem_tag: begin
      MenuItem.Checked := FAttachedTsCap32.Connected;
      MenuItem.Enabled := TRUE;
    end;
    PreviewItem_tag: begin
      MenuItem.Checked := FAttachedTsCap32.Parameter.Preview;
      MenuItem.Enabled := FAttachedTsCap32.Connected;
    end;
    OverlayItem_tag:
      if not FAttachedTsCap32.DriverCaps.HasOverlay then begin
        MenuItem.Checked := FALSE;
        MenuItem.Enabled := FALSE;
      end else begin
        MenuItem.Checked := FAttachedTsCap32.Parameter.Overlay;
        MenuItem.Enabled := FAttachedTsCap32.Connected;
      end;
    DialogsItem_tag: begin
      MenuItem.Checked := FALSE;
      MenuItem.Enabled := FAttachedTsCap32.Connected;
    end;
    DialogFormatItem_tag: begin
      MenuItem.Checked := FALSE;
      MenuItem.Enabled := FAttachedTsCap32.Connected and FAttachedTsCap32.DriverCaps.HasDlgVideoFormat;
    end;
    DialogDisplayItem_tag: begin
      MenuItem.Checked := FALSE;
      MenuItem.Enabled := FAttachedTsCap32.Connected and FAttachedTsCap32.DriverCaps.HasDlgVideoDisplay;
    end;
    DialogSourceItem_tag: begin
      MenuItem.Checked := FALSE;
      MenuItem.Enabled := FAttachedTsCap32.Connected and FAttachedTsCap32.DriverCaps.HasDlgVideoSource;
    end;
    DialogCompressionItem_tag: begin
      MenuItem.Checked := FALSE;
      MenuItem.Enabled := FAttachedTsCap32.Connected;
    end;
    CopyItem_tag,
    SaveAsBmpItem_tag: begin
      MenuItem.Checked := FALSE;
      MenuItem.Enabled := FAttachedTsCap32.Connected;
    end;
    BufferFileItem_tag: begin
      MenuItem.Checked := FALSE;
      MenuItem.Enabled := TRUE;
    end;
    CaptureDriverItem_tag: begin
      MenuItem.Checked := FALSE;
      MenuItem.Enabled := not FAttachedTsCap32.Connected;
    end;
  end; //case
end;

var
  i: Integer;
begin
  if FAttachedTsCap32 = nil then
    //nichts angeschlossen - alle menuitems entchecken und grayen
    for i := FirstInternalItemPosition to Items.Count - 1 do begin
      Items[i].Checked := FALSE;
      Items[i].Enabled := FALSE;
    end
  else
    //Menuitems dem Status des angeschl. Objektes anpassen
    for i := FirstInternalItemPosition to Items.Count - 1 do begin
      SyncInternal(Items[i]);
    end;
end;

procedure TtsCap32PopupMenu.OnStartClick(Sender: TObject);
begin
  if FAttachedTsCap32 <> nil then
    FAttachedTsCap32.Caporder := start;
end;

procedure TtsCap32PopupMenu.OnStopClick(Sender: TObject);
begin
  if FAttachedTsCap32 <> nil then
    FAttachedTsCap32.Caporder := stop;
end;

procedure TtsCap32PopupMenu.OnSaveClick(Sender: TObject);
var
  TmpFileRequester : TSaveDialog;
begin
  if FAttachedTsCap32 <> nil then begin
    //Requester schaffen
    TmpFileRequester := TSaveDialog.Create(Application);
    //Eigenschaften einstellen
    with TmpFileRequester do begin
      FileName := FAttachedTsCap32.Parameter.SaveFile;
      Title := 'Save captured video as...';
      Filterindex := 1;
      Filter := 'AVI-Video (*.avi)|*.avi|Alle Dateien (*.*)|*.*';
      DefaultExt := 'avi';
      Options := [ofOverwritePrompt, ofPathMustExist];
    end;
    //Requester ausführen
    if TmpFileRequester.Execute then begin
      FAttachedTsCap32.Parameter.SaveFile := TmpFileRequester.FileName;
      FAttachedTsCap32.Caporder := save;
    end;
  end;
end;

procedure TtsCap32PopupMenu.OnGrabClick(Sender: TObject);
begin
  if FAttachedTsCap32 <> nil then
    FAttachedTsCap32.Caporder := grab;
end;

procedure TtsCap32PopupMenu.OnConnectClick(Sender: TObject);
begin
  if FAttachedTsCap32 <> nil then begin
    FAttachedTsCap32.Connected := not FAttachedTsCap32.Connected;
  end;
end;

procedure TtsCap32PopupMenu.OnPreviewClick(Sender: TObject);
begin
  if FAttachedTsCap32 <> nil then
    FAttachedTsCap32.Parameter.Preview := not FAttachedTsCap32.Parameter.Preview;
end;

procedure TtsCap32PopupMenu.OnOverlayClick(Sender: TObject);
begin
  if FAttachedTsCap32 <> nil then
    FAttachedTsCap32.Parameter.Overlay := not FAttachedTsCap32.Parameter.Overlay;
end;

procedure TtsCap32PopupMenu.OnDialogsClick(Sender: TObject);
begin
  if (FAttachedTsCap32 <> nil) and (Sender is TMenuItem) then
    case TmenuItem(Sender).tag of
      DialogFormatItem_tag: FAttachedTsCap32.Parameter.DlgFormat := TRUE;
      DialogDisplayItem_tag: FAttachedTsCap32.Parameter.DlgDisplay := TRUE;
      DialogCompressionItem_tag: FAttachedTsCap32.Parameter.DlgCompression := TRUE;
      DialogSourceItem_tag: FAttachedTsCap32.Parameter.DlgSource := TRUE;
    end;
end;

procedure TtsCap32PopupMenu.OnCopyClick(Sender: TObject);
begin
  if FAttachedTsCap32 <> nil then
    FAttachedTsCap32.CopyToClipboard := TRUE;
end;

procedure TtsCap32PopupMenu.OnSaveAsBmpClick(Sender: TObject);
var
  TmpFileRequester : TSaveDialog;
begin
  if FAttachedTsCap32 <> nil then begin
    //Requester schaffen
    TmpFileRequester := TSaveDialog.Create(Application);
    //Eigenschaften einstellen
    with TmpFileRequester do begin
      FileName := FAttachedTsCap32.SaveAsBmp;
      Title := 'Save Frame As...';
      Filterindex := 1;
      Filter := 'Windows-Bitmap (*.bmp)|*.bmp|Alle Dateien (*.*)|*.*';
      DefaultExt := 'bmp';
      Options := [ofOverwritePrompt, ofPathMustExist];
    end;
    //Requester ausführen
    if TmpFileRequester.Execute then
      FAttachedTsCap32.SaveAsBmp := TmpFileRequester.FileName;
  end;
end;

procedure TtsCap32PopupMenu.OnBufferFileClick(Sender: TObject);
var
  dlg: TtsCap32Dialogs;
begin
  dlg := TtsCap32Dialogs.Create(self);
  dlg.AttachedTsCap32 := FAttachedTsCap32;
  dlg.BufferFileDlg := TRUE;
  dlg.Free;
end;

procedure TtsCap32PopupMenu.OnCaptureDriverClick(Sender: TObject);
var
  dlg: TtsCap32Dialogs;
begin
  dlg := TtsCap32Dialogs.Create(self);
  dlg.AttachedTsCap32 := FAttachedTsCap32;
  dlg.DriverDlg := TRUE;
  dlg.Free;
end;






{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32Dialogs                                   }
{                                                                            }
{****************************************************************************}

  constructor TtsCap32Dialogs.Create(AOwner: TComponent);
  begin
    inherited Create(AOwner);
    FAttachedTsCap32 := nil;
    tsCap32PeriphInstances.Add(self);
  end;

  destructor TtsCap32Dialogs.Destroy;
  begin
    tsCap32PeriphInstances.Remove(self);
    inherited Destroy;
  end;

  procedure TtsCap32Dialogs.AttacheTsCap32(TsCap32: TtsCap32);
  var
    OldTsCap32: TtsCap32;
  begin
    FAttachedTsCap32 := TsCap32;

  end;

  procedure TtsCap32Dialogs.TsCap32Killed(var Msg: TMessage);
  begin
    with Msg do
      if TtsCap32(lParam) = FAttachedTsCap32 then
        AttachedTsCap32 := nil;
  end;

  procedure TtsCap32Dialogs.SetBufferFileDlg(status: Boolean);
  var
    Frm: TtsCap32BufferFileFrm;
  begin
    if status then begin
      if FAttachedTsCap32 <> nil then begin
        Application.CreateForm(TtsCap32BufferFileFrm, Frm);
        with Frm do begin
          BufferFile := FAttachedTsCap32.Parameter.BufferFile;
          BufferFileSize_Mb := FAttachedTsCap32.Parameter.BufferFileSize_Mb;
          if ShowModal = mrOk then begin
            FAttachedTsCap32.Parameter.BufferFile := BufferFile;
            FAttachedTsCap32.Parameter.BufferFileSize_Mb := BufferFileSize_Mb;
          end;
          Free;
        end;
      end else
        MessageDlg('No TtsCap32-Component attached', mtError, [mbOk], 0);
    end;
  end;

  procedure TtsCap32Dialogs.SetAboutDlg(status: Boolean);
  var
    Frm: TtsCap32AboutFrm;
  begin
    if status then begin
      if FAttachedTsCap32 <> nil then begin
        Application.CreateForm(TtsCap32AboutFrm, Frm);
        with Frm do begin
          AboutAuthor := FAttachedTsCap32.AboutAuthor;
          AboutVersion := FAttachedTsCap32.AboutVersion;
          ShowModal;
          Free;
        end;
      end else
        MessageDlg('No TtsCap32-Component attached', mtError, [mbOk], 0);
    end;
  end;

  procedure TtsCap32Dialogs.SetDriverDlg(status: Boolean);
  var
    Frm: TtsCap32DriverFrm;
  begin
    if status then begin
      if FAttachedTsCap32 <> nil then begin
        Application.CreateForm(TtsCap32DriverFrm, Frm);
        with Frm do begin
          DriverCmbB.Items.Assign(FAttachedTsCap32.FDriverNameList);
          DriverCmbB.ItemIndex := 0;
          FDriverVersionList.Assign(FAttachedTsCap32.FDriverVersionList);
          VersionEd.Caption := FDriverVersionList[0];
          if ShowModal = mrOk then begin
            FAttachedTsCap32.FAutomaticSearchForDriver := FALSE;
            FAttachedTsCap32.FDriverNo := DriverCmbB.ItemIndex;
          end;
          Free;
        end;
      end else
        MessageDlg('No TtsCap32-Component attached', mtError, [mbOk], 0);
    end;
  end;

  procedure TtsCap32Dialogs.SetAudioParameterDlg(status: Boolean);
  var
    Frm: TtsCap32AudioParameterFrm;
  begin
    if status then begin
      if FAttachedTsCap32 <> nil then begin
        Application.CreateForm(TtsCap32AudioParameterFrm, Frm);
        with Frm do begin

          AudioHardware := not FAttachedTsCap32.Connected or FAttachedTsCap32.AudioParameter.AudioHardware;
          if FAttachedTsCap32.Connected then begin
            if AudioHardware then
              AudioHardwareLb.Caption := 'Audio Hardware Found'
            else begin
              AudioHardwareLb.Caption := 'Audio Hardware Not Found';
              AudioHardwareLb.Font.Color := clRed;
            end;
          end else
            AudioHardwareLb.Caption := 'Not Connected';

          AudioCapEnabledCb.Checked := FAttachedTsCap32.AudioParameter.AudioCapEnabled;
          SampleFrequ := FAttachedTsCap32.AudioParameter.SplFrequ;
          SampleWidth := FAttachedTsCap32.AudioParameter.SplWidth;
          Channels := FAttachedTsCap32.AudioParameter.Channels;

          if ShowModal = mrOk then begin
            FAttachedTsCap32.AudioParameter.AudioCapEnabled := AudioCapEnabledCb.Checked;
            FAttachedTsCap32.AudioParameter.SplFrequ := SampleFrequ;
            FAttachedTsCap32.AudioParameter.SplWidth := SampleWidth;
            FAttachedTsCap32.AudioParameter.Channels := Channels;
          end;
          Free;
        end;
      end else
        MessageDlg('No TtsCap32-Component attached', mtError, [mbOk], 0);
    end;
  end;

  procedure TtsCap32Dialogs.SetCaptureSettingsDlg(status: Boolean);
  var
    Frm: TtsCap32CaptureSettingsFrm;
  begin
    if status then begin
      if FAttachedTsCap32 <> nil then begin
        Application.CreateForm(TtsCap32CaptureSettingsFrm, Frm);
        with Frm do begin
          AttachedTsCap32 := FAttachedTsCap32;
          TimeLimit := FAttachedTsCap32.Parameter.TimeLimit;
          CaptureRate_fps := FAttachedTsCap32.Parameter.CaptureRate_fps;
          EnableTimeLimitCb.Checked := FAttachedTsCap32.Parameter.TimeLimitEnabled;
          if ShowModal = mrOk then begin
            FAttachedTsCap32.Parameter.TimeLimit := TimeLimit;
            FAttachedTsCap32.Parameter.CaptureRate_fps := CaptureRate_fps;
            FAttachedTsCap32.Parameter.TimeLimitEnabled := EnableTimeLimitCb.Checked;
          end;
          Free;
        end;
      end else
        MessageDlg('No TtsCap32-Component attached', mtError, [mbOk], 0);
    end;
  end;

  procedure TtsCap32Dialogs.SetPreviewRateDlg(status: Boolean);
  var
    Frm: TtsCap32PreviewRateFrm;
  begin
    if status then begin
      if FAttachedTsCap32 <> nil then begin
        Application.CreateForm(TtsCap32PreviewRateFrm, Frm);
        with Frm do begin
          PreviewRate_mspf := FAttachedTsCap32.Parameter.PreviewRate_mspf;
          PreviewRate_fps := 1000 div PreviewRate_mspf;
          if ShowModal = mrOk then begin
            FAttachedTsCap32.Parameter.PreviewRate_mspf := PreviewRate_mspf;
          end;
          Free;
        end;
      end else
        MessageDlg('No TtsCap32-Component attached', mtError, [mbOk], 0);
    end;
  end;

  procedure TtsCap32Dialogs.SetAdvCaptureSettingsDlg(status: Boolean);
  var
    Frm: TtsCap32AdvCaptureSettingsFrm;
  begin
    if status then begin
      if FAttachedTsCap32 <> nil then begin
        Application.CreateForm(TtsCap32AdvCaptureSettingsFrm, Frm);
        with Frm do begin
          IndexSize := FAttachedTsCap32.Parameter.IndexSize;
          if IndexSize = 0 then IndexSizeCb.Checked := TRUE;
          NumVideoRequested := FAttachedTsCap32.Parameter.NumVideoRequested;
          if NumVideoRequested = 0 then NumVideoRequestedCb.Checked := TRUE;
          NumAudioRequested := FAttachedTsCap32.Parameter.NumAudioRequested;
          if NumAudioRequested = 0 then NumAudioRequestedCb.Checked := TRUE;
          AudioBufferSize := FAttachedTsCap32.Parameter.AudioBufferSize;
          if AudioBufferSize = 0 then AudioBufferSizeCb.Checked := TRUE;
          ChunkGranularity := FAttachedTsCap32.Parameter.ChunkGranularity;
          if ChunkGranularity = 0 then ChunkGranularityCb.Checked := TRUE;
          PercentDropForError := FAttachedTsCap32.Parameter.PercentDropForError;
          if ShowModal = mrOk then begin
            if IndexSizeCb.Checked then
              FAttachedTsCap32.Parameter.IndexSize := 0
            else
              FAttachedTsCap32.Parameter.IndexSize := IndexSize;
            if NumVideoRequestedCb.Checked then
              FAttachedTsCap32.Parameter.NumVideoRequested := 0
            else
              FAttachedTsCap32.Parameter.NumVideoRequested := NumVideoRequested;
            if NumAudioRequestedCb.Checked then
              FAttachedTsCap32.Parameter.NumAudioRequested := 0
            else
              FAttachedTsCap32.Parameter.NumAudioRequested := NumAudioRequested;
            if AudioBufferSizeCb.Checked then
              FAttachedTsCap32.Parameter.AudioBufferSize := 0
            else
              FAttachedTsCap32.Parameter.AudioBufferSize := AudioBufferSize;
            if ChunkGranularityCb.Checked then
              FAttachedTsCap32.Parameter.ChunkGranularity := 0
            else
              FAttachedTsCap32.Parameter.ChunkGranularity := ChunkGranularity;
            FAttachedTsCap32.Parameter.PercentDropForError := PercentDropForError;
          end;
          Free;
        end;
      end else
        MessageDlg('No TtsCap32-Component attached', mtError, [mbOk], 0);
    end;
  end;

  function TtsCap32Dialogs.DummyBooleanGetFalse: Boolean;
  begin
    Result := FALSE;
  end;



{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32BufferFileDlgFrm                          }
{                                                                            }
{****************************************************************************}


procedure TtsCap32BufferFileFrm.SizeEdChange(Sender: TObject);
begin
  BufferFileSize_Mb := StrToIntDef(SizeEd.Text, BufferFileSize_Mb);
  SizeEd.Text := IntToStr(BufferFileSize_Mb);
end;

procedure TtsCap32BufferFileFrm.DDDBnClick(Sender: TObject);
begin
  with SaveDialog1 do begin
    Filename := BufferFile;
    InitialDir := ExtractFilePath(BufferFile);
    if SaveDialog1.Execute then begin
      BufferFile := SaveDialog1.Filename;
      FileEd.Text := SaveDialog1.Filename;
    end;
  end;
end;

procedure TtsCap32BufferFileFrm.FormCreate(Sender: TObject);
begin
  BufferFile := 'C:\capture.avi';
  BufferFileSize_Mb := 100;
end;

procedure TtsCap32BufferFileFrm.FormShow(Sender: TObject);
begin
  FileEd.Text := BufferFile;
  SizeEd.Text := IntToStr(BufferFileSize_Mb);
end;


{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32AboutFrm                                  }
{                                                                            }
{****************************************************************************}

procedure TtsCap32AboutFrm.FormShow(Sender: TObject);
begin
  AuthorEd.Caption := AboutAuthor;
  VersionEd.Caption := AboutVersion;
  Font.Size := 7;
  OkBn.Left := (ClientWidth div 2) - (OkBn.Width div 2);
  Color := clBlack;
end;

procedure TtsCap32AboutFrm.Paint;
var
  HeadLine: string;
begin
  inherited Paint;
  FIXWMF_DrawToCanvas(Canvas, 0, 0, ClientWidth + 2, ClientHeight + 2);
  HeadLine := 'tsCap32 - Video Capture Component';
  with canvas do begin
    Canvas.Brush.Style := bsClear;
    textOut((ClientWidth - TextWidth(HeadLine)) div 2, 5, Format('%s', [HeadLine]));
    textOut((ClientWidth - TextWidth(AboutAuthor)) div 2, 20, Format('%s', [AboutAuthor]));
    textOut((ClientWidth - TextWidth(AboutVersion)) div 2, 35, Format('%s', [AboutVersion]));
  end;
end;

{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32DriverFrm                                  }
{                                                                            }
{****************************************************************************}

constructor TtsCap32DriverFrm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDriverVersionList := TstringList.Create;
end;

destructor TtsCap32DriverFrm.Destroy;
begin
  FDriverVersionList.Free;
  inherited Destroy;
end;

procedure TtsCap32DriverFrm.DriverCmbBChange(Sender: TObject);
begin
  VersionEd.Caption := FDriverVersionList[DriverCmbB.ItemIndex];
end;



{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32AudioParameterFrm                         }
{                                                                            }
{****************************************************************************}

procedure TtsCap32AudioParameterFrm.AudioCapEnabledCbClick(
  Sender: TObject);
begin
  if not AudioHardware and AudioCapEnabledCb.Checked then
    AudioCapEnabledCb.Checked := FALSE;
  Sync;
end;

procedure TtsCap32AudioParameterFrm.Sync;
begin
  swGb.Enabled := AudioCapEnabledCb.Checked;
  if AudioCapEnabledCb.Checked then
    swGb.Font.Color := clWindowText
  else
    swGb.Font.Color := clInactiveCaption;
  swDefaultRb.Enabled := AudioCapEnabledCb.Checked;
  sw8bitRb.Enabled := AudioCapEnabledCb.Checked;
  sw16bitRb.Enabled := AudioCapEnabledCb.Checked;
  sfGb.Enabled := AudioCapEnabledCb.Checked;
  if AudioCapEnabledCb.Checked then
    sfGb.Font.Color := clWindowText
  else
    sfGb.Font.Color := clInactiveCaption;
  sfDefaultRb.Enabled := AudioCapEnabledCb.Checked;
  sf8000Rb.Enabled := AudioCapEnabledCb.Checked;
  sf11025Rb.Enabled := AudioCapEnabledCb.Checked;
  sf22050Rb.Enabled := AudioCapEnabledCb.Checked;
  sf44100Rb.Enabled := AudioCapEnabledCb.Checked;
  chGb.Enabled := AudioCapEnabledCb.Checked;
  if AudioCapEnabledCb.Checked then
    chGb.Font.Color := clWindowText
  else
    chGb.Font.Color := clInactiveCaption;
  chDefaultRb.Enabled := AudioCapEnabledCb.Checked;
  chMonoRb.Enabled := AudioCapEnabledCb.Checked;
  chStereoRb.Enabled := AudioCapEnabledCb.Checked;
end;

procedure TtsCap32AudioParameterFrm.swRbClick(Sender: TObject);
begin
  Case TComponent(Sender).Tag of
  0: SampleWidth := wDefault;
  1: SampleWidth := w8bit;
  2: SampleWidth := w16bit;
  end;
end;

procedure TtsCap32AudioParameterFrm.sfRbClick(Sender: TObject);
begin
  Case TComponent(Sender).Tag of
  0: SampleFrequ := fDefault;
  1: SampleFrequ := f8000Hz;
  2: SampleFrequ := f11025Hz;
  3: SampleFrequ := f22050Hz;
  4: SampleFrequ := f44100Hz;
  end;
end;

procedure TtsCap32AudioParameterFrm.chRbClick(Sender: TObject);
begin
  Case TComponent(Sender).Tag of
  0: Channels := chDefault;
  1: Channels := chMono;
  2: Channels := chStereo;
  end;
end;

procedure TtsCap32AudioParameterFrm.FormShow(Sender: TObject);
begin
  if not AudioHardware then
    AudioCapEnabledCb.Checked := FALSE;

  sync;

  case SampleWidth of
    wDefault: swDefaultRb.Checked := TRUE;
    w8bit: sw8bitRb.Checked := TRUE;
    w16bit: sw16bitRb.Checked := TRUE;
  end;
  case SampleFrequ of
    fDefault: sfDefaultRb.Checked := TRUE;
    f8000Hz: sf8000Rb.Checked := TRUE;
    f11025Hz: sf11025Rb.Checked := TRUE;
    f22050Hz: sf22050Rb.Checked := TRUE;
    f44100Hz: sf44100Rb.Checked := TRUE;
  end;
  case Channels of
    chDefault: chDefaultRb.Checked := TRUE;
    chMono: chMonoRb.Checked := TRUE;
    chStereo: chStereoRb.Checked := TRUE;
  end;
end;



{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32CaptureSettingsFrm                        }
{                                                                            }
{****************************************************************************}


procedure TtsCap32CaptureSettingsFrm.EnableTimeLimitCbClick(Sender: TObject);
begin
  Sync;
end;

procedure TtsCap32CaptureSettingsFrm.Sync;
begin
  TimeLimitEd.Enabled := EnableTimeLimitCb.Checked;
  if EnableTimeLimitCb.Checked then
    TimeLimitLb.Font.Color := clWindowText
  else
    TimeLimitLb.Font.Color := clInactiveCaption;

  TimeLimitEd.Text := IntToStr(TimeLimit);
  CaptureRateEd.Text := IntToStr(CaptureRate_fps);
end;


procedure TtsCap32CaptureSettingsFrm.FormatDlgBnClick(Sender: TObject);
begin
  AttachedTsCap32.Parameter.DlgFormat := TRUE;
  BringToFront;
end;

procedure TtsCap32CaptureSettingsFrm.CompressionDlgBnClick(Sender: TObject);
begin
  AttachedTsCap32.Parameter.DlgCompression := TRUE;
  BringToFront;
end;

procedure TtsCap32CaptureSettingsFrm.AudioFormatDlgBnClick(Sender: TObject);
var
  TmpDlg: TtsCap32Dialogs;
begin
  TmpDlg := TtsCap32Dialogs.Create(self);
  TmpDlg.AttachedTsCap32 := AttachedTsCap32;
  TmpDlg.AudioParameterDlg := TRUE;
  TmpDlg.Free;
  BringToFront;
end;

procedure TtsCap32CaptureSettingsFrm.CaptureRateEdChange(Sender: TObject);
begin
  CaptureRate_fps := StrToIntDef(CaptureRateEd.Text, 0);
  Sync;
end;

procedure TtsCap32CaptureSettingsFrm.TimeLimitEdChange(Sender: TObject);
begin
  TimeLimit := StrToInt(TimeLimitEd.Text);
  Sync;
end;

procedure TtsCap32CaptureSettingsFrm.FormShow(Sender: TObject);
begin
  Sync;
end;


{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32PreviewRateFrm                            }
{                                                                            }
{****************************************************************************}


procedure TtsCap32PreviewRateFrm.FormShow(Sender: TObject);
begin
  Sync;
end;

procedure TtsCap32PreviewRateFrm.Sync;
begin
  PreviewRate_fpsEd.Text := IntToStr(PreviewRate_fps);
  PreviewRate_mspfEd.Text := IntToStr(PreviewRate_mspf);
end;

procedure TtsCap32PreviewRateFrm.PreviewRate_fpsEdChange(Sender: TObject);
var
  i: Integer;
begin
  i := StrToIntDef(PreviewRate_fpsEd.Text, 1);
  if (i > 0) and (i <= 1000) then begin
    PreviewRate_fps := i;
    PreviewRate_mspf := 1000 div PreviewRate_fps;
  end;
  Sync;
end;

procedure TtsCap32PreviewRateFrm.PreviewRate_mspfEdChange(Sender: TObject);
var
  i: Integer;
begin
  i := StrToIntDef(PreviewRate_mspfEd.Text, 1);
  if (i > 0) and (i <= 1000) then begin
    PreviewRate_mspf := i;
    PreviewRate_fps := 1000 div PreviewRate_mspf;
  end;
  Sync;
end;




{****************************************************************************}
{                                                                            }
{    Klassenimplementation TtsCap32AdvCaptureSettingsFrm                            }
{                                                                            }
{****************************************************************************}



procedure TtsCap32AdvCaptureSettingsFrm.Sync;
begin
  IndexSizeEd.Text := IntToStr(IndexSize);
  NumVideoRequestedEd.Text := IntToStr(NumVideoRequested);
  NumAudioRequestedEd.Text := IntToStr(NumAudioRequested);
  AudioBufferSizeEd.Text := IntToStr(AudioBufferSize);
  ChunkGranularityEd.Text := IntToStr(ChunkGranularity);
  PercentDropForErrorEd.Text := IntToStr(PercentDropForError);
  IndexSizeEd.Enabled := not IndexSizeCb.Checked;
  NumVideoRequestedEd.Enabled := not NumVideoRequestedCb.Checked;
  NumAudioRequestedEd.Enabled := not NumAudioRequestedCb.Checked;
  AudioBufferSizeEd.Enabled := not AudioBufferSizeCb.Checked;
  ChunkGranularityEd.Enabled := not ChunkGranularityCb.Checked;
end;

procedure TtsCap32AdvCaptureSettingsFrm.CbClick(Sender: TObject);
begin
  Sync;
end;

procedure TtsCap32AdvCaptureSettingsFrm.FormShow(Sender: TObject);
begin
  Sync;
end;

procedure TtsCap32AdvCaptureSettingsFrm.EdChange(Sender: TObject);
var
  i: Integer;
begin
  i := StrToIntDef(TEdit(Sender).Text, 1);
  if i > 0 then
    case TEdit(Sender).Tag of
      0: IndexSize := i;
      1: NumVideoRequested := i;
      2: ChunkGranularity := i;
      3: NumAudioRequested := i;
      4: AudioBufferSize := i;
      5: PercentDropForError := i;
  end;
  Sync;
end;



{****************************************************************************}
{                                                                            }
{    Implementation globaler Funktionen                                      }
{                                                                            }
{****************************************************************************}




{****************************************************************************}
{    Callbackfunktionen                                                      }
{****************************************************************************}

function CallbackOnFrame(hwnd: HWND; pVidHdr: PVIDEOHDR): LRESULT;
var
  pObj: ^TObject;
  i: integer;
begin
  //Instanz von TtsCap32, zu der hwnd gehört,suchen
  pObj := nil;
  for i:=0 to tsCap32Instances.Count-1 do
    if TtsCap32(tsCap32Instances.Items[i]).FhCapWnd = hwnd then pObj := tsCap32Instances.Items[i];
  //wenn gefunden: interne Callbackmethode aufrufen
  if pObj <> nil then
    TtsCap32(pObj).OnFrameInternal(pVidHdr);
  Result := LRESULT(TRUE);
end;

function CallbackOnVideoStream(hwnd: HWND; pVidHdr: PVIDEOHDR): LRESULT;
var
  pObj: ^TObject;
  i: integer;
begin
  //Instanz von TtsCap32, zu der hwnd gehört,suchen
  pObj := nil;
  for i:=0 to tsCap32Instances.Count-1 do
    if TtsCap32(tsCap32Instances.Items[i]).FhCapWnd = hwnd then pObj := tsCap32Instances.Items[i];
  //wenn gefunden: interne Callbackmethode aufrufen
  if pObj <> nil then
    TtsCap32(pObj).OnVideoStreamInternal(pVidHdr);
  Result := LRESULT(TRUE);
end;

function CallbackOnError(hWnd: HWND; nID: Integer; lpsz: PChar): LRESULT;
var
  pObj: ^TObject;
  i: integer;
begin
  //Instanz von TtsCap32, zu der hwnd gehört,suchen
  pObj := nil;
  for i:=0 to tsCap32Instances.Count-1 do
    if TtsCap32(tsCap32Instances.Items[i]).FhCapWnd = hwnd then pObj := tsCap32Instances.Items[i];
  //wenn gefunden: Fehlerbeschreibung übergeben,
  //interne Callbackmethode aufrufen
  if pObj<>nil then
    with TtsCap32(pObj) do
    begin
      FError := StrPas(lpsz);
      OnErrorInternal;
    end;
  Result := LRESULT(TRUE);
end;

function CallbackOnYield(hWnd: HWND): LRESULT;
var
  pObj: ^TObject;
  i: integer;
begin
  //Instanz von TtsCap32, zu der hwnd gehört,suchen
  pObj := nil;
  for i:=0 to tsCap32Instances.Count-1 do
    if TtsCap32(tsCap32Instances.Items[i]).FhCapWnd = hwnd then pObj := tsCap32Instances.Items[i];
    //wenn gefunden: interne Callbackmethode aufrufen
  if pObj <> nil then
    with TtsCap32(pObj) do OnYieldInternal;
  Result := LRESULT(TRUE);
end;

function CallbackOnWaveStream(hWnd: HWND; lpWHdr: PWAVEHDR): LRESULT;
var
  pObj: ^TObject;
  i: integer;
begin
  //Instanz von TtsCap32, zu der hwnd gehört,suchen
  pObj := nil;
  for i:=0 to tsCap32Instances.Count-1 do
    if TtsCap32(tsCap32Instances.Items[i]).FhCapWnd = hwnd then pObj := tsCap32Instances.Items[i];
    //wenn gefunden: Ereigniss Object.OnFrame auslösen
  if pObj <> nil then
    with TtsCap32(pObj) do OnWaveStreamInternal(lpWHdr);
  Result := LRESULT(TRUE);
end;

function CallbackOnStatus(hWnd: HWND; nID: Integer; lpsz: PChar): LRESULT;
var
  pObj: ^TObject;
  i: integer;
begin
  //Instanz von TtsCap32, zu der hwnd gehört,suchen
  pObj := nil;
  for i:=0 to tsCap32Instances.Count-1 do
    if TtsCap32(tsCap32Instances.Items[i]).FhCapWnd = hwnd then pObj := tsCap32Instances.Items[i];
    //wenn gefunden: interne Callbackmethode aufrufen
  if pObj <> nil then
    with TtsCap32(pObj) do OnStatusInternal(nID, lpsz);
  Result := LRESULT(TRUE);
end;

function CallbackOnCapControl(hWnd: HWND; nState: Integer): LRESULT;
var
  pObj: ^TObject;
  i: integer;
begin
  //Instanz von TtsCap32, zu der hwnd gehört,suchen
  pObj := nil;
  for i:=0 to tsCap32Instances.Count-1 do
    if TtsCap32(tsCap32Instances.Items[i]).FhCapWnd = hwnd then pObj := tsCap32Instances.Items[i];
    //wenn gefunden: interne Callbackmethode aufrufen
  if pObj <> nil then
    with TtsCap32(pObj) do OnCapControlInternal(nState);
  Result := LRESULT(TRUE);
end;




{Windows-Broadcast-Funktionen}
type TtsBcMsg = record
  Message: TMessage;
  WndClassName: string;
  Sender: HWND;
end;
pTtsBcMsg = ^TtsBcMsg;


procedure BroadcastToWindows(Sender: HWND; WndClassName: string; MsgCode: DWORD; wp: WPARAM; lp: LPARAM);
var
  BcMsg: TtsBcMsg;
begin
  with BcMsg.Message do begin
    Msg := MsgCode;
    wparam := wp;
    lparam := lp;
  end;
  BcMsg.WndClassName := WndClassName;
  BcMsg.Sender := Sender;
  EnumWindows(Addr(EnumWindowsProc), LPARAM(@BcMsg));
end;

{fenster zählen - Callbackfunktionen für broadcast}
function EnumWindowsProc(hWnd: HWND; pBcMsg: LPARAM): LongBool; stdcall;
begin
  EnumChildWindows(hWnd, Addr(EnumChildProc), pBcMsg);
end;

function EnumChildProc(hWnd: HWND; pBcMsg: LPARAM): LongBool; stdcall;
var
  txt: array[0..19] of Char;
  TempMsg: TtsBcMsg;
begin
  if pTtsBcMsg(pBcMsg)^.Sender <> hWnd then begin
    GetClassName(hWnd, @txt, 19);
    TempMsg := pTtsBcMsg(pBcMsg)^;
    with TempMsg do
      if StrPas(@txt) = WndClassName then
        SendMessage(hWnd, Message.Msg, Message.wparam, Message.lparam);
  end;
end;




{Broadcast an periphere Komponenten}
procedure BroadcastToPeriphericals(Sender: TObject; MsgCode: UINT; wp: WPARAM);
var
  Msg: TMessage;
  i: Integer;
begin
  with Msg do begin
    Msg := MsgCode;
    LParam := LongInt(Sender);
    wParam := wp;
  end;
  for i := 0 to tsCap32PeriphInstances.Count - 1 do
    TObject(tsCap32PeriphInstances[i]).Dispatch(Msg);
end;


{delay}

procedure delay_ms(ms: DWORD);
var
  t: DWORD;
begin
  t := GetTickCount;
  while (GetTickCount-t) < ms do;
end;








initialization
begin
  tsCap32Instances := TList.Create;
  tsCap32PeriphInstances := TList.Create;
  tsCap32MessageRedirecter := TtsCap32MessageRedirecter.Create;
  FGlobalPreventMessageHook := FALSE;
end;
finalization
begin
  tsCap32Instances.Free;
  tsCap32PeriphInstances.Free;
  tsCap32MessageRedirecter.Free;
end;

end.
