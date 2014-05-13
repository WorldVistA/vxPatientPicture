unit fPtSel;

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

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ExtCtrls, ORFn, ORNet, ORDtTmRng, Gauges, Menus, ComCtrls,
  Buttons, JvExButtons, JvButtons, AxCtrls, ComObj{,UBAGlobals, UBACore};

type
  TfrmPtSel = class(TForm)
    pnlPtSel: TORAutoPanel;
    cboPatient: TORComboBox;
    lblPatient: TLabel;
    cmdSaveList: TJvHTButton;
    cmdOK: TJvHTButton;
    cmdCancel: TJvHTButton;
    imPreview: TImage;
    procedure cboPatientChange(Sender: TObject);
    procedure cboPatientKeyPause(Sender: TObject);
    procedure cboPatientMouseClick(Sender: TObject);
    procedure cboPatientEnter(Sender: TObject);
    procedure cboPatientExit(Sender: TObject);
    procedure cboPatientNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboPatientDblClick(Sender: TObject);
    procedure cmdSaveListClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pnlPtSelResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cboPatientKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    function DupLastSSN(const DFN: string): Boolean;
    procedure lstFlagsClick(Sender: TObject);
    procedure lstFlagsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    fs: TFileStream; //kw added
    OleGraphic: TOleGraphic; //kw added
    FsortCol: integer;
    FsortAscending: boolean;
    //FLastPt: string; //kw moved to public
    procedure AdjustFormSize(ShowNotif: Boolean; FontSize: Integer);
    procedure ClearIDInfo;
    procedure ShowIDInfo;
    procedure ShowFlagInfo;
    procedure SetCaptionTop;
    procedure SetPtListTop(IEN: Int64);
    procedure RPLDisplay;
  public
    FLastPt: string; //kw moved here from private
    FPatientDFN: string;
    procedure Loaded; override;
    //property PatientDFN: string read FPatientDFN write FPatientDFN;
  end;

procedure SelectPatient(ShowNotif: Boolean; FontSize: Integer);

var
  frmPtSel: TfrmPtSel;
  FDfltSrc, FDfltSrcType: string;
  IsRPL, RPLJob, DupDFN: string;                 // RPLJob stores server $J job number of RPL pt. list.
  RPLProblem: boolean;                           // Allows close of form if there's an RPL problem.
  PtStrs: TStringList;
  SortViaKeyboard: boolean;

  PatientDFN: string;

implementation

{$R *.DFM}

uses rCore, uCore, fDupPts, fPtSens, fPtSelDemog, fPtSelOptns, fPatientFlagMulti,
     uOrPtf, {fAlertForward,} rMisc{,  fFrame}, fD2006PatLookup, Unit1;

const
  TX_DGSR_ERR    = 'Unable to perform sensitive record checks';
  TC_DGSR_ERR    = 'Error';
  TC_DGSR_SHOW   = 'Restricted Record';
  TC_DGSR_DENY   = 'Access Denied';
  TX_DGSR_YESNO  = CRLF + 'Do you want to continue processing this patient record?';
  AliasString = ' -- ALIAS';

procedure SelectPatient(ShowNotif: Boolean; FontSize: Integer);
{ displays patient selection dialog (with optional notifications), updates Patient object }
var
  frmPtSel: TfrmPtSel;
begin
  frmPtSel := TfrmPtSel.Create(Application);
  RPLProblem := false;
  try
    with frmPtSel do
    begin
      AdjustFormSize(ShowNotif, FontSize);           // Set initial form size
      FDfltSrc := DfltPtList;
      FDfltSrcType := Piece(FDfltSrc, U, 2);
      FDfltSrc := Piece(FDfltSrc, U, 1);
      if (IsRPL = '1') then                          // Deal with restricted patient list users.
        FDfltSrc := '';
      frmPtSelOptns.SetDefaultPtList(FDfltSrc);
      if RPLProblem then
         begin
          frmPtSel.Release;
          Exit;
        end;
      Notifications.Clear;
//      AlertList;
      ClearIDInfo;
      if (IsRPL = '1') then                          // Deal with restricted patient list users.
        RPLDisplay;                                  // Removes unnecessary components from view.
      ShowModal;
    end;
  finally
    frmPtSel.Release;
  end;
end;

