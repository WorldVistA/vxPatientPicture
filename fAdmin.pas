unit fAdmin;

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

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, ExtCtrls, Mask, JvExMask, JvSpin,
  FileCtrl, ORNet, ORFn;

type
  TfmAdmin = class(TForm)
    Panel1: TPanel;
    sbStatusBar: TStatusBar;
    buClose: TButton;
    MainMenu1: TMainMenu;
    meFile: TMenuItem;
    Panel2: TPanel;
    meClose: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    seMaxFilesDIV: TJvSpinEdit;
    Bevel1: TBevel;
    Label4: TLabel;
    edImageRootDirectoryDIV: TEdit;
    Bevel2: TBevel;
    Label5: TLabel;
    buSaveAll: TButton;
    edImageRootDirectorySYS: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    seMaxFilesSYS: TJvSpinEdit;
    Label10: TLabel;
    Label11: TLabel;
    procedure buCloseClick(Sender: TObject);
    procedure meCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure buSaveAllClick(Sender: TObject);
    procedure edImageRootDirectoryDIVChange(Sender: TObject);
    procedure edImageRootDirectorySYSChange(Sender: TObject);
    procedure seMaxFilesDIVChange(Sender: TObject);
    procedure seMaxFilesSYSChange(Sender: TObject);
  private
    AdminValuesSaved: boolean;
    procedure ChanceToSaveAdminValues(Sender: TObject);
  public
    function ValidImageDirectories(Sender: TObject) : boolean;
  end;

const
  DIVISION = 4;
  SYSTEM = 4.2;
  INVALID_DIV_DIRECTORY = '* The directory specified for ''Division'' is invalid *' + #13#10#13#10 +
                              'Please verify that the directory specified for ''Division'' is valid, and that it actually exists.';
  INVALID_SYS_DIRECTORY = '* The directory specified for ''System'' is invalid *' + #13#10#13#10 +
                              'Please verify that the directory specified for ''System'' is valid, and that it actually exists.';

var
  fmAdmin: TfmAdmin;

implementation

uses
  Unit1, uCore;

{$R *.dfm}

procedure TfmAdmin.ChanceToSaveAdminValues(Sender: TObject);
begin
  if not self.AdminValuesSaved then
    begin
    if MessageDlg('One or more fields on this form have changed.' + #13#10#13#10 +
                  'Do you want to save the changes?', mtWarning, [mbYes, mbNo], 0) = mrYes then
      begin
      buSaveAllClick(Sender);
      sbStatusBar.Panels[0].Text := 'Saved';
      end;
    end;
end;

procedure TfmAdmin.edImageRootDirectoryDIVChange(Sender: TObject);
begin
  self.AdminValuesSaved := false;
  sbStatusBar.Panels[0].Text := 'Not saved...';
end;

procedure TfmAdmin.edImageRootDirectorySYSChange(Sender: TObject);
begin
  self.edImageRootDirectoryDIVChange(Sender);
end;

procedure TfmAdmin.seMaxFilesDIVChange(Sender: TObject);
begin
  self.edImageRootDirectoryDIVChange(Sender);
end;

procedure TfmAdmin.seMaxFilesSYSChange(Sender: TObject);
begin
  self.edImageRootDirectoryDIVChange(Sender);
end;

procedure TfmAdmin.buCloseClick(Sender: TObject);
begin
  self.meCloseClick(Sender);
end;

