unit Unit1;

{
Copyright 2013 Document Storage Systems, Inc. 
 
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
 
       http://www.apache.org/licenses/LICENSE-2.0
 
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
}


{.$DEFINE Debug}
{$DEFINE WIN32}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, tscap32_rt, ExtCtrls, StdCtrls, ComCtrls, uPtSel,
  ORNet, ORFn, Trpcb, vxrpcBroker, JvExControls, JvButton, AxCtrls, ComObj,
  JvTransparentButton, Buttons, JvExButtons, JvBitBtn, JvExStdCtrls,
  JvCtrls, DB, DBClient, DBTables, Provider, Grids, DBGrids, IniFiles;

const
  VXPP_FIELD_NUMBER = '21603.01';
  MUTEX_ID = '0A92CC1A-5634-4D50-A991-735E5F9D481E';
  VXPATIENTPICTURE_V = ' vxPatientPicture v';
  SPLASH_DELAY = 1000;
  IMPREVIEW_INIT_HEIGHT = 250; //255;
  IMPREVIEW_INIT_WIDTH  = 180; //300;
  CONTEXT_NAME = 'VFDVXP PATIENT PIC CONTEXT';
  VXPP_ADMIN_KEY = 'VFDVXP PATIENT PIC ADMIN';
  MUST_HAVE_MENU_OPTION = 'To access vxPatientPicture, user must have Menu Option ' + CONTEXT_NAME;
  PATH_PROBLEM = 'The picture folder path is missing, or is incorrect.' + CRLF +
                 'Please contact the vxPatientPicture Adminstrator to update the picture folder path.' + CRLF+CRLF +
                 'If you are the vxPatientPicture Administrator, click ''OK'' to continue.' + CRLF +
                 'Otherwise, clicking ''OK'' will terminate the vxPatientPicture application.';
  CANT_FIND_IMAGE_PATH = 'The image path in parameter ''VFDVXP PATIENT PIC ROOT'' can''t be found.' + CRLF+CRLF +
                          'Please contact the vxPatientPicture Adminstrator';
  CANT_FIND_IMAGE_PATH_ADMIN = 'A valid root directory for patient pictures can''t be found.' + CRLF+CRLF +
                            'Please check to see that a valid directory path for patient images, exists.';
  CAMERA_CONNECTED = 'Camera connected';
  CAMERA_DISCONNECTED = 'Camera disconnected';
  BROKER_CONNECTED = 'Broker connected';
  BROKER_DISCONNECTED = 'Broker disconnected';

{$IFDEF Debug}
  MAX_FILES = 5;
{$ELSE}
  MAX_FILES = 100000;
{$ENDIF}

type
{//REMOVE
  TFSFlag = (FSCaseIsPreserved, FSCaseSensitive, FSUnicodeStoredOnDisk,
      FSPersistentACLS, FSVolIsCompressed, FSFileCompression);
  TFSFlags = set of TFSFlag;

  TVolumeInfo = record
    VolumeName: String;
    VolumeSN: DWord;
    MaxComponent: DWord;
    FSFlags: TFSFlags;
    FSName: String;
  end;
}
  TfmMain = class(TForm)
    tsCap321: TtsCap32;
    Label4: TLabel;
    sbStatusBar: TStatusBar;
    paBottom: TPanel;
    buStartAVICapture: TButton;
    buStopAVICapture: TButton;
    paPatientInfo: TPanel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    StaticText1: TStaticText;
    Label5: TLabel;
    MainMenu1: TMainMenu;
    meFile: TMenuItem;
    meExit: TMenuItem;
    meHelp: TMenuItem;
    meAbout: TMenuItem;
    meContents: TMenuItem;
    meBrokerHistory: TMenuItem;
    Label6: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    ListBox1: TListBox;
    meAdmin: TMenuItem;
    buLogon: TJvImgBtn;
    buLogoff: TJvImgBtn;
    buPtSel: TJvImgBtn;
    buCaptureImage: TJvImgBtn;
    buCropImage: TJvImgBtn;
    buAccept: TJvImgBtn;
    buDeleteImage: TJvImgBtn;
    buConnectDisconnect: TJvImgBtn;
    buClose: TJvImgBtn;
    meOptions: TMenuItem;
    meHintsOn: TMenuItem;
    meThumbnailSize: TMenuItem;
    me100x75: TMenuItem;
    me200x150: TMenuItem;
    me400x300: TMenuItem;
    meAboutTSCAP3211: TMenuItem;
    meTSCAP321DriverDlg: TMenuItem;
    meSource: TMenuItem;
    imPreview: TImage;
    tsCap32Dialogs1: TtsCap32Dialogs;
    procedure buStartAVICaptureClick(Sender: TObject);
    procedure buStopAVICaptureClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure meAboutClick(Sender: TObject);
    procedure meBrokerHistoryClick(Sender: TObject);
    procedure meExitClick(Sender: TObject);
    procedure meAdminClick(Sender: TObject);
    function AutomaticSearchForDriver: integer;
    procedure buLogonClick(Sender: TObject);
    procedure buLogoffClick(Sender: TObject);
    procedure buPtSelClick(Sender: TObject);
    procedure buCaptureImageClick(Sender: TObject);
    procedure buCropImageClick(Sender: TObject);
    procedure buAcceptClick(Sender: TObject);
    procedure buConnectDisconnectClick(Sender: TObject);
    procedure buCloseClick(Sender: TObject);
    procedure buDeleteImageClick(Sender: TObject);
    procedure meHintsOnClick(Sender: TObject);
    procedure tsCap321MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure me100x75Click(Sender: TObject);
    procedure me200x150Click(Sender: TObject);
    procedure me400x300Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure meAboutTSCAP3211Click(Sender: TObject);
    procedure meTSCAP321DriverDlgClick(Sender: TObject);
    procedure meSourceClick(Sender: TObject);
  private
    lastLoginHadMenuOption: boolean;
    //AnchorX: integer;
    //AnchorY: integer;
    //CurX: integer;
    //CurY: integer;
    //Bounding: boolean;
    OleGraphic: TOleGraphic;
    fs: TFileStream;
    FimageRootDirectory: string;
    FFirstTickCount: Cardinal;
    //thumbnail : TBitmap;
    //thumbRect : TRect;
    maxWidth: integer;
    maxHeight: integer;
    FAccepted: boolean;
    FIniFile: TIniFile;
    procedure Delay(msecs: integer);
    procedure DeleteTempImageFiles();
    procedure WritePathAndFilename(thisTargetFile: string);
    procedure RestoreImage(Sender: TObject);
    procedure Accept(Sender: TObject);
    function GetScaledCenteredBitmap(maxWidth, maxHeight: integer): TBitmap;
  public
    AppName: string;
    DSSPtSel : TDSSPtLookup;
    FPictureLocation: string;
    currentPatientDFN: string;

    sbmp: TBitmap;
    thisBitmap: TBitmap;

    bmp: string;
    jpg: string;
    FMaxFilesPerDirectory: Extended;
    lastSubdirectory: string;
    FDIVroot: string;
    FDIVmax: string;
    FSYSroot: string;
    FSYSmax: string;
    FSavedPatientPicturePath: string;
    FSavedImage: TImage;
    fsBuffer: TFileStream;
    OleGraphicBuffer: TOleGraphic;
    FPreviousPatient: string;
    FinitialPatientSelect: boolean;  //defect 69
    property Accepted: boolean read FAccepted write FAccepted; //defect 69
    property InitialPatientSelect: boolean read FinitialPatientSelect write FinitialPatientSelect;  //defect 69
    property RootDirectory: string read FimageRootDirectory write FimageRootDirectory;
    property MaxFilesDIV: Extended read FMaxFilesPerDirectory write FMaxFilesPerDirectory;
    property MaxFilesSYS: Extended read FMaxFilesPerDirectory write FMaxFilesPerDirectory;
    function DirectoryIsFull(thisDirectory: string) : boolean;
    function StartupCheck() : boolean;
    function BMPtoJPG(var BMPpic, JPGpic: string) : boolean;
    procedure InitializeImagePreviewSize(Sender: TObject);
    function FileCount(path: string) : integer;
    function SubdirectoriesExist(sPath: string) : boolean;
    procedure ResizePreview(Sender: TObject);
  end;

const
  DELETE_BUTTON_CAPTION = '&Delete';
  ACCEPT_BUTTON_CAPTION = '&Accept';
  STD_HEIGHT = 250;
  STD_WIDTH = 295;

var
  hMutex: HWND;
  fmMain: TfmMain;
  ExitSave: pointer;
  slPatientInfo : TStringList;

implementation

{$R *.dfm}

uses
  jpeg, fEnlarge, About, fxBroker, uCore, rCore, fAdmin, fSplash, fFindingPatientImage,
  fPtSel;