procedure TfrmPtSel.AdjustFormSize(ShowNotif: Boolean; FontSize: Integer);
{ Adjusts the initial size of the form based on the font used & if notifications should show. }
var
  Rect: TRect;
begin
  //ResizeAnchoredFormToFont(self); //kw commented
//  TheFormHeight := pnlPtSel.Height;
  // Make the form bigger (140%) to show notifications and show notification controls.
  if ShowNotif then
  begin
//    TheFormHeight := Round(TheFormHeight * 2.4);
//    pnlDivide.Height := lblNotifications.Height + 4;
//    pnlDivide.Visible := True;
//    lstvAlerts.Visible := True;
//    pnlNotifications.Visible := True;
    //pnlPtSel.BevelOuter := bvRaised; //kw commented
//    ClientHeight := TheFormHeight;
  end
  else
  begin
//    pnlDivide.Visible := False;
//    lstvAlerts.Visible := False;
//    pnlNotifications.Visible := False;
//    ClientHeight := TheFormHeight;
//    pnlPtSel.Anchors := [akLeft,akRight,akTop,akBottom];
  end;
//  ClientHeight := TheFormHeight;
//  VertScrollBar.Range := TheFormHeight;

  //After all of this calcualtion, we still use the saved preferences when possible
  //SetFormPosition(self); //kw commented
  //Rect := BoundsRect;  //kw commented
  //ForceInsideWorkArea(Rect);  //kw commented
  //BoundsRect := Rect;  //kw commented

//lwm20061118  if frmFrame.EnduringPtSelSplitterPos <> 0 then
//lwm20061118    SplitterTop := frmFrame.EnduringPtSelSplitterPos
//lwm20061118  else
//lwm20061118    SetUserBounds2(Name+'.'+sptVert.Name,SplitterTop, t1, t2, t3);
//lwm20061118  if SplitterTop <> 0 then
//lwm20061118    pnlPtSel.Height := SplitterTop;
end;

procedure TfrmPtSel.SetCaptionTop;
{ Show patient list name, set top list to 'Select ...' if appropriate. }
var
  x: string;
begin
  x := '';
  lblPatient.Caption := 'Patients';
  if (not User.IsReportsOnly) then
  begin
  case frmPtSelOptns.SrcType of
  TAG_SRC_DFLT: lblPatient.Caption := 'Patients (' + FDfltSrc + ')';
  TAG_SRC_PROV: x := 'Provider';
  TAG_SRC_TEAM: x := 'Team';
  TAG_SRC_SPEC: x := 'Specialty';
  TAG_SRC_CLIN: x := 'Clinic';
  TAG_SRC_WARD: x := 'Ward';
  TAG_SRC_ALL:  { Nothing };
  end; // case stmt
  end; // begin
  if Length(x) > 0 then with cboPatient do
  begin
    RedrawSuspend(Handle);
    ClearIDInfo;
    ClearTop;
    Text := '';
    Items.Add('^Select a ' + x + '...');
    Items.Add(LLS_LINE);
    Items.Add(LLS_SPACE);
    cboPatient.InitLongList('');
    RedrawActivate(cboPatient.Handle);
  end;
end;

{ List Source events: }

procedure TfrmPtSel.SetPtListTop(IEN: Int64);
{ Sets top items in patient list according to list source type and optional list source IEN. }
var
  NewTopList: string;
  FirstDate, LastDate: string;
