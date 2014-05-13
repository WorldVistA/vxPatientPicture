unit fDupPts;

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
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ORCtrls, ExtCtrls, OrFn;

type
  TfrmDupPts = class(TForm)
    pnlDupPts: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    pnlSelDupPt: TPanel;
    lboSelPt: TORListBox;
    lblDupPts: TLabel;
    lblSelDupPts: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lboSelPtDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDupPts: TfrmDupPts;

implementation

{$R *.dfm}

uses rCore, uCore, fPtSel;

procedure TfrmDupPts.btnCancelClick(Sender: TObject);
begin

close;

end;

procedure TfrmDupPts.FormCreate(Sender: TObject);
var
  theDups: tStringList;
begin
  fPtSel.DupDFN := 'Cancel'; // Pre-set as default.
  theDups := tStringList.create;
  if fPtSel.PtStrs <> nil then
  theDups.assign(fPtSel.PtStrs);
  lboSelPt.items.assign(theDups);
  //ResizeAnchoredFormToFont(self); //kw commented
end;

procedure TfrmDupPts.btnOKClick(Sender: TObject);
begin

if not (Length(lboSelPt.ItemID) > 0) then  //*DFN*
begin
  infoBox('A patient has not been selected.', 'No Patient Selected', MB_OK);
  exit;
end;

fPtSel.DupDFN := lboSelPt.ItemID;  //*DFN*
close;

end;

procedure TfrmDupPts.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

// Check for "Esc" keypress:
if (key = 27) then // ESC key.
  btnCancel.click;

end;

procedure TfrmDupPts.lboSelPtDblClick(Sender: TObject);
begin
  btnOKClick(btnOK);
end;

end.
