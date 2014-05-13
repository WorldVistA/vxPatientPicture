unit fFindingPatientImage;

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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfmFindingPatientImage = class(TForm)
    Label1: TLabel;
    Shape1: TShape;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmFindingPatientImage: TfmFindingPatientImage;

implementation

{$R *.dfm}

end.