begin
  // NOTE:  Some pieces in RPC returned arrays are rearranged by ListPtByDflt call in rCore!
  IsRPL := User.IsRPL;
  if (IsRPL = '') then // First piece in ^VA(200,.101) should always be set (to 1 or 0).
    begin
      InfoBox('Patient selection list flag not set.', 'Incomplete User Information', MB_OK);
      RPLProblem := true;
      Exit;
    end;
  // FirstDate := 0; LastDate := 0; // Not req'd, but eliminates hint.
  // Assign list box TabPosition, Pieces properties according to type of list to be displayed.
  // (Always use Piece "2" as the first in the list to assure display of patient's name.)
  cboPatient.pieces := '2,3'; // This line and next: defaults set - exceptions modifield next.
  cboPatient.tabPositions := '20,28';
  if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and (FDfltSrc = 'Combination')) then
    begin
      cboPatient.pieces := '2,3,4,5,9';
      cboPatient.tabPositions := '20,28,35,45';
    end;
  if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and
      (FDfltSrcType = 'Ward')) or (frmPtSelOptns.SrcType = TAG_SRC_WARD) then
    cboPatient.tabPositions := '35';
  if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and
      (AnsiStrPos(pChar(FDfltSrcType), 'Clinic') <> nil)) or (frmPtSelOptns.SrcType = TAG_SRC_CLIN) then
    begin
      cboPatient.pieces := '2,3,9';
      cboPatient.tabPositions := '24,45';
    end;
  NewTopList := IntToStr(frmPtSelOptns.SrcType) + U + IntToStr(IEN); // Default setting.
  if (frmPtSelOptns.SrcType = TAG_SRC_CLIN) then with frmPtSelOptns.cboDateRange do
    begin
      if ItemID = '' then Exit;                        // Need both clinic & date range.
      FirstDate := Piece(ItemID, ';', 1);
      LastDate  := Piece(ItemID, ';', 2);
      NewTopList := IntToStr(frmPtSelOptns.SrcType) + U + IntToStr(IEN) + U + ItemID; // Modified for clinics.
    end;
  if NewTopList = frmPtSelOptns.LastTopList then Exit; // Only continue if new top list.
  frmPtSelOptns.LastTopList := NewTopList;
  RedrawSuspend(cboPatient.Handle);
  ClearIDInfo;
  cboPatient.ClearTop;
  cboPatient.Text := '';
  if (IsRPL = '1') then                                // Deal with restricted patient list users.
    begin
      RPLJob := MakeRPLPtList(User.RPLList);           // MakeRPLPtList is in rCore, writes global "B" x-ref list.
      if (RPLJob = '') then
        begin
          InfoBox('Assignment of valid OE/RR Team List Needed.', 'Unable to build Patient List', MB_OK);
          RPLProblem := true;
          Exit;
        end;
    end
  else
    begin
      case frmPtSelOptns.SrcType of
      TAG_SRC_DFLT: ListPtByDflt(cboPatient.Items);
      TAG_SRC_PROV: ListPtByProvider(cboPatient.Items, IEN);
      TAG_SRC_TEAM: ListPtByTeam(cboPatient.Items, IEN);
      TAG_SRC_SPEC: ListPtBySpecialty(cboPatient.Items, IEN);
      TAG_SRC_CLIN: ListPtByClinic(cboPatient.Items, frmPtSelOptns.cboList.ItemIEN, FirstDate, LastDate);
      TAG_SRC_WARD: ListPtByWard(cboPatient.Items, IEN);
      TAG_SRC_ALL:  ListPtTop(cboPatient.Items);
      end;
    end;
  if frmPtSelOptns.cboList.Visible then
    lblPatient.Caption := 'Patients (' + frmPtSelOptns.cboList.Text + ')';
  if frmPtSelOptns.SrcType = TAG_SRC_ALL then
    lblPatient.Caption := 'Patients (All Patients)';
  with cboPatient do if ShortCount > 0 then
    begin
      Items.Add(LLS_LINE);
      Items.Add(LLS_SPACE);
    end;
  cboPatient.Caption := lblPatient.Caption;
  cboPatient.InitLongList('');
  RedrawActivate(cboPatient.Handle);
end;

{ Patient Select events: }

procedure TfrmPtSel.cboPatientEnter(Sender: TObject);
begin
  cmdOK.Default := True;
  if cboPatient.ItemIndex >= 0 then
  begin
    ShowIDInfo;
    ShowFlagInfo;
  end;
end;

procedure TfrmPtSel.cboPatientExit(Sender: TObject);
begin
  cmdOK.Default := False;
end;

procedure TfrmPtSel.cboPatientChange(Sender: TObject);
var
  PatientList : TStringList;
  cntr : integer;
  sTmp1 : string;
  sTmp2 : string;
  sTmp3 : string;

    procedure ShowMatchingPatients;
    begin
      with cboPatient do
        begin
          ClearIDInfo;
          if ShortCount > 0 then
            begin
              if ShortCount = 1 then
                begin
                  ItemIndex := 0;
                  ShowIDInfo;
                  ShowFlagInfo;
                end;
              Items.Add(LLS_LINE);
              Items.Add(LLS_SPACE);
            end;
          InitLongList('');
        end;
    end;

