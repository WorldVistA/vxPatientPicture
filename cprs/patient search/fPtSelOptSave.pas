unit fPtSelOptSave;

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
  StdCtrls, ExtCtrls, ORCtrls, ORFn;

type
  TfrmPtSelOptSave = class(TForm)
    pnlClinSave: TPanel;
    rGrpClinSave: TKeyClickRadioGroup;
    lblClinSettings: TMemo;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure rGrpClinSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPtSelOptSave: TfrmPtSelOptSave;

implementation

{$R *.DFM}

uses
  rCore, fPtSelOptns;

procedure TfrmPtSelOptSave.FormCreate(Sender: TObject);
begin
  //ResizeAnchoredFormToFont(self); //kw commented
  self.caption := 'Save Patient List Settings';
  fPtSelOptns.clinDoSave := false; // Initialize.
  fPtSelOptns.clinSaveToday := false;
  lblClinSettings.text := 'Save ' + fPtSelOptns.clinDefaults +
                             CRLF + ' defaults as follows?';
  rGrpClinSave.itemIndex := -1;
//  rGrpClinSave.TabStop := True;
  btnOK.Enabled := False;
end;

procedure TfrmPtSelOptSave.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPtSelOptSave.btnOKClick(Sender: TObject);
begin

if ((rGrpClinSave.itemIndex < 0) or (rGrpClinSave.itemIndex >1)) then
  begin
    InfoBox('No selection made', 'Clinic Save Options', MB_OK);
    exit;
  end;
  if (rGrpClinSave.itemIndex = 0) then
    fPtSelOptns.clinSaveToday := false;
  if (rGrpClinSave.itemIndex = 1) then
    fPtSelOptns.clinSaveToday := true;
  fPtSelOptns.clinDoSave := true;
close;

end;

procedure TfrmPtSelOptSave.rGrpClinSaveClick(Sender: TObject);
var
  Chosen: Boolean;
begin
  Chosen := rGrpClinSave.ItemIndex >= 0;
//  rGrpClinSave.TabStop := not Chosen;
  btnOK.Enabled := Chosen;
end;

end.
