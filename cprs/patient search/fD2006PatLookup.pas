unit fD2006PatLookup;

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
  Dialogs, Buttons, StdCtrls, uPtSel, ORNet, ORFn, Trpcb, vxrpcBroker;

type
  TfmPatientLookup = class(TForm)
    StaticText1: TStaticText;
    buLogon: TSpeedButton;
    buLogoff: TSpeedButton;
    buPtSel: TSpeedButton;
    buSearch: TButton;
    procedure buLogonClick(Sender: TObject);
    procedure buLogoffClick(Sender: TObject);
    procedure buPtSelClick(Sender: TObject);
    procedure buSearchClick(Sender: TObject);
  private
    { Private declarations }
    DSSPtSel : TDSSPtLookup;
  public
    { Public declarations }
  end;

var
  fmPatientLookup: TfmPatientLookup;

implementation

//uses USearch;

{$R *.dfm}

procedure TfmPatientLookup.buSearchClick(Sender: TObject);
begin
{
  if (DSSPtSel <> nil) then
    begin
    if DSSPtSel.DFN = '' then
      Exit
    else
      frmSearch.Show;
    end;
}
end;

procedure TfmPatientLookup.buLogonClick(Sender: TObject);
begin
 //if (DSSRPCBroker1.Execute) then //kw - commented
// RPCBroker1.Connected := true; //kw
// if (RPCBroker1.Connected) then //kw - added
  vxRPCBrokerV.Connected := True;
  if (vxRPCBrokerV.Connected) then
  begin
    buLogon.Enabled := false;
    buLogoff.Enabled := true;
    buPtSel.Enabled := true;
  end;
end;

procedure TfmPatientLookup.buLogoffClick(Sender: TObject);
begin
 //DSSRPCBroker1.Connected := false; //kw - commented
// RPCBroker1.Connected := false; //kw - added
  vxRPCBrokerV.Connected := False;
  buLogoff.Enabled := false;
  buPtSel.Enabled := false;
  buLogon.Enabled := true;
  if Assigned(DSSPtSel) then
  begin
    DSSPtSel.Free;
    DSSPtSel := nil;
  end;
end;

procedure TfmPatientLookup.buPtSelClick(Sender: TObject);
var
 slPatientInfo : TStringList;
begin
 if not(Assigned(DSSPtSel)) then
  //DSSPtSel := TDSSPtLookup.Create(DSSRPCBroker1, Font); //kw - commented
  //DSSPtSel := TDSSPtLookup.Create(RPCBroker1, Font); //kw - added
  DSSPtSel := TDSSPtLookup.Create(vxRPCBrokerV, Font);

  if (DSSPtSel.Execute) then
  begin
    slPatientInfo := TStringList.Create;
    slPatientInfo.Add(DSSPtSel.Name);
    slPatientInfo.Add(DSSPtSel.DFN);
    slPatientInfo.Add(DSSPtSel.SSN);
    slPatientInfo.Add(DSSPtSel.Sex);
    slPatientInfo.Add(DSSPtSel.CWAD);
    slPatientInfo.Add(DSSPtSel.DSSAge);
    slPatientInfo.Add(DSSPtSel.WardService);
    slPatientInfo.Add(DSSPtSel.PrimaryTeam);
    slPatientInfo.Add(DSSPtSel.PrimaryProvider);
    slPatientInfo.Add(DSSPtSel.Attending);
    slPatientInfo.Add(DSSPtSel.ICN);
    slPatientInfo.Add(DSSptSel.MRN);
    StaticText1.Caption := slPatientInfo.Text;
    slPatientInfo.Free;
  end
  else
  begin
    StaticText1.Caption := '';
  end;
end;

end.