begin
  with cboPatient do
  begin
    if ((Length(Text) > 0) and (Text[1] = ' ')) then
    begin
      if ((Length(Text) > 1) and (ItemIndex = -1)) then
      begin
//       LookupPiece := 3;
       PatientList := TstringList.Create;
       sTmp1 := Trim(Text);
       ListPtByAltLookups(PatientList,sTmp1,'','ALTID');
       for cntr := 0 to PatientList.Count-1 do
       begin
        sTmp1 := PatientList[cntr];
        sTmp2 := ' ' + Piece(Piece(sTmp1,U,4),'~',2);
        sTmp3 := Piece(sTmp1,U,2);
        SetPiece(sTmp1,U,3,sTmp3);
        SetPiece(sTmp1,U,2,sTmp2);
        PatientList[cntr] := sTmp1;
       end;
//       Items.Clear;
       Items.Assign(PatientList);
       PatientList.Free;
       ShowMatchingPatients;
      end;
    end
    else
    begin
      LookupPiece := 2;
    end;
    if frmPtSelOptns.IsLast5(Text) then
      begin
        if (IsRPL = '1') then
          ListPtByRPLLast5(Items, Text)
        else
          ListPtByLast5(Items, Text);
        ShowMatchingPatients;
      end
    else if frmPtSelOptns.IsFullSSN(Text) then
      begin
        if (IsRPL = '1') then
           ListPtByRPLFullSSN(Items, Text)
        else
           ListPtByFullSSN(Items, Text);
        ShowMatchingPatients;
      end;
  end;
end;

procedure TfrmPtSel.cboPatientKeyPause(Sender: TObject);
begin
  if Length(cboPatient.ItemID) > 0 then  //*DFN*
  begin
    ShowIDInfo;
    ShowFlagInfo;    
  end else
  begin
    ClearIDInfo;
  end;
end;

procedure TfrmPtSel.cboPatientMouseClick(Sender: TObject);
var
  tempList: TStrings;
