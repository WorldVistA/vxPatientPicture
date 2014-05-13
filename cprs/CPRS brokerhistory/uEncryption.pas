unit uEncryption;

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

uses LbCipher, LBRSA, Classes, SysUtils, ORNet, ORClasses, TRPCB;

Type

  //AES is aka RDL (Rijndael)
  TAES = class(TObject)
      Passphrase       : string;
      Key256           : TKey256;
      PlainText        : string;
      CipherText       : string;
      procedure Encrypt;
      procedure Decrypt;
    private
      procedure RefreshKeys;
  end;

  //basic key value type
  TPGPKey = class(TObject) //use for Session / Symetric Key
    Value : TKey128;       //array [0..15] of Byte;
    procedure GenerateValue;
    function GetsValue: string;
    property sValue: string read GetsValue;
  end;

  TRSA = class(TObject)
      LbRSA1     : TLbRSA;   //has key pair (private, public) and encryption methods
      PlainText  : string;
      CipherText : string;
      constructor Create;
      destructor Destroy; override;
      procedure Encrypt;
      procedure Decrypt;
      procedure SaveKeys(const sPublicFilename, sPrivateFilename : string);
      procedure LoadKeys(const sPublicFilename, sPrivateFilename : string);
      procedure RefreshKeys;
      procedure LoadPrivateKey(sFilename : string); //get receivers private RSA key
      procedure SavePrivateKey(sFilename : string); //save passphrase-encrypted
      procedure SetAndSavePrivateKey(const sPriExponent, sPriModulus : string);
      //property methods
      function GetsValue: string; //dirty 4-line display of PublicKey and PrivateKey values
      procedure SetsValue(const sPubPriKeys: string); //receive dirty 4-line display of PublicKey and PrivateKey values
      function GetPrettyPublic: string; //pretty 2-line display of PublicKey values
      procedure SetPrettyPublic(const sPubKey: string); //receive pretty 2-line display of PublicKey values
      function PrettysValue: string; //pretty 4-line display of PublicKey and PrivateKey. used by PGP.exe test harness only
      //properties
      property sValue : string read GetsValue write SetsValue;
      property sPrettyPublicValue: string read GetPrettyPublic write SetPrettyPublic; //pretty 2-line display of PublicKey Exponent and Modulus
    private
      function Public_sValue: string; //dirty 2-line display of PublicKey Exponent and Modulus
//      function Private_sValue: string; //dirty 2-line display of PrivateKey Exponent and Modulus
      procedure LoadPublicKey(sFilename : string);
      procedure SavePublicKey(sFilename : string); //save un-encrypted (it's public)
      function VerifyNonEmptyKeys: boolean; //returns TRUE if both Public and Private keys are filled
      procedure FixFilePath(var sFilename : string); //set RSA key paths to local EXE path
  end;

  TPGPFileLayout = record
//    SenderPubKeyExponent   : string; //1st line of file
//    SenderPubKeyModulus    : string; //2nd line of file 
    EncryptedSymetricKey   : string; //1st line of file
    ReceiverPubKeyExponent : string; //2nd line of file
    ReceiverPubKeyModulus  : string; //3rd line of file
    EncryptedMessage       : string; //rest of the lines of the file (1st line un-encrypted is SHA-1 hash of un-encrypted source body)
  end;

  //allow setup of both sender & receiver around encrypted data to be sent
  TPGP2Parties = class(TObject)
//    Sender : TRSA;
    Receiver : TRSA;
    SymetricKey : TPGPKey;
    EncryptedSymetricKeyString : string;
    DecryptedSymetricKeyString : string;
    KeySize : Integer;
    PlainText  : string;
    SendSHA1Hash : string;
    FinalSHA1Hash: string;
    CipherText : string;
    PGPFile : TPGPFileLayout;
    constructor Create;
    destructor Destroy; override;
    //encryption side of it all
    procedure SetEncryptSymetricKey;
    procedure SetPubPriKeys(iPartyNumber: integer; iKeySize: integer);
    procedure SetPubPriSymKeys(iKeySize: integer);
    procedure SetKeysForEncryption(const PubKeyExp, PubKeyMod: string);
    class function GetReceiverPubKey(var sPubExp, sPubMod : string): boolean;
    class procedure GetReceiverPriKeyFromFile(var sPriExp, sPriMod : string);
    procedure CreatePubPriKeys(iKeySize: integer);
    function GetSHA1HashForString(StringToHash: string) : string;
    function EncryptMessage : string; //AES encrypt message body
    function BuildEncryptedFile: string; //returns full file text for display
    function SaveEncryptedFile(const sInFilename: string = ''): TFilename;
    //now the decryption side of it all
    procedure SetKeysForDecryption(const PriKeyExp, PriKeyMod: string);
    procedure DecryptEncryptedSymetricKey;
    procedure GetDecryptKeys;
    function DecryptMessage : string;
  private
{$ifndef ORDER_DLL_BUILD}
    class procedure GetReceiverPubKeyFromDB(var sPubExp, sPubMod : string);
{$else}
    class procedure GetReceiverPubKeyFromFile(var sPubExp, sPubMod : string);
{$endif}
  end;

