
{
tscap32 - Delphi Video Capture Component
Copyright (C) 1996-2003 Thomas Stuefe

contact: tstuefe@users.sourceforge.net
web:     http://tscap32.sourceforge.net


This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
}

unit tsMessages;

interface

uses Messages;

const
  //Offset für interne Botschaften
  WM_TSTECH_BASE = WM_USER + 1702;


{tsWav}
  //Dokumentbotschaften
  TSWM_DOCUMENT_CHANGED = WM_TSTECH_BASE;
  TSWM_DOCUMENT_KILLED = WM_TSTECH_BASE + 1;

  //Nachricht vom Viewercache, zwingt alle Viewer, ihre Einträge neu
  //berechnen zu lassen. Wird ausgelöst, wenn ein oder mehrere Entries
  //gelöscht wurden, um die Cacheindizes in den Viewern zu aktualisieren
  TSWM_VIEWER_RECALCULATE = WM_TSTECH_BASE + 2;

{tsCap32}

  TSWM_TSCAP32_KILLED = WM_TSTECH_BASE + 3;

implementation

end.