begin
  try
    fmMain.FSavedPatientPicturePath := ''; //init
    fmMain.FSavedImage.Picture := nil; //init

    if Length(cboPatient.ItemID) > 0 then   //*DFN*
      begin
        ShowIDInfo;
        ShowFlagInfo;

      try
        templist := TStringList.Create;
        if ((SysUtils.DirectoryExists(fmMain.FPictureLocation)) and (fmMain.SubDirectoriesExist(fmMain.FPictureLocation))) then
          begin
          tCallV(templist, 'VFDC DDR GETS ENTRY DATA', ['2', string(cboPatient.ItemID), VXPP_FIELD_NUMBER, '']);

          {$IFDEF Debug}
          if fmMain.DSSPtSel.DOB = -1 then
            begin
            MessageDlg('Patient ' + fmMain.DSSPtSel.Name + ' has an invalid Date Of Birth.', mtWarning, [mbOK], 0);
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
          if ((DirectoryExists(fmMain.FPictureLocation)) and (fmMain.SubDirectoriesExist(fmMain.FPictureLocation)) and (FileExists(fmMain.FPictureLocation + '\' + Piece(tempList[0],'^',4)))) then
          {$ENDIF}
           {$IFDEF linux}
           if ((DirectoryExists(self.FPictureLocation)) and (SubDirectoriesExist(self.FPictureLocation)) and (FileExists(self.FPictureLocation + '/' + Piece(tempList[0],'^',4)))) then
           {$ENDIF}
            begin
            {$IFDEF WIN32}
            fs := TFileStream.Create(fmMain.FPictureLocation + '\' + Piece(tempList[0],'^',4), fmOpenRead or fmShareDenyNone);
            {$ENDIF}
            {$IFDEF linux}
            fs := TFileStream.Create(self.FPictureLocation + '/' + Piece(tempList[0],'^',4), fmOpenRead or fmShareDenyNone);
            {$ENDIF}

            OleGraphic := TOleGraphic.Create;
            OleGraphic.LoadFromStream(fs);
            imPreview.Picture.Assign(OleGraphic);

            //Save for possible Restore later
            //fmMain.FSavedPatientPicturePath := fmMain.FPictureLocation + '\' + Piece(templist[0],'^',4);
            fmMain.FSavedPatientPicturePath := fmMain.FPictureLocation + Piece(templist[0],'^',4);
            fmMain.FSavedImage.Picture.Assign(OleGraphic);
            end
          else
            imPreview.Picture.Bitmap.LoadFromResourceName(hInstance,'NoImageAvailable');
        except
          on E: EListError do
            begin
              //do nothing - silent exception
            end;
        end;
      except
        on E: EOleError do
          MessageDlg('Error loading OleGraphic in procedure TfrmPtSel.cboPatientMouseClick().' + #13#10 + E.Message, mtError, [mbOK], 0);
      end;

      if tempList <> nil then
        tempList.Free;

      end
    else
      begin
        ClearIDInfo;
      end;
  except
    on E: Exception do
      MessageDlg('An error has occurred in procedure TfrmPtSel.cboPatientMouseClick()' + #13#10#13#10 + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmPtSel.cboPatientDblClick(Sender: TObject);
begin
  if Length(cboPatient.ItemID) > 0 then
    cmdOKClick(Self);  //*DFN*
end;

procedure TfrmPtSel.cboPatientNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
var
  i: Integer;
  NoAlias, Patient: String;
  PatientList: TStringList;
begin

NoAlias := StartFrom;
with Sender as TORComboBox do
  if Items.Count > ShortCount then
    NoAlias := Piece(Items[Items.Count-1], U, 1) + U + NoAlias;
if pos(AliasString, NoAlias)> 0 then
  NoAlias := Copy(NoAlias, 1, pos(AliasString, NoAlias)-1);
PatientList := TStringList.Create;
try
  begin
    if (IsRPL  = '1') then // Restricted patient lists uses different feed for long list box:
      PatientList.Assign(ReadRPLPtList(RPLJob, NoAlias, Direction))
    else
    begin
//      NoAlias := Piece(NoAlias,U,2);
      if NoAlias = '' then
       NoAlias := '@~';
      if (Direction = 1) then
       ListPtByAltLookups(PatientList,NoAlias,'','NAME')
      else
       ListPtByAltLookups(PatientList,NoAlias,'','-NAME')
{
      PatientList.Assign(SubSetOfPatients(NoAlias, Direction));
      for i := 0 to PatientList.Count-1 do  // Add " - Alias" to alias names:
      begin
        Patient := PatientList[i];
        // Piece 6 avoids display problems when mixed with "RPL" lists:
        if (Uppercase(Piece(Patient, U, 2)) <> Uppercase(Piece(Patient, U, 6))) then
        begin
          SetPiece(Patient, U, 2, Piece(Patient, U, 2) + AliasString);
          PatientList[i] := Patient;
        end;
      end;
}
    end;
    cboPatient.ForDataUse(PatientList);
  end;
finally
  PatientList.Free;
end;

end;

procedure TfrmPtSel.ClearIDInfo;
begin
  frmPtSelDemog.ClearIDInfo;
end;

procedure TfrmPtSel.ShowIDInfo;
begin
  frmPtSelDemog.ShowDemog(cboPatient.ItemID);
end;

{ Command Button events: }

procedure TfrmPtSel.cmdOKClick(Sender: TObject);
{ Checks for restrictions on the selected patient and sets up the Patient object. }
const
  DLG_CANCEL = False;
  DGSR_FAIL = -1;
  DGSR_NONE =  0;
  DGSR_SHOW =  1;
  DGSR_ASK  =  2;
  DGSR_DENY =  3;
var
  NewDFN, AMsg: string;  //*DFN*
  AccessStatus: Integer;
  DateDied: TFMDateTime;
begin
if not (Length(cboPatient.ItemID) > 0) then  //*DFN*
  begin
    InfoBox('A patient has not been selected.', 'No Patient Selected', MB_OK);
    Exit;
  end;

  NewDFN := cboPatient.ItemID;  //*DFN*
  if FLastPt <> cboPatient.ItemID then
    begin
      HasActiveFlg(FlagList, HasFlag, cboPatient.ItemID);
      flastpt := cboPatient.ItemID;
    end;

  If DupLastSSN(NewDFN) then    // Check for, deal with duplicate patient data.
    if (DupDFN = 'Cancel') then
      Exit
    else
      NewDFN := DupDFN;

  CheckSensitiveRecordAccess(NewDFN, AccessStatus, AMsg);
  case AccessStatus of
  DGSR_FAIL: begin
               InfoBox(TX_DGSR_ERR, TC_DGSR_ERR, MB_OK);
               Exit;
             end;

  DGSR_NONE: { Nothing - allow access to the patient. };
  DGSR_SHOW: InfoBox(AMsg, TC_DGSR_SHOW, MB_OK);
  DGSR_ASK:  if InfoBox(AMsg + TX_DGSR_YESNO, TC_DGSR_SHOW, MB_YESNO or MB_ICONWARNING or
               MB_DEFBUTTON2) = IDYES then
                  LogSensitiveRecordAccess(NewDFN)
             else Exit;
  else       begin
               InfoBox(AMsg, TC_DGSR_DENY, MB_OK);
               Exit;
             end;
  end;

  DateDied := DateOfDeath(NewDFN);
  if (DateDied > 0) and (InfoBox('This patient died ' + FormatFMDateTime('mmm dd,yyyy hh:nn', DateDied) + CRLF +
     'Do you wish to continue?', 'Deceased Patient', MB_YESNO or MB_DEFBUTTON2) = ID_NO) then
    Exit;

  // 9/23/2002: Code used to check for changed pt. DFN here, but since same patient could be
  //    selected twice in diff. Encounter locations, check was removed and following code runs
  //    no matter; in fFrame code then updates Encounter display if Encounter.Location has changed.
  // NOTE: Some pieces in RPC returned arrays are modified/rearranged by ListPtByDflt call in rCore!
  Patient.DFN := NewDFN;     // The patient object in uCore must have been created already!
  Encounter.Clear;
  Changes.Clear;             // An earlier call to ReviewChanges should have cleared this.

  if (frmPtSelOptns.SrcType = TAG_SRC_CLIN) and (frmPtSelOptns.cboList.ItemIEN > 0) and
    IsFMDateTime(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 4)) then // Clinics, not by default.
    begin
      Encounter.Location := frmPtSelOptns.cboList.ItemIEN;
      with cboPatient do
        Encounter.DateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 4));
    end
  else
      if (frmPtSelOptns.SrcType = TAG_SRC_DFLT) and (DfltPtListSrc = 'C') and
         IsFMDateTime(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 4))then
       with cboPatient do // "Default" is a clinic.
          begin
            Encounter.Location := StrToIntDef(Piece(Items[ItemIndex], U, 10), 0); // Piece 10 is ^SC( location IEN in this case.
            Encounter.DateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 4));
          end
  else
    if ((frmPtSelOptns.SrcType = TAG_SRC_DFLT) and (FDfltSrc = 'Combination') and
           (copy(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 3), 1, 2) = 'Cl')) and
           (IsFMDateTime(Piece(cboPatient.Items[cboPatient.ItemIndex], U, 8))) then
       with cboPatient do // "Default" combination, clinic pt.
          begin
            Encounter.Location := StrToIntDef(Piece(Items[ItemIndex], U, 7), 0); // Piece 7 is ^SC( location IEN in this case.
            Encounter.DateTime := MakeFMDateTime(Piece(Items[ItemIndex], U, 8));
          end
  else
    if Patient.Inpatient then // Everything else:
      begin
        Encounter.Inpatient := True;
        Encounter.Location := Patient.Location;
        Encounter.DateTime := Patient.AdmitTime;
        Encounter.VisitCategory := 'H';
      end;
      
  if User.IsProvider then Encounter.Provider := User.DUZ;

  PatientDFN := cboPatient.ItemID;

  //vxPP
  fmMain.buAccept.Enabled := false; //force crop
  if Assigned(fs) then
    FreeAndNil(fs);
  if Assigned(fmMain.fsBuffer) then
    FreeAndNil(fmMain.fsBuffer);
  //NOT DO THIS - If we do this, we get EInvalidPointer, because fsBuffer has already been free'd.
  //if fmMain.OleGraphicBuffer <> nil then //If we do this, we get EInvalidPointer, because fsBuffer has already been free'd
    //fmMain.OleGraphicBuffer.Free;
  DeleteFile('UNDO_' + fmMain.DSSPtSel.DFN + '.jpg'); //vxPP - CAN'T HAPPEN UNTIL TFileStream is Free'd !!
  Application.ProcessMessages;
  fmMain.FPreviousPatient := PatientDFN; //Get newly selected patient DFN for next Undo filename
  fmMain.InitialPatientSelect := false;  //defect 69
  fmMain.Accepted := false; //defect 69
  fmMain.buAccept.Enabled := false; //defect 69
  fmMain.buCropImage.Enabled := false;
  fmMain.buAccept.Enabled := false;
  fmMain.imPreview.Show;
  //vxPP end

  Close;