procedure TfmAdmin.buSaveAllClick(Sender: TObject);
begin
  if not self.ValidImageDirectories(Sender) then
    Exit;

  try
    if vxrpcBrokerV.Connected then
      begin
      if ((edImageRootDirectoryDIV.Text = '') and (edImageRootDirectorySYS.Text = '')) then
        begin
        if MessageDlg('*** Missing values for ''Image Root Directories'' for Division and System ***' + #13#10#13#10 +
            'Click ''No'' to cancel this change.' + #13#10#13#10 +
            'If you click ''Yes'', vxPatientPicture will shutdown, and you will be required to manually set values' + #13#10#13#10 +
            'for the parameter ''VFDVXP PATIENT PIC ROOT'' before vxPatientPicture can be run again.',
            mtWarning, [mbYes, mbNo], 0) = mrNo then
          Exit
        else
          begin
          sCallV('VFDC XPAR EDIT', ['DIV' + '~VFDVXP PATIENT PIC ROOT~~@']); //delete the parameter value for Division
          sCallV('VFDC XPAR EDIT', ['SYS' + '~VFDVXP PATIENT PIC ROOT~~@']); //delete the parameter value for System
          vxrpcBrokerV.Connected := false;
          Application.ProcessMessages;
          Application.Terminate;
          Exit;
          Application.ProcessMessages;
          end;
        end;

      if edImageRootDirectoryDIV.Text = '' then
          begin
          sCallV('VFDC XPAR EDIT', ['DIV' + '~VFDVXP PATIENT PIC ROOT~~@']); //delete the parameter value for Division
          fmMain.FDIVroot := '';
          end
        else
          begin
          sCallV('VFDC XPAR EDIT', ['DIV' + '~VFDVXP PATIENT PIC ROOT~~' + IncludeTrailingPathDelimiter(edImageRootDirectoryDIV.Text)]);
          fmMain.RootDirectory := IncludeTrailingPathDelimiter(edImageRootDirectoryDIV.Text);
          fmMain.FPictureLocation := IncludeTrailingPathDelimiter(edImageRootDirectoryDIV.Text);
          fmMain.FDIVroot := fmMain.RootDirectory; //update
          end;

      if edImageRootDirectorySYS.Text = '' then
          begin
          sCallV('VFDC XPAR EDIT', ['SYS' + '~VFDVXP PATIENT PIC ROOT~~@']); //delete the parameter value for System
          fmMain.FSYSroot := ''
          end
        else
          //Write the SYS path
          sCallV('VFDC XPAR EDIT', ['SYS' + '~VFDVXP PATIENT PIC ROOT~~' + IncludeTrailingPathDelimiter(edImageRootDirectorySYS.Text)]);

          //Change the root to SYS, ONLY if edImageRootDirectoryDIV.Text = ''.
          //Otherwise, RootDirectory, FPictureLocation and FSYSroot will overwrite the DIV values
          //and the image will end up getting written to the wrong directory.
          if edImageRootDirectoryDIV.Text = '' then
            begin
            fmMain.RootDirectory := IncludeTrailingPathDelimiter(edImageRootDirectorySYS.Text);
            fmMain.FPictureLocation := IncludeTrailingPathDelimiter(edImageRootDirectorySYS.Text);
            fmMain.FSYSroot := fmMain.RootDirectory; //update
            end;

      //Set Max files per folder
      sCallV('VFDC XPAR EDIT', ['DIV' + '~VFDVXP PATIENT PIC MAX IMAGES~~' + floatToStr(seMaxFilesDIV.Value)]);
      fmMain.MaxFilesDIV := seMaxFilesDIV.Value; //update
      sCallV('VFDC XPAR EDIT', ['SYS' + '~VFDVXP PATIENT PIC MAX IMAGES~~' + floatToStr(seMaxFilesSYS.Value)]);
      fmMain.MaxFilesSYS := seMaxFilesSYS.Value; //update
      end;

      self.AdminValuesSaved := true;
      sbStatusBar.Panels[0].Text := 'Saved.';

  except
    on E: Exception	do
      MessageDlg('An error has occurred in fmAdmin.buSaveAllClick()' + #13#10 +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfmAdmin.FormShow(Sender: TObject);
var
  retVal: TStrings;
begin
  try
    if vxrpcBrokerV.Connected then
      begin
      retVal := TStringList.Create;

      // Examp. return values from VFDC XPAR GET ALL
      //DIV^2956^\\vxQA\vxPatientimages\
      //SYS^1^\\vxQA\vxPatientimages\
      tCallV(retVal, 'VFDC XPAR GET ALL', ['~VFDVXP PATIENT PIC ROOT']);

      //Make sure that the current Admin-user has the same Division number as the Institution IEN (<broker>.User.Division)
      //If they are not the same, then we don't want to allow this Admin to change the path/maxFiles for Division.
      //In other words, we want to ensure that the vxPP GUI Admin can only change the Division image path if the institution IEN matches
      //the division number for the logged in vxPP GUI Admin. Otherwise, they can change only the System path.
      if Piece(retVal[0],'^',1) = '-1' then
        begin
        MessageDlg('Error in call to ''VFDC XPAR GET ALL'', in procedure TfmAdmin.FormShow().', mtError, [mbOK], 0);
        Exit;
        end
      else
        begin
        if Piece(retVal[0],'^',1) = 'DIV' then
          begin
            if Piece(vxrpcBrokerV.User.Division,'^',1) <> Piece(retVal[0],'^',2) then
              begin
              edImageRootDirectoryDIV.Enabled := false;
              seMaxFilesDIV.Enabled := false;
              end
            else
              begin
              edImageRootDirectoryDIV.Enabled := true;
              seMaxFilesDIV.Enabled := true;
              end;
          end;
        end;
      end;

    try
      //Re-populate the Admin boxes on this form by making the rpc calls in StartupCheck().
      //This call is OK to do here, since if there were any invalid info detected in StartupCheck()
      //during initial app startup, we never would have gotten to here. So, since we're here, we assume valid info.
      fmMain.StartupCheck();

      edImageRootDirectoryDIV.Text := fmMain.FDIVroot;
      edImageRootDirectorySYS.Text := fmMain.FSYSroot;

      if fmMain.FDIVmax <> '' then
        seMaxFilesDIV.Value := strToInt(fmMain.FDIVmax)
      else
        seMaxFilesDIV.Value := Unit1.MAX_FILES;

      if fmMain.FSYSmax <> '' then
        seMaxFilesSYS.Value := strToInt(fmMain.FSYSmax)
      else
        seMaxFilesSYS.Value := Unit1.MAX_FILES;
    except
      on E: Exception	do
        begin
        Application.ProcessMessages;
        MessageDlg('An error has occurred in fmAdmin.FormShow()' + #13#10 + E.Message, mtError, [mbOK], 0);
        end;
    end;

    self.AdminValuesSaved := true;
    sbStatusBar.Panels[0].Text := ''; //init
    sbStatusBar.Panels[1].Text := ''; //init
    Application.ProcessMessages;
  except
    on E: Exception do
      MessageDlg('An exception has occurred in TfmAdmin.FormShow()' + #13#10 +
                E.Message, mtError, [mbOk], 0);
  end;
end;

function TfmAdmin.ValidImageDirectories(Sender: TObject) : boolean;
begin
  result := true;

  //Validate that the patient picture directories exist. If don't then
  if edImageRootDirectoryDIV.Text <> '' then
    begin
    sbStatusBar.Panels[1].Text := 'Checking to see if directory for ''Division'' exists...';
    Application.ProcessMessages;                                                                                                               
    if not DirectoryExists(edImageRootDirectoryDIV.Text) then
      begin
      result := false;
      sbStatusBar.Panels[1].Text := '';
      Application.ProcessMessages;
      MessageDlg(INVALID_DIV_DIRECTORY, mtError, [mbOK], 0);
      Exit;
      end;
    end;

  if edImageRootDirectorySYS.Text <> '' then
    begin
    sbStatusBar.Panels[1].Text := 'Checking to see if directory for ''System'' exists...';
    Application.ProcessMessages;
    if not DirectoryExists(edImageRootDirectorySYS.Text) then
      begin
      result := false;
      sbStatusBar.Panels[1].Text := '';
      Application.ProcessMessages;      
      MessageDlg(INVALID_SYS_DIRECTORY, mtError, [mbOK], 0);
      Exit;
      end;
    end;

  if result then
    begin
    sbStatusBar.Panels[1].Text := '';
    Application.ProcessMessages;
    end;
end;

procedure TfmAdmin.meCloseClick(Sender: TObject);
begin
  sbStatusBar.Panels[1].Text := '';
  Application.ProcessMessages;

  if ((not self.ValidImageDirectories(Sender)) or (not self.AdminValuesSaved)) then
    ChanceToSaveAdminValues(Sender);

  ////////////////////////////////////////////////////////////////
  //          vxPatientPicture - Admin "backdoor"               //
  ////////////////////////////////////////////////////////////////
  // If we're running vxPP via Admin "backdoor", then close the app on Close button click
  // so that vxPP does not continue to run from Admin "backdoor" mode. This code ensures
  // that an Admin does not login via the "backdoor", then leave vxPP running for a non-Admin
  // when they are finished Admin'ing. Also see procedure TfmMain.buLogonClick()
  ////////////////////////////////////////////////////////////////
  if UpperCase(ParamStr(1)) = 'ADMIN' then
    begin
    if User.HasKey(VXPP_ADMIN_KEY) then
        begin
        Application.Terminate;
        Exit;
        Application.ProcessMessages;
        end
    end
  else
    Close; //not running from Admin "backdoor"
end;

end.
