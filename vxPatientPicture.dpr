program vxPatientPicture;

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

uses
  Forms,
  Windows,
  Unit1 in 'Unit1.pas' {fmMain},
  About in 'About.pas' {frmAbout},
  rMisc in 'cprs\rMisc.pas',
  uCore in 'cprs\uCore.pas',
  uConst in 'cprs\uConst.pas',
  fxBroker in 'cprs\CPRS brokerhistory\fxBroker.pas' {frmBroker},
  uEncryption in 'cprs\CPRS brokerhistory\uEncryption.pas',
  fAutoSz in 'cprs\patient search\fAutoSz.pas' {frmAutoSz},
  fBase508Form in 'cprs\patient search\fBase508Form.pas' {frmBase508Form},
  fPtSelDemog in 'cprs\patient search\fPtSelDemog.pas' {frmPtSelDemog},
  fPtSelOptns in 'cprs\patient search\fPtSelOptns.pas' {frmPtSelOptns},
  uPtSel in 'cprs\patient search\uPtSel.pas',
  fPtSel in 'cprs\patient search\fPtSel.pas' {frmPtSel},
  fPatientFlagMulti in 'cprs\patient search\fPatientFlagMulti.pas' {frmFlags},
  fD2006PatLookup in 'cprs\patient search\fD2006PatLookup.pas' {fmPatientLookup},
  fDupPts in 'cprs\patient search\fDupPts.pas' {frmDupPts},
  rCore in 'cprs\rCore.pas',
  fPtSelOptSave in 'cprs\patient search\fPtSelOptSave.pas' {frmPtSelOptSave},
  uOrPtf in 'cprs\patient search\uOrPtf.pas',
  fEnlarge in 'fEnlarge.pas' {fmEnlarge},
  fAdmin in 'fAdmin.pas' {fmAdmin},
  SysUtils,
  Dialogs,
  fSplash in 'fSplash.pas' {fmSplash},
  fFindingPatientImage in 'fFindingPatientImage.pas' {fmFindingPatientImage};

{$R *.res}

begin
  //Ensure that only ONE single instance of vxPatientPicture can be run at one time.
  //A mutex object coordinates mutually exclusive access to a resource; and only one
  //thread at a time can own the mutex object.  It might look like the code below
  //is leaking a handle because it's not saving the return value of CreateMutex().
  //But, it's not.  Windows will automatically release the handle when vxPatientPicture
  //is terminated, and that's fine.  Used a GUID for the mutex object name, since it is
  //extremely unlikely to be used for anything else.
  hMutex := CreateMutex(nil, true, MUTEX_ID);
  if hMutex = 0 then
    SysUtils.RaiseLastOSError;

  if GetLastError = Windows.ERROR_ALREADY_EXISTS then
    begin
    MessageDlg('An instance of vxPatientPicture is already running.', mtWarning, [mbOK], 0);
    Exit;
    end;

  Application.Initialize;
  Application.Title := 'vxPatientPicture';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmSplash, fmSplash);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfmEnlarge, fmEnlarge);
  Application.CreateForm(TfmAdmin, fmAdmin);
  Application.Run;
end.
  