end;

procedure TfrmPtSel.cmdCancelClick(Sender: TObject);
begin
  if fmMain.Accepted then
    begin
    fmMain.buAccept.Caption := '&Undo';
    fmMain.buAccept.Enabled := true; //vxPP
    end
  else
    begin
    fmMain.buAccept.Enabled := true;
    fmMain.buAccept.Caption := '&Accept';
    end;

  //fmMain.InitializeImagePreviewSize(Sender);
  imPreview.Height := STD_HEIGHT;
  imPreview.Width := STD_WIDTH;
  fmMain.imPreview.Show;

  // Leave Patient object unchanged
  Close;
end;

procedure TfrmPtSel.cmdSaveListClick(Sender: TObject);
begin
  frmPtSelOptns.cmdSaveListClick(Sender);
end;


procedure TfrmPtSel.FormDestroy(Sender: TObject);
begin
  //SaveUserBounds(Self); //kw commented
//lwm20061118  frmFrame.EnduringPtSelSplitterPos := pnlPtSel.Height;
 end;

procedure TfrmPtSel.pnlPtSelResize(Sender: TObject);
begin
  frmPtSelDemog.Left := cboPatient.Left + cboPatient.Width + 9;
  frmPtSelDemog.Width := pnlPtSel.Width - frmPtSelDemog.Left - 2;
  frmPtSelOptns.Width := cboPatient.Left-8;