procedure vxPPExitProc;
begin
  try
    System.ExitProc := ExitSave; //restore the original vector
  except
    on E: Exception do
      MessageDlg('An exception has occurred in vxPPExitProc()' + CRLF +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfmMain.Delay(msecs: integer);
begin
  try
    Application.ProcessMessages;
    self.FFirstTickCount := GetTickCount;
    repeat
      Application.ProcessMessages;
    until ((GetTickCount - self.FFirstTickCount) >= longInt(msecs));
  except
    on E: Exception do
    MessageDlg('An exception has occurred in TfmMain.Delay()' + CRLF+CRLF + E.Message, mtError, [mbOK], 0);
  end;
end;

function TfmMain.FileCount(path: string) : integer;
var
  sr: TSearchRec;
  FileAttrs: Integer;
  Count : integer;
begin
  try
    FileAttrs := faAnyfile;
    Count:=0;

    if FindFirst(path, FileAttrs, sr) = 0 then
      begin
        repeat
            Inc(Count);
        until FindNext(sr) <> 0;
      FindClose(sr);
      end;

    Result := Count; //-2; //2 hidden file entries
  except
    on E: Exception do
      MessageDlg('An exception has occurred in TfmMain.FileCount()' + CRLF +
        E.Message, mtError, [mbOK], 0);
  end;
end;

function TfmMain.SubdirectoriesExist(sPath: String) : boolean;
var
  Path : String;
  Rec : TSearchRec;
begin
  result := false;
  try
    Path := IncludeTrailingBackslash(sPath);
    if FindFirst(PChar(Path) + '*.*', faDirectory, Rec) = 0 then
      try
        repeat
        if (Rec.Name <> '.') and (Rec.Name <> '..') and (Rec.Attr = FILE_ATTRIBUTE_DIRECTORY) then
          begin
          result := true;
          ListBox1.Items.Add(Path + Rec.Name);
          lastSubdirectory := Path + Rec.Name;
          lastSubdirectory := IncludeTrailingBackslash(lastSubdirectory);
          SubdirectoriesExist(Path + Rec.Name);
          end;
        until FindNext(Rec) <> 0;
      finally
        FindClose(Rec); //FindFirst allocates resources (memory) which must be released by calling FindClose
      end;
  except
    on E: Exception do
      MessageDlg('An exception has occurred in TfmMain.GetAllSubFolders()' + CRLF + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfmMain.tsCap321MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  tscap321.ShowHint;
end;

function TfmMain.DirectoryIsFull(thisDirectory: string) : boolean;
var
  numFiles: Extended;
begin
  try
    result := false;
    numFiles := 0; //init
    numFiles := FileCount(lastSubdirectory + '\*.jpg');

    if self.FDIVroot <> '' then
      begin
      if numFiles >= strToInt(self.FDIVmax) then
        result := true;
      end
    else
      if self.FSYSroot <> '' then
        if numFiles >= strToInt(self.FSYSmax) then
          result := true;
  except
    on E: Exception do
      MessageDlg('An exception has occurred in TfmMain.DirectoryIsFull()' + CRLF +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfmMain.me100x75Click(Sender: TObject);
begin
  me100x75.Checked := true;
  self.FIniFile := TIniFile.Create(ChangeFileExt( Application.ExeName, '.ini'));
  self.FIniFile.WriteInteger('RESOLUTION','resolution',0);
  self.FIniFile.Free;
end;

procedure TfmMain.me200x150Click(Sender: TObject);
begin
  me200x150.Checked := true;
  self.FIniFile := TIniFile.Create(ChangeFileExt( Application.ExeName, '.ini'));
  self.FIniFile.WriteInteger('RESOLUTION','resolution',1);
  self.FIniFile.Free;
end;

procedure TfmMain.me400x300Click(Sender: TObject);
begin
  me400x300.Checked := true;
  self.FIniFile := TIniFile.Create(ChangeFileExt( Application.ExeName, '.ini'));
  self.FIniFile.WriteInteger('RESOLUTION','resolution',2);
  self.FIniFile.Free;
end;

procedure TfmMain.meAboutClick(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

procedure TfmMain.meAboutTSCAP3211Click(Sender: TObject);
begin
  tsCap32Dialogs1.AboutDlg := true;
end;

procedure TfmMain.meAdminClick(Sender: TObject);
begin
  fmAdmin.ShowModal;
end;

procedure TfmMain.meBrokerHistoryClick(Sender: TObject);
begin
  ShowBroker;
end;

procedure TfmMain.meExitClick(Sender: TObject);
begin
  try
    Close;
  except
    //If there is an exception, clean up as much as possible, then kill the app.
    if vxrpcBrokerV <> nil then
      begin
      if vxrpcBrokerV.Connected then
        begin
        vxrpcBrokerV.Connected := false;
        sbStatusBar.Panels[2].Text := BROKER_DISCONNECTED;
        Application.ProcessMessages;
        end;
      vxrpcBrokerV.Free;

      if Assigned(self.OleGraphic) then
        FreeAndNil(OleGraphic);

      if Assigned(self.OleGraphicBuffer) then
        FreeAndNil(OleGraphicBuffer);

      if Assigned(self.fs) then
        FreeAndNil(self.fs);

      if Assigned(self.fsBuffer) then
        FreeAndNil(self.fsBuffer);

      if frmAbout <> nil then
        frmAbout.Release;

      if fmEnlarge <> nil then
        fmEnlarge.Release;

      if fmMain <> nil then
        fmMain.Release;

      Application.ProcessMessages;
      Application.Terminate;
      end;
  end;
end;

procedure TfmMain.meHintsOnClick(Sender: TObject);
begin
  if not meHintsOn.Checked then
    begin
    meHintsOn.Checked := true;
    Application.ShowHint := true;
    end
  else
    begin
    meHintsOn.Checked := false;
    Application.ShowHint := false;
    end;
end;

procedure TfmMain.meSourceClick(Sender: TObject);
begin
  tsCap321.Parameter.DlgSource := true;
end;

procedure TfmMain.meTSCAP321DriverDlgClick(Sender: TObject);
begin
  tsCap32Dialogs1.DriverDlg := true;
end;

function TfmMain.BMPtoJPG(var BMPpic, JPGpic: string) : boolean;
//Convert the .bmp to a .jpg
var
  bitmap: TBitmap;
  Stream: TFileStream;
begin
  try
    bitmap := TBitmap.Create;
    try
      try
        bitmap.LoadFromFile(BMPpic);
      except
        on E: EInvalidGraphic do
          MessageDlg('Error attempting to load an invalid graphic image in fmMain.BMPtoJPG().' + CRLF +
            E.Message, mtError, [mbOK], 0);
      end;
      
      with TJPEGImage.Create do
        try
        Assign(bitmap);
        CompressionQuality := StrToIntDef(ParamStr(2),100);
        Stream := TFileStream.Create(ChangeFileExt(JPGpic,'.JPG'),fmCreate);
          try
            SaveToStream(Stream);
          finally
            Stream.Free
          end
        finally
          Free
        end
    finally
      Bitmap.Free
    end;
  except
    on E: Exception do
      MessageDlg('Streaming error in fmMain.BMPtoJPG', mtError, [mbOK], 0);
  end;
end;

procedure TfmMain.WritePathAndFilename(thisTargetFile: string);
var
  sl: TStringList;
  slinput: TStringList;
  thisPath: string;
  tempPath: string;
  imageSubDirectoryName: string;

  lastDelimPos: integer;
  i: integer;

begin
  sl := TStringList.Create;
  slinput := TStringList.Create;

  tempPath := ExtractFilePath(thisTargetFile);
  thisPath := '';
  for i := 0 to Length(tempPath)-1 do
    thisPath := thisPath + tempPath[i];

  {$IFDEF WIN32}
    lastDelimPos := LastDelimiter('\', thisPath);
    imageSubDirectoryName := '';
    for i := (lastDelimPos + 1) to Length(thisPath) do
      imageSubDirectoryName := imageSubDirectoryName + thisPath[i];
    imageSubDirectoryName := imageSubDirectoryName + '\' + ExtractFilename(thisTargetFile);
  {$ENDIF}

  {$IFDEF linux}
    lastDelimPos := LastDelimiter('/', thisPath);
    imageSubDirectoryName := '';
    for i := (lastDelimPos + 1) to Length(thisPath) do
      imageSubDirectoryName := imageSubDirectoryName + thisPath[i];
    imageSubDirectoryName := imageSubDirectoryName + '/' + ExtractFilename(thisTargetFile);      
  {$ENDIF}

  slinput.Add(VXPP_FIELD_NUMBER + '^' + '^' + imageSubDirectoryName);  //<<------- includes the <filename>.jpg
  
  try
{
    RPC call to store the picture location beyond the root to field 21603.01 of file 2
    ------- Setting VFDVXP PATIENT PIC ROOT  for System: VXCPT.VXVISTA.ORG -------
    HFS ROOT: \\vxqa\vxPatientimages\  Replace ??

    This parameter maintains the configuration data for the root path of
    patient pictures. This root along with the field(21603.01) value of the
    patient file(2) completes the location of the patient's picture. This
    link is used by the vxPatient Picture app and vxCPRS extension dll
    (vxPatientImages.dll) to load and display the image. We must ensure that
    the root plus the 21603.01 entry equals a valid path which includes the picture
    name. vxPP handles storing the second half of the address beyond the root
    defined by this parameter.

    PATIENT PICTURE LINK:
    This field contains the address defined "beyond" the root directory (i.e., a subdirectory) the parameter
    (VFDVXP PATIENT PIC ROOT) to create a complete HFS file location. This
    value would either be a file name or a subfolder + file name.
}
    tCallV(sl,'VFDC FM FILER', [2, currentPatientDFN + ',', '', slinput]);

    if Piece(sl[0],'^',1) = '-1' then  //rpc call failed
      begin
      imPreview.Picture := nil;
      MessageDlg('''Accept'' failed.  No image captured.', mtError, [mbOk], 0); //rpc call failed
      end
    else
      MessageDlg('Success.', mtInformation, [mbOK], 0); //rpc call succeeded
  except
    on E : Exception do
    begin
      DeleteFile(lastSubdirectory + thisTargetFile); //delete the image file on exception
      imPreview.Picture := nil;
      MessageDlg('Exception in TfmMain.WritePathAndFilename()' + CRLF+CRLF + E.Message + CRLF+CRLF + '* FAILED *', mtError, [mbOK], 0);
    end;
  end;

  if sl <> nil then
    sl.Free;
  if slInput <> nil then
    slinput.Free;
end;

procedure TfmMain.DeleteTempImageFiles();
begin
  try
    //delete the .bmp image file - we don't need it anymore
    DeleteFile(currentPatientDFN + '_TEMP' + '.bmp');
  except
    on E: EInOutError do
      MessageDlg('Error while attempting to delete temporary .bmp image file.', mtError, [mbOk], 0);
  end;

  //Delete the temporary jpg image
  try
    //delete the .jpg image file - we don't need it anymore
    DeleteFile(currentPatientDFN + '_TEMP' + '.jpg');

  except
    on E: EInOutError do
      MessageDlg('Error while attempting to delete temporary .jpg image file.', mtError, [mbOk], 0);
  end;
end;

function TfmMain.GetScaledCenteredBitmap(maxWidth, maxHeight: integer): TBitmap;
//preserves the aspect ratio of the bitmap
var
  scaledWidth: integer;
  scaledHeight: integer;
begin 
  scaledWidth := 0;
  scaledHeight := 0; 
  thisBitmap := TBitmap.Create;
  sbmp := TBitmap.Create;
  thisBitmap.Assign(imPreview.Picture.Bitmap);

  if thisBitmap.Width > thisBitmap.Height then
    begin
    scaledHeight := trunc(maxWidth * thisBitmap.Height / thisBitmap.Width);
    scaledWidth := maxWidth;
    end
  else
    if thisBitmap.Height > thisBitmap.Width then
      begin
      scaledWidth := trunc(maxHeight * thisBitmap.Width / thisBitmap.Height);
      scaledHeight := maxHeight;
      end;

  sbmp.Width := maxWidth; 
  sbmp.Height := maxHeight; 
  sbmp.Canvas.Brush.Color := clBlack; 
  sbmp.Canvas.FillRect(Bounds(0, 0, maxWidth, maxHeight)); 
  sbmp.Canvas.StretchDraw(Bounds(maxWidth div 2 - scaledWidth div 2, maxHeight div 2 - scaledHeight div 2, scaledWidth, scaledHeight), thisBitmap);

  result := sbmp;
  thisBitmap.Free;
end;

procedure TfmMain.Accept(Sender: TObject);
var
  sourceFile: string;
  targetFile: string;
  errCode: DWORD;
  ErrorMessage: Pointer;
  thisNow: TDateTime;
  tempList: TStrings;
  slInput: TStrings;
  thisFile: string;
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  slDebug: TStrings; //DEBUG - Deliberately cause an access violation so that we drop into the except block, for testing exception on image delete.
                     //See 'except' block in this procedure, below.
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  try
    self.FPictureLocation := self.RootDirectory;

    if ((Piece(self.FPictureLocation, '^', 1) = '-1') or (self.FPictureLocation = '')) then //the path may not be defined, or defined as a non-existent path
      begin
      MessageDlg(PATH_PROBLEM + CRLF+CRLF + '* Picture storage FAILED *', mtError, [mbOK], 0);
      Exit;
      end;

    if ((ExtractFilePath(self.FSavedPatientPicturePath) = lastSubdirectory) and (not DirectoryIsFull(lastSubdirectory))) then
      begin
        CopyFile(PChar(self.FSavedPatientPicturePath), PChar('UNDO_' + DSSPtSel.DFN + '.jpg'), false);
        
      try
        self.fsBuffer := TFileStream.Create('UNDO_' + DSSPtSel.DFN + '.jpg', fmOpenRead or fmShareDenyNone);
      except
        on E: EFOpenError do
          MessageDlg('An exception has occurred in procedure TfmMain.Accept().' + CRLF+CRLF + '*** Patient Picture was not saved ***' + CRLF +
                    E.Message, mtError, [mbOk], 0);
      end;

      self.OleGraphicBuffer := TOleGraphic.Create;
      self.OleGraphicBuffer.LoadFromStream(self.fsBuffer);
      end;

    sourceFile := currentPatientDFN + '_TEMP' + '.jpg';
    targetFile := currentPatientDFN + '.jpg';

      if fmMain.me100x75.Checked then
        begin
        maxWidth := THUMBNAIL_WIDTH_100x75;
        maxHeight := THUMBNAIL_HEIGHT_100x75;
        end;

      if fmMain.me200x150.Checked then
        begin
        maxWidth := THUMBNAIL_WIDTH_200x150;
        maxHeight := THUMBNAIL_HEIGHT_200x150;
        end;

      if fmMain.me400x300.Checked then
        begin
        maxWidth := THUMBNAIL_WIDTH_400x300;
        maxHeight := THUMBNAIL_HEIGHT_400x300;
        end;
      fmMain.imPreview.Picture.Bitmap.Assign(GetScaledCenteredBitmap(maxWidth, maxHeight));

    self.imPreview.Picture.SaveToFile(sourceFile); //We save the physical file below. So, save the resized image first.

    if fmEnlarge.croppedImage <> nil then
      fmEnlarge.croppedImage.Free;

    ListBox1.Clear;

    if SubDirectoriesExist(self.FPictureLocation) then
      begin
        if not DirectoryIsFull(lastSubdirectory) then
          begin
            if not CopyFile(Pchar(sourceFile),PChar(lastSubdirectory + targetFile), false) then
              begin
              errCode := GetLastError();
              FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM, nil, errCode, 0, @ErrorMessage, 0, nil);
              MessageDlg('* Picture storage FAILED *' + CRLF+CRLF + PChar(ErrorMessage), mtError, [mbOK], 0);
              end
            else //CopyFile succeeded, so call VFDC FM FILER
              WritePathAndFilename(lastSubdirectory + targetFile);
          end
        else //directory IS full
          begin
          thisNow := 0; //init
          thisNow := Now; //subdirectory name
          //NOTE: Using a Delphi TDateTime as a directory name serves two purposes:
          //      1) It virtually guarantees a unique folder name, and
          //      2) all image subfolders will appear in a listing (e.g., Windows Explorer), in chronological order.
          if not CreateDir(IncludeTrailingPathDelimiter(self.FPictureLocation) + 'vxp_' + FloatToStr(thisNow)) then //create subdirectory <subdirectory name = thisNow>
            begin
            raise Exception.Create('Cannot create image subdirectory vxp_' + FloatToStr(thisNow) + '.' + CRLF+CRLF + 'Please contact the vxPatientPicture Administrator.');
            Exit;
            end
          else
            begin
            ListBox1.Clear;
            if SubDirectoriesExist(self.FPictureLocation) then //get name of last subdirectory
              begin
              lastSubdirectory := ListBox1.Items.Strings[ListBox1.Count-1];
              lastSubdirectory := IncludeTrailingBackslash(lastSubdirectory);
              if not CopyFile(Pchar(sourceFile),PChar(lastSubdirectory + targetFile), false) then
                begin
                errCode := GetLastError();
                FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM, nil, errCode, 0, @ErrorMessage, 0, nil);
                MessageDlg('* Picture storage FAILED *' + CRLF+CRLF + PChar(ErrorMessage), mtError, [mbOK], 0);
                end
              else  //CopyFile succeeded, so call VFDC FM FILER
                WritePathAndFilename(lastSubdirectory + targetFile);
              end;
            end;
          end;

      end
    else //there are no subdirectories, so create one
      begin
      thisNow := 0;
      thisNow := Now; //subdirectory name
      if not CreateDir(self.FPictureLocation + 'vxp_' + FloatToStr(thisNow)) then
        begin
        MessageDlg('Cannot create image subdirectory vxp_' + FloatToStr(thisNow) + CRLF + '*** Patient picture was not saved ***' + CRLF+CRLF +
                  'Please contact the vxPatientPicture Administrator.', mtError, [mbOK], 0);
        Exit;
        end
      else
        if SubDirectoriesExist(self.FPictureLocation) then //get name of last subdirectory
          begin
          lastSubdirectory := IncludeTrailingBackslash(lastSubdirectory);
          if not CopyFile(Pchar(sourceFile),PChar(lastSubdirectory + targetFile), false) then
            begin
            errCode := GetLastError();
            FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM, nil, errCode, 0, @ErrorMessage, 0, nil);
            MessageDlg('* Picture storage FAILED *' + CRLF+CRLF + PChar(ErrorMessage), mtError, [mbOK], 0);
            end
          else  //CopyFile succeeded, so call VFDC FM FILER
            WritePathAndFilename(lastSubdirectory + targetFile);
          end;
      end;

    self.DeleteTempImageFiles();
    buCropImage.Enabled := false;
    self.Accepted := true;

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //slDebug[0] := ''; //DEBUG - Deliberately cause an access violation so that we drop into the except block, for testing image delete exception
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  except
    on E: Exception do
      begin
      self.Accepted := false;
      tempList := TStringList.Create;
      slInput := TStringList.Create;

      //get the image path from the patient record
      if ((DirectoryExists(self.RootDirectory)) and (SubDirectoriesExist(self.RootDirectory))) then
        begin
        //get the image path/filename
        tCallV(templist, 'VFDC DDR GETS ENTRY DATA', ['2', DSSPtSel.DFN, VXPP_FIELD_NUMBER, '']);
        thisFile := IncludeTrailingBackslash(self.RootDirectory) + Piece(tempList[0], '^', 4);

        //If there is a patient picture file at the path in the patient record, Delete it
        if FileExists(thisFile) then
          begin
          DeleteFile(thisFile);
          Application.ProcessMessages;
          end;

        //Clear the image pointer in the patient record
        tCallV(templist, 'VFDC DDR GETS ENTRY DATA', ['2', DSSPtSel.DFN, VXPP_FIELD_NUMBER, '']);
        slInput.Add(VXPP_FIELD_NUMBER + '^^');  //<<------- write null to field 21603.01 to remove any <path>\<filename>.jpg that was there
        tCallV(slInput,'VFDC FM FILER', [2, currentPatientDFN + ',', '', slinput]);

      //Delete all the TEMP images for this patient, if they exist...from the CLIENT (same directory as the .exe)
      if FileExists(currentPatientDFN + '_TEMP' + '.bmp') then
        DeleteFile(currentPatientDFN + '_TEMP' + '.bmp');

      if FileExists(currentPatientDFN + '_TEMP' + '.jpg') then
        DeleteFile(currentPatientDFN + '_TEMP' + '.jpg');

        Application.ProcessMessages;

        MessageDlg('An exception has occurred in procedure TfmMain.Accept().' + CRLF+CRLF + '*** Patient Picture was not saved ***' + CRLF +
                  E.Message, mtError, [mbOk], 0);
        buDeleteImage.Enabled := false;
        end;

      tempList.Free;
      slInput.Free;
      end;
  end;
end;

procedure TfmMain.buAcceptClick(Sender: TObject);
var
  sourceFile: string;
  targetFile: string;
  errCode: DWORD;
  ErrorMessage: Pointer;
  thisNow: TDateTime;
  tempList: TStrings;
  slInput: TStrings;
  thisFile: string;
  slDebug: TStrings;
  fs: TFileStream;
begin
  if buAccept.Caption = ACCEPT_BUTTON_CAPTION then
    begin
      if self.FSavedPatientPicturePath = '' then
        begin
        Accept(Sender);
        buAccept.Enabled := false;
        buDeleteImage.Enabled := true;
        end
      else
        begin
        if MessageDlg('This patient already has a picture on file.' + CRLF+CRLF +
          'Are you sure?', mtWarning, [mbYes, mbNo], 0) = mrYes then
            begin
            Accept(Sender);
            buAccept.Caption := '&Undo';
            buDeleteImage.Enabled := false;
            end
        else //revert back to the saved image
          begin

            tempList := TStringList.Create;
            tCallV(templist, 'VFDC DDR GETS ENTRY DATA', ['2', DSSPtSel.DFN, VXPP_FIELD_NUMBER, '']); //get the image path/filename
            fs := TFileStream.Create(self.FPictureLocation + '/' + Piece(tempList[0],'^',4), fmOpenRead or fmShareDenyNone);
            OleGraphic := TOleGraphic.Create;
            OleGraphic.LoadFromStream(fs);
            imPreview.Picture.Assign(OleGraphic);
            fs.Free;
            tempList.Free;
          end;
        end;
    end
  else //Undo clicked
    begin
    if (ExtractFilePath(self.FSavedPatientPicturePath) <> self.lastSubDirectory) then
      begin

        if MessageDlg('This action will restore the previous picture for this patient, if there is one.' + CRLF +
          //'If this patient has no previous picture on file, then this action will delete the picture you just took.' + CRLF+CRLF +
          'Are you sure?', mtWarning, [mbYes, mbNo], 0) = mrYes then
          begin
            templist := TStringList.Create;
            slInput := TStringList.Create;
            //delete the pic that was just taken
            tCallV(templist, 'VFDC DDR GETS ENTRY DATA', ['2', DSSPtSel.DFN, VXPP_FIELD_NUMBER, '']); //get the image path/filename
            thisFile := IncludeTrailingBackslash(self.RootDirectory) + Piece(tempList[0], '^', 4);
            DeleteFile(thisFile); //Delete the file from it's directory location
            Application.ProcessMessages;

            if Assigned(templist) then
              FreeAndNil(templist);
            if Assigned(slInput) then
              FreeAndNil(slInput);

          RestoreImage(Sender);
          //delete the local UNDO_ file
          DeleteFile('UNDO_' + DSSPtSel.DFN + '.jpg');
          end
      end
    else
      begin //UNDO - self.FSavedPatientPicturePath = self.lastSubDirectory
        if MessageDlg('This action will restore the previous picture for this patient.' + CRLF +
          //'If this patient has no previous picture on file, then this action will delete the picture you just took.' + CRLF+CRLF +
          'Are you sure?', mtWarning, [mbYes, mbNo], 0) = mrYes then
          begin
            templist := TStringList.Create;
            slInput := TStringList.Create;
            tCallV(templist, 'VFDC DDR GETS ENTRY DATA', ['2', DSSPtSel.DFN, VXPP_FIELD_NUMBER, '']); //get the image path/filename
            thisFile := IncludeTrailingBackslash(self.RootDirectory) + Piece(tempList[0], '^', 4);

            DeleteFile(thisFile);
            Application.ProcessMessages;


            if not CopyFile(Pchar('UNDO_' + DSSPtSel.DFN + '.jpg'),PChar(thisFile), false) then
              begin
              errCode := GetLastError();
              FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM, nil, errCode, 0, @ErrorMessage, 0, nil);
              MessageDlg('* Picture storage FAILED on Undo in buAcceptClick() *' + CRLF+CRLF + PChar(ErrorMessage), mtError, [mbOK], 0);
              end;

            WritePathAndFilename(thisFile); //update 21603.01
            imPreview.Picture.Assign(self.OleGraphicBuffer);
            if fmMain.OleGraphicBuffer <> nil then
              fmMain.OleGraphicBuffer.Free;

            //delete the local UNDO_ file
            DeleteFile('UNDO_' + DSSPtSel.DFN + '.jpg');

              if Assigned(templist) then
                FreeAndNil(templist);
              if Assigned(slInput) then
                FreeAndNil(slInput);
          end;
      end;

    if self.Accepted then
      buAccept.Enabled := false; //disable 'Undo' button
    end;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
   if Assigned(slPatientInfo) then
      slPatientInfo.Free;

   if Assigned(ListBox1) then
    ListBox1.Free;

   if Assigned(fmFindingPatientImage) then
    fmFindingPatientImage.Free;
  except
    on E: Exception do
      MessageDlg('An exception has occurred in TfmMain.TfmMain.FormClose()' + CRLF +
                E.Message, mtError, [mbOk], 0);
  end;
end;

procedure TfmMain.InitializeImagePreviewSize(Sender: TObject);
begin
  imPreview.Height := IMPREVIEW_INIT_HEIGHT;
  imPreview.Width := IMPREVIEW_INIT_WIDTH;
end;

procedure TfmMain.buPtSelClick(Sender: TObject);
var
  lastPtDFN: string;
  tempList: TStrings;
  left: integer;
  top: integer;
begin
  if not fmMain.InitialPatientSelect then  //defect 69
    begin
    if MessageDlg('Click ''Yes'' to select a new patient.' + CRLF +
                  'Otherwise, click ''No''.', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      begin
        if self.Accepted then
          begin
          buAccept.Caption := '&Undo'; //defect 69
          buAccept.Enabled := true;
          end;

        imPreview.Show;
        Exit;
      end
    else
      begin
      //
      end;
    end;

  lastPtDFN := DSSPtSel.DFN;
  try
    if not (Assigned(DSSPtSel)) then
      DSSPtSel := TDSSPtLookup.Create(vxRPCBrokerV, Font);

    if (DSSPtSel.Execute) then
     begin
      slPatientInfo.Clear;
      slPatientInfo.Add('');
      slPatientInfo.Add('              MRN: ' + DSSptSel.MRN);
      slPatientInfo.Add('             Name: ' + DSSPtSel.Name);
      //slPatientInfo.Add('              DFN: ' + DSSPtSel.DFN);
      //slPatientInfo.Add('              SSN: ' + DSSPtSel.SSN);
      slPatientInfo.Add('              Sex: ' + DSSPtSel.Sex);
      slPatientInfo.Add('              DOB: ' + DateTimeToStr(ORFn.FMDateTimeToDateTime(DSSptSel.DOB)));
      //slPatientInfo.Add('             CWAD: ' + DSSPtSel.CWAD);              //<<----------------- Leave commented lines here, for now ----------
      slPatientInfo.Add('              Age: ' + intToStr(DSSPtSel.Age));
      //slPatientInfo.Add('      WardService: ' + DSSPtSel.WardService);
      //slPatientInfo.Add('      PrimaryTeam: ' + DSSPtSel.PrimaryTeam);
      //slPatientInfo.Add('  PrimaryProvider: ' + DSSPtSel.PrimaryProvider);
      //slPatientInfo.Add('        Attending: ' + DSSPtSel.Attending);
      //slPatientInfo.Add('              ICN: ' + DSSPtSel.ICN);

      if DSSPtSel.DOB = -1 then
        Exit
      else
        begin
        StaticText1.Caption := slPatientInfo.Text;
        buCaptureImage.Enabled := true;
        buConnectDisconnect.Enabled := buCaptureImage.Enabled;
        if User.HasKey(VXPP_ADMIN_KEY) then
          meBrokerHistory.Visible := true
        else
          meBrokerHistory.Visible := false;
        end;

      if (lastPtDFN <> DSSPtSel.DFN) then //changing patients
        begin
        if fmFindingPatientImage = nil then
          fmFindingPatientImage := TfmFindingPatientImage.Create(fmMain);

        fmFindingPatientImage.Show; //poScreenCenter (app startup)
        sbStatusBar.Panels[1].Text := fmFindingPatientImage.Label1.Caption;  //'Finding patient image...';
        Application.ProcessMessages;
        imPreview.Picture := nil; //clear the picture preview
        buCropImage.Enabled := false;
        buAccept.Enabled := false;
        buDeleteImage.Enabled := false;
        self.DeleteTempImageFiles();
        end;
     end;

    StaticText1.Caption := slPatientInfo.Text;
    sbStatusBar.Panels[1].Text := 'Patient IEN ' + DSSPtSel.DFN + ':  ' + DSSPtSel.Name;

   //check to see if there is an existing picture for this patient.
   //If there is one, and there are no problems at login (below), load it into the image preview pane
    //self.RootDirectory := GetImageRootDirectory(); ///// Replaced by function StartupCheck() /////
    self.FPictureLocation := self.RootDirectory;

      try
        templist := TStringList.Create;
        if ((DirectoryExists(self.FPictureLocation)) and (SubDirectoriesExist(self.FPictureLocation))) then
          begin
          tCallV(templist, 'VFDC DDR GETS ENTRY DATA', ['2', DSSPtSel.DFN, VXPP_FIELD_NUMBER, '']);

          {$IFDEF Debug}
          if DSSPtSel.DOB = -1 then
            begin
            MessageDlg('Patient ' + DSSPtSel.Name + ' has an invalid Date Of Birth.', mtWarning, [mbOK], 0);
            buCaptureImage.Enabled := false;
            imPreview.Picture := nil;
            Exit;
            end;
          {$ENDIF}
          end;
      except
        on E: EListError do
          begin
            //do nothing - silent exception
          end;
      end;

      try
        try
          {$IFDEF WIN32}
          if ((DirectoryExists(self.FPictureLocation)) and (SubDirectoriesExist(self.FPictureLocation)) and (FileExists(self.FPictureLocation + '\' + Piece(tempList[0],'^',4)))) then
          {$ENDIF}
           {$IFDEF linux}
             if ((DirectoryExists(self.FPictureLocation)) and (SubDirectoriesExist(self.FPictureLocation)) and (FileExists(self.FPictureLocation + '/' + Piece(tempList[0],'^',4)))) then
             {$ENDIF}
              begin
              {$IFDEF WIN32}
              fs := TFileStream.Create(self.FPictureLocation + '\' + Piece(tempList[0],'^',4), fmOpenRead or fmShareDenyNone);
              {$ENDIF}
              {$IFDEF linux}
              fs := TFileStream.Create(self.FPictureLocation + '/' + Piece(tempList[0],'^',4), fmOpenRead or fmShareDenyNone);
              {$ENDIF}

              fmMain.InitializeImagePreviewSize(Sender);
              OleGraphic := TOleGraphic.Create;
              OleGraphic.LoadFromStream(fs);
              imPreview.Picture.Assign(OleGraphic);
              buCropImage.Enabled := false; //defect 77 - patient with no previously existing image
              buAccept.Enabled := false;    //defect 77 - patient with no previously existing image
              end
            else
              begin
              imPreview.Height := STD_HEIGHT;
              imPreview.Width := STD_WIDTH;
              imPreview.Picture.Bitmap.LoadFromResourceName(hInstance,'NoImageAvailable');
              buCropImage.Enabled := false; //defect 77 - patient with no previously existing image
              buAccept.Enabled := false;    //defect 77 - patient with no previously existing image
              end;
        except
          on E: EListError do
            begin
              //do nothing - silent exception
            end;
        end;
      except
        on E: EOleError do
          MessageDlg('Error loading OleGraphic in procedure TfmMain.buPtSelClick().' + CRLF + E.Message, mtError, [mbOK], 0);
      end;

    if fmFindingPatientImage <> nil then //user may have clicked 'Cancel' on Patient Select form (frmPtSel)
      begin
      fmFindingPatientImage.Hide;
      Application.ProcessMessages;
      //Reposition this user msg over the main form center (for all form showing's subsequent to app startup)
      left := fmMain.Left + fmMain.Width div 2;
      fmFindingPatientImage.Left := left - fmFindingPatientImage.Width div 2;
      top := fmFindingPatientImage.Top + fmFindingPatientImage.Top div 2;
      fmFindingPatientImage.Top := top + fmFindingPatientImage.Height div 2;
      fmFindingPatientImage.Position := poOwnerFormCenter;
      end;

    currentPatientDFN := DSSPtSel.DFN;

    if tempList <> nil then
      templist.Free;

  except
    on E: Exception do
      begin
      if fmFindingPatientImage <> nil then
        fmFindingPatientImage.Hide;
      Application.ProcessMessages;
      MessageDlg('An error has occurred in fmMain.buPtSelClick()' + CRLF+CRLF + E.Message, mtError, [mbOK], 0);

      {$IFDEF Debug}
      if DSSPtSel.DOB = -1 then
        begin
        StaticText1.Caption := slPatientInfo.Text;
        sbStatusBar.Panels[1].Text := 'Patient IEN ' + DSSPtSel.DFN + ':  ' + DSSPtSel.Name;
        MessageDlg('Patient ' + DSSPtSel.Name + ' has an invalid Date Of Birth.', mtWarning, [mbOK], 0);
        buCaptureImage.Enabled := false;
        imPreview.Picture := nil;
        if tempList <> nil then
          templist.Free;
        Application.ProcessMessages;
        Exit;
        end;
      {$ENDIF}
      end;
  end;
end;

{.$DEFINE SIMULATE_NODRIVER} //This $DEFINE used for debugging TSCap32 Driver-Availability only
function TfmMain.AutomaticSearchForDriver: Integer;
//Returns the first available CaptureDriver. See function TtsCap32.AutomaticSearchForDriver: Integer;
var
  i: Integer;
begin
  i := 0;
  while (i < 10) and (tscap321.DriverName[i] = '-') do inc(i);
{$IFDEF SIMULATE_NODRIVER}
  i := 10;                         
{$ENDIF}
  //If we have Inc()'d to 10, this means the DriverName[] list is "blank" (i.e., all '-'s.....no drivers installed)
  result := i;
end;

procedure TfmMain.buLogonClick(Sender: TObject);
begin
  self.Caption := self.AppName; //init
  
  self.Accepted := false; //Defect 97

  if fmSplash <> nil then
    fmSplash.Show;
  Application.ProcessMessages;
  self.Delay(SPLASH_DELAY);

  try
    tscap321.Connected := true;  //not tscap321.Connected;

    //If we have Inc()'d to 10 in function AutomaticSearchForDriver(), this means the DriverName[] list is "blank" (i.e., all '-'s.....no drivers installed)
    if self.AutomaticSearchForDriver() = 10 then  //Ref: see function TtsCap32.AutomaticSearchForDriver: Integer;
      begin
      fmSplash.laCameraConnected.Font.Style := [fsBold];
      fmSplash.laCameraConnected.Font.Color := clRed;
      fmSplash.laCameraConnected.Caption := '= No camera driver =';
      Application.ProcessMessages;
      MessageDlg('*** NO CAMERA DRIVER FOUND ***' + CRLF + 'Please verify that your camera has a driver installed, and that the driver is enabled and correctly configured.' + CRLF+CRLF +
                'Click ''OK'' to shutdown vxPatientPicture.', mtError, [mbOk], 0);
      Application.Terminate;
      Exit;
      Application.ProcessMessages;
      end;

    if tscap321.Connected then
      buConnectDisconnect.Caption := 'Disconn&ect Camera'
    else
      buConnectDisconnect.Caption := 'C&onnect Camera';

    if tscap321.Connected then
      sbStatusBar.Panels[0].Text := CAMERA_CONNECTED
    else
      sbStatusBar.Panels[0].Text := CAMERA_DISCONNECTED;

  except
    on E: Exception do
      begin
      buConnectDisconnect.Caption := 'C&onnect Camera';
      if fmSplash <> nil then
        fmSplash.laCameraConnected.Caption := 'No camera detected';
      MessageDlg('No Camera Detected, or no driver installed.' + CRLF+CRLF + 'Error attempting to connect to camera in fmMain.buLogonClick()' + CRLF + 'Please check that your camera is connected.' +
        CRLF+CRLF + 'Click ''OK'' to exit vxPatientPicture.', mtError, [mbOK], 0);
      if fmSplash <> nil then
        begin
        fmSplash.Free;
        fmSplash := nil;
        Application.ProcessMessages;
        end;
      Application.Terminate;
      end;
  end;  

  if fmSplash <> nil then
    begin
    fmSplash.laCameraConnected.Font.Color := clBlue;
    fmSplash.laCameraConnected.Caption := CAMERA_CONNECTED;
    end;

  Application.ProcessMessages;
  self.Delay(SPLASH_DELAY);

  try
    EnsureBroker; //if broker=nil then create one
  except
    on E: Exception do
      MessageDlg('An exception has occurred in TfmMain.buLogonClick() in call to EnsureBroker()' + CRLF +
                E.Message, mtError, [mbOk], 0);
  end;

  try
    if ORNet.ConnectToServer(CONTEXT_NAME) then //Server list / Broker login
      begin
      if not (rCore.HasMenuOptionAccess(CONTEXT_NAME)) then //{and (vxRPCBrokerV.Connected)) then
        begin
        MessageDlg(MUST_HAVE_MENU_OPTION + CONTEXT_NAME +
          CRLF + 'Click ''OK'' to exit...', mtInformation, [mbOK], 0);
        meExitClick(Sender); //close the app cuz the user does not have the menu option
        fmSplash.Close;
        //Exit;
        Application.Terminate;
        end
      else
        begin
        fmSplash.laCameraConnected.Caption := 'Performing startup check...';
        Application.ProcessMessages;
        if not StartupCheck() then
          begin
          Application.Terminate;
          Exit;
          Application.ProcessMessages;
          end;

        if not (Assigned(DSSPtSel)) then
          DSSPtSel := TDSSPtLookup.Create(vxRPCBrokerV, Font);

        if fmSplash <> nil then
          fmSplash.Close;

        ////////////////////////////////////////////////////////////////
        //          vxPatientPicture - Admin "backdoor"               //
        ////////////////////////////////////////////////////////////////
        // An admin should not be forced to have to select
        // a patient on startup just to be able to get to
        // the Admin form. This code allows a vxPP Admin to
        // run vxPP from command line, and go directly to the Admin form,
        // skipping patient selection.
        // Also see procedure TfmAdmin.meCloseClick()
        ////////////////////////////////////////////////////////////////
        if UpperCase(ParamStr(1)) = 'ADMIN' then
          if User.HasKey(VXPP_ADMIN_KEY) then
            begin
            fmAdmin.Position := poScreenCenter;
            fmAdmin.ShowModal;
            end
        else
          fmAdmin.Position := poOwnerFormCenter; //owner form is fmMain
        ////////////////////////////////////////////////////////////////

        //Defect 78 Fix
        if User.HasKey(VXPP_ADMIN_KEY) then
          begin
          meAdmin.Visible := true;
          meBrokerHistory.Visible := true;
          end
        else
          begin
          meAdmin.Visible := false;
          meBrokerHistory.Visible := false;
          end;

        buPtSelClick(Sender);
        buLogon.Enabled := false;
        buLogoff.Enabled := true;
        buPtSel.Enabled := true;
        meOptions.Enabled := false;
        end;
      end
    else  //ConnectToServer()
      //HPQC #16 - If user Cancels login, then kill the app
      //HPQC #66 - Login user w/vxPP Context, logoff, login user w/o vxPP Context
      if vxrpcBrokerV <> nil then
        if not rCore.HasMenuOptionAccess(CONTEXT_NAME) then
          begin
          Application.ProcessMessages;
          Application.Terminate;
          Exit;
          end;
  except
    on E: Exception do
      begin
      //Defect 66 - Scenario: Login user w/vxPP Context, logoff, login user w/o vxPP Context. Or, login
      //            initially with a user who does not have VFDVXP PATIENT PIC CONTEXT as a menu option.
      //            If we're getting Application Context error, then
      //            the user prob does not have the necessary menu option (VFDVXP PATIENT PIC CONTEXT)
      //            So disable everything except 'Login' button, and keep running the app.
      buLogon.Enabled := true;
      buLogoff.Enabled := false;
      buPtSel.Enabled := false;
      buCaptureImage.Enabled := false;
      buCropImage.Enabled := false;
      buAccept.Enabled := false;
      buConnectDisconnect.Enabled := false;
      buClose.Enabled := true;
      meOptions.Enabled := false;

      Screen.Cursor := crArrow;
      vxRPCBrokerV.Connected := false;
      MessageDlg(E.Message + CRLF + CRLF + MUST_HAVE_MENU_OPTION + CONTEXT_NAME, mtError, [mbOk], 0);
      fmSplash.Close;
      Application.ProcessMessages;

      //Two different scenarios:
      //1: Initial instance of vxPP - if valid Login then enable Options menu, open application
      //                              else close application
      //2: Running Instance of vxPP - if valid Login (via Logon button) then enable Options menu, con't running
      //                              else disable Options menu and everything else except 'Close', con't running
      //On Logoff - Unconditionally disable the Options menu
      if not lastLoginHadMenuOption then
        begin
        Close;
        Application.ProcessMessages;
        end;
      end;
  end;

  buCaptureImage.Enabled := buLogoff.Enabled;

  if ((vxrpcBrokerV <> nil) and (vxrpcBrokerV.Connected)) then
    sbStatusBar.Panels[2].Text := BROKER_CONNECTED;

  if not tscap321.Connected then
    begin
    tscap321.Connected := true;
    sbStatusBar.Panels[0].Text := CAMERA_CONNECTED;
    Application.ProcessMessages;
    end;

  lastLoginHadMenuOption := true;
  if rCore.HasMenuOptionAccess(CONTEXT_NAME) then
    begin
    self.Caption := self.AppName + '       In use by:  ' + vxRPCBrokerV.User.Name;
    meOptions.Enabled := true;
    end
  else
    begin
    self.Caption := self.AppName;
    meOptions.Enabled := false;
    end;
end;

procedure TfmMain.buLogoffClick(Sender: TObject);
begin
  try
    if vxRPCBrokerV <> nil then
      begin
      vxRPCBrokerV.Connected := False;
      sbStatusBar.Panels[2].Text := BROKER_DISCONNECTED;
      sbStatusBar.Panels[1].Text := 'Logging off.  Please wait...';
      Application.ProcessMessages;
      end;
  except
    on E: Exception do
      MessageDlg('An exception has occurred in TfmMain.buLogoffClick() while attempting to disconnect vxRPCBrokerV' + CRLF +
                E.Message, mtError, [mbOk], 0);
  end;

  //delete the .bmp image file (we don't need it anymore)
  self.FPictureLocation := self.RootDirectory;

  try
    if FileExists(self.FPictureLocation + currentPatientDFN + '_TEMP' + '.bmp') then
      DeleteFile(self.FPictureLocation + currentPatientDFN + '_TEMP' + '.bmp');
  except
    on E: EInOutError	do
      MessageDlg('File I/O Error in fmMain.buLogoffClick()', mtError, [mbOK], 0);
  end;
       
  imPreview.Picture := nil;
  buLogoff.Enabled := false;
  buPtSel.Enabled := false;
  buLogon.Enabled := true;
  buAccept.Enabled := false;

  //buCaptureImage.Enabled := buLogoff.Enabled;
  buCaptureImage.Enabled := false;
  buConnectDisconnect.Enabled := buCaptureImage.Enabled;

  buDeleteImage.Enabled := buLogoff.Enabled;
  buCropImage.Enabled := buLogoff.Enabled;
  buAccept.Enabled := buLogoff.Enabled;

  meOptions.Enabled := false;
  meAdmin.Visible := false;
  meBrokerHistory.Visible := false;

  StaticText1.Caption := '';
  currentPatientDFN := '';
  sbStatusBar.Panels[1].Text := '';
  Application.ProcessMessages;

  tscap321.Connected := false;
  Application.ProcessMessages;

  if tscap321.Connected then
    buConnectDisconnect.Caption := 'Disconn&ect Camera'
  else
    buConnectDisconnect.Caption := 'C&onnect Camera';

  if tscap321.Connected then
    sbStatusBar.Panels[0].Text := CAMERA_CONNECTED
  else
    sbStatusBar.Panels[0].Text := CAMERA_DISCONNECTED;

  self.Caption := self.AppName;
end;

procedure TfmMain.ResizePreview(Sender: TObject);
begin
  if fmMain.me100x75.Checked then
    begin
    imPreview.Height := THUMBNAIL_HEIGHT_100x75;
    imPreview.Width := THUMBNAIL_WIDTH_100x75;
    end;

  if fmMain.me200x150.Checked then
    begin
    imPreview.Height := THUMBNAIL_HEIGHT_200x150;
    imPreview.Width := THUMBNAIL_WIDTH_200x150;
    end;

  if fmMain.me400x300.Checked then
    begin
    imPreview.Height := THUMBNAIL_HEIGHT_400x300;
    imPreview.Width := THUMBNAIL_WIDTH_400x300;
    end;
end;

procedure TfmMain.buCaptureImageClick(Sender: TObject);
begin
  buCropImage.Enabled := false; //init on Capture
  buAccept.Enabled := false;    //init on Capture

  buAccept.Caption := ACCEPT_BUTTON_CAPTION;

  imPreview.Hide;
  imPreview.Height := STD_HEIGHT;
  imPreview.Width := STD_WIDTH;
  
  try
    fmEnlarge.fOriginalBitmap := nil; //init for next photo

    if StaticText1.Caption = '' then //el-cheapo test to see if a patient has been selected
      begin
      MessageDlg('Please select a patient before taking picture.', mtInformation, [mbOk], 0);
      Exit;
      end;

    if DSSPtSel <> nil then
      begin
      //confirm patient
      if MessageDlg('Please confirm that patient ' {+ CRLF+CRLF} + DSSPtSel.Name + ' is present.', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        begin
        buPtSelClick(Sender);

        if not self.Accepted then
          buAccept.Caption := '&Accept' //defect 69
        else
          buAccept.Caption := '&Undo';

        //buAccept.Enabled := false; //defect 69
        Exit;
        end
      else //Patient is present
        begin
        buCropImage.Enabled := true;
        buAccept.Caption := '&Accept'; //defect 69
        buDeleteImage.Enabled := false;
        end;

      //Force repaint of the camera image so that the MessageDlg will not overlay it if user clicks 'Yes'
      tsCap321.Invalidate;
      Application.ProcessMessages;

      tscap321.SaveAsBMP := currentPatientDFN + '_TEMP' + '.bmp'; //local

      try
        imPreview.Picture.LoadFromFile(currentPatientDFN + '_TEMP' + '.bmp'); //local
      except
        on E: EInvalidGraphic do
          MessageDlg('Error attempting to load an invalid graphic image in fmMain.buCaptureImageClick().' + CRLF +
            E.Message, mtError, [mbOK], 0);
      end;

      bmp := currentPatientDFN + '_TEMP' + '.bmp'; //local
      jpg := currentPatientDFN + '_TEMP' + '.jpg'; //local
      self.BMPtoJPG(bmp, jpg);
      end;

    currentPatientDFN := DSSPtSel.DFN;
    imPreview.Show;
  except
    on E: Exception do
      MessageDlg('An exception has occurred in TfmMain.buCaptureImageClick()' + CRLF +
                E.Message, mtError, [mbOk], 0);
  end;
end;

function TfmMain.StartupCheck() : boolean;
//Check DIV and SYS for parameters VFDVXP PATIENT PIC ROOT and VFDVXP PATIENT MAX IMAGES, for valid values.
//Allow vxPatientPicture to run (or continue, as when called from fmAdmin.FormShow) ONLY IF, =either= DIV =or= SYS have a valid path/maxImages pair.
//
//The possible values are:
//  DIV                             SYS
//  -----------------               -----------------
//  Path    |     Max               Path     |    Max
//  -----------------               -----------------
//  null        null                null        null
//  VALUE       null                VALUE       null
//  null        VALUE               null        VALUE
//  VALUE       VALUE   <<----->>   VALUE       VALUE  <<-----  These two pairs for DIV and SYS, are the ONLY conditions under which vxPP will run
//  -----------------               -----------------           Otherwise, shutdown after the startup check.
var
  retVal: TStrings;
  //slEntities: TStrings;
  thisNow: TDateTime;
begin
  result := true;
  try
    try
      //do parameters exist?
      if vxrpcBrokerV.Connected then
        begin
        retVal := TStringList.Create;
        tCallV(retVal, 'VFDC XPAR GET ALL', ['~VFDVXP PATIENT PIC ROOT']);

        if Piece(retVal[0],'^',1) = '-1' then //rpc error?
          begin
          result := false;
          MessageDlg('Error: Parameter VFDVXP PATIENT PIC ROOT does not exist, or does not have a value.' + CRLF +
            'vxPatientPicture requires that parameter VFDVXP PATIENT PIC ROOT exists, and has a valid value.' + CRLF+CRLF +
            'If you are the vxPatientPicture Administrator, please verify that parameter VFDVXP PATIENT PIC ROOT exists, and has a valid value.' + CRLF+CRLF +
            'Click ''OK'' to close vxPatientPicture.', mtError, [mbOk], 0);
          Application.Terminate;
          Exit;
          Application.ProcessMessages;
          end
        else
          if retVal.Count < 2 then //Only DIV =or= SYS is defined
            begin
            if Piece(retVal[0],'^',1) = 'DIV' then
              begin
              FDIVroot := Piece(retVal[0],'^',3);
              if DirectoryExists(FDIVroot) then  //make sure the specified directory physically exists
                begin
                self.FPictureLocation := FDIVroot;
                self.RootDirectory := FDIVroot;
                end
              else
                begin
                result := false;
                MessageDlg('Error: The directory ' + FDIVroot + ' does not exist.' + CRLF +
                            'If ''Division'' has a value for parameter ''VFDVXP PATIENT PIC ROOT'', vxPatientPicture requires that the specified directory exists.' + CRLF+CRLF +
                            'If you are the vxPatientPicture Administrator, please verify that the root directory specified for parameter VFDVXP PATIENT PIC ROOT, ''Division'', exists and has a valid value.' + CRLF+CRLF +
                            'Click ''OK'' to close vxPatientPicture.', mtError, [mbOk], 0);
                Application.Terminate;
                Exit;
                Application.ProcessMessages;
                end;
              end
            else
              if Piece(retVal[0],'^',1) = 'SYS' then
                begin
                FSYSroot := Piece(retVal[0],'^',3);
                if DirectoryExists(FSYSroot) then //make sure the specified directory physically exists
                  begin
                  self.FPictureLocation := FSYSroot;
                  self.RootDirectory := FSYSroot;
                  end
                else
                  begin
                  result := false;
                  MessageDlg('Error: The directory ' + FSYSroot + ' does not exist.' + CRLF +
                              'If ''System'' has a value for parameter ''VFDVXP PATIENT PIC ROOT'', vxPatientPicture requires that the specified directory exists.' + CRLF+CRLF +
                              'If you are the vxPatientPicture Administrator, please verify that the root directory specified for parameter VFDVXP PATIENT PIC ROOT, ''System'', exists and has a valid value.' + CRLF+CRLF +
                              'Click ''OK'' to close vxPatientPicture.', mtError, [mbOk], 0);
                  Application.Terminate;
                  Exit;
                  Application.ProcessMessages;
                  end;

                end
            end
          else //Both DIV =and= SYS are defined
            begin
            FDIVroot := Piece(retVal[0],'^',3);
            FSYSroot := Piece(retVal[1],'^',3);
            self.FPictureLocation := FDIVroot; //DIV takes precedence
            self.RootDirectory := FDIVroot; //DIV takes precedence
            end;

        retVal.Clear;
        tCallV(retVal, 'VFDC XPAR GET ALL', ['~VFDVXP PATIENT PIC MAX IMAGES']);

        if Piece(retVal[0],'^',1) = '-1' then
          begin
          result := false;
          MessageDlg('Error: Parameter VFDVXP PATIENT MAX IMAGES does not exist, or does not have a value.' + CRLF +
            'vxPatientPicture requires that parameter VFDVXP PATIENT MAX IMAGES exists, and has a valid value.' + CRLF+CRLF +
            'If you are the vxPatientPicture Administrator, please verify that parameter VFDVXP PATIENT MAX IMAGES exists, and has a valid value.' + CRLF+CRLF +
            'Click ''OK'' to close vxPatientPicture.', mtError, [mbOk], 0);
          Application.Terminate;
          Exit;
          Application.ProcessMessages;
          end
        else
          if retVal.Count < 2 then //Only DIV =or= SYS is defined
            begin
            if Piece(retVal[0],'^',1) = 'DIV' then
              FDIVmax := Piece(retVal[0],'^',3)
            else
              if Piece(retVal[0],'^',1) = 'SYS' then
                FSYSmax := Piece(retVal[0],'^',3);
            end
          else //Both DIV =and= SYS are defined
            begin
            FDIVmax := Piece(retVal[0],'^',3);
            FSYSmax := Piece(retVal[1],'^',3);
            end;
        end;

    finally
      //Check for the existence of at least one subdirectory under the root.
      //If there isn't one, then create one. Otherwise, vxPP will not be
      //able to 'Accept' the very first image after an install since
      //procedure TfmMain.WritePathAndFilename() writes to the last
      //subdirectory!  If there isn't one, there's nowhere to write to.
      if not self.SubdirectoriesExist(self.RootDirectory) then
        begin
        thisNow := Now; //'Now' is always changing. So, we need a "stable" time value, one that won't change during the coming function call.
        if not CreateDir(IncludeTrailingPathDelimiter(self.FPictureLocation) + 'vxp_' + FloatToStr(thisNow)) then
          begin
          raise Exception.Create('An exception has occurred in StartupCheck()' + CRLF + CRLF +
                                 'Cannot create initial image subdirectory under the image root directory, ' + self.RootDirectory + CRLF + CRLF +
                                 'Please contact your vxPatientPicture Administrator.' + CRLF + CRLF +
                                 'vxPatientPicture will now shutdown.');
          if retVal <> nil then
            retVal.Free;
          Application.Terminate;
          //Application.ProcessMessages;
          end;

        if retVal <> nil then
          retVal.Free;
        end;
    end;
  except
    on E: Exception do
      MessageDlg('An exception has occurred in TfmMain.StartupCheck()' + CRLF +
                E.Message, mtError, [mbOk], 0);
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
////////////////////////////////////////////////////////////////////////
// We don't need this now, since we are limiting max files to 100,000 //
////////////////////////////////////////////////////////////////////////
var
  //defResolution: integer;
  thisResolution: integer;
begin
  self.Visible := false;

  try
    self.FIniFile := TIniFile.Create(ChangeFileExt( Application.ExeName, '.ini'));
    thisResolution := self.FIniFile.ReadInteger('RESOLUTION', 'resolution', 2);
    case thisResolution of
      0:   me100x75.Checked := true;
      1:   me200x150.Checked := true;
      2:   me400x300.Checked := true;
    end;
  finally
    if self.FIniFile <> nil then
      self.FIniFile.Free;
  end;

  self.InitialPatientSelect := true; //defect 69

  {$IFDEF WIN32}
    {$IFDEF Debug}
    //FMaxFilesPerDirectory := MAX_FILES;
    {$ELSE}
    //FMaxFilesPerDirectory := $186A0; //100,000  //$EE6B2800;  //4,000,000,000d - NOTE: actual max is 4,294,967,295
    //self.MaxFiles := $186A0; //100,000  //$EE6B2800;  //4,000,000,000d - NOTE: actual max is 4,294,967,295
    {$ENDIF}
  {$ENDIF}

  
  {$IFDEF linux}
    {$IFDEF Debug}
    //FMaxFilesPerDirectory := MAX_FILES;
    //self.MaxFiles := MAX_FILES;
    {$ELSE}
    //FMaxFilesPerDirectory := $186A0; //100,000  //$EE6B2800;  //4,000,000,000d - NOTE: actual max is 4,294,967,295 - This assumes Linux 'ext4' file system
    //self.MaxFiles := $186A0; //100,000  //$EE6B2800;  //4,000,000,000d - NOTE: actual max is 4,294,967,295 - This assumes Linux 'ext4' file system
    {$ENDIF}
  {$ENDIF}

  FSavedImage := TImage.Create(nil); //init
  self.Accepted := false; //init

  currentPatientDFN := ''; //init
  slPatientInfo := TStringList.Create;

  if meHintsOn.Checked then
    Application.ShowHint := true
  else
    Application.ShowHint := false;

  imPreview.Height := IMPREVIEW_INIT_HEIGHT;
  imPreview.Width := IMPREVIEW_INIT_WIDTH;

  lastLoginHadMenuOption := false;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  if FSavedImage <> nil then
    FSavedImage.Free;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  Application.ProcessMessages;
  self.BringToFront;
  Application.ProcessMessages;
  self.buLogonClick(Sender);

  /////////////// Defect 66 ////////////////////////////////////////////////
  try
    if not rCore.HasMenuOptionAccess(CONTEXT_NAME) then
      //do nothing
  except
      MessageDlg(MUST_HAVE_MENU_OPTION + CONTEXT_NAME +
        CRLF + 'Click ''OK'' to exit...', mtInformation, [mbOK], 0);
      //User does not have VFDVXP PATIENT PIC CONTEXT
      //Trap the broker error and shut down.
      tscap321.Connected := false;
      if vxRPCBrokerV <> nil then
        begin
        vxRPCBrokerV.Connected := false;
        FreeAndNil(vxRPCBrokerV);
        end;
      Application.ProcessMessages;
      Application.Terminate;
  end;
  /////////////// end Defect 66 ////////////////////////////////////////////////

  if ((rCore.HasMenuOptionAccess(CONTEXT_NAME)) and (vxRPCBrokerV.Connected)) then
    buCaptureImage.Enabled := buLogoff.Enabled;

  if User.HasKey(VXPP_ADMIN_KEY) then
    meAdmin.Visible := true
  else
    meAdmin.Visible := false;

  buDeleteImage.Enabled := false;

  if FDIVmax <> '' then
    self.MaxFilesDIV := strToInt(FDIVMax)
  else
    if FSYSmax <> '' then
      self.MaxFilesSYS := strToInt(FSYSmax);

  {$IFDEF Debug}
    MessageDlg('vxPatientPicture is running in Debug mode.' + CRLF + 'Max # image files per directory = ' +
                intToStr(self.MaxFiles), mtInformation, [mbOK], 0);
  {$ENDIF}
end;

function NormalizeRect(aRect: TRect): TRect;
var 
  i: integer;
begin
  try
    result:= aRect;
    with Result do
      begin
      if Right < Left then
        begin
        i:= Right;
        Right:= Left;
        Left:= i;
        end;
      if Bottom < Top then
        begin
        i:= Top;
        Top:= Bottom;
        Bottom:= i;
        end;
      end;
  except
    on E: EInvalidGraphicOperation do
      MessageDlg('Graphics error in function NormalizeRect()' + CRLF +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfmMain.RestoreImage(Sender: TObject);
var
  tempList: TStrings;
begin
    WritePathAndFilename(self.FSavedPatientPicturePath); //FM FILER
    buDeleteImage.Caption := DELETE_BUTTON_CAPTION;
    buDeleteImage.Enabled := false;

    try
      templist := TStringList.Create;
      if ((DirectoryExists(self.FPictureLocation)) and (SubDirectoriesExist(self.FPictureLocation))) then
        tCallV(templist, 'VFDC DDR GETS ENTRY DATA', ['2', DSSPtSel.DFN, VXPP_FIELD_NUMBER, '']);
    except
      on E: EListError do
        begin
          //do nothing - silent exception
        end;
    end;

      try
        try
          {$IFDEF WIN32}
          if ((DirectoryExists(self.FPictureLocation)) and (SubDirectoriesExist(self.FPictureLocation)) and (FileExists(self.FPictureLocation + '\' + Piece(tempList[0],'^',4)))) then
          {$ENDIF}
           {$IFDEF linux}
           if ((DirectoryExists(self.FPictureLocation)) and (SubDirectoriesExist(self.FPictureLocation)) and (FileExists(self.FPictureLocation + '/' + Piece(tempList[0],'^',4)))) then
           {$ENDIF}
            begin
            {$IFDEF WIN32}
            self.fs := TFileStream.Create(self.FPictureLocation + '\' + Piece(tempList[0],'^',4), fmOpenRead or fmShareDenyNone);
            {$ENDIF}
            {$IFDEF linux}
            self.fs := TFileStream.Create(self.FPictureLocation + '/' + Piece(tempList[0],'^',4), fmOpenRead or fmShareDenyNone);
            {$ENDIF}
            self.OleGraphic := TOleGraphic.Create;
            self.OleGraphic.LoadFromStream(self.fs);
            imPreview.Picture.Assign(self.OleGraphic);
            //MessageDlg('Previous patient picture restored.', mtInformation, [mbOk], 0);                                               
            end
          else
            begin
            imPreview.Height := STD_HEIGHT;
            imPreview.Width := STD_WIDTH;
            imPreview.Picture.Bitmap.LoadFromResourceName(hInstance,'NoImageAvailable');
            end;
        except
          on E: EListError do
            begin
              //do nothing - silent exception
            end;
        end;
      except
        on E: EOleError do
          MessageDlg('Error loading OleGraphic in procedure TfmMain.RestoreImage().' + CRLF + E.Message, mtError, [mbOK], 0);
      end;

    tempList.Free;
end;

procedure TfmMain.buDeleteImageClick(Sender: TObject);
var
  tempList: TStrings;
  slInput: TStrings;
  thisFile: string;
begin
    if MessageDlg('This action will delete this image.' + CRLF+CRLF +
      'Are you sure?', mtWarning, [mbYes, mbNo], 0) = mrNo then
      Exit;

    self.FPictureLocation := self.RootDirectory;

    try
      templist := TStringList.Create;
      slInput := TStringList.Create;

        buAccept.Enabled := false;
        tCallV(templist, 'VFDC DDR GETS ENTRY DATA', ['2', DSSPtSel.DFN, VXPP_FIELD_NUMBER, '']); //Delete the file from it's directory location

        thisFile := IncludeTrailingBackslash(self.RootDirectory) + Piece(tempList[0], '^', 4);
        //If there is a patient picture file at the path in the patient record, Delete it
        if FileExists(thisFile) then
          begin
          DeleteFile(thisFile); //Delete the file from it's directory location
          Application.ProcessMessages;
          end;

        slInput.Add(VXPP_FIELD_NUMBER + '^^');  //<<------- write null to field 21603.01 to remove any <path>\<filename>.jpg that was there
        tCallV(slInput,'VFDC FM FILER', [2, currentPatientDFN + ',', '', slinput]);

        if Piece(slInput[0],'^',1) = '-1' then  //rpc call failed
            MessageDlg('''Delete'' failed.  No image deleted.', mtError, [mbOk], 0) //rpc call failed
        else
          begin
          imPreview.Picture := nil;
          MessageDlg('Success.', mtInformation, [mbOK], 0); //rpc call succeeded
          end;

        //Delete all the TEMP images for this patient, if they exist...from the CLIENT (same directory as the .exe)
        if FileExists(currentPatientDFN + '_TEMP' + '.bmp') then
          DeleteFile(currentPatientDFN + '_TEMP' + '.bmp');

        if FileExists(currentPatientDFN + '_TEMP' + '.jpg') then
          DeleteFile(currentPatientDFN + '_TEMP' + '.jpg');

        imPreview.Height := STD_HEIGHT;
        imPreview.Width := STD_WIDTH;
        imPreview.Picture.Bitmap.LoadFromResourceName(hInstance,'NoImageAvailable');
    except
      on E: EInOutError	do
        MessageDlg('File I/O Error in fmMain.buDeleteImageClick()', mtError, [mbOK], 0);
    end;

    if tempList <> nil then
      FreeAndNil(tempList);

    if slInput <> nil then
      FreeAndNil(slInput);

    buDeleteImage.Enabled := false; //disallow clicking 'Delete' button after a previous delete. Must Capture again before next delete.
    Application.ProcessMessages;
end;

procedure TfmMain.buConnectDisconnectClick(Sender: TObject);
begin
  try
    tscap321.Connected := Not tscap321.Connected;
  if tscap321.Connected then
    begin
    buCaptureImage.Enabled := true;
    buConnectDisconnect.Caption := 'Disconn&ect Camera';
    sbStatusBar.Panels[0].Text := CAMERA_CONNECTED;
    end
  else
    begin
    buCaptureImage.Enabled := false;
    buConnectDisconnect.Caption := 'C&onnect Camera';
    sbStatusBar.Panels[0].Text := CAMERA_DISCONNECTED;
    end;
  except
    MessageDlg('An exception has occurred in fmMain.buConnectDisconnectClick().', mtError, [mbOK], 0);
  end;
end;

procedure TfmMain.buStartAVICaptureClick(Sender: TObject);
begin
  //tscap321.CapOrder := start;
end;

procedure TfmMain.buStopAVICaptureClick(Sender: TObject);
begin
  //tscap321.CapOrder := stop;
end;

procedure TfmMain.buCropImageClick(Sender: TObject);
begin
  fmEnlarge.Image1.Top := fEnlarge.DEFAULT_TOP;
  fmEnlarge.Image1.Left := fEnlarge.DEFAULT_LEFT;
  fmEnlarge.Image1.Width := fEnlarge.DEFAULT_WIDTH;
  fmEnlarge.Image1.Height := fEnlarge.DEFAULT_HEIGHT;

  fmEnlarge.buUndo.Enabled := false; //Defect 102
  self.FPictureLocation := self.RootDirectory;

  try
    //We can use LoadFromFile here, since we're just loading a *local* .bmp file
    //When we are retrieving images over the network, we use a TOleGraphic and TFileStream
    fmEnlarge.Image1.Picture.LoadFromFile(currentPatientDFN + '_TEMP' + '.bmp');
  except
    on E: EInvalidGraphic do
      MessageDlg('Error attempting to load an invalid graphic image in fmMain.buCropImageClick().' + CRLF +
        E.Message, mtError, [mbOK], 0);
  end;
  
  fmEnlarge.ShowModal;
end;

procedure TfmMain.buCloseClick(Sender: TObject);
var
  Rec: TSearchRec;
begin
  imPreview.Picture := nil;
  StaticText1.Caption := '';
  buLogoff.Enabled := false;
  buPtSel.Enabled := false;
  buAccept.Enabled := false;
  buCropImage.Enabled := false;
  buConnectDisconnect.Enabled := false;
  buCaptureImage.Enabled := false;
  Application.ProcessMessages;  

  try
    sbStatusBar.Panels[0].Text := 'Disconnecting camera...';
    tscap321.Connected := false;
    sbStatusBar.Panels[0].Text := CAMERA_DISCONNECTED;
    Application.ProcessMessages;
  except
    sbStatusBar.Panels[0].Text := 'Error disconnecting camera.';
    Application.ProcessMessages;
  end;

  if ((vxrpcBrokerV <> nil) and (vxrpcBrokerV.Connected)) then
    fmMain.buLogoffClick(Sender);

  sbStatusBar.Panels[1].Text := 'Closing vxPatientPicture.  Please wait...';
  Application.ProcessMessages;

  //delete the .bmp image file if it exists(we don't need it anymore)
  self.FPictureLocation := self.RootDirectory;

  try
    if DSSPtSel <> nil then
      begin
      DeleteFile(self.FPictureLocation + currentPatientDFN + '_TEMP' + DSSPtSel.DFN + '.bmp');
      DeleteFile(self.FPictureLocation + currentPatientDFN + '_TEMP' + DSSPtSel.DFN + '.jpg');
      DeleteFile(self.FPictureLocation + currentPatientDFN + 'UNDO_' + DSSPtSel.DFN + '.jpg');
      end;

    //////////////////////////  Defect 104 - Moved to here from vxPPExitProc() //////////////////////
    //Delete any lingering .JPG files that may still exist in the vxPP application directory,
    //due to any earlier call to Application.Terminate
    if FindFirst('*.JPG', faDirectory, Rec) = 0 then
     try
       repeat
        if ( Rec.Name <> '.') and (Rec.Name <> '..') then
          DeleteFile(Rec.Name);
       until FindNext(Rec) <> 0;
     finally
       FindClose(Rec);
     end;

    //Delete any lingering .BMP files that may still exist in the vxPP application directory,
    //due to any earlier call to Application.Terminate
    if FindFirst('*.BMP', faDirectory, Rec) = 0 then
     try
       repeat
        if (Rec.Name <> '.') and (Rec.Name <> '..') then
          DeleteFile(Rec.Name);
       until FindNext(Rec) <> 0;
     finally
       FindClose(Rec);
     end;      
     ///////////////////////// end Defect 104 //////////////////////////////////////
  except
    on E: EInOutError	do
      MessageDlg('File I/O Error in fmMain.buCloseClick()', mtError, [mbOK], 0);
  end;

  meExitClick(Sender);
end;

initialization
  ExitSave := ExitProc; //save the original vector
  ExitProc := @vxPPExitProc;
end.
