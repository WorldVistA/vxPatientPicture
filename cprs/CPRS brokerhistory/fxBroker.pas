unit fxBroker;
{
Copyright 2012 Document Storage Systems, Inc. 
 
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
  StdCtrls, DateUtils, ORNet, ORFn, {rMisc,} ComCtrls, Buttons, ExtCtrls,
  ORCtrls, ORSystem, fBase508Form, VA508AccessibilityManager, JvDialogs;

type
  TfrmBroker = class(TfrmBase508Form)
    pnlTop: TORAutoPanel;
    lblMaxCalls: TLabel;
    txtMaxCalls: TCaptionEdit;
    cmdPrev: TBitBtn;
    cmdNext: TBitBtn;
    udMax: TUpDown;
    memData: TRichEdit;
    lblCallID: TStaticText;
    btnRLT: TButton;
    btnSaveBrkrHist: TButton;
    jvsvdlgSaveBrkrHist: TJvSaveDialog;
    procedure cmdPrevClick(Sender: TObject);
    procedure cmdNextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnRLTClick(Sender: TObject);
    procedure btnSaveBrkrHistClick(Sender: TObject);
  private
    { Private declarations }
    FRetained: Integer;
    FCurrent: Integer;
  public
    { Public declarations }
  end;

procedure ShowBroker;

implementation

{$R *.DFM}

uses uEncryption; //GKP (removed rCore)

procedure ShowBroker;
var
  frmBroker: TfrmBroker;
begin
  frmBroker := TfrmBroker.Create(Application);
  try
    //ResizeAnchoredFormToFont(frmBroker);  //kw commented
    with frmBroker do
    begin
      FRetained := RetainedRPCCount - 1;
      FCurrent := FRetained;
      LoadRPCData(memData.Lines, FCurrent);
      memData.SelStart := 0;
      lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
      ShowModal;
    end;
  finally
    frmBroker.Release;
  end;
end;

procedure TfrmBroker.cmdPrevClick(Sender: TObject);
begin
  FCurrent := HigherOf(FCurrent - 1, 0);
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
end;

procedure TfrmBroker.btnSaveBrkrHistClick(Sender: TObject);
var
 cntr : integer;
 tmpStr : TStringList;
 strmBrkrHist : TFileStream;
  //GKP
  sPubExp : string;
  sPubMod : string;
begin
 jvsvdlgSaveBrkrHist.InitialDir := '%userprofile%\local settings\my documents';
 jvsvdlgSaveBrkrHist.FileName := 'BrokerHistory.txt';
 jvsvdlgSaveBrkrHist.Filter := 'Text files|*.txt|All files|*.*'; //gkp
 jvsvdlgSaveBrkrHist.DefaultExt := 'txt';                        //gkp
 if (jvsvdlgSaveBrkrHist.Execute) then
 begin
  strmBrkrHist := TfileStream.Create(jvsvdlgSaveBrkrHist.FileName,fmCreate);
  if (assigned(strmBrkrHist)) then
  begin
   tmpStr := TStringList.Create;
   try
    for cntr := FRetained downto 0 do
    begin
      tmpStr.Clear;
      LoadRPCData(tmpStr,cntr);
      if tmpStr.Count > 0 then
      begin
        if (FRetained - cntr <> 0) then
        begin
          tmpStr.Insert(0,'Last Broker Call Minus: ' + IntToStr(FRetained - cntr));
          tmpStr.Insert(0,'');
          tmpStr.Insert(0,'');
          tmpStr.Insert(0,'');
        end
      else
      begin
        tmpStr.Insert(0,'Last Broker Call Minus: 0');
      end;
      tmpStr.SaveToStream(strmBrkrHist);
    end;
   end;

    //GKP Added RSA/AES/SHA-1 encryption piece
    { TODO : change so un-encrypted file is never viewable
             and handle file size over 64k    }
    strmBrkrHist.Free;  //this saves the broker file
//LWM Comment out the following section of code if we are not ready to release the encrypted broker history to the field.
    //grab the receiver's public key to use to Encrypt the file
    //raises exception if key is not found
    if TPGP2Parties.GetReceiverPubKey(sPubExp, sPubMod) then
    begin

     tmpStr.Clear;
     tmpStr.LoadFromFile(jvsvdlgSaveBrkrHist.FileName);
     try
       if FileExists(jvsvdlgSaveBrkrHist.FileName) then
         DeleteFile(jvsvdlgSaveBrkrHist.FileName);
     except
       //eat error
     end;
     //call the Encryption wrapper
     try
       tmpStr.Text := uEncryption.DoFullPGPEncryptionProcessOnText(tmpStr.Text,
                   sPubExp, sPubMod, jvsvdlgSaveBrkrHist.FileName);
     finally
       //leaves PGP2Parties object created so the calling form can use it if needed
       PGP2Parties.Free;
       PGP2Parties := nil;
     end;
    end;
    //note we do not do anything with the returned encrypted tmpStr.text for now
//End area to comment out
   finally
     tmpStr.Free;
     strmBrkrHist := nil;
   end;
  end;
 end;
end;

procedure TfrmBroker.cmdNextClick(Sender: TObject);
begin
  FCurrent := LowerOf(FCurrent + 1, FRetained);
  LoadRPCData(memData.Lines, FCurrent);
  memData.SelStart := 0;
  lblCallID.Caption := 'Last Call Minus: ' + IntToStr(FRetained - FCurrent);
end;

procedure TfrmBroker.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetRetainedRPCMax(StrToIntDef(txtMaxCalls.Text, 5))
end;

procedure TfrmBroker.FormResize(Sender: TObject);
begin
  Refresh;
end;

procedure TfrmBroker.FormCreate(Sender: TObject);
begin
  udMax.Position := GetRPCMax;
end;

procedure TfrmBroker.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TfrmBroker.btnRLTClick(Sender: TObject);
var
  startTime, endTime: tDateTime;
  clientVer, serverVer, diffDisplay: string;
  theDiff: integer;
const
  TX_OPTION  = 'VFDVX CPRS GUI CHART';
//  TX_OPTION  = 'OR CPRS GUI CHART';
  disclaimer = 'NOTE: Strictly relative indicator:';

  function ServerVersion(const Option, VerClient: string): string;
  begin
    Result := sCallV('ORWU VERSRV', [Option, VerClient]);
  end;

begin

clientVer := clientVersion(Application.ExeName); // Obtain before starting.

// Check time lapse between a standard RPC call:
startTime := now;
serverVer :=  serverVersion(TX_OPTION, clientVer);
endTime := now;
theDiff := milliSecondsBetween(endTime, startTime);
diffDisplay := intToStr(theDiff);

// Show the results:
infoBox('Lapsed time (milliseconds) = ' + diffDisplay + '.', disclaimer, MB_OK);

end;

end.