end;

procedure TfrmPtSel.Loaded;
begin
  inherited;
// This needs to be in Loaded rather than FormCreate or the TORAutoPanel resize logic breaks.
  frmPtSelDemog := TfrmPtSelDemog.Create(Self);  // Was application - kcm
  with frmPtSelDemog do
  begin
    parent := pnlPtSel;
    Top := 125;
    Left := cboPatient.Left + cboPatient.Width + 9;
    Width := pnlPtSel.Width - Left - 2;
    TabOrder := cmdCancel.TabOrder + 1;  //Place after cancel button
    Show;
  end;

  frmPtSelOptns := TfrmPtSelOptns.Create(Self);  // Was application - kcm
  with frmPtSelOptns do
  begin
    parent := pnlPtSel;
    Top := 4;
    Left := 4;
    Width := cboPatient.Left-8;
    SetCaptionTopProc := SetCaptionTop;
    SetPtListTopProc  := SetPtListTop;
    if RPLProblem then
      Exit;
    TabOrder := cmdSaveList.TabOrder;  //Put just before save default list button
    Show;
  end;
  FLastPt := '';
end;

procedure TfrmPtSel.RPLDisplay;
begin

// Make unneeded components invisible:
cmdSaveList.visible := false;
frmPtSelOptns.visible := false;

end;

procedure TfrmPtSel.FormClose(Sender: TObject; var Action: TCloseAction);
begin

if (IsRPL = '1') then                          // Deal with restricted patient list users.
  KillRPLPtList(RPLJob);                       // Kills server global data each time.
                                               // (Global created by MakeRPLPtList in rCore.)
end;

procedure TfrmPtSel.cboPatientKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = Ord('D')) and (ssCtrl in Shift) then begin
    Key := 0;
    frmPtSelDemog.ToggleMemo;
  end;
end;

function ConvertDate(var thisList: TStringList; listIndex: integer) : string;
{
 CQ1075: Convert date portion from yyyy/mm/dd to mm/dd/yyyy
}
var
  //thisListItem: TListItem;
  thisDateTime: string[16];
  tempDt: string;
  tempYr: string;
  tempTime: string;
  newDtTime: string;
  k: byte;
  piece1: string;
  piece2: string;
  piece3: string;
  piece4: string;
  piece5: string;
  piece6: string;
  piece7: string;
  piece8: string;
  piece9: string;
  piece10: string;
  piece11: string;