const
  ENCRYPTEDFILENAME = 'BrokerHistory.txt';
  MESSAGESOURCEFILTER = 'Text files|*.txt|All files|*.*';
  DEFAULT_RECEIVER_PUBEXP='F313';
  DEFAULT_RECEIVER_PUBMOD='E7E478ABEF36924844B5C258C8511AA0458579E05BD3AA2CE6492557CA7677ECF51AD245A6CE243AA94A23AF8E66CE76FB506BD2D3FBC519E2E4AA900DD4A7A5';
  DEFAULT_RECEIVER_PRVEXP='432FC5E8BE9AA3C333D085D51360754AF9BB3794FD460B065340FD8A7762C94DBAA42DBD000C1FE410D8B889C28B7D93EACC295995D601A2C20B02B523FDA4A3';
  DEFAULT_RECEIVER_PRVMOD='E7E478ABEF36924844B5C258C8511AA0458579E05BD3AA2CE6492557CA7677ECF51AD245A6CE243AA94A23AF8E66CE76FB506BD2D3FBC519E2E4AA900DD4A7A5';
  KEY_SIZE = 128; //used for session symetric keysize only (a small size here still grants great protection)

var
  PGP2Parties : TPGP2Parties;

// E N T R Y   P O I N T  (sender/encryption side)
function DoFullPGPEncryptionProcessOnText(inText : string;
                                   PubKeyExp : string = DEFAULT_RECEIVER_PUBEXP;
                                   PubKeyMod : string = DEFAULT_RECEIVER_PUBMOD;
                                   sFilename : string = ''): string;

// R E - E N T R Y   P O I N T S (receiver/decryption side)
function DoFullPGPDecryptionProcessOnText(inText : string;
                                   PriKeyExp : string = DEFAULT_RECEIVER_PRVEXP;
                                   PriKeyMod : string = DEFAULT_RECEIVER_PRVMOD): string;
{$ifdef UseDecryptionForm}
procedure ShowAndDoDecryptionProcess(sCaption, PriKeyExp, PriKeyMod : string); //shows form and wraps DoFullPGPDecryptionProcessOnText()
{$endif}

procedure ShowDebug(const sTemp : string);

implementation

uses
  LbString, Forms, Dialogs, LbAsym
  {$ifdef UseDecryptionForm},fDecryption{$endif}
//  {$ifndef ORDER_DLL_BUILD},rCore{$endif}
  , LbClass //SHA-1
  , VAUtils, ORFn
  ;

const
  RSAPRIVATEPASSPHRASE = 'I was NOT here at all  shhh';
  DEFAULTPRIVATEKEYFILE = 'Party2Private.TXT';
  DEFAULTPUBLICKEYFILE = 'Party2Public.INI';
  UnitName = 'urpcVistAParams';


// E N T R Y   P O I N T  (sender/encryption side)
function DoFullPGPEncryptionProcessOnText(inText : string;
                                   PubKeyExp : string = DEFAULT_RECEIVER_PUBEXP;
                                   PubKeyMod : string = DEFAULT_RECEIVER_PUBMOD;
                                   sFilename : string = ''): string;
begin
  result := '';
  if not Assigned(PGP2Parties) then
    PGP2Parties := TPGP2Parties.Create;
  try
    PGP2Parties.PlainText := inText;
    PGP2Parties.KeySize := 512;
    PGP2Parties.SetKeysForEncryption(PubKeyExp, PubKeyMod);
    PGP2Parties.EncryptMessage;
    PGP2Parties.SaveEncryptedFile(sFilename); //calls BuildEncryptedFile;
    result := PGP2Parties.CipherText;  //does not return header information (keys, etc)
  finally
    PGP2Parties.Free;
    PGP2Parties := nil;
  end;
end;


// R E - E N T R Y   P O I N T  (receiver/decryption side)
function DoFullPGPDecryptionProcessOnText(inText : string;
                                   PriKeyExp : string = DEFAULT_RECEIVER_PRVEXP;
                                   PriKeyMod : string = DEFAULT_RECEIVER_PRVMOD): string;
begin
  if not Assigned(PGP2Parties) then
    PGP2Parties := TPGP2Parties.Create;

  PGP2Parties.CipherText := inText;
  PGP2Parties.KeySize := 512;
  PGP2Parties.SetKeysForDecryption(PriKeyExp, PriKeyMod);
  PGP2Parties.DecryptMessage;
  result := PGP2Parties.PlainText;
end;

// R E - E N T R Y   P O I N T  (receiver/decryption side)
{$ifdef UseDecryptionForm}
procedure ShowAndDoDecryptionProcess(sCaption, PriKeyExp, PriKeyMod : string); //shows form and wraps DoFullPGPDecryptionProcessOnText()
var
  sPlainText : string;
