unit fPatientFlagMulti;

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
  Dialogs, StdCtrls, fAutoSz, ORCtrls, ExtCtrls, ComCtrls, rMisc;

type
  TfrmFlags = class(TfrmAutoSz)
    Splitter1: TSplitter;
    Panel1: TPanel;
    btnClose: TButton;
    Panel2: TPanel;
    lblFlags: TLabel;
    lstFlags: TORListBox;
    memFlags: TCaptionMemo;
    procedure lstFlagsClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FFlagID: integer;
  public
    { Public declarations }
  end;

procedure ShowFlags(FlagId: integer = 0);

implementation

uses uCore,uOrPtf,ORFn;
{$R *.dfm}

procedure ShowFlags(FlagId: integer);
var
  frmFlags: TfrmFlags;
begin
  frmFlags := TFrmFlags.Create(Nil);
  try
    //SetFormPosition(frmFlags); //kw commented
    if HasFlag then
    begin
      //SetFormPosition(frmFlags); //kw commented
      frmFlags.FFlagID := FlagId;
      frmFlags.lstFlags.Items.Assign(FlagList);
      frmFlags.memFlags.SelStart := 0;
      //ResizeFormToFont(TForm(frmFlags));
      frmFlags.ShowModal;
    end
  finally
    frmFlags.Release;
  end;
end;

procedure TfrmFlags.lstFlagsClick(Sender: TObject);
var
  FlagArray: TStringList;
begin
  if lstFlags.ItemIndex >= 0 then
  begin
    FlagArray := TStringList.Create;
    GetActiveFlg(FlagArray, Patient.DFN, lstFlags.ItemID);
    if FlagArray.Count > 0 then
      memFlags.Lines.Assign(FlagArray);
    memFlags.SelStart := 0;
  end;
end;

procedure TfrmFlags.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFlags.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;


procedure TfrmFlags.FormShow(Sender: TObject);
var
  idx: integer;
begin
  inherited;
  idx := 0;
  if FFlagID > 0 then idx := lstFlags.SelectByIEN(FFlagId);
  lstFlags.ItemIndex := idx;
  lstFlagsClick(Self);
  ActiveControl := memFlags;
end;

procedure TfrmFlags.FormCreate(Sender: TObject);
begin
  inherited;
  FFlagID := 0;
end;

procedure TfrmFlags.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  //SaveUserBounds(Self);  //kw commented
end;



end.