begin
  piece1 := '';
  piece2 := '';
  piece3 := '';
  piece4 := '';
  piece5 := '';
  piece6 := '';
  piece7 := '';
  piece8 := '';
  piece9 := '';
  piece10 := '';
  piece11 := '';

  piece1 := Piece(thisList[listIndex],U,1);
  piece2 := Piece(thisList[listIndex],U,2);
  piece3 := Piece(thisList[listIndex],U,3);
  piece4 := Piece(thisList[listIndex],U,4);
  //piece5 := Piece(thisList[listIndex],U,5);
  piece6 := Piece(thisList[listIndex],U,6);
  piece7 := Piece(thisList[listIndex],U,7);
  piece8 := Piece(thisList[listIndex],U,8);
  piece9 := Piece(thisList[listIndex],U,9);
  piece10 := Piece(thisList[listIndex],U,1);

  thisDateTime := Piece(thisList[listIndex],U,5);

  tempYr := '';
  for k := 1 to 4 do
   tempYr := tempYr + thisDateTime[k];

  tempDt := '';
  for k := 6 to 10 do
   tempDt := tempDt + thisDateTime[k];

  tempTime := '';
  //Use 'Length' to prevent stuffing the control chars into the date when a trailing zero is missing
  for k := 11 to Length(thisDateTime) do //16 do
   tempTime := tempTime + thisDateTime[k];

  newDtTime := '';
  newDtTime := newDtTime + tempDt + '/' + tempYr + tempTime;
  piece5 := newDtTime;

  Result := piece1 +U+ piece2 +U+ piece3 +U+ piece4 +U+ piece5 +U+ piece6 +U+ piece7 +U+ piece8 +U+ piece9 +U+ piece10 +U+ piece11;
end;

function TfrmPtSel.DupLastSSN(const DFN: string): Boolean;
var
  i: integer;
  frmPtDupSel: tForm;
begin
  Result := False;

  // Check data on server for duplicates:
  CallV('DG CHK BS5 XREF ARRAY', [DFN]);
  if (RPCBrokerV.Results[0] <> '1') then // No duplicates found.
    Exit;
  Result := True;
  PtStrs := TStringList.Create;
  with RPCBrokerV do if Results.Count > 0 then
  begin
    for i := 1 to Results.Count - 1 do
    begin
      if Piece(Results[i], U, 1) = '1' then
        PtStrs.Add(Piece(Results[i], U, 2) + U + Piece(Results[i], U, 3) + U +
                   FormatFMDateTimeStr('mmm dd,yyyy', Piece(Results[i], U, 4)) + U +
                   Piece(Results[i], U, 5));
    end;
  end;

  // Call form to get user's selection from expanded duplicate pt. list (resets DupDFN variable if applicable):
  DupDFN := DFN;
  frmPtDupSel:= TfrmDupPts.Create(Application);
  with frmPtDupSel do
    begin
      try
        ShowModal;
      finally
        frmPtDupSel.Release;
      end;
    end;
end;

procedure TfrmPtSel.ShowFlagInfo;
begin
  if (Pos('*SENSITIVE*',frmPtSelDemog.lblPtSSN.Caption)>0) then
  begin
//    pnlPrf.Visible := False;
    Exit;
  end;
  if (flastpt <> cboPatient.ItemID) then
  begin
    HasActiveFlg(FlagList, HasFlag, cboPatient.ItemID);
    flastpt := cboPatient.ItemID;
  end;
  if HasFlag then
  begin
//    lstFlags.Items.Assign(FlagList);
//    pnlPrf.Visible := True;
  end
//  else pnlPrf.Visible := False;
end;

procedure TfrmPtSel.lstFlagsClick(Sender: TObject);
begin
{  if lstFlags.ItemIndex >= 0 then
     ShowFlags(lstFlags.ItemID); }
end;

procedure TfrmPtSel.lstFlagsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    lstFlagsClick(Self);
end;

procedure TfrmPtSel.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
{
var
  keyValue: word;
}  
begin{
  keyValue := MapVirtualKey(Key,2);
  if keyValue = VK_RETURN then
     cmdProcessClick(Sender);
}
end;

Initialization
  SortViaKeyboard := false;

end.