begin
  if not Assigned(frmDecryption) then
    frmDecryption := TfrmDecryption.Create(Application);
  try
    PGP2Parties.CipherText := '';
    frmDecryption.Caption := sCaption;
    frmDecryption.btnLoadEncryptedFileClick(Application);
    if (PGP2Parties.CipherText <> '') then  //if a file was loaded
    begin
      sPlainText := DoFullPGPDecryptionProcessOnText(PGP2Parties.CipherText, PriKeyExp, PriKeyMod);
      frmDecryption.lstDecrypted.Items.Text:= sPlainText;
      frmDecryption.ShowModal;
    end;
  finally
    PGP2Parties.Free;
    PGP2Parties := nil;
    frmDecryption.Free;
    frmDecryption := nil;
  end;
end;
{$endif}

{helpers}

function bintoAscii(const bin: array of byte): AnsiString;
var
  i: integer;
begin
  SetLength(Result, Length(bin));
  for i := 0 to Length(bin) - 1 do
    result[i+1] := AnsiChar(bin[i]);
end;

function ReduceDupeCRLF(const sTemp : string): string;
begin
  result := StringReplace(sTemp, #13#10#13#10, #13#10, [rfReplaceAll]);
end;

procedure ShowDebug(const sTemp : string);
begin
  {$ifdef DEBUG_ENCRYPTION}
  Showmessage(sTemp);
  {$endif}
end;


{* TAES -------------------------------------------------------------------- *}

procedure TAES.RefreshKeys;
begin
  Assert(Passphrase <> '', 'AES passhrase not set in RefreshKeys(). Fix.');
  GenerateLMDKey(Key256, SizeOf(Key256), Passphrase);
end;

procedure TAES.Encrypt;
begin
  RefreshKeys;
  CipherText := RDLEncryptStringEx(PlainText, Key256, 16, TRUE);
end;

procedure TAES.Decrypt;
begin
  if CipherText = '' then
    raise Exception.Create('There is nothing to decrypt, so the process has stopped.');
  RefreshKeys;
  PlainText := '';
  PlainText := RDLEncryptStringEx(CipherText, Key256, 16, False);
end;


{* TPGPKey ----------------------------------------------------------------- *}

procedure TPGPKey.GenerateValue;
var
  I     : Integer;
  KeySize : Integer;
begin
  KeySize := SizeOf(Value);
  Randomize;
  for I := 0 to KeySize - 1 do
    Value[I] := System.Random(256);
end;

function TPGPKey.GetsValue: string;
var
  sTemp : string;
begin
  //convert Value (array of Bytes) to tempString (string)
  sTemp := bintoAscii(Value);
  result := sTemp;
end;


{* TRSA -------------------------------------------------------------------- *}

constructor TRSA.Create;
begin
  inherited Create;
  LbRSA1 := TLbRSA.Create(Application);
end;

destructor TRSA.Destroy;
begin
  LbRSA1.Free;
  inherited;
end;

procedure TRSA.RefreshKeys;
begin
  LbRSA1.GenerateKeyPair;
end;

function TRSA.VerifyNonEmptyKeys: boolean; //returns TRUE if both Public and Private keys are filled
begin
  result := NOT((LbRSA1.PublicKey.ExponentAsString = '') or
                (LbRSA1.PublicKey.ModulusAsString = '') or
                (LbRSA1.PrivateKey.ExponentAsString = '') or
                (LbRSA1.PrivateKey.ModulusAsString = ''));
  if result then
    result := (LbRSA1.PublicKey.ModulusAsString = LbRSA1.PrivateKey.ModulusAsString);
  if not result then
    ShowMessage('Encryption keys were not properly setup.'+#13#10+
                'Process aborted.');
end;

procedure TRSA.SaveKeys(const sPublicFilename, sPrivateFilename : string);
begin
  SavePublicKey(sPublicFilename);
  SavePrivateKey(sPrivateFilename);
end;

procedure TRSA.FixFilePath(var sFilename : string);
var
  sDir : string;
begin
//  sDir := '%userprofile%\local settings\my documents\';
  sDir := ExtractFilePath(Application.ExeName);
  sFilename := sDir+ExtractFilename(sFilename);
end;

procedure TRSA.SavePublicKey(sFilename : string); //save un-encrypted (it's public)
var
  slPrettyKey : TStringList;
begin
  FixFilePath(sFilename);
  ShowDebug(ExpandFilename(sFilename));
  if Assigned(LbRSA1.PublicKey) then
  begin
    slPrettyKey := TStringList.Create;
    try
      slPrettyKey.Text := sPrettyPublicValue;
      slPrettyKey.SaveToFile(sFilename);
    finally
      slPrettyKey.Free;
    end;
  end;
end;

procedure TRSA.SavePrivateKey(sFilename : string); //save passphrase-encrypted
var
  FS : TFileStream;
begin
  FixFilePath(sFilename);
  ShowDebug(ExpandFilename(sFilename));
  if Assigned(LbRSA1.PrivateKey) then
  begin
    FS := TFileStream.Create(sFilename, fmCreate);
    try
      LbRSA1.PrivateKey.Passphrase := RSAPRIVATEPASSPHRASE;
      LbRSA1.PrivateKey.StoreToStream(FS);
    finally
      FS.Free;
    end;
  end;
end;

procedure TRSA.SetAndSavePrivateKey(const sPriExponent, sPriModulus : string);
begin
  LbRSA1.PrivateKey.ExponentAsString := sPriExponent;
  LbRSA1.PrivateKey.ModulusAsString := sPriModulus;
  SavePrivateKey(DEFAULTPRIVATEKEYFILE);
end;

procedure TRSA.LoadKeys(const sPublicFilename, sPrivateFilename : string);
begin
  LoadPublicKey(sPublicFilename);
  LoadPrivateKey(sPrivateFilename);
end;

procedure TRSA.LoadPublicKey(sFilename : string);
var
  slPrettyKey : TStringList;
begin
  FixFilePath(sFilename);
  ShowDebug(ExpandFilename(sFilename));
  slPrettyKey := TStringList.Create;
  try
    slPrettyKey.LoadFromFile(sFilename);
    sPrettyPublicValue := slPrettyKey.Text;
  finally
    slPrettyKey.Free;
  end;
end;

procedure TRSA.LoadPrivateKey(sFilename : string);
var
  FS : TFileStream;
begin
  FixFilePath(sFilename);
  ShowDebug(ExpandFilename(sFilename));
  FS := TFileStream.Create(sFilename, fmOpenRead);
  try
    LbRSA1.PrivateKey.Passphrase := RSAPRIVATEPASSPHRASE;
    LbRSA1.PrivateKey.LoadFromStream(FS);
  finally
    FS.Free;
  end;
end;

function TRSA.PrettysValue: string;
var
  slTemp : TStringList;
begin
  slTemp := TStringList.Create;
  try
    slTemp.Add(LbRSA1.Name);
    slTemp.Add('PubExp=' + LbRSA1.PublicKey.ExponentAsString);
    slTemp.Add('PubMod=' + LbRSA1.PublicKey.ModulusAsString);
    slTemp.Add('PriExp=' + LbRSA1.PrivateKey.ExponentAsString);
    slTemp.Add('PriMod=' + LbRSA1.PrivateKey.ModulusAsString);
    result := slTemp.Text;
  finally
    slTemp.Free;
  end;
end;

function TRSA.Public_sValue: string; //dirty 2-line display of PublicKey Exponent and Modulus
var
  slTemp : TStringList;
begin
  slTemp := TStringList.Create;
  try
    slTemp.Add(LbRSA1.PublicKey.ExponentAsString);
    slTemp.Add(LbRSA1.PublicKey.ModulusAsString);
    result := slTemp.Text;
  finally
    slTemp.Free;
  end;
end;

{function TRSA.Private_sValue: string; //dirty 2-line display of PrivateKey Exponent and Modulus
var
  slTemp : TStringList;
begin
  slTemp := TStringList.Create;
  try
    slTemp.Add(LbRSA1.PrivateKey.ExponentAsString);
    slTemp.Add(LbRSA1.PrivateKey.ModulusAsString);
    result := slTemp.Text;
  finally
    slTemp.Free;
  end;
end;
}

function TRSA.GetsValue: string; //dirty 4-line display of PublicKey and PrivateKey values
var
  slTemp : TStringList;
begin
  slTemp := TStringList.Create;
  try
    slTemp.Add(Public_sValue);
    slTemp.Add(LbRSA1.PrivateKey.ExponentAsString);
    slTemp.Add(LbRSA1.PrivateKey.ModulusAsString);
    slTemp.Text := ReduceDupeCRLF(slTemp.Text);
    result := slTemp.Text;
  finally
    slTemp.Free;
  end;
end;

procedure TRSA.SetsValue(const sPubPriKeys: string); //receive dirty 4-line display of PublicKey and PrivateKey values
var
  slTemp : TStringList;
begin
  slTemp := TStringList.Create;
  try
    slTemp.Text := sPubPriKeys;
    slTemp.Text := ReduceDupeCRLF(slTemp.Text);
    if slTemp.Count <> 4 then { TODO : verify what comes back from RPC is private and public keys }
      raise Exception.Create('Keys returned do not match expected format. Please correct.');
    LbRSA1.PublicKey.ExponentAsString := slTemp[0];
    LbRSA1.PublicKey.ModulusAsString  := slTemp[1];
    LbRSA1.PrivateKey.ExponentAsString := slTemp[2];
    LbRSA1.PrivateKey.ModulusAsString  := slTemp[3];
  finally
    slTemp.Free;
  end;
end;

function TRSA.GetPrettyPublic: string; //pretty 2-line display of PublicKey values
var
  slTemp : TStringList;
begin
  slTemp := TStringList.Create;
  try
    slTemp.Add('PubExp=' + LbRSA1.PublicKey.ExponentAsString);
    slTemp.Add('PubMod=' + LbRSA1.PublicKey.ModulusAsString);
    result := slTemp.Text;
  finally
    slTemp.Free;
  end;
end;

procedure TRSA.SetPrettyPublic(const sPubKey: string); //receive pretty 2-line display of PublicKey values
var
  slTemp : TStringList;
begin
  slTemp := TStringList.Create;
  try
    slTemp.Text := sPubKey;
    slTemp.Text := ReduceDupeCRLF(slTemp.Text);
    if slTemp.Count <> 2 then
      raise Exception.Create('Key returned does not match expected format. Please correct.');
    LbRSA1.PublicKey.ExponentAsString := slTemp.Values['PubExp'];
    LbRSA1.PublicKey.ModulusAsString  := slTemp.Values['PubMod'];
  finally
    slTemp.Free;
  end;
end;

procedure TRSA.Encrypt;
begin
  CipherText := RSAEncryptString(PlainText, LbRSA1.PublicKey, TRUE);
end;

procedure TRSA.Decrypt;
begin
  if CipherText = '' then
    raise Exception.Create('There is nothing to decrypt, so the process has stopped.');
  PlainText := '';
  PlainText := RSAEncryptString(CipherText, LbRSA1.PrivateKey, FALSE);
end;


{* TPGP2Parties ------------------------------------------------------------ *}

constructor TPGP2Parties.Create;
begin
  inherited;
//  Sender := TRSA.Create;
  Receiver := TRSA.Create;
  SymetricKey := TPGPKey.Create;
end;

procedure TPGP2Parties.SetEncryptSymetricKey;
//sets EncryptedSymetricKeyString
begin
  Receiver.PlainText := SymetricKey.sValue;
  Receiver.Encrypt;      //use Receiver's RSA public key to encrypt Symetric Key
  EncryptedSymetricKeyString := Receiver.CipherText;
end;

procedure TPGP2Parties.DecryptEncryptedSymetricKey;
//sets DecryptedSymetricKeyString
begin
  Receiver.CipherText := EncryptedSymetricKeyString;
  Receiver.Decrypt;     //use Receiver's RSA private key to decrypt Symetric Key
  DecryptedSymetricKeyString := Receiver.PlainText;
end;

procedure TPGP2Parties.SetKeysForEncryption(const PubKeyExp, PubKeyMod: string);
//input parameters are the file Receiver's RSA public key properties
begin
  if KeySize=0 then
    KeySize := 512; //default to 512
  Receiver.LbRSA1.KeySize := aks512;
  Receiver.LbRSA1.PublicKey.ExponentAsString := PubKeyExp;
  Receiver.LbRSA1.PublicKey.ModulusAsString := PubKeyMod;
  SetPubPriKeys(1, PGP2Parties.KeySize);  //set sender keys
  SymetricKey.GenerateValue;//like normal PGP, generate symmetric (session) key on-the-fly
  SetEncryptSymetricKey; //sets EncryptedSymetricKeyString
end;

procedure TPGP2Parties.SetKeysForDecryption(const PriKeyExp, PriKeyMod: string);
//input parameters are the file Receiver's RSA private key properties
begin
  if KeySize=0 then
    KeySize := 512; //default to 512
  Receiver.LbRSA1.KeySize := aks512;
  Receiver.LbRSA1.PrivateKey.ExponentAsString := PriKeyExp;
  Receiver.LbRSA1.PrivateKey.ModulusAsString := PriKeyMod;
  GetDecryptKeys; //get keys (including decrypting S key) from inText
end;

procedure TPGP2Parties.SetPubPriSymKeys(iKeySize: integer);
begin
  //like normal PGP, generate symmetric (session) key on-the-fly
  SymetricKey.GenerateValue;

  if iKeySize=0 then
    iKeySize := 512; //default to 512 if 0 size was sent
  SetPubPriKeys(1, iKeySize);  //set sender keys
  SetPubPriKeys(2, iKeySize);  //set receiver keys
end;

procedure TPGP2Parties.SetPubPriKeys(iPartyNumber: integer; iKeySize: integer);
//iPartyNumber = 1 means Sender (encryptor), iPartyNumber = 2 means Receiver (decryptor)
//iKeySize will default if 0 is sent, but the owner PGP2Parties should have the key
var
  sPubExp : string;
  sPubMod : string;
begin
  if iKeySize=0 then
    iKeySize := KEY_SIZE; //default to KEY_SIZE if 0 size was sent

  //get Sender keys (generate on-the-fly)
  if (iPartyNumber = 1) then
  begin
{    if iKeySize = 512 then
      Sender.LbRSA1.KeySize := aks512; //only setup for RSA keysize of 512
    Sender.RefreshKeys; }
  end;

  //get Receiver keys (read Public key from Mumps or INI file, and Private Key from TXT file)
  if (iPartyNumber = 2) then
  begin
    if iKeySize = 512 then
      Receiver.LbRSA1.KeySize := aks512; //only setup for RSA keysize of 512
    //public key info
    GetReceiverPubKey(sPubExp, sPubMod);
    Receiver.LbRSA1.PublicKey.ExponentAsString := sPubExp;
    Receiver.LbRSA1.PublicKey.ModulusAsString := sPubMod;
    //private key info
    Receiver.LoadPrivateKey(DEFAULTPRIVATEKEYFILE);
    //verify all Receiver's RSA keys properties (4 total) have values
    Receiver.VerifyNonEmptyKeys();
  end;
end;

procedure TPGP2Parties.CreatePubPriKeys(iKeySize: integer);
//iKeySize will default if 0 is sent, but the owner PGP2Parties should have the keysize
begin
  if iKeySize=0 then
    iKeySize := KEY_SIZE; //default to KEY_SIZE if 0 size was sent
  if iKeySize = 512 then
    Receiver.LbRSA1.KeySize := aks512; //only setup for RSA keysize of 512

  Receiver.RefreshKeys;

  //save Public key to un-encrypted file so anyone (including installer) can read
  Receiver.SavePublicKey(DEFAULTPUBLICKEYFILE);
  { TODO : change to SAVE public key to Mumps
  //save public key info to Mumps
  Receiver.LbRSA1.PublicKey.ExponentAsString := sCallV('VFD RSA KEY', ['ALL.BRKR_HIST.PUB.E']);
  Receiver.LbRSA1.PublicKey.ModulusAsString := sCallV('VFD RSA KEY', ['ALL.BRKR_HIST.PUB.M']); }

  //save Private key info to (encrypted) file
  Receiver.SavePrivateKey(DEFAULTPRIVATEKEYFILE);
end;

class function TPGP2Parties.GetReceiverPubKey(var sPubExp, sPubMod : string): boolean;
begin
{$ifndef ORDER_DLL_BUILD}
  GetReceiverPubKeyFromDB(sPubExp, sPubMod);
{$else}
  GetReceiverPubKeyFromFile(sPubExp, sPubMod);
{$endif}
 if (Piece(sPubExp,U,1) = '-1') or (Piece(sPubMod,U,1) = '-1') then
  Result := False
 else
  Result := true;
end;

{$ifndef ORDER_DLL_BUILD}  //vxCPRSChart.exe has keys in DB and ORDER_DLL_BUILD not defined
class procedure TPGP2Parties.GetReceiverPubKeyFromDB(var sPubExp, sPubMod : string);

  function GetValueOfParameter(sParameterName : string;
                               var sResult : string; sInstance : string = '';
                               sEntities : string = ''; sValueType : string = 'Q';
                               bTrapResultErrors : boolean = true ) : boolean;
  var
   sData : string;
   slResultList : TStringList;
  begin
    Assert( sParameterName <> '');                 { MAKE SURE ALL IN VALUES ARE VALID }
    Result := TRUE;
    sData := sEntities + '~' + sParameterName + '~' + sInstance + '~~~' + sValueType;
    slResultList := TStringList.Create;
    try
      RPCBrokerV.Param.Clear;
      tCallV(slResultList,'VFDC XPAR GET VALUE',[sData]);
      if slResultList.Count > 0 then
        begin
          sResult := slResultList[0];
          if ((bTrapResultErrors) and (Piece(RPCBrokerV.Results[0], U, 1) = '-1')) then
            begin
              raise Exception.Create('Error in ' + UnitName + ' routine rpc_GetValueOfParameter: '
                                     + Piece(slResultList[0], U, 2));
              Result := FALSE;
            end;
        end;
    except
      on E: EBrokerError do
        begin
          raise Exception.Create('Error in ' + UnitName + ' routine rpc_GetValueOfParameter: '
                                 + Piece(RPCBrokerV.Results[0], U, 2));
          Result  := FALSE;
        end;
    end;
    slResultList.Free;
  end;

begin
  //note that it raises an exception if key is not found
  GetValueOfParameter('VFD RSA KEY', sPubExp, 'ALL.BRKR_HIST.PUB.E','','Q',False);
  GetValueOfParameter('VFD RSA KEY', sPubMod, 'ALL.BRKR_HIST.PUB.M','','Q',False);
end;
{$else}
class procedure TPGP2Parties.GetReceiverPubKeyFromFile(var sPubExp, sPubMod : string);
var
  bHadToCreate : boolean;
begin
  bHadToCreate := not Assigned(PGP2Parties);
  if bHadToCreate then
    PGP2Parties := TPGP2Parties.Create;
  try
    PGP2Parties.Receiver.LoadPublicKey(DEFAULTPUBLICKEYFILE);
    sPubExp := PGP2Parties.Receiver.LbRSA1.PublicKey.ExponentAsString;
    sPubMod := PGP2Parties.Receiver.LbRSA1.PublicKey.ModulusAsString;
  finally
    if bHadToCreate then begin
      PGP2Parties.Free;
      PGP2Parties := nil;
    end;
  end;
end;
{$endif}

class procedure TPGP2Parties.GetReceiverPriKeyFromFile(var sPriExp, sPriMod : string);
var
  bHadToCreate : boolean;
begin
  bHadToCreate := not Assigned(PGP2Parties);
  if bHadToCreate then
    PGP2Parties := TPGP2Parties.Create;
  try
    PGP2Parties.Receiver.LoadPrivateKey(DEFAULTPRIVATEKEYFILE);
    sPriExp := PGP2Parties.Receiver.LbRSA1.PrivateKey.ExponentAsString;
    sPriMod := PGP2Parties.Receiver.LbRSA1.PrivateKey.ModulusAsString;
  finally
    if bHadToCreate then begin
      PGP2Parties.Free;
      PGP2Parties := nil;
    end;
  end;
end;

function TPGP2Parties.GetSHA1HashForString(StringToHash: string) : string;
//per LWM
var
  Digest: TSHA1Digest;
  cntr: integer;
  iTmp: integer;
  sTmp: string;
  LbSHA11: TLbSHA1;
begin
  result := '';
  LbSHA11 := TLbSHA1.Create(nil);
  try
    LbSHA11.HashString(StringToHash);
    LbSHA11.GetDigest(Digest);
    sTmp := '';
    for cntr := 0 to 4 do
    begin
      iTmp := Digest[cntr*4];
      iTmp := iTmp shl 8;
      iTmp := iTmp + Digest[cntr*4 + 1];
      iTmp := iTmp shl 8;
      iTmp := iTmp + Digest[cntr*4 + 2];
      iTmp := iTmp shl 8;
      iTmp := iTmp + Digest[cntr*4 + 3];
      sTmp := sTmp + ' ' + IntToHex(iTmp, 8);
    end;
  except on exception do;
  end;
  LbSHA11.Free;
  Result := sTmp;
end;

function TPGP2Parties.EncryptMessage : string;
var
  AES : TAES;
begin
  Assert(SymetricKey.sValue <> '', 'SymetricKey must be set.');
  Assert(PlainText <> '', 'PlainText must be set.');
  //
  AES := TAES.Create;
  try
    AES.Passphrase := SymetricKey.sValue;
    SendSHA1Hash := GetSHA1HashForString(PlainText);//insert SHA-1 hash of PlainText
    ShowMessage('File has been encrypted. The hash value is '+#13#10+
                '"'+SendSHA1Hash+'"'); //vxCPRSChart wants to show this
    AES.PlainText := SendSHA1Hash + #13#10 + PlainText;
    AES.Encrypt; //sets AES.CipherText
    CipherText := AES.CipherText;
    result := CipherText;
  finally
    AES.Free;
  end;
end;

function TPGP2Parties.BuildEncryptedFile: string; //returns full file text for display
var
  slTemp : TStringList;
begin
  Assert(EncryptedSymetricKeyString <> '', 'Encrypted symmetric (session) key should exist.');
  Assert(Receiver.LbRSA1.PublicKey.ExponentAsString <> '', 'RSA Public key should exist.');
  Assert(Receiver.LbRSA1.PublicKey.ModulusAsString <> '', 'RSA Public key should exist.');
  Assert(CipherText <> '', 'CipherText should exist.');
  //
  slTemp := TStringList.Create;
  try
{    //1st line of file
    PGPFile.SenderPubKeyExponent := Sender.LbRSA1.PublicKey.ExponentAsString;
    slTemp.Add(PGPFile.SenderPubKeyExponent);
    //2nd line of file
    PGPFile.SenderPubKeyModulus := Sender.LbRSA1.PublicKey.ModulusAsString;
    slTemp.Add(PGPFile.SenderPubKeyModulus); }
    //1st line of file
    PGPFile.EncryptedSymetricKey := EncryptedSymetricKeyString;
    slTemp.Add(PGPFile.EncryptedSymetricKey);
    //2nd line of file
    PGPFile.ReceiverPubKeyExponent := Receiver.LbRSA1.PublicKey.ExponentAsString;
    slTemp.Add(PGPFile.ReceiverPubKeyExponent);
    //3rd line of file
    PGPFile.ReceiverPubKeyModulus := Receiver.LbRSA1.PublicKey.ModulusAsString;
    slTemp.Add(PGPFile.ReceiverPubKeyModulus);
    //rest of the lines of the file
    PGPFile.EncryptedMessage := CipherText;
    slTemp.Add(PGPFile.EncryptedMessage);
    result := slTemp.Text;
  finally
    slTemp.Free;
  end;
end;

function TPGP2Parties.SaveEncryptedFile(const sInFilename: string = ''): TFilename;
var
  SaveDialog1 : TSaveDialog;
  procedure BuildAndSaveFile(sFilename: string);
  var
    slTemp : TStringList;
  begin
    result := '';
    slTemp := TStringList.Create;
    try
      slTemp.Add(BuildEncryptedFile()); //this is the heart of what is saved
      slTemp.SaveToFile(sFilename);
      result := sFilename;
    finally
      slTemp.Free;
    end;
  end;
begin
  if sInFilename = '' then
  begin
    SaveDialog1 := TSaveDialog.Create(Application);
    try
    with SaveDialog1 do begin
      Filename := ENCRYPTEDFILENAME;    //default filename
      InitialDir := '%userprofile%\local settings\my documents';
      Filter := MESSAGESOURCEFILTER;   // Allow txt (or all) files to be selected
      FilterIndex := 1;    // Select text files as the starting filter type
      // Display the save file dialog
      if Execute then
        BuildAndSaveFile(Filename)
      else ShowMessage('Save file was cancelled');
    end;
    finally
      SaveDialog1.Free;
    end;
  end
  else
    BuildAndSaveFile(sInFilename);
end;

procedure TPGP2Parties.GetDecryptKeys;
var
  slTemp : TStringList;
  i : integer;
begin
  slTemp := TStringList.Create;
  try
    if PGP2Parties.KeySize = 0 then
      PGP2Parties.KeySize := KEY_SIZE;

    slTemp.Clear;
    slTemp.Text := CipherText;
    Assert(slTemp.Count >= 4, 'Loaded file does not have enough lines to be a valid encrypted file');

    //pull header out of encrypted file
{    //1st line of file (sender's public key exponent)
    PGPFile.SenderPubKeyExponent := slTemp[0];
    Sender.LbRSA1.PublicKey.ExponentAsString := PGPFile.SenderPubKeyExponent;
    //2nd line of file (sender's public key modulus)
    PGPFile.SenderPubKeyModulus := slTemp[1];
    Sender.LbRSA1.PublicKey.ModulusAsString := PGPFile.SenderPubKeyModulus; }
    //1st line of file (encrypted symetric key)
    PGPFile.EncryptedSymetricKey := slTemp[0];
    EncryptedSymetricKeyString := PGPFile.EncryptedSymetricKey;
    PGP2Parties.DecryptEncryptedSymetricKey; //sets DecryptedSymetricKeyString
    //2nd line of file (receiver's public key exponent)
    PGPFile.ReceiverPubKeyExponent := slTemp[1];
    PGP2Parties.Receiver.LbRSA1.PublicKey.ExponentAsString := PGPFile.ReceiverPubKeyExponent;
    //3rd line of file (receiver's public key modulus)
    PGPFile.ReceiverPubKeyModulus := slTemp[2];
    PGP2Parties.Receiver.LbRSA1.PublicKey.ModulusAsString := PGPFile.ReceiverPubKeyModulus;
    //delete the 1st 3 lines
    slTemp.Delete(0);
    slTemp.Delete(0);
    slTemp.Delete(0);

    //clean the rest of the lines of the file
    slTemp.Text := StringReplace(slTemp.Text, #13#10, '', [rfReplaceAll]);
    for i := slTemp.Count - 1 downto 0 do
    begin
      if slTemp[i] = '' then
        slTemp.Delete(i);
    end;
    slTemp.Text := Trim(slTemp.Text);

    //remaining strings are only the [encrypted] file memo to be decrypted
    CipherText := slTemp[0];
    PGPFile.EncryptedMessage := CipherText;
  finally
    slTemp.Free;
  end;
end;

function TPGP2Parties.DecryptMessage : string;
//sets and returns decrypted PlainText, and sets SendSHA1Hash and FinalSHA1Hash
var
  AES : TAES;
  slDecrypted : TStringList;
begin
  Assert(DecryptedSymetricKeyString <> '', 'DecryptedSymetricKeyString must be set.');
  Assert(CipherText <> '', 'CipherText must be set.');
  //
  AES := TAES.Create;
  try
    AES.Passphrase := DecryptedSymetricKeyString;
    AES.CipherText := CipherText;
    AES.Decrypt; //sets AES.PlainText
    //extract SHA-1 hash from the first line of AES.PlainText
    slDecrypted := TStringList.Create;
    try
      slDecrypted.Text := AES.PlainText;
      if slDecrypted.Count < 2 then
      begin
        ShowMessage('The received text does not have the SHA-1 hash and text.');
        result := '';
        exit;
      end;
      SendSHA1Hash := slDecrypted[0]; //should match EncryptMessage's SendSHA1Hash
      slDecrypted.Delete(0);
      AES.PlainText := slDecrypted.Text;
    finally
      slDecrypted.Free;
    end;
    //set PlainText from the remaining text
    PlainText := AES.PlainText;
    //get SHA-1 hash of remaining text (FinalSHA1Hash should equal SendSHA1Hash)
    FinalSHA1Hash := GetSHA1HashForString(PlainText);
    //set result
    result := PlainText;
  finally
    AES.Free;
  end;
end;

destructor TPGP2Parties.Destroy();
begin
//  Sender.Free;
  Receiver.Free;
  inherited;
end;

end.
