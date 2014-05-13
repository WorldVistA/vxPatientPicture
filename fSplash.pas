unit fSplash;

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
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, jclfileutils, dateutils, jpeg;

type
  TfmSplash = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label3: TLabel;
    lblFileVersion: TLabel;
    pnl508: TPanel;
    lbl508: TLabel;
    lblCopyright: TLabel;
    laCameraConnected: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  fmSplash: TfmSplash;
  vi: TJclFileVersionInfo;

implementation

uses Unit1;

{$R *.dfm}

procedure TfmSplash.FormShow(Sender: TObject);
begin
  vi := TJclFileVersionInfo.Create(ExtractFilename(GetModuleName(HInstance)));
  try
    lblFileVersion.Caption := vi.ProductName + ' version ' + vi.ProductVersion;
    //lblCompany.Caption := vi.CompanyName;
    lblCopyright.Caption := 'Copyright ' + Chr(169) + ' Document Storage Systems, Inc. 2000 - ' + IntToStr(YearOf(Now));
    fmMain.AppName := Unit1.VXPATIENTPICTURE_V + fSplash.vi.ProductVersion;
  finally
    vi.Free;
  end;
end;

end.
