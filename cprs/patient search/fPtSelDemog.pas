unit fPtSelDemog;

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls;

type
  TfrmPtSelDemog = class(TForm)
    orapnlMain: TORAutoPanel;
    lblSSN: TStaticText;
    lblPtSSN: TStaticText;
    lblDOB: TStaticText;
    lblPtDOB: TStaticText;
    lblPtSex: TStaticText;
    lblPtVet: TStaticText;
    lblPtSC: TStaticText;
    lblLocation: TStaticText;
    lblPtRoomBed: TStaticText;
    lblPtLocation: TStaticText;
    lblRoomBed: TStaticText;
    lblPtName: TStaticText;
    Memo: TCaptionMemo;
    lblSex: TStaticText;
    lblPtAddress: TStaticText;
    lblPtState: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLastDFN: string;
    FOldWinProc :TWndMethod;
    slIdentifiers : TStringList;
    procedure NewWinProc(var Message: TMessage);
  public
    procedure ClearIDInfo;
    procedure ShowDemog(ItemID: string);
    procedure ToggleMemo;
  end;

var
  frmPtSelDemog: TfrmPtSelDemog;

implementation

uses rCore;

{$R *.DFM}

const
{ constants referencing the value of the tag property in components }
  TAG_HIDE     =  1;                             // labels to be hidden
  TAG_CLEAR    =  2;                             // labels to be cleared

procedure TfrmPtSelDemog.ClearIDInfo;
{ clears controls with patient ID info (controls have '2' in their Tag property }
var
  i: Integer;
begin
  FLastDFN := '';
  with orapnlMain do
  for i := 0 to ControlCount - 1 do
  begin
    if Controls[i].Tag = TAG_HIDE then Controls[i].Visible := False;
    if Controls[i].Tag = TAG_CLEAR then with Controls[i] as TStaticText do Caption := '';
  end;
  Memo.Clear;
end;

procedure TfrmPtSelDemog.ShowDemog(ItemID: string);
{ gets a record of patient indentifying information from the server and displays it }
var
  PtRec: TPtIDInfo;
  i: Integer;
  sPtAddress : string;
  sPtState : string;
  sMRN : string;
begin
  if ItemID = FLastDFN then Exit;
  Memo.Clear;
  FLastDFN := ItemID;
  PtRec := GetPtIDInfo(ItemID);
  //sPtAddress := GetDSSSpecPatientDemog(ItemID, '.111');
  //sPtState := GetDSSSpecPatientDemog(ItemID, '.115');
  //sMRN := GetDSSSpecPatientMRN(ItemID);
  with PtRec do
  begin
    Memo.Lines.Add(Name);
    Memo.Lines.Add(lblSSN.Caption + ' ' + sMRN + '.');
    Memo.Lines.Add(lblDOB.Caption + ' ' + DOB + '.');
    if Sex <> '' then
      Memo.Lines.Add(lblSex.Caption + ' ' + Sex + '.');
    if sPtAddress <> '' then
      Memo.Lines.Add(lblPtVet.Caption + ' ' + sPtAddress + '.');
    if sPtState <> '' then
      Memo.Lines.Add(lblPtSC.Caption + ' ' + sPtState + '.');
    if Location <> '' then
      Memo.Lines.Add(lblLocation.Caption + ' ' + Location + '.');
    if RoomBed <> '' then
      Memo.Lines.Add(lblRoomBed.Caption + ' ' + RoomBed + '.');

    lblPtName.Caption     := Name;
    lblPtSSN.Caption      := sMRN;
    lblPtDOB.Caption      := DOB;
    lblPtSex.Caption      := Sex {+ ', age ' + Age};
    lblPtAddress.Caption  := sPtAddress;
    lblPtState.Caption    := sPtState;
//    lblPtSC.Caption       := SCSts;
//    lblPtVet.Caption      := Vet;
    lblPtLocation.Caption := Location;
    lblPtRoomBed.Caption  := RoomBed;
  end;
  with orapnlMain do for i := 0 to ControlCount - 1 do
    if Controls[i].Tag = TAG_HIDE then Controls[i].Visible := True;
  if lblPtSex.Caption = '' then
    lblSex.Hide
  else
    lblSex.Show;
  if lblPtAddress.Caption = '' then
    lblPtVet.Hide
  else
    lblPtVet.Show;
  if lblPtState.Caption = '' then
    lblPtSC.Hide
  else
    lblPtSc.Show;
  if lblPtLocation.Caption = '' then
    lblLocation.Hide
  else
    lblLocation.Show;
  if lblPtRoomBed.Caption = ''  then
    lblRoomBed.Hide
  else
    lblRoomBed.Show;
  Memo.SelectAll;
end;

procedure TfrmPtSelDemog.ToggleMemo;
begin
  if Memo.Visible then
  begin
    Memo.Hide;
  end
  else
  begin
    Memo.Show;
    Memo.BringToFront;
  end;
end;

procedure TfrmPtSelDemog.FormCreate(Sender: TObject);
begin
  FOldWinProc := orapnlMain.WindowProc;
  orapnlMain.WindowProc := NewWinProc;
  slIdentifiers := TStringList.Create;

end;

procedure TfrmPtSelDemog.NewWinProc(var Message: TMessage);
const
  Gap = 4;

begin
  if(assigned(FOldWinProc)) then FOldWinProc(Message);
  if(Message.Msg = WM_Size) then
  begin
    if(lblPtSSN.Left < (lblSSN.Left+lblSSN.Width+Gap)) then
      lblPtSSN.Left := (lblSSN.Left+lblSSN.Width+Gap);
    if(lblPtDOB.Left < (lblDOB.Left+lblDOB.Width+Gap)) then
      lblPtDOB.Left := (lblDOB.Left+lblDOB.Width+Gap);
    if(lblPtSSN.Left < lblPtDOB.Left) then
      lblPtSSN.Left := lblPtDOB.Left
    else
      lblPtDOB.Left := lblPtSSN.Left;
    lblPtAddress.Left := lblPtSSN.Left;
    lblPtState.Left := lblPtSSN.Left;
    lblPtSex.Left := lblPtSSN.Left;

    if(lblPtLocation.Left < (lblLocation.Left+lblLocation.Width+Gap)) then
      lblPtLocation.Left := (lblLocation.Left+lblLocation.Width+Gap);
    if(lblPtRoomBed.Left < (lblRoomBed.Left+lblRoomBed.Width+Gap)) then
      lblPtRoomBed.Left := (lblRoomBed.Left+lblRoomBed.Width+Gap);
    if(lblPtLocation.Left < lblPtRoomBed.Left) then
      lblPtLocation.Left := lblPtRoomBed.Left
    else
      lblPtRoomBed.Left := lblPtLocation.Left;
  end;
end;

procedure TfrmPtSelDemog.FormDestroy(Sender: TObject);
begin
  orapnlMain.WindowProc := FOldWinProc;
  slIdentifiers.Free;
end;

end.
