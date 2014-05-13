unit uPtSel;

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
 StdCtrls, Graphics, Controls, SysUtils, Trpcb, {vxDSSRPC,}
 Classes, fPtSel, rMisc, uCore, ORNet, ORFn;

type
 TDSSPtLookup = class
 private
  Ffont : TFont;
    FDFN:        string;                         // Internal Entry Number in Patient file  //*DFN*
    FICN:        string;                         // Integration Control Number from MPI
    FName:       string;                         // Patient Name (mixed case)
    FSSN:        string;                         // Patient Identifier (generally SSN)
    FDOB:        TFMDateTime;                    // Date of Birth in Fileman format
    FAge:        Integer;                        // Patient Age
    FSex:        Char;                           // Male, Female, Unknown
    FCWAD:       string;                         // chars identify if pt has CWAD warnings
    FInpatient:  Boolean;                        // True if that patient is an inpatient
    FLocation:   Integer;                        // IEN in Hosp Loc if inpatient
    FWardService: string;
    FSpecialty:  Integer;                        // IEN of the treating specialty if inpatient
    FAdmitTime:  TFMDateTime;                    // Admit date/time if inpatient
    FSrvConn:    Boolean;                        // True if patient is service connected
    FSCPercent:  Integer;                        // Per Cent Service Connection
    FPrimTeam:   string;                         // name of primary care team
    FPrimProv:   string;                         // name of primary care provider
    FAttending:  string;                         // if inpatient, name of attending
    FDateDied: TFMDateTime;                      // Date of Patient Death (<=0 or still alive)
    FDSSAge :    string;                         // DSS Patient Age
    FMRN:        string;                         // DSS Alternate ID
    function GetDateDied: TFMDateTime;       // *DFN*
    procedure LoadValues();
 protected
 published
 public
  //constructor Create(RPCBroker : TvxDSSRPCBroker; Font : TFont);
  constructor Create(RPCBroker : TRPCBroker; Font : TFont);
  destructor Destroy;
  function Execute(): boolean;
    procedure Clear;
    property DFN:              string      read FDFN;  //*DFN*
    property ICN:              string      read FICN;
    property Name:             string      read FName;
    property SSN:              string      read FSSN;
    property DOB:              TFMDateTime read FDOB;
    property Age:              Integer     read FAge;
    property Sex:              Char        read FSex;
    property CWAD:             string      read FCWAD;
    property Inpatient:        Boolean     read FInpatient;
    property Location:         Integer     read FLocation;
    property WardService:      string      read FWardService;
    property Specialty:        Integer     read FSpecialty;
    property AdmitTime:        TFMDateTime read FAdmitTime;
    property DateDied:         TFMDateTime read GetDateDied;
    property ServiceConnected: Boolean     read FSrvConn;
    property SCPercent:        Integer     read FSCPercent;
    property PrimaryTeam:      string      read FPrimTeam;
    property PrimaryProvider:  string      read FPrimProv;
    property Attending:        string      read FAttending;
    property DSSAge:           string      read FDSSAge;
    property MRN:              string      read FMRN;
 end;


implementation

//constructor  TDSSPtLookup.Create(RPCBroker : TvxDSSRPCBroker; Font : TFont);
constructor  TDSSPtLookup.Create(RPCBroker : TRPCBroker; Font : TFont);
begin
 RPCBrokerV := RPCBroker;
 Ffont := Font;
 //SizeHolder := TSizeHolder.Create; //kw commented
 if (not Assigned(User)) then
  User := TUser.Create;
 if (not Assigned(Patient)) then
  Patient := TPatient.Create;
 if (not Assigned(Encounter)) then
  Encounter := TEncounter.Create;
 if (not Assigned(Changes)) then
  Changes := TChanges.Create;
 if (not Assigned(Notifications)) then
  Notifications := TNotifications.Create;
 if (not Assigned(RemoteSites)) then
  RemoteSites := TRemoteSiteList.Create;
 if (not Assigned(RemoteReports)) then
  RemoteReports := TRemoteReportList.Create;
 if (not Assigned(FlagList)) then
  FlagList := TStringList.Create;
end;

destructor TDSSPtLookup.Destroy;
begin
 //SizeHolder.Free; //kw commented
 User.Free;
 Patient.Free;
 Encounter.Free;
 Changes.Free;
 Notifications.Free;
 RemoteSites.Free;
 RemoteReports.Free;
 FlagList.Free;

 inherited Destroy;
end;

function TDSSPtLookup.Execute(): boolean;
var
 CurIFN : string;
begin
  CurIFN := Patient.DFN;
  SelectPatient(False,Ffont.Size);
  if ((CurIFN <> Patient.DFN) and (Patient.DFN <> '')) then
  begin
   Result := true;
   LoadValues;
  end
  else
   Result := false;
end;

procedure TDSSPtLookup.Clear;
{ clears all fields in the Patient object }
begin
 Patient.Clear;
 LoadValues;
end;

function TDSSPtLookup.GetDateDied: TFMDateTime;       // *DFN*
begin
 Result := Patient.DateDied;
end;

procedure TDSSPtLookup.LoadValues();
begin
 FDFN := Patient.DFN;
 FICN := Patient.ICN;
 FName := Patient.Name;
 FSSN := Patient.SSN;
 FDOB := Patient.DOB;
 FAge := Patient.Age;
 FSex := Patient.Sex;
 FCWAD := Patient.CWAD;
 FInpatient := Patient.Inpatient;
 FLocation := Patient.Location;
 FWardService := Patient.WardService;
 FSpecialty := Patient.Specialty;
 FAdmitTime := Patient.AdmitTime;
 FSrvConn := Patient.ServiceConnected;
 FSCPercent := Patient.SCPercent;
 FPrimTeam := Patient.PrimaryTeam;
 FPrimProv := Patient.PrimaryProvider;
 FAttending := Patient.Attending;
 FDSSAge := Patient.DSSAge;
 FMRN := Patient.MRN;
end;

end.
