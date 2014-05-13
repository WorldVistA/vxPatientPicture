
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


{//////////////////////////////////////////////////////////////////////////////
//		File:	vfwUnit
//		Zweck:	Auszug aus den vfw-Includes des win32sdk
//
//////////////////////////////////////////////////////////////////////////////}

unit vfwUnit;

interface

uses windows, Messages, mmsystem;

function capCreateCaptureWindowA
(lpszWindowName:PChar;dwStyle,x,y,nWidth,nHeight:LongInt;hWnd:THandle;nID:LongInt):THandle; stdcall; external 'avicap32.dll';

function capGetDriverDescriptionA (wDriverIndex: LongInt; lpszName: PChar; cbName: LongInt; lpszVer:PChar; cbVer: LongInt):LongBool; stdcall; external 'avicap32.dll';



// ------------------------------------------------------------------
// String IDs from status and error callbacks
// ------------------------------------------------------------------

const IDS_CAP_BEGIN =              300  ;    // "Capture Start" */
const IDS_CAP_END   =              301  ;    // "Capture End" */

const IDS_CAP_INFO   =             401  ;    // "%s" */
const IDS_CAP_OUTOFMEM =           402  ;    // "Out of memory" */
const IDS_CAP_FILEEXISTS=          403  ;    // "File '%s' exists -- overwrite it?" */
const IDS_CAP_ERRORPALOPEN =       404  ;    // "Error opening palette '%s'" */
const IDS_CAP_ERRORPALSAVE  =      405  ;    // "Error saving palette '%s'" */
const IDS_CAP_ERRORDIBSAVE   =     406  ;    // "Error saving frame '%s'" */
const IDS_CAP_DEFAVIEXT    =       407  ;    // "avi" */
const IDS_CAP_DEFPALEXT     =      408  ;    // "pal" */
const IDS_CAP_CANTOPEN       =     409  ;    // "Cannot open '%s'" */
const IDS_CAP_SEQ_MSGSTART    =    410  ;    // "Select OK to start capture\nof video sequence\nto %s." */
const IDS_CAP_SEQ_MSGSTOP  =       411  ;    // "Hit ESCAPE or click to end capture" */

const IDS_CAP_VIDEDITERR    =      412  ;    // "An error occurred while trying to run VidEdit." */
const IDS_CAP_READONLYFILE   =     413  ;    // "The file '%s' is a read-only file." */
const IDS_CAP_WRITEERROR      =    414  ;    // "Unable to write to file '%s'.\nDisk may be full." */
const IDS_CAP_NODISKSPACE      =   415  ;    // "There is no space to create a capture file on the specified device." */
const IDS_CAP_SETFILESIZE       =  416  ;    // "Set File Size" */
const IDS_CAP_SAVEASPERCENT =      417  ;    // "SaveAs: %2ld%%  Hit Escape to abort." */

const IDS_CAP_DRIVER_ERROR   =     418  ;    // Driver specific error message */

const IDS_CAP_WAVE_OPEN_ERROR =    419  ;    // "Error: Cannot open the wave input device.\nCheck sample size, frequency, and channels." */
const IDS_CAP_WAVE_ALLOC_ERROR =   420  ;    // "Error: Out of memory for wave buffers." */
const IDS_CAP_WAVE_PREPARE_ERROR=  421  ;    // "Error: Cannot prepare wave buffers." */
const IDS_CAP_WAVE_ADD_ERROR  =    422  ;    // "Error: Cannot add wave buffers." */
const IDS_CAP_WAVE_SIZE_ERROR  =   423  ;    // "Error: Bad wave size." */

const IDS_CAP_VIDEO_OPEN_ERROR  =  424  ;    // "Error: Cannot open the video input device." */
const IDS_CAP_VIDEO_ALLOC_ERROR  = 425  ;    // "Error: Out of memory for video buffers." */
const IDS_CAP_VIDEO_PREPARE_ERROR =426  ;    // "Error: Cannot prepare video buffers." */
const IDS_CAP_VIDEO_ADD_ERROR =    427  ;    // "Error: Cannot add video buffers." */
const IDS_CAP_VIDEO_SIZE_ERROR =   428  ;    // "Error: Bad video size." */

const IDS_CAP_FILE_OPEN_ERROR   =  429  ;    // "Error: Cannot open capture file." */
const IDS_CAP_FILE_WRITE_ERROR  =  430  ;    // "Error: Cannot write to capture file.  Disk may be full." */
const IDS_CAP_RECORDING_ERROR   =  431  ;    // "Error: Cannot write to capture file.  Data rate too high or disk full." */
const IDS_CAP_RECORDING_ERROR2  =  432  ;    // "Error while recording" */
const IDS_CAP_AVI_INIT_ERROR    =  433  ;    // "Error: Unable to initialize for capture." */
const IDS_CAP_NO_FRAME_CAP_ERROR=  434  ;    // "Warning: No frames captured.\nConfirm that vertical sync interrupts\nare configured and enabled." */
const IDS_CAP_NO_PALETTE_WARN   =  435  ;    // "Warning: Using default palette." */
const IDS_CAP_MCI_CONTROL_ERROR =  436  ;    // "Error: Unable to access MCI device." */
const IDS_CAP_MCI_CANT_STEP_ERROR= 437  ;    // "Error: Unable to step MCI device." */
const IDS_CAP_NO_AUDIO_CAP_ERROR = 438  ;    // "Error: No audio data captured.\nCheck audio card settings." */
const IDS_CAP_AVI_DRAWDIB_ERROR  = 439  ;    // "Error: Unable to draw this data format." */
const IDS_CAP_COMPRESSOR_ERROR   = 440  ;    // "Error: Unable to initialize compressor." */
const IDS_CAP_AUDIO_DROP_ERROR   = 441  ;    // "Error: Audio data was lost during capture, reduce capture rate." */

// status string IDs */
const IDS_CAP_STAT_LIVE_MODE     = 500  ;    // "Live window" */
const IDS_CAP_STAT_OVERLAY_MODE  = 501  ;    // "Overlay window" */
const IDS_CAP_STAT_CAP_INIT      = 502  ;    // "Setting up for capture - Please wait" */
const IDS_CAP_STAT_CAP_FINI      = 503  ;    // "Finished capture, now writing frame %ld" */
const IDS_CAP_STAT_PALETTE_BUILD = 504  ;    // "Building palette map" */
const IDS_CAP_STAT_OPTPAL_BUILD  = 505  ;    // "Computing optimal palette" */
const IDS_CAP_STAT_I_FRAMES      = 506  ;    // "%d frames" */
const IDS_CAP_STAT_L_FRAMES      = 507  ;    // "%ld frames" */
const IDS_CAP_STAT_CAP_L_FRAMES  = 508  ;    // "Captured %ld frames" */
const IDS_CAP_STAT_CAP_AUDIO     = 509  ;    // "Capturing audio" */
const IDS_CAP_STAT_VIDEOCURRENT  = 510  ;    // "Captured %ld frames (%ld dropped) %d.%03d sec." */
const IDS_CAP_STAT_VIDEOAUDIO    = 511  ;    // "Captured %d.%03d sec.  %ld frames (%ld dropped) (%d.%03d fps).  %ld audio bytes (%d,%03d sps)" */
const IDS_CAP_STAT_VIDEOONLY     = 512  ;    // "Captured %d.%03d sec.  %ld frames (%ld dropped) (%d.%03d fps)" */
const IDS_CAP_STAT_FRAMESDROPPED = 513  ;    // "Dropped %ld of %ld frames (%d.%02d%%) during capture." */






//////////////////////////////////////////////////////////////////
// ------------------------------------------------------------------
//  Window Messages  WM_CAP... which can be sent to an AVICAP window
// ------------------------------------------------------------------

// UNICODE
//
// The Win32 version of AVICAP on NT supports UNICODE applications:
// for each API or message that takes a char or string parameter, there are
// two versions, ApiNameA and ApiNameW. The default name ApiName is #defined
// to one or other depending on whether UNICODE is defined. Apps can call
// the A and W apis directly, and mix them.
//
// The 32-bit AVICAP on NT uses unicode exclusively internally.
// ApiNameA() will be implemented as a call to ApiNameW() together with
// translation of strings.

// Defines start of the message range
const
WM_CAP_START=WM_USER;
WM_CAP_GET_CAPSTREAMPTR=			(WM_CAP_START+1);
WM_CAP_SET_CALLBACK_ERROR=			(WM_CAP_START+2);
WM_CAP_SET_CALLBACK_STATUS=		(WM_CAP_START+3);

WM_CAP_SET_CALLBACK_YIELD=			(WM_CAP_START+4);
WM_CAP_SET_CALLBACK_FRAME=			(WM_CAP_START+5);
WM_CAP_SET_CALLBACK_VIDEOSTREAM=	(WM_CAP_START+6);
WM_CAP_SET_CALLBACK_WAVESTREAM=	(WM_CAP_START+7);

WM_CAP_GET_USER_DATA=				(WM_CAP_START+8);
WM_CAP_SET_USER_DATA=				(WM_CAP_START+9);
WM_CAP_DRIVER_CONNECT=				(WM_CAP_START+10);
WM_CAP_DRIVER_DISCONNECT=			(WM_CAP_START+11);

WM_CAP_DRIVER_GET_NAME=			(WM_CAP_START+12);
WM_CAP_DRIVER_GET_VERSION=			(WM_CAP_START+13);

WM_CAP_DRIVER_GET_CAPS=			(WM_CAP_START+14);

WM_CAP_FILE_SET_CAPTURE_FILE=		(WM_CAP_START+20);
WM_CAP_FILE_GET_CAPTURE_FILE=		(WM_CAP_START+21);
WM_CAP_FILE_SAVEAS=				(WM_CAP_START+23);
WM_CAP_FILE_SAVEDIB=				(WM_CAP_START+25);

// out of order to save on ifdefs
WM_CAP_FILE_ALLOCATE=				(WM_CAP_START+22);
WM_CAP_FILE_SET_INFOCHUNK=			(WM_CAP_START+24);

WM_CAP_EDIT_COPY=					(WM_CAP_START+30);

WM_CAP_SET_AUDIOFORMAT=			(WM_CAP_START+35);
WM_CAP_GET_AUDIOFORMAT=			(WM_CAP_START+36);

 WM_CAP_DLG_VIDEOFORMAT=			(WM_CAP_START+41);
 WM_CAP_DLG_VIDEOSOURCE=			(WM_CAP_START+42);
 WM_CAP_DLG_VIDEODISPLAY=			(WM_CAP_START+43);
 WM_CAP_GET_VIDEOFORMAT=			(WM_CAP_START+44);
 WM_CAP_SET_VIDEOFORMAT=			(WM_CAP_START+45);
 WM_CAP_DLG_VIDEOCOMPRESSION=		(WM_CAP_START+46);

 WM_CAP_SET_PREVIEW=              	(WM_CAP_START+  50);
 WM_CAP_SET_OVERLAY=               (WM_CAP_START+  51);
 WM_CAP_SET_PREVIEWRATE =         	(WM_CAP_START+  52);
 WM_CAP_SET_SCALE=                	(WM_CAP_START+  53);
 WM_CAP_GET_STATUS=               	(WM_CAP_START+  54);
 WM_CAP_SET_SCROLL=               	(WM_CAP_START+  55);

 WM_CAP_GRAB_FRAME=               	(WM_CAP_START+  60);
 WM_CAP_GRAB_FRAME_NOSTOP=        	(WM_CAP_START+  61);

 WM_CAP_SEQUENCE=                 	(WM_CAP_START+  62);
 WM_CAP_SEQUENCE_NOFILE=          	(WM_CAP_START+  63);
 WM_CAP_SET_SEQUENCE_SETUP=       	(WM_CAP_START+  64);
 WM_CAP_GET_SEQUENCE_SETUP=       	(WM_CAP_START+  65);

 WM_CAP_SET_MCI_DEVICE=         	(WM_CAP_START+  66);
 WM_CAP_GET_MCI_DEVICE=         	(WM_CAP_START+  67);

 WM_CAP_STOP=                    	(WM_CAP_START+  68);
 WM_CAP_ABORT=                    	(WM_CAP_START+  69);

 WM_CAP_SINGLE_FRAME_OPEN=        	(WM_CAP_START+  70);
 WM_CAP_SINGLE_FRAME_CLOSE=       	(WM_CAP_START+  71);
 WM_CAP_SINGLE_FRAME=             	(WM_CAP_START+  72);

 WM_CAP_PAL_OPEN=               	(WM_CAP_START+  80);
 WM_CAP_PAL_SAVE =              	(WM_CAP_START+  81);

 WM_CAP_PAL_PASTE=                	(WM_CAP_START+  82);
 WM_CAP_PAL_AUTOCREATE=           	(WM_CAP_START+  83);
 WM_CAP_PAL_MANUALCREATE=         	(WM_CAP_START+  84);

// Following added post VFW 1.1
 WM_CAP_SET_CALLBACK_CAPCONTROL=  	(WM_CAP_START+  85);

// Defines end of the message range


 WM_CAP_END=                      	WM_CAP_PAL_SAVE;

{////////////////////////////////////////////////////////////////////////////////////////
// ------------------------------------------------------------------
//  Structures
// ------------------------------------------------------------------
}

type
tagCapDriverCaps = record
    wDeviceIndex: Integer;               // Driver index in system.ini
    fHasOverlay,                // Can device overlay?
    fHasDlgVideoSource,         // Has Video source dlg?
    fHasDlgVideoFormat,         // Has Format dlg?
    fHasDlgVideoDisplay,        // Has External out dlg?
    fCaptureInitialized,        // Driver ready to capture?
    fDriverSuppliesPalettes: LongBool;    // Can driver make palettes?

// following always NULL on Win32.
    hVideoIn,                   // Driver In channel
    hVideoOut,                  // Driver Out channel
    hVideoExtIn,                // Driver Ext In channel
    hVideoExtOut: THandle;               // Driver Ext Out channel
end;
CAPDRIVERCAPS = tagCapDriverCaps;
PCAPDRIVERCAPS = ^tagCapDriverCaps;

type
tagCapStatus = record
    uiImageWidth,               // Width of the image
    uiImageHeight: Integer;              // Height of the image
    fLiveWindow,                // Now Previewing video?
    fOverlayWindow,             // Now Overlaying video?
    fScale: LongBool;                     // Scale image to client?
    ptScroll: TPoint{POINT};                   // Scroll position
    fUsingDefaultPalette,       // Using default driver palette?
    fAudioHardware,             // Audio hardware present?
    fCapFileExists: LongBool;             // Does capture file exist?
    dwCurrentVideoFrame,        // # of video frames cap'td
    dwCurrentVideoFramesDropped,// # of video frames dropped
    dwCurrentWaveSamples,       // # of wave samples cap'td
    dwCurrentTimeElapsedMS: DWORD;     // Elapsed capture duration
    hPalCurrent: HPALETTE;                // Current palette in use
    fCapturingNow: LongBool;              // Capture in progress?
    dwReturn: DWORD;                   // Error value after any operation
    wNumVideoAllocated,         // Actual number of video buffers
    wNumAudioAllocated: Integer;         // Actual number of audio buffers
end;
CAPSTATUS = tagCapStatus;
PCAPSTATUS = ^tagCapStatus;

                                            // Default values in parenthesis
type
tagCaptureParms = record
    dwRequestMicroSecPerFrame: DWORD;  // Requested capture rate
    fMakeUserHitOKToCapture: LongBool;    // Show "Hit OK to cap" dlg?
    wPercentDropForError: Integer;       // Give error msg if > (10%)
    fYield: LongBool;                     // Capture via background task?
    dwIndexSize: DWORD;                // Max index size in frames (32K)
    wChunkGranularity: Integer;          // Junk chunk granularity (2K)
    fUsingDOSMemory: LongBool;            // Use DOS buffers?
    wNumVideoRequested: Integer;         // # video buffers, If 0, autocalc
    fCaptureAudio: LongBool;              // Capture audio?
    wNumAudioRequested: Integer;         // # audio buffers, If 0, autocalc
    vKeyAbort: Integer;                  // Virtual key causing abort
    fAbortLeftMouse,            // Abort on left mouse?
    fAbortRightMouse,           // Abort on right mouse?
    fLimitEnabled: LongBool;              // Use wTimeLimit?
    wTimeLimit: Integer;                 // Seconds to capture
    fMCIControl: LongBool;                // Use MCI video source?
    fStepMCIDevice: LongBool;             // Step MCI device?
    dwMCIStartTime,             // Time to start in MS
    dwMCIStopTime: DWORD;              // Time to stop in MS
    fStepCaptureAt2x: LongBool;           // Perform spatial averaging 2x
    wStepCaptureAverageFrames: Integer;  // Temporal average n Frames
    dwAudioBufferSize: DWORD;          // Size of audio bufs (0 = default)
    fDisableWriteCache: LongBool;         // Attempt to disable write cache
    AVStreamMaster: Integer;             // Which stream controls length?
end;
CAPTUREPARMS = tagCaptureParms;
PCAPTUREPARMS = ^tagCaptureParms;



{/{/***************************************************************************

                         Structures

****************************************************************************/}
//* video data block header */
type
videohdr_tag=record
    lpData:Pointer;                 //* pointer to locked data buffer */
    dwBufferLength,         //* Length of data buffer */
    dwBytesUsed,            //* Bytes actually used */
    dwTimeCaptured,         //* Milliseconds from start of stream */
    dwUser,                 //* for client's use */
    dwFlags:LongInt;                //* assorted flags (see defines) */
    dwReserved:array[0..3]of LongInt;          //* reserved for driver */
end;

VIDEOHDR=videohdr_tag;
PVIDEOHDR=^videohdr_tag;

//* dwFlags field of VIDEOHDR */
const
VHDR_DONE       =$00000001;  //* Done bit */
VHDR_PREPARED   =$00000002;  //* Set if this header has been prepared */
VHDR_INQUEUE    =$00000004;  //* Reserved for driver */
VHDR_KEYFRAME   =$00000008;  //* Key Frame */

//* Channel capabilities structure */
type
channel_caps_tag=record
    dwFlags,                //* Capability flags*/
    dwSrcRectXMod,          //* Granularity of src rect in x */
    dwSrcRectYMod,          //* Granularity of src rect in y */
    dwSrcRectWidthMod,      //* Granularity of src rect width */
    dwSrcRectHeightMod,     //* Granularity of src rect height */
    dwDstRectXMod,          //* Granularity of dst rect in x */
    dwDstRectYMod,          //* Granularity of dst rect in y */
    dwDstRectWidthMod,      //* Granularity of dst rect width */
    dwDstRectHeightMod:LongInt;     //* Granularity of dst rect height */
end;
CHANNEL_CAPS=channel_caps_tag;
PCHANNEL_CAPS=^channel_caps_tag;

//* dwFlags of CHANNEL_CAPS */
const
VCAPS_OVERLAY       =$00000001;      //* overlay channel */
VCAPS_SRC_CAN_CLIP  =$00000002;      //* src rect can clip */
VCAPS_DST_CAN_CLIP  =$00000004;      //* dst rect can clip */
VCAPS_CAN_SCALE     =$00000008;      //* allows src != dst */

{/***************************************************************************

			API Flags

****************************************************************************/}

// Types of channels to open with the videoOpen function
VIDEO_EXTERNALIN		=$0001;
VIDEO_EXTERNALOUT		=$0002;
VIDEO_IN			=$0004;
VIDEO_OUT			=$0008;

// Is a driver dialog available for this channel?
VIDEO_DLG_QUERY			=$0010;

// videoConfigure (both GET and SET)
VIDEO_CONFIGURE_QUERY   	=$8000;

// videoConfigure (SET only)
VIDEO_CONFIGURE_SET		=$1000;

// videoConfigure (GET only)
VIDEO_CONFIGURE_GET		=$2000;
VIDEO_CONFIGURE_QUERYSIZE	=$0001;

VIDEO_CONFIGURE_CURRENT		=$0010;
VIDEO_CONFIGURE_NOMINAL		=$0020;
VIDEO_CONFIGURE_MIN		=$0040;
VIDEO_CONFIGURE_MAX		=$0080;






{/****************************************************************************
 *
 *  COMPMAN - Installable Compression Manager.
 *
 ****************************************************************************/}


const ICVERSION=$0104;

type
  HIC=THandle;     //* Handle to a Installable Compressor */


{//
// this code in biCompression means the DIB must be accessed via
// 48 bit pointers! using *ONLY* the selector given.
//}

const
BI_1632=$32333631;     // '1632'

{#ifndef mmioFOURCC
#define mmioFOURCC( ch0, ch1, ch2, ch3 )				\
		( (DWORD)(BYTE)(ch0) | ( (DWORD)(BYTE)(ch1) << 8 ) |	\
		( (DWORD)(BYTE)(ch2) << 16 ) | ( (DWORD)(BYTE)(ch3) << 24 ) )
#endif}

{#ifndef aviTWOCC
#define aviTWOCC(ch0, ch1) ((WORD)(BYTE)(ch0) | ((WORD)(BYTE)(ch1) << 8))
#endif}

{#ifndef ICTYPE_VIDEO
#define ICTYPE_VIDEO    mmioFOURCC('v', 'i', 'd', 'c')
#define ICTYPE_AUDIO    mmioFOURCC('a', 'u', 'd', 'c')
#endif}

const
  ICERR_OK =              $0;
  ICERR_DONTDRAW =        1;
  ICERR_NEWPALETTE =      2;
  ICERR_GOTOKEYFRAME =	3;
  ICERR_STOPDRAWING = 	4;

  ICERR_UNSUPPORTED =    -1;
  ICERR_BADFORMAT =      -2;
  ICERR_MEMORY =         -3;
  ICERR_INTERNAL =       -4;
  ICERR_BADFLAGS =       -5;
  ICERR_BADPARAM =       -6;
  ICERR_BADSIZE  =       -7;
  ICERR_BADHANDLE =      -8;
  ICERR_CANTUPDATE =     -9;
  ICERR_ABORT =          -10;
  ICERR_ERROR =          -100;
  ICERR_BADBITDEPTH =    -200;
  ICERR_BADIMAGESIZE =   -201;
  ICERR_CUSTOM =         -400;    // errors less than ICERR_CUSTOM...


{/* Values for dwFlags of ICOpen() */}
  ICMODE_COMPRESS = 1;
  ICMODE_DECOMPRESS = 2;
  ICMODE_FASTDECOMPRESS = 3;
  ICMODE_QUERY =           4;
  ICMODE_FASTCOMPRESS =    5;
  ICMODE_DRAW =            8;


{/* Flags for AVI file index */}
 AVIIF_LIST =	$00000001;
 AVIIF_TWOCC =	$00000002;
 AVIIF_KEYFRAME=$00000010;

{/* quality flags */}
 ICQUALITY_LOW =      0;
 ICQUALITY_HIGH =     10000;
 ICQUALITY_DEFAULT =  -1;

{/************************************************************************
************************************************************************/}

 ICM_USER =         (DRV_USER+$0000);
 ICM_RESERVED_LOW=  (DRV_USER+$1000);
 ICM_RESERVED =     ICM_RESERVED_LOW;

 ICM_RESERVED_HIGH =(DRV_USER+$2000);

{/************************************************************************

    messages.

************************************************************************/}

  ICM_GETSTATE =              (ICM_RESERVED+0);    // Get compressor state
  ICM_SETSTATE =               (ICM_RESERVED+1);    // Set compressor state
  ICM_GETINFO  =               (ICM_RESERVED+2);    // Query info about the compressor

  ICM_CONFIGURE =              (ICM_RESERVED+10);   // show the configure dialog
  ICM_ABOUT     =              (ICM_RESERVED+11);   // show the about box

  ICM_GETDEFAULTQUALITY =      (ICM_RESERVED+30);   // get the default value for quality
  ICM_GETQUALITY  =            (ICM_RESERVED+31);   // get the current value for quality
  ICM_SETQUALITY  =            (ICM_RESERVED+32);   // set the default value for quality

  ICM_SET	   =		    (ICM_RESERVED+40);	// Tell the driver something
  ICM_GET	=		    (ICM_RESERVED+41);	// Ask the driver something

// Constants for ICM_SET:
{  ICM_FRAMERATE       mmioFOURCC('F','r','m','R')
  ICM_KEYFRAMERATE    mmioFOURCC('K','e','y','R')}

{/************************************************************************

    ICM specific messages.

************************************************************************/}

  ICM_COMPRESS_GET_FORMAT     = (ICM_USER+4);    // get compress format or size
  ICM_COMPRESS_GET_SIZE       = (ICM_USER+5);    // get output size
  ICM_COMPRESS_QUERY          = (ICM_USER+6);    // query support for compress
  ICM_COMPRESS_BEGIN          = (ICM_USER+7);    // begin a series of compress calls.
  ICM_COMPRESS                = (ICM_USER+8);    // compress a frame
  ICM_COMPRESS_END            = (ICM_USER+9);    // end of a series of compress calls.

  ICM_DECOMPRESS_GET_FORMAT   = (ICM_USER+10);   // get decompress format or size
  ICM_DECOMPRESS_QUERY        = (ICM_USER+11);   // query support for dempress
  ICM_DECOMPRESS_BEGIN        = (ICM_USER+12);   // start a series of decompress calls
  ICM_DECOMPRESS              = (ICM_USER+13);   // decompress a frame
  ICM_DECOMPRESS_END          = (ICM_USER+14);   // end a series of decompress calls
  ICM_DECOMPRESS_SET_PALETTE  = (ICM_USER+29);   // fill in the DIB color table
  ICM_DECOMPRESS_GET_PALETTE  = (ICM_USER+30);   // fill in the DIB color table

  ICM_DRAW_QUERY              = (ICM_USER+31);   // query support for dempress
  ICM_DRAW_BEGIN              = (ICM_USER+15);   // start a series of draw calls
  ICM_DRAW_GET_PALETTE        = (ICM_USER+16);   // get the palette needed for drawing
  ICM_DRAW_START              = (ICM_USER+18);   // start decompress clock
  ICM_DRAW_STOP               = (ICM_USER+19);   // stop decompress clock
  ICM_DRAW_END                = (ICM_USER+21);   // end a series of draw calls
  ICM_DRAW_GETTIME            = (ICM_USER+32);   // get value of decompress clock
  ICM_DRAW                    = (ICM_USER+33);   // generalized "render" message
  ICM_DRAW_WINDOW             = (ICM_USER+34);   // drawing window has moved or hidden
  ICM_DRAW_SETTIME            = (ICM_USER+35);   // set correct value for decompress clock
  ICM_DRAW_REALIZE            = (ICM_USER+36);   // realize palette for drawing
  ICM_DRAW_FLUSH	            = (ICM_USER+37);   // clear out buffered frames
  ICM_DRAW_RENDERBUFFER       = (ICM_USER+38);   // draw undrawn things in queue

  ICM_DRAW_START_PLAY         = (ICM_USER+39);   // start of a play
  ICM_DRAW_STOP_PLAY          = (ICM_USER+40);   // end of a play

  ICM_DRAW_SUGGESTFORMAT      = (ICM_USER+50);   // Like ICGetDisplayFormat
  ICM_DRAW_CHANGEPALETTE      = (ICM_USER+51);   // for animating palette

  ICM_GETBUFFERSWANTED        = (ICM_USER+41);   // ask about prebuffering

  ICM_GETDEFAULTKEYFRAMERATE  = (ICM_USER+42);   // get the default value for key frames

  ICM_DECOMPRESSEX_BEGIN      = (ICM_USER+60);   // start a series of decompress calls
  ICM_DECOMPRESSEX_QUERY      = (ICM_USER+61);   // start a series of decompress calls
  ICM_DECOMPRESSEX            = (ICM_USER+62);   // decompress a frame
  ICM_DECOMPRESSEX_END        = (ICM_USER+63);   // end a series of decompress calls

  ICM_COMPRESS_FRAMES_INFO    = (ICM_USER+70);   // tell about compress to come
  ICM_SET_STATUS_PROC	        = (ICM_USER+72);   // set status callback

{/************************************************************************
************************************************************************/}

type
TIcOpen = record
  dwSize,         // sizeof(ICOPEN)
  fccType,        // 'vidc'
  fccHandler,     //
  dwVersion,      // version of compman opening you
  dwFlags: DWORD;        // LOWORD is type specific
  {  LRESULT} dwError: LongInt;        // error return.
  pV1Reserved,    // Reserved
  pV2Reserved: Pointer;    // Reserved
  dnDevNode: DWORD;      // Devnode for PnP devices
end;

PIcOpen = ^TIcOpen;

{/************************************************************************
***********************************************************************/}

type
TIcInfo = record
    dwSize,                 // sizeof(TIcInfo)
    fccType,                // compressor type     'vidc' 'audc'
    fccHandler,             // compressor sub-type 'rle ' 'jpeg' 'pcm '
    dwFlags,                // flags LOWORD is type specific
    dwVersion,              // version of the driver
    dwVersionICM: DWORD;           // version of the ICM used
    //
    // under Win32, the driver always returns UNICODE strings.
    //
    szName: array[0..15] of WORD;             // short name
    szDescription: array[0..127] of WORD;     // long name
    szDriver: array[0..127]of WORD;          // driver that contains compressor
end;

PIcInfo = ^TIcInfo;

const
{/* Flags for the <dwFlags> field of the <TIcInfo> structure. */}
  VIDCF_QUALITY        = $0001;  // supports quality
  VIDCF_CRUNCH         = $0002;  // supports crunching to a frame size
  VIDCF_TEMPORAL       = $0004;  // supports inter-frame compress
  VIDCF_COMPRESSFRAMES = $0008;  // wants the compress all frames message
  VIDCF_DRAW           = $0010;  // supports drawing
  VIDCF_FASTTEMPORALC  = $0020;  // does not need prev frame on compress
  VIDCF_FASTTEMPORALD  = $0080;  // does not need prev frame on decompress
//#define VIDCF_QUALITYTIME    0x0040  // supports temporal quality

//#define VIDCF_FASTTEMPORAL   (VIDCF_FASTTEMPORALC|VIDCF_FASTTEMPORALD)

{/************************************************************************
************************************************************************/}

{/****************************************************************************
 *
 *  AVIFile - routines for reading/writing standard AVI files
 *
 ***************************************************************************/


/*
 * Ansi - Unicode thunking.
 *
 * Unicode or Ansi-only apps can call the avifile APIs.
 * any Win32 app who wants to use
 * any of the AVI COM interfaces must be UNICODE - the AVISTREAMINFO and
 * AVIFILEINFO structures used in the Info methods of these interfaces are
 * the unicode variants, and no thunking to or from ansi takes place
 * except in the AVIFILE api entrypoints.
 *
 * For Ansi/Unicode thunking: for each entrypoint or structure that
 * uses chars or strings, two versions are declared in the Win32 version,
 * ApiNameW and ApiNameA. The default name ApiName is #defined to one or
 * other of these depending on whether UNICODE is defined (during
 * compilation of the app that is including this header). The source will
 * contain ApiName and ApiNameA (with ApiName being the Win16 implementation,
 * and also #defined to ApiNameW, and ApiNameA being the thunk entrypoint).
 *
 */ }

{#ifndef mmioFOURCC
    #define mmioFOURCC( ch0, ch1, ch2, ch3 ) \
	( (DWORD)(BYTE)(ch0) | ( (DWORD)(BYTE)(ch1) << 8 ) |	\
	( (DWORD)(BYTE)(ch2) << 16 ) | ( (DWORD)(BYTE)(ch3) << 24 ) )
#endif

#ifndef streamtypeVIDEO
streamtypeVIDEO = mmioFOURCC('v', 'i', 'd', 's')
#define streamtypeAUDIO		mmioFOURCC('a', 'u', 'd', 's')
#define streamtypeMIDI		mmioFOURCC('m', 'i', 'd', 's')
#define streamtypeTEXT		mmioFOURCC('t', 'x', 't', 's')
#endif }


//const AVIIF_KEYFRAME=$00000010; // this frame is a key frame.


// For GetFrame::SetFormat - use the best format for the display
const AVIGETFRAMEF_BESTDISPLAYFMT=1;
//
// Structures used by AVIStreamInfo & AVIFileInfo.
//
// These are related to, but not identical to, the header chunks
// in an AVI file.
//

{/*
 *
 * --- AVISTREAMINFO ------------------------------------------------
 *
 * for Unicode/Ansi thunking we need to declare three versions of this!
 */}
type
_AVISTREAMINFOW = record
    fccType,
    fccHandler,
    dwFlags,        //* Contains AVITF_* flags */
    dwCaps: DWORD;
    wPriority,
    wLanguage: WORD;
    dwScale,
    dwRate, //* dwRate / dwScale == samples/second */
    dwStart,
    dwLength, //* In units above... */
    dwInitialFrames,
    dwSuggestedBufferSize,
    dwQuality,
    dwSampleSize: DWORD;
    rcFrame: TRect;
    dwEditCount,
    dwFormatChangeCount: DWORD;
    szName: array[0..63] of WCHAR;
end;
AVISTREAMINFOW = _AVISTREAMINFOW;
PAVISTREAMINFOW = ^_AVISTREAMINFOW;

{für win32 nicht benötigt, s.o.
typedef struct _AVISTREAMINFOA {
    DWORD		fccType;
    DWORD               fccHandler;
    DWORD               dwFlags;        /* Contains AVITF_* flags */
    DWORD		dwCaps;
    WORD		wPriority;
    WORD		wLanguage;
    DWORD               dwScale;
    DWORD               dwRate; /* dwRate / dwScale == samples/second */
    DWORD               dwStart;
    DWORD               dwLength; /* In units above... */
    DWORD		dwInitialFrames;
    DWORD               dwSuggestedBufferSize;
    DWORD               dwQuality;
    DWORD               dwSampleSize;
    RECT                rcFrame;
    DWORD		dwEditCount;
    DWORD		dwFormatChangeCount;
    char		szName[64];
}{ AVISTREAMINFOA, FAR * LPAVISTREAMINFOA;}

//#ifdef UNICODE
type AVISTREAMINFO = AVISTREAMINFOW;
type PAVISTREAMINFO = PAVISTREAMINFOW;
{#else
#define AVISTREAMINFO	AVISTREAMINFOA
#define LPAVISTREAMINFO	LPAVISTREAMINFOA
#endif}

const AVISTREAMINFO_DISABLED=$00000001;
const AVISTREAMINFO_FORMATCHANGES=$00010000;

{/*
 * --- AVIFILEINFO ----------------------------------------------------
 *
 */}

type
_AVIFILEINFOW = record
    		dwMaxBytesPerSec,	// max. transfer rate
    		dwFlags,		// the ever-present flags
    		dwCaps,
    		dwStreams,
    		dwSuggestedBufferSize,

    		dwWidth,
    		dwHeight,

    		dwScale,
    		dwRate,	//* dwRate / dwScale == samples/second */
    		dwLength,

    		dwEditCount: DWORD;

                szFileType: array[0..63] of WCHAR;		// descriptive string for file type?
end;
type AVIFILEINFOW = _AVIFILEINFOW;
type PAVIFILEINFOW = ^_AVIFILEINFOW;

{typedef struct _AVIFILEINFOA {
    DWORD		dwMaxBytesPerSec;	// max. transfer rate
    DWORD		dwFlags;		// the ever-present flags
    DWORD		dwCaps;
    DWORD		dwStreams;
    DWORD		dwSuggestedBufferSize;

    DWORD		dwWidth;
    DWORD		dwHeight;

    DWORD		dwScale;
    DWORD		dwRate;	/* dwRate / dwScale == samples/second */
    DWORD		dwLength;

    DWORD		dwEditCount;

    char		szFileType[64];		// descriptive string for file type?
} {AVIFILEINFOA, FAR * LPAVIFILEINFOA;}

//#ifdef UNICODE
type AVIFILEINFO = AVIFILEINFOW;
type PAVIFILEINFO = PAVIFILEINFOW;
{#else
#define AVIFILEINFO	AVIFILEINFOA
#define LPAVIFILEINFO	LPAVIFILEINFOA
#endif}

// Flags for dwFlags
const AVIFILEINFO_HASINDEX		 = $00000010;
const AVIFILEINFO_MUSTUSEINDEX	 = $00000020;
const AVIFILEINFO_ISINTERLEAVED	 = $00000100;
const AVIFILEINFO_WASCAPTUREFILE	 = $00010000;
const AVIFILEINFO_COPYRIGHTED		 = $00020000;

// Flags for dwCaps
const AVIFILECAPS_CANREAD		 = $00000001;
const AVIFILECAPS_CANWRITE		 = $00000002;
const AVIFILECAPS_ALLKEYFRAMES	 = $00000010;
const AVIFILECAPS_NOCOMPRESSION	 = $00000020;

{typedef BOOL (FAR PASCAL * AVISAVECALLBACK)(int);

/************************************************************************/
/* Declaration for the AVICOMPRESSOPTIONS structure.  Make sure it 	*/
/* matches the AutoDoc in avisave.c !!!                            	*/
/************************************************************************/

typedef struct {
    DWORD	fccType;		    /* stream type, for consistency */
    DWORD       fccHandler;                 /* compressor */
    DWORD       dwKeyFrameEvery;            /* keyframe rate */
    DWORD       dwQuality;                  /* compress quality 0-10,000 */
    DWORD       dwBytesPerSecond;           /* bytes per second */
    DWORD       dwFlags;                    /* flags... see below */
    LPVOID      lpFormat;                   /* save format */
    DWORD       cbFormat;
    LPVOID      lpParms;                    /* compressor options */
    DWORD       cbParms;
    DWORD       dwInterleaveEvery;          /* for non-video streams only */
}// AVICOMPRESSOPTIONS, FAR *LPAVICOMPRESSOPTIONS;

//
// Defines for the dwFlags field of the AVICOMPRESSOPTIONS struct
// Each of these flags determines if the appropriate field in the structure
// (dwInterleaveEvery, dwBytesPerSecond, and dwKeyFrameEvery) is payed
// attention to.  See the autodoc in avisave.c for details.
//
{#define AVICOMPRESSF_INTERLEAVE		0x00000001    // interleave
#define AVICOMPRESSF_DATARATE		0x00000002    // use a data rate
#define AVICOMPRESSF_KEYFRAMES		0x00000004    // use keyframes
#define AVICOMPRESSF_VALID		0x00000008    // has valid data?

#include <ole2.h>

/*	-	-	-	-	-	-	-	-	*/

/****** AVI Stream Interface *******************************************/

#undef  INTERFACE
#define INTERFACE   IAVIStream

DECLARE_INTERFACE_(IAVIStream, IUnknown)
{
    // *** IUnknown methods ***
    STDMETHOD(QueryInterface) (THIS_ REFIID riid, LPVOID FAR* ppvObj) PURE;
    STDMETHOD_(ULONG,AddRef) (THIS)  PURE;
    STDMETHOD_(ULONG,Release) (THIS) PURE;

    // *** IAVIStream methods ***
    STDMETHOD(Create)      (THIS_ LPARAM lParam1, LPARAM lParam2) PURE ;
    STDMETHOD(Info)        (THIS_ AVISTREAMINFOW FAR * psi, LONG lSize) PURE ;
    STDMETHOD_(LONG, FindSample)(THIS_ LONG lPos, LONG lFlags) PURE ;
    STDMETHOD(ReadFormat)  (THIS_ LONG lPos,
			    LPVOID lpFormat, LONG FAR *lpcbFormat) PURE ;
    STDMETHOD(SetFormat)   (THIS_ LONG lPos,
			    LPVOID lpFormat, LONG cbFormat) PURE ;
    STDMETHOD(Read)        (THIS_ LONG lStart, LONG lSamples,
			    LPVOID lpBuffer, LONG cbBuffer,
			    LONG FAR * plBytes, LONG FAR * plSamples) PURE ;
    STDMETHOD(Write)       (THIS_ LONG lStart, LONG lSamples,
			    LPVOID lpBuffer, LONG cbBuffer,
			    DWORD dwFlags,
			    LONG FAR *plSampWritten,
			    LONG FAR *plBytesWritten) PURE ;
    STDMETHOD(Delete)      (THIS_ LONG lStart, LONG lSamples) PURE;
    STDMETHOD(ReadData)    (THIS_ DWORD fcc, LPVOID lp, LONG FAR *lpcb) PURE ;
    STDMETHOD(WriteData)   (THIS_ DWORD fcc, LPVOID lp, LONG cb) PURE ;
#ifdef _WIN32
    STDMETHOD(SetInfo) (THIS_ AVISTREAMINFOW FAR * lpInfo,
			    LONG cbInfo) PURE;
#else
    STDMETHOD(Reserved1)            (THIS) PURE;
    STDMETHOD(Reserved2)            (THIS) PURE;
    STDMETHOD(Reserved3)            (THIS) PURE;
    STDMETHOD(Reserved4)            (THIS) PURE;
    STDMETHOD(Reserved5)            (THIS) PURE;
#endif
}

{typedef       IAVIStream FAR* PAVISTREAM;

#undef  INTERFACE
#define INTERFACE   IAVIStreaming

DECLARE_INTERFACE_(IAVIStreaming, IUnknown)
{
    // *** IUnknown methods ***
    STDMETHOD(QueryInterface) (THIS_ REFIID riid, LPVOID FAR* ppvObj) PURE;
    STDMETHOD_(ULONG,AddRef) (THIS)  PURE;
    STDMETHOD_(ULONG,Release) (THIS) PURE;

    // *** IAVIStreaming methods ***
    STDMETHOD(Begin) (THIS_
		      LONG  lStart,		    // start of what we expect
						    // to play
		      LONG  lEnd,		    // expected end, or -1
		      LONG  lRate) PURE;	    // Should this be a float?
    STDMETHOD(End)   (THIS) PURE;
}

{typedef       IAVIStreaming FAR* PAVISTREAMING;

#undef  INTERFACE
#define INTERFACE   IAVIEditStream

DECLARE_INTERFACE_(IAVIEditStream, IUnknown)
{
    // *** IUnknown methods ***
    STDMETHOD(QueryInterface) (THIS_ REFIID riid, LPVOID FAR* ppvObj) PURE;
    STDMETHOD_(ULONG,AddRef) (THIS)  PURE;
    STDMETHOD_(ULONG,Release) (THIS) PURE;

    // *** IAVIEditStream methods ***
    STDMETHOD(Cut) (THIS_ LONG FAR *plStart,
			  LONG FAR *plLength,
			  PAVISTREAM FAR * ppResult) PURE;
    STDMETHOD(Copy) (THIS_ LONG FAR *plStart,
			   LONG FAR *plLength,
			   PAVISTREAM FAR * ppResult) PURE;
    STDMETHOD(Paste) (THIS_ LONG FAR *plPos,
			    LONG FAR *plLength,
			    PAVISTREAM pstream,
			    LONG lStart,
			    LONG lEnd) PURE;
    STDMETHOD(Clone) (THIS_ PAVISTREAM FAR *ppResult) PURE;
    STDMETHOD(SetInfo) (THIS_ AVISTREAMINFOW FAR * lpInfo,
			    LONG cbInfo) PURE;
}

{typedef       IAVIEditStream FAR* PAVIEDITSTREAM;

/****** AVI File Interface *******************************************/

#undef  INTERFACE
#define INTERFACE   IAVIFile
#define PAVIFILE IAVIFile FAR*

DECLARE_INTERFACE_(IAVIFile, IUnknown)
{
    // *** IUnknown methods ***
    STDMETHOD(QueryInterface) (THIS_ REFIID riid, LPVOID FAR* ppvObj) PURE;
    STDMETHOD_(ULONG,AddRef) (THIS)  PURE;
    STDMETHOD_(ULONG,Release) (THIS) PURE;

    // *** IAVIFile methods ***
    STDMETHOD(Info)                 (THIS_
                                     AVIFILEINFOW FAR * pfi,
                                     LONG lSize) PURE;
    STDMETHOD(GetStream)            (THIS_
                                     PAVISTREAM FAR * ppStream,
				     DWORD fccType,
                                     LONG lParam) PURE;
    STDMETHOD(CreateStream)         (THIS_
                                     PAVISTREAM FAR * ppStream,
                                     AVISTREAMINFOW FAR * psi) PURE;
    STDMETHOD(WriteData)            (THIS_
                                     DWORD ckid,
                                     LPVOID lpData,
                                     LONG cbData) PURE;
    STDMETHOD(ReadData)             (THIS_
                                     DWORD ckid,
                                     LPVOID lpData,
                                     LONG FAR *lpcbData) PURE;
    STDMETHOD(EndRecord)            (THIS) PURE;
    STDMETHOD(DeleteStream)         (THIS_
				     DWORD fccType,
                                     LONG lParam) PURE;
}

{#undef PAVIFILE
typedef       IAVIFile FAR* PAVIFILE;

/****** GetFrame Interface *******************************************/

#undef  INTERFACE
#define INTERFACE   IGetFrame
#define PGETFRAME   IGetFrame FAR*

DECLARE_INTERFACE_(IGetFrame, IUnknown)
{
    // *** IUnknown methods ***
    STDMETHOD(QueryInterface) (THIS_ REFIID riid, LPVOID FAR* ppvObj) PURE;
    STDMETHOD_(ULONG,AddRef) (THIS)  PURE;
    STDMETHOD_(ULONG,Release) (THIS) PURE;

    // *** IGetFrame methods ***

    STDMETHOD_(LPVOID,GetFrame) (THIS_ LONG lPos) PURE;
//  STDMETHOD_(LPVOID,GetFrameData) (THIS_ LONG lPos) PURE;

    STDMETHOD(Begin) (THIS_ LONG lStart, LONG lEnd, LONG lRate) PURE;
    STDMETHOD(End) (THIS) PURE;

    STDMETHOD(SetFormat) (THIS_ LPBITMAPINFOHEADER lpbi, LPVOID lpBits, int x, int y, int dx, int dy) PURE;

//  STDMETHOD(DrawFrameStart) (THIS) PURE;
//  STDMETHOD(DrawFrame) (THIS_ LONG lPos, HDC hdc, int x, int y, int dx, int dy) PURE;
//  STDMETHOD(DrawFrameEnd) (THIS) PURE;
}

{#undef PGETFRAME
typedef IGetFrame FAR* PGETFRAME;

/****** GUIDs *******************************************/

#define DEFINE_AVIGUID(name, l, w1, w2) \
    DEFINE_GUID(name, l, w1, w2, 0xC0,0,0,0,0,0,0,0x46)

DEFINE_AVIGUID(IID_IAVIFile,            0x00020020, 0, 0);
DEFINE_AVIGUID(IID_IAVIStream,          0x00020021, 0, 0);
DEFINE_AVIGUID(IID_IAVIStreaming,       0x00020022, 0, 0);
DEFINE_AVIGUID(IID_IGetFrame,           0x00020023, 0, 0);
DEFINE_AVIGUID(IID_IAVIEditStream,      0x00020024, 0, 0);
#ifndef UNICODE
DEFINE_AVIGUID(CLSID_AVISimpleUnMarshal,        0x00020009, 0, 0);
#endif

DEFINE_AVIGUID(CLSID_AVIFile,           0x00020000, 0, 0);

#define	AVIFILEHANDLER_CANREAD		0x0001
#define	AVIFILEHANDLER_CANWRITE		0x0002
#define	AVIFILEHANDLER_CANACCEPTNONRGB	0x0004

//
// functions
//

STDAPI_(void) AVIFileInit(void);   // Call this first!
STDAPI_(void) AVIFileExit(void);

STDAPI_(ULONG) AVIFileAddRef       (PAVIFILE pfile);
STDAPI_(ULONG) AVIFileRelease      (PAVIFILE pfile);

#ifdef _WIN32
STDAPI AVIFileOpenA       (PAVIFILE FAR * ppfile, LPCSTR szFile,
			  UINT uMode, LPCLSID lpHandler);
STDAPI AVIFileOpenW       (PAVIFILE FAR * ppfile, LPCWSTR szFile,
			  UINT uMode, LPCLSID lpHandler);
#ifdef UNICODE
#define AVIFileOpen	  AVIFileOpenW	
#else
#define AVIFileOpen	  AVIFileOpenA
#endif
#else // win16
STDAPI AVIFileOpen       (PAVIFILE FAR * ppfile, LPCSTR szFile,
			  UINT uMode, LPCLSID lpHandler);
#endif

#ifdef _WIN32
STDAPI AVIFileInfoW (PAVIFILE pfile, LPAVIFILEINFOW pfi, LONG lSize);
STDAPI AVIFileInfoA (PAVIFILE pfile, LPAVIFILEINFOA pfi, LONG lSize);
#ifdef UNICODE
#define AVIFileInfo	AVIFileInfoW
#else
#define AVIFileInfo	AVIFileInfoA
#endif
#else //win16 version
STDAPI AVIFileInfo (PAVIFILE pfile, LPAVIFILEINFO pfi, LONG lSize);
#endif

STDAPI AVIFileGetStream     (PAVIFILE pfile, PAVISTREAM FAR * ppavi, DWORD fccType, LONG lParam);

#ifdef _WIN32
STDAPI AVIFileCreateStreamW (PAVIFILE pfile, PAVISTREAM FAR *ppavi, AVISTREAMINFOW FAR * psi);
STDAPI AVIFileCreateStreamA (PAVIFILE pfile, PAVISTREAM FAR *ppavi, AVISTREAMINFOA FAR * psi);
#ifdef UNICODE
#define AVIFileCreateStream	AVIFileCreateStreamW
#else
#define AVIFileCreateStream	AVIFileCreateStreamA
#endif
#else //win16 version
STDAPI AVIFileCreateStream(PAVIFILE pfile, PAVISTREAM FAR *ppavi, AVISTREAMINFO FAR * psi);
#endif

STDAPI AVIFileWriteData	(PAVIFILE pfile,
					 DWORD ckid,
					 LPVOID lpData,
					 LONG cbData);
STDAPI AVIFileReadData	(PAVIFILE pfile,
					 DWORD ckid,
					 LPVOID lpData,
					 LONG FAR *lpcbData);
STDAPI AVIFileEndRecord	(PAVIFILE pfile);

STDAPI_(ULONG) AVIStreamAddRef       (PAVISTREAM pavi);
STDAPI_(ULONG) AVIStreamRelease      (PAVISTREAM pavi);

STDAPI AVIStreamInfoW (PAVISTREAM pavi, LPAVISTREAMINFOW psi, LONG lSize);
STDAPI AVIStreamInfoA (PAVISTREAM pavi, LPAVISTREAMINFOA psi, LONG lSize);
#ifdef UNICODE
#define AVIStreamInfo	AVIStreamInfoW
#else
#define AVIStreamInfo	AVIStreamInfoA
#endif

STDAPI_(LONG) AVIStreamFindSample(PAVISTREAM pavi, LONG lPos, LONG lFlags);
STDAPI AVIStreamReadFormat   (PAVISTREAM pavi, LONG lPos,LPVOID lpFormat,LONG FAR *lpcbFormat);
STDAPI AVIStreamSetFormat    (PAVISTREAM pavi, LONG lPos,LPVOID lpFormat,LONG cbFormat);
STDAPI AVIStreamReadData     (PAVISTREAM pavi, DWORD fcc, LPVOID lp, LONG FAR *lpcb);
STDAPI AVIStreamWriteData    (PAVISTREAM pavi, DWORD fcc, LPVOID lp, LONG cb);

STDAPI AVIStreamRead         (PAVISTREAM pavi,
			      LONG lStart,
			      LONG lSamples,
			      LPVOID lpBuffer,
			      LONG cbBuffer,
			      LONG FAR * plBytes,
			      LONG FAR * plSamples);
#define AVISTREAMREAD_CONVENIENT	(-1L)

STDAPI AVIStreamWrite        (PAVISTREAM pavi,
			      LONG lStart, LONG lSamples,
			      LPVOID lpBuffer, LONG cbBuffer, DWORD dwFlags,
			      LONG FAR *plSampWritten,
			      LONG FAR *plBytesWritten);

// Right now, these just use AVIStreamInfo() to get information, then
// return some of it.  Can they be more efficient?
STDAPI_(LONG) AVIStreamStart        (PAVISTREAM pavi);
STDAPI_(LONG) AVIStreamLength       (PAVISTREAM pavi);
STDAPI_(LONG) AVIStreamTimeToSample (PAVISTREAM pavi, LONG lTime);
STDAPI_(LONG) AVIStreamSampleToTime (PAVISTREAM pavi, LONG lSample);

STDAPI AVIStreamBeginStreaming(PAVISTREAM pavi, LONG lStart, LONG lEnd, LONG lRate);
STDAPI AVIStreamEndStreaming(PAVISTREAM pavi);

//
// helper functions for using IGetFrame
//
STDAPI_(PGETFRAME) AVIStreamGetFrameOpen(PAVISTREAM pavi,
					 LPBITMAPINFOHEADER lpbiWanted);
STDAPI_(LPVOID) AVIStreamGetFrame(PGETFRAME pg, LONG lPos);
STDAPI AVIStreamGetFrameClose(PGETFRAME pg);

// !!! We need some way to place an advise on a stream....
// STDAPI AVIStreamHasChanged   (PAVISTREAM pavi);

// Shortcut function
STDAPI AVIStreamOpenFromFileA(PAVISTREAM FAR *ppavi, LPCSTR szFile,
			     DWORD fccType, LONG lParam,
			     UINT mode, CLSID FAR *pclsidHandler);
STDAPI AVIStreamOpenFromFileW(PAVISTREAM FAR *ppavi, LPCWSTR szFile,
			     DWORD fccType, LONG lParam,
			     UINT mode, CLSID FAR *pclsidHandler);
#ifdef UNICODE
#define AVIStreamOpenFromFile	AVIStreamOpenFromFileW
#else
#define AVIStreamOpenFromFile	AVIStreamOpenFromFileA
#endif

// Use to create disembodied streams
STDAPI AVIStreamCreate(PAVISTREAM FAR *ppavi, LONG lParam1, LONG lParam2,
		       CLSID FAR *pclsidHandler);

// PHANDLER    AVIAPI AVIGetHandler         (PAVISTREAM pavi, PAVISTREAMHANDLER psh);
// PAVISTREAM  AVIAPI AVIGetStream          (PHANDLER p);

//
// flags for AVIStreamFindSample
//
#define FIND_DIR        0x0000000FL     // direction
#define FIND_NEXT       0x00000001L     // go forward
#define FIND_PREV       0x00000004L     // go backward
#define FIND_FROM_START 0x00000008L     // start at the logical beginning

#define FIND_TYPE       0x000000F0L     // type mask
#define FIND_KEY        0x00000010L     // find key frame.
#define FIND_ANY        0x00000020L     // find any (non-empty) sample
#define FIND_FORMAT     0x00000040L     // find format change

#define FIND_RET        0x0000F000L     // return mask
#define FIND_POS        0x00000000L     // return logical position
#define FIND_LENGTH     0x00001000L     // return logical size
#define FIND_OFFSET     0x00002000L     // return physical position
#define FIND_SIZE       0x00003000L     // return physical size
#define FIND_INDEX      0x00004000L     // return physical index position

//
//  stuff to support backward compat.
//
#define AVIStreamFindKeyFrame AVIStreamFindSample
#define FindKeyFrame	FindSample

#define AVIStreamClose AVIStreamRelease
#define AVIFileClose   AVIFileRelease
#define AVIStreamInit  AVIFileInit
#define AVIStreamExit  AVIFileExit

#define SEARCH_NEAREST  FIND_PREV
#define SEARCH_BACKWARD FIND_PREV
#define SEARCH_FORWARD  FIND_NEXT
#define SEARCH_KEY      FIND_KEY
#define SEARCH_ANY      FIND_ANY

//
//  helper macros.
//
#define     AVIStreamSampleToSample(pavi1, pavi2, l) \
            AVIStreamTimeToSample(pavi1,AVIStreamSampleToTime(pavi2, l))

#define     AVIStreamNextSample(pavi, l) \
            AVIStreamFindSample(pavi,l+1,FIND_NEXT|FIND_ANY)

#define     AVIStreamPrevSample(pavi, l) \
            AVIStreamFindSample(pavi,l-1,FIND_PREV|FIND_ANY)

#define     AVIStreamNearestSample(pavi, l) \
            AVIStreamFindSample(pavi,l,FIND_PREV|FIND_ANY)

#define     AVIStreamNextKeyFrame(pavi,l) \
            AVIStreamFindSample(pavi,l+1,FIND_NEXT|FIND_KEY)

#define     AVIStreamPrevKeyFrame(pavi, l) \
            AVIStreamFindSample(pavi,l-1,FIND_PREV|FIND_KEY)

#define     AVIStreamNearestKeyFrame(pavi, l) \
            AVIStreamFindSample(pavi,l,FIND_PREV|FIND_KEY)

#define     AVIStreamIsKeyFrame(pavi, l) \
            (AVIStreamNearestKeyFrame(pavi,l) == l)

#define     AVIStreamPrevSampleTime(pavi, t) \
            AVIStreamSampleToTime(pavi, AVIStreamPrevSample(pavi,AVIStreamTimeToSample(pavi,t)))

#define     AVIStreamNextSampleTime(pavi, t) \
            AVIStreamSampleToTime(pavi, AVIStreamNextSample(pavi,AVIStreamTimeToSample(pavi,t)))

#define     AVIStreamNearestSampleTime(pavi, t) \
            AVIStreamSampleToTime(pavi, AVIStreamNearestSample(pavi,AVIStreamTimeToSample(pavi,t)))

#define     AVIStreamNextKeyFrameTime(pavi, t) \
            AVIStreamSampleToTime(pavi, AVIStreamNextKeyFrame(pavi,AVIStreamTimeToSample(pavi, t)))

#define     AVIStreamPrevKeyFrameTime(pavi, t) \
            AVIStreamSampleToTime(pavi, AVIStreamPrevKeyFrame(pavi,AVIStreamTimeToSample(pavi, t)))

#define     AVIStreamNearestKeyFrameTime(pavi, t) \
            AVIStreamSampleToTime(pavi, AVIStreamNearestKeyFrame(pavi,AVIStreamTimeToSample(pavi, t)))

#define     AVIStreamStartTime(pavi) \
            AVIStreamSampleToTime(pavi, AVIStreamStart(pavi))

#define     AVIStreamLengthTime(pavi) \
            AVIStreamSampleToTime(pavi, AVIStreamLength(pavi))

#define     AVIStreamEnd(pavi) \
            (AVIStreamStart(pavi) + AVIStreamLength(pavi))

#define     AVIStreamEndTime(pavi) \
            AVIStreamSampleToTime(pavi, AVIStreamEnd(pavi))

#define     AVIStreamSampleSize(pavi, lPos, plSize) \
	    AVIStreamRead(pavi,lPos,1,NULL,0,plSize,NULL)

#define     AVIStreamFormatSize(pavi, lPos, plSize) \
            AVIStreamReadFormat(pavi,lPos,NULL,plSize)

#define     AVIStreamDataSize(pavi, fcc, plSize) \
            AVIStreamReadData(pavi,fcc,NULL,plSize)

/****************************************************************************
 *
 *  AVISave routines and structures
 *
 ***************************************************************************/

#ifndef comptypeDIB
#define comptypeDIB         mmioFOURCC('D', 'I', 'B', ' ')
#endif

STDAPI AVIMakeCompressedStream(
		PAVISTREAM FAR *	    ppsCompressed,
		PAVISTREAM		    ppsSource,
		AVICOMPRESSOPTIONS FAR *    lpOptions,
		CLSID FAR *pclsidHandler);

EXTERN_C HRESULT CDECL AVISaveA (LPCSTR               szFile,
		CLSID FAR *pclsidHandler,
		AVISAVECALLBACK     lpfnCallback,
		int                 nStreams,
		PAVISTREAM	    pfile,
		LPAVICOMPRESSOPTIONS lpOptions,
		...);

STDAPI AVISaveVA(LPCSTR               szFile,
		CLSID FAR *pclsidHandler,
		AVISAVECALLBACK     lpfnCallback,
		int                 nStreams,
		PAVISTREAM FAR *    ppavi,
		LPAVICOMPRESSOPTIONS FAR *plpOptions);
EXTERN_C HRESULT CDECL AVISaveW (LPCWSTR               szFile,
		CLSID FAR *pclsidHandler,
		AVISAVECALLBACK     lpfnCallback,
		int                 nStreams,
		PAVISTREAM	    pfile,
		LPAVICOMPRESSOPTIONS lpOptions,
		...);

STDAPI AVISaveVW(LPCWSTR               szFile,
		CLSID FAR *pclsidHandler,
		AVISAVECALLBACK     lpfnCallback,
		int                 nStreams,
		PAVISTREAM FAR *    ppavi,
		LPAVICOMPRESSOPTIONS FAR *plpOptions);
#ifdef UNICODE
#define AVISave		AVISaveW
#define AVISaveV	AVISaveVW
#else
#define AVISave		AVISaveA
#define AVISaveV	AVISaveVA
#endif

STDAPI_(BOOL) AVISaveOptions(HWND hwnd,
			     UINT	uiFlags,
			     int	nStreams,
			     PAVISTREAM FAR *ppavi,
			     LPAVICOMPRESSOPTIONS FAR *plpOptions);

STDAPI AVISaveOptionsFree(int nStreams,
			     LPAVICOMPRESSOPTIONS FAR *plpOptions);

// FLAGS FOR uiFlags:
//
// Same as the flags for ICCompressorChoose (see compman.h)
// These determine what the compression options dialog for video streams
// will look like.

STDAPI AVIBuildFilterW(LPWSTR lpszFilter, LONG cbFilter, BOOL fSaving);
STDAPI AVIBuildFilterA(LPSTR lpszFilter, LONG cbFilter, BOOL fSaving);
#ifdef UNICODE
#define AVIBuildFilter	AVIBuildFilterW
#else
#define AVIBuildFilter	AVIBuildFilterA
#endif
STDAPI AVIMakeFileFromStreams(PAVIFILE FAR *	ppfile,
			       int		nStreams,
			       PAVISTREAM FAR *	papStreams);

STDAPI AVIMakeStreamFromClipboard(UINT cfFormat, HANDLE hGlobal, PAVISTREAM FAR *ppstream);

/****************************************************************************
 *
 *  Clipboard routines
 *
 ***************************************************************************/

STDAPI AVIPutFileOnClipboard(PAVIFILE pf);

STDAPI AVIGetFromClipboard(PAVIFILE FAR * lppf);

STDAPI AVIClearClipboard(void);

/****************************************************************************
 *
 *  Editing routines
 *
 ***************************************************************************/
STDAPI CreateEditableStream(
		PAVISTREAM FAR *	    ppsEditable,
		PAVISTREAM		    psSource);

STDAPI EditStreamCut(PAVISTREAM pavi, LONG FAR *plStart, LONG FAR *plLength, PAVISTREAM FAR * ppResult);

STDAPI EditStreamCopy(PAVISTREAM pavi, LONG FAR *plStart, LONG FAR *plLength, PAVISTREAM FAR * ppResult);

STDAPI EditStreamPaste(PAVISTREAM pavi, LONG FAR *plPos, LONG FAR *plLength, PAVISTREAM pstream, LONG lStart, LONG lEnd);

STDAPI EditStreamClone(PAVISTREAM pavi, PAVISTREAM FAR *ppResult);

STDAPI EditStreamSetNameA(PAVISTREAM pavi, LPCSTR lpszName);
STDAPI EditStreamSetNameW(PAVISTREAM pavi, LPCWSTR lpszName);
STDAPI EditStreamSetInfoW(PAVISTREAM pavi, LPAVISTREAMINFOW lpInfo, LONG cbInfo);
STDAPI EditStreamSetInfoA(PAVISTREAM pavi, LPAVISTREAMINFOA lpInfo, LONG cbInfo);
#ifdef UNICODE
#define EditStreamSetInfo	EditStreamSetInfoW
#define EditStreamSetName	EditStreamSetNameW
#else
#define EditStreamSetInfo	EditStreamSetInfoA
#define EditStreamSetName	EditStreamSetNameA
#endif

/*	-	-	-	-	-	-	-	-	*/

#ifndef AVIERR_OK
#define AVIERR_OK               0L

#define MAKE_AVIERR(error)	MAKE_SCODE(SEVERITY_ERROR, FACILITY_ITF, 0x4000 + error)

// !!! Questions to be answered:
// How can you get a string form of these errors?
// Which of these errors should be replaced by errors in SCODE.H?
#define AVIERR_UNSUPPORTED      MAKE_AVIERR(101)
#define AVIERR_BADFORMAT        MAKE_AVIERR(102)
#define AVIERR_MEMORY           MAKE_AVIERR(103)
#define AVIERR_INTERNAL         MAKE_AVIERR(104)
#define AVIERR_BADFLAGS         MAKE_AVIERR(105)
#define AVIERR_BADPARAM         MAKE_AVIERR(106)
#define AVIERR_BADSIZE          MAKE_AVIERR(107)
#define AVIERR_BADHANDLE        MAKE_AVIERR(108)
#define AVIERR_FILEREAD         MAKE_AVIERR(109)
#define AVIERR_FILEWRITE        MAKE_AVIERR(110)
#define AVIERR_FILEOPEN         MAKE_AVIERR(111)
#define AVIERR_COMPRESSOR       MAKE_AVIERR(112)
#define AVIERR_NOCOMPRESSOR     MAKE_AVIERR(113)
#define AVIERR_READONLY		MAKE_AVIERR(114)
#define AVIERR_NODATA		MAKE_AVIERR(115)
#define AVIERR_BUFFERTOOSMALL	MAKE_AVIERR(116)
#define AVIERR_CANTCOMPRESS	MAKE_AVIERR(117)
#define AVIERR_USERABORT        MAKE_AVIERR(198)
#define AVIERR_ERROR            MAKE_AVIERR(199)
#endif
#else
    #include <avifile.h>
#endif  /* not _WIN32 */
#endif  /* NOAVIFILE */
}

const
  ICCOMPRESS_KEYFRAME =	$00000001;


type
 ICCOMPRESS = record
    dwFlags: DWORD;        // flags

    lpbiOutput: PBITMAPINFOHEADER;     // output format
    lpOutput: Pointer;       // output data

    lpbiInput: PBITMAPINFOHEADER;      // format of frame to compress
    lpInput: Pointer;        // frame data to compress

    lpckid: ^DWORD;         // ckid for data in AVI file
    lpdwFlags: ^DWORD;      // flags in the AVI index.
    lFrameNum: LongInt;      // frame number of seq.
    dwFrameSize: DWORD;    // reqested size in bytes. (if non zero)

    dwQuality: DWORD;      // quality

    // these are new fields
    lpbiPrev: PBITMAPINFOHEADER;       // format of previous frame
    lpPrev: Pointer;         // previous frame
end;


{/************************************************************************
************************************************************************/}

const
 ICCOMPRESSFRAMES_PADDING = $00000001;

type

 ICCOMPRESSFRAMES = record
    dwFlags: DWORD;        // flags

    lpbiOutput: PBITMAPINFOHEADER;     // output format
    lOutput: LPARAM;        // output identifier

    lpbiInput: PBITMAPINFOHEADER;      // format of frame to compress
    lInput: LPARAM;         // input identifier

    lStartFrame: LongInt;    // start frame
    lFrameCount: LongInt;    // # of frames

    lQuality,       // quality
    lDataRate,      // data rate
    lKeyRate: Longint;       // key frame rate

    dwRate,		// frame rate, as always
    dwScale,
    dwOverheadPerFrame,
    dwReserved2: DWORD;

{    LONG (CALLBACK *GetData)(LPARAM lInput, LONG lFrame, LPVOID lpBits, LONG len);
    LONG (CALLBACK *PutData)(LPARAM lOutput, LONG lFrame, LPVOID lpBits, LONG len);}
    GetData,PutData: LongInt;
end;

    {// messages for Status callback}
const
  ICSTATUS_START =	    0;
  ICSTATUS_STATUS =	    1;	    // l == % done
  ICSTATUS_END =	    2;
  ICSTATUS_ERROR =	    3;	    // l == error string (LPSTR)
  ICSTATUS_YIELD =	    4;
    // return nonzero means abort operation in progress

type
  ICSETSTATUSPROC = record
    dwFlags: DWORD;
    lParam: LPARAM;
    Status: LongInt;
{    LONG (CALLBACK *Status) (LPARAM lParam, UINT message, LONG l);}
end;

{/************************************************************************
************************************************************************/}
const
  ICDECOMPRESS_HURRYUP      = $80000000   ;  // don't draw just buffer (hurry up!)
  ICDECOMPRESS_UPDATE       = $40000000   ;  // don't draw just update screen
  ICDECOMPRESS_PRERO      = $20000000   ;  // this frame is before rea start
  ICDECOMPRESS_NUFRAME    = $10000000   ;  // repeat ast frame
  ICDECOMPRESS_NOTKEYFRAME  = $08000000   ;  // this frame is not a key frame

type

ICDECOMPRESS = record
    dwFlags: DWORD;    // flags (from AVI index...)

    lpbiInput: PBITMAPINFOHEADER;  // BITMAPINFO of compressed data
                                    // biSizeImage has the chunk size
    lpInput: Pointer;    // compressed data

    lpbiOutput: PBITMAPINFOHEADER; // DIB to decompress to
    lpOutput: Pointer;
    ckid: Pointer;	    // ckid from AVI file
end;

type

  ICDECOMPRESSEX = record
    //
    // same as ICM_DECOMPRESS
    //
    dwFlags: DWORD;

    lpbiSrc: PBITMAPINFOHEADER;    // BITMAPINFO of compressed data
    lpSrc: Pointer;      // compressed data

    lpbiDst: PBITMAPINFOHEADER;    // DIB to decompress to
    lpDst: Pointer;      // output data

    //
    // new for ICM_DECOMPRESSEX
    //
    xDst,       // destination rectangle
    yDst,
    dxDst,
    dyDst,

    xSrc,       // source rectangle
    ySrc,
    dxSrc,
    dySrc: integer;
end;


{/************************************************************************
************************************************************************/}
const
   ICDRAW_QUERY        = $00000001   ; // test for support
   ICDRAW_FULLSCREEN   = $00000002   ; // draw to full screen
   ICDRAW_HDC          = $00000004   ; // draw to a HDC/HWND
   ICDRAW_ANIMATE	    = $00000008	  ; // expect palette animation
   ICDRAW_CONTINUE	    = $00000010	  ; // draw is a continuation of previous draw
   ICDRAW_MEMORYDC	    = $00000020	  ; // DC is offscreen, by the way
   ICDRAW_UPDATING	    = $00000040	  ; // We're updating, as opposed to playing
   ICDRAW_RENDER       = $00000080   ; // used to render data not draw it
   ICDRAW_BUFFER       = $00000100   ; // please buffer this data offscreen, we will need to update it

type

ICDRAWBEGIN = record
    dwFlags: DWORD;        // flags

    hpal: HPALETTE;           // palette to draw with
    hwnd: HWND;           // window to draw to
    hdc: HDC;            // HDC to draw to

    xDst,           // destination rectangle
    yDst,
    dxDst,
    dyDst: integer;

    lpbi: PBITMAPINFOHEADER;           // format of frame to draw

    xSrc,           // source rectangle
    ySrc,
    dxSrc,
    dySrc: integer;

    dwRate,         // frames/second = (dwRate/dwScale)
    dwScale: DWORD;
end;


{/************************************************************************
************************************************************************/}
const
   ICDRAW_HURRYUP      = $80000000;   // don't draw just buffer (hurry up!)
   ICDRAW_UPDATE       = $4000000;   // don't draw just update screen
   ICDRAW_PREROLL	    = $20000000;	  // this frame is before real start
   ICDRAW_NULLFRAME    = $10000000;	  // repeat last frame
   ICDRAW_NOTKEYFRAME  = $08000000;   // this frame is not a key frame

type

  ICDRAW = record
    dwFlags: DWORD;        // flags
    lpFormat: Pointer;       // format of frame to decompress
    lpData: Pointer;         // frame data to decompress
    cbData: DWORD;
    lTime: LongInt;          // time in drawbegin units (see dwRate and dwScale)
  end;

  ICDRAWSUGGEST = record
    lpbiIn,		// format to be drawn
    lpbiSuggest: PBITMAPINFOHEADER;	// location for suggested format (or NULL to get size)
    dxSrc,		// source extent or 0
    dySrc,
    dxDst,		// dest extent or 0
    dyDst: integer;
    hicDecompressor: HIC;// decompressor you can talk to
  end;

{/************************************************************************
************************************************************************/}

type
ICPALETTE = record
    dwFlags: DWORD;    // flags (from AVI index...)
    iStart,     // first palette to change
    iLen: integer;       // count of entries to change.
    lppe: PPALETTEENTRY;       // palette
end;

{/************************************************************************

    ICM function declarations

************************************************************************/}

function ICInfo(fccType: DWORD; fccHandler: DWORD; lpicinfo: PIcInfo): LongBool; stdcall; external 'msvideo.dll';
function ICInstall(fccType, fccHandler: DWORD; lParam: LPARAM; szDesc: PChar; wFlags: Integer): LongBool; stdcall; external 'msvideo.dll';
function ICRemove(fccType, fccHandler: DWORD; wFlags: Integer): LongBool; stdcall; external 'msvideo.dll';
function ICGetInfo(hic: HIC; picinfo: PIcInfo; cb:DWORD): LRESULT; stdcall; external 'msvideo.dll';

function ICOpen(fccType, fccHandler: DWORD; wMode: Integer): HIC; stdcall; external 'msvideo.dll';
function ICOpenFunction(fccType, fccHandler: DWORD; wMode: Integer; lpfnHandler: Pointer): HIC; stdcall; external 'msvideo.dll';
function ICClose(hic: HIC): LResult; stdcall; external 'msvideo.dll';

function ICSendMessage(hic: HIC; msg: Integer; dw1, dw2: DWORD): LRESULT; stdcall; external 'msvideo.dll';

{win31 only
LRESULT VFWAPIV ICMessage(HIC hic, UINT msg, UINT cb, ...);
 }

{/* Values for wFlags of ICInstall() */}
{const
 ICINSTALL_UNICODE  =    $8000;

 ICINSTALL_FUNCTION  =    $0001;  // lParam is a DriverProc (function ptr)
 ICINSTALL_DRIVER  =      $0002;  // lParam is a driver name (string)
 ICINSTALL_HDRV  =        $0004;  // lParam is a HDRVR (driver handle)

 ICINSTALL_DRIVERW =      $8002;  // lParam is a unicode driver name

{/************************************************************************

    query macros

************************************************************************/}
{ ICMF_CONFIGURE_QUERY     0x00000001
 ICMF_ABOUT_QUERY         0x00000001

#define ICQueryAbout(hic) \
    (ICSendMessage(hic, ICM_ABOUT, (DWORD) -1, ICMF_ABOUT_QUERY) == ICERR_OK)

#define ICAbout(hic, hwnd) \
    ICSendMessage(hic, ICM_ABOUT, (DWORD)(UINT)(hwnd), 0)

#define ICQueryConfigure(hic) \
    (ICSendMessage(hic, ICM_CONFIGURE, (DWORD) -1, ICMF_CONFIGURE_QUERY) == ICERR_OK)

#define ICConfigure(hic, hwnd) \
    ICSendMessage(hic, ICM_CONFIGURE, (DWORD)(UINT)(hwnd), 0)

/************************************************************************

    get/set state macros
	
************************************************************************/

#define ICGetState(hic, pv, cb) \
    ICSendMessage(hic, ICM_GETSTATE, (DWORD)(LPVOID)(pv), (DWORD)(cb))

#define ICSetState(hic, pv, cb) \
    ICSendMessage(hic, ICM_SETSTATE, (DWORD)(LPVOID)(pv), (DWORD)(cb))

#define ICGetStateSize(hic) \
    ICGetState(hic, NULL, 0)

/************************************************************************

    get value macros

************************************************************************/
static DWORD dwICValue;

#define ICGetDefaultQuality(hic) \
    (ICSendMessage(hic, ICM_GETDEFAULTQUALITY, (DWORD)(LPVOID)&dwICValue, sizeof(DWORD)), dwICValue)

#define ICGetDefaultKeyFrameRate(hic) \
    (ICSendMessage(hic, ICM_GETDEFAULTKEYFRAMERATE, (DWORD)(LPVOID)&dwICValue, sizeof(DWORD)), dwICValue)

/************************************************************************

    draw window macro

************************************************************************/
#define ICDrawWindow(hic, prc) \
    ICSendMessage(hic, ICM_DRAW_WINDOW, (DWORD)(LPVOID)(prc), sizeof(RECT))

/************************************************************************

    compression functions

************************************************************************/
/*
 *  ICCompress()
 *
 *  compress a single frame
 *
 */
DWORD VFWAPIV ICCompress(
    HIC                 hic,
    DWORD               dwFlags,        // flags
    LPBITMAPINFOHEADER  lpbiOutput,     // output format
    LPVOID              lpData,         // output data
    LPBITMAPINFOHEADER  lpbiInput,      // format of frame to compress
    LPVOID              lpBits,         // frame data to compress
    LPDWORD             lpckid,         // ckid for data in AVI file
    LPDWORD             lpdwFlags,      // flags in the AVI index.
    LONG                lFrameNum,      // frame number of seq.
    DWORD               dwFrameSize,    // reqested size in bytes. (if non zero)
    DWORD               dwQuality,      // quality within one frame
    LPBITMAPINFOHEADER  lpbiPrev,       // format of previous frame
    LPVOID              lpPrev);        // previous frame

/*
 *  ICCompressBegin()
 *
 *  start compression from a source format (lpbiInput) to a dest
 *  format (lpbiOuput) is supported.
 *
 */
#define ICCompressBegin(hic, lpbiInput, lpbiOutput) \
    ICSendMessage(hic, ICM_COMPRESS_BEGIN, (DWORD)(LPVOID)(lpbiInput), (DWORD)(LPVOID)(lpbiOutput))

/*
 *  ICCompressQuery()
 *
 *  determines if compression from a source format (lpbiInput) to a dest
 *  format (lpbiOuput) is supported.
 *
 */
#define ICCompressQuery(hic, lpbiInput, lpbiOutput) \
    ICSendMessage(hic, ICM_COMPRESS_QUERY, (DWORD)(LPVOID)(lpbiInput), (DWORD)(LPVOID)(lpbiOutput))

/*
 *  ICCompressGetFormat()
 *
 *  get the output format, (format of compressed data)
 *  if lpbiOutput is NULL return the size in bytes needed for format.
 *
 */
#define ICCompressGetFormat(hic, lpbiInput, lpbiOutput) \
    ICSendMessage(hic, ICM_COMPRESS_GET_FORMAT, (DWORD)(LPVOID)(lpbiInput), (DWORD)(LPVOID)(lpbiOutput))

#define ICCompressGetFormatSize(hic, lpbi) \
    ICCompressGetFormat(hic, lpbi, NULL)

/*
 *  ICCompressSize()
 *
 *  return the maximal size of a compressed frame
 *
 */
#define ICCompressGetSize(hic, lpbiInput, lpbiOutput) \
    ICSendMessage(hic, ICM_COMPRESS_GET_SIZE, (DWORD)(LPVOID)(lpbiInput), (DWORD)(LPVOID)(lpbiOutput))

#define ICCompressEnd(hic) \
    ICSendMessage(hic, ICM_COMPRESS_END, 0, 0)

/************************************************************************

    decompression functions

************************************************************************/

/*
 *  ICDecompress()
 *
 *  decompress a single frame
 *
 */
#define ICDECOMPRESS_HURRYUP    0x80000000L     // don't draw just buffer (hurry up!)

DWORD VFWAPIV ICDecompress(
    HIC                 hic,
    DWORD               dwFlags,    // flags (from AVI index...)
    LPBITMAPINFOHEADER  lpbiFormat, // BITMAPINFO of compressed data
                                    // biSizeImage has the chunk size
    LPVOID              lpData,     // data
    LPBITMAPINFOHEADER  lpbi,       // DIB to decompress to
    LPVOID              lpBits);

/*
 *  ICDecompressBegin()
 *
 *  start compression from a source format (lpbiInput) to a dest
 *  format (lpbiOutput) is supported.
 *
 */
#define ICDecompressBegin(hic, lpbiInput, lpbiOutput) \
    ICSendMessage(hic, ICM_DECOMPRESS_BEGIN, (DWORD)(LPVOID)(lpbiInput), (DWORD)(LPVOID)(lpbiOutput))

/*
 *  ICDecompressQuery()
 *
 *  determines if compression from a source format (lpbiInput) to a dest
 *  format (lpbiOutput) is supported.
 *
 */
#define ICDecompressQuery(hic, lpbiInput, lpbiOutput) \
    ICSendMessage(hic, ICM_DECOMPRESS_QUERY, (DWORD)(LPVOID)(lpbiInput), (DWORD)(LPVOID)(lpbiOutput))

/*
 *  ICDecompressGetFormat()
 *
 *  get the output format, (format of un-compressed data)
 *  if lpbiOutput is NULL return the size in bytes needed for format.
 *
 */
#define ICDecompressGetFormat(hic, lpbiInput, lpbiOutput) \
    ((LONG) ICSendMessage(hic, ICM_DECOMPRESS_GET_FORMAT, (DWORD)(LPVOID)(lpbiInput), (DWORD)(LPVOID)(lpbiOutput)))

#define ICDecompressGetFormatSize(hic, lpbi) \
    ICDecompressGetFormat(hic, lpbi, NULL)

/*
 *  ICDecompressGetPalette()
 *
 *  get the output palette
 *
 */
#define ICDecompressGetPalette(hic, lpbiInput, lpbiOutput) \
    ICSendMessage(hic, ICM_DECOMPRESS_GET_PALETTE, (DWORD)(LPVOID)(lpbiInput), (DWORD)(LPVOID)(lpbiOutput))

#define ICDecompressSetPalette(hic, lpbiPalette) \
    ICSendMessage(hic, ICM_DECOMPRESS_SET_PALETTE, (DWORD)(LPVOID)(lpbiPalette), 0)

#define ICDecompressEnd(hic) \
    ICSendMessage(hic, ICM_DECOMPRESS_END, 0, 0)

/************************************************************************

    decompression (ex) functions

************************************************************************/

//
// on Win16 these functions are macros that call ICMessage. ICMessage will
// not work on NT. rather than add new entrypoints we have given
// them as static inline functions
//

/*
 *  ICDecompressEx()
 *
 *  decompress a single frame
 *
 */
static __inline LRESULT VFWAPI
ICDecompressEx(
            HIC hic,
            DWORD dwFlags,
            LPBITMAPINFOHEADER lpbiSrc,
            LPVOID lpSrc,
            int xSrc,
            int ySrc,
            int dxSrc,
            int dySrc,
            LPBITMAPINFOHEADER lpbiDst,
            LPVOID lpDst,
            int xDst,
            int yDst,
            int dxDst,
            int dyDst)
{
    ICDECOMPRESSEX ic;

    ic.dwFlags = dwFlags;
    ic.lpbiSrc = lpbiSrc;
    ic.lpSrc = lpSrc;
    ic.xSrc = xSrc;
    ic.ySrc = ySrc;
    ic.dxSrc = dxSrc;
    ic.dySrc = dySrc;
    ic.lpbiDst = lpbiDst;
    ic.lpDst = lpDst;
    ic.xDst = xDst;
    ic.yDst = yDst;
    ic.dxDst = dxDst;
    ic.dyDst = dyDst;

    // note that ICM swaps round the length and pointer
    // length in lparam2, pointer in lparam1
    return ICSendMessage(hic, ICM_DECOMPRESSEX, (DWORD)&ic, sizeof(ic));


/*
 *  ICDecompressExBegin()
 *
 *  start compression from a source format (lpbiInput) to a dest
 *  format (lpbiOutput) is supported.
 *
 */
static __inline LRESULT VFWAPI
ICDecompressExBegin(
            HIC hic,
            DWORD dwFlags,
            LPBITMAPINFOHEADER lpbiSrc,
            LPVOID lpSrc,
            int xSrc,
            int ySrc,
            int dxSrc,
            int dySrc,
            LPBITMAPINFOHEADER lpbiDst,
            LPVOID lpDst,
            int xDst,
            int yDst,
            int dxDst,
            int dyDst)
{
    ICDECOMPRESSEX ic;

    ic.dwFlags = dwFlags;
    ic.lpbiSrc = lpbiSrc;
    ic.lpSrc = lpSrc;
    ic.xSrc = xSrc;
    ic.ySrc = ySrc;
    ic.dxSrc = dxSrc;
    ic.dySrc = dySrc;
    ic.lpbiDst = lpbiDst;
    ic.lpDst = lpDst;
    ic.xDst = xDst;
    ic.yDst = yDst;
    ic.dxDst = dxDst;
    ic.dyDst = dyDst;

    // note that ICM swaps round the length and pointer
    // length in lparam2, pointer in lparam1
    return ICSendMessage(hic, ICM_DECOMPRESSEX_BEGIN, (DWORD)&ic, sizeof(ic));


/*
 *  ICDecompressExQuery()
 *
 */
static __inline LRESULT VFWAPI
ICDecompressExQuery(
            HIC hic,
            DWORD dwFlags,
            LPBITMAPINFOHEADER lpbiSrc,
            LPVOID lpSrc,
            int xSrc,
            int ySrc,
            int dxSrc,
            int dySrc,
            LPBITMAPINFOHEADER lpbiDst,
            LPVOID lpDst,
            int xDst,
            int yDst,
            int dxDst,
            int dyDst)
{
    ICDECOMPRESSEX ic;

    ic.dwFlags = dwFlags;
    ic.lpbiSrc = lpbiSrc;
    ic.lpSrc = lpSrc;
    ic.xSrc = xSrc;
    ic.ySrc = ySrc;
    ic.dxSrc = dxSrc;
    ic.dySrc = dySrc;
    ic.lpbiDst = lpbiDst;
    ic.lpDst = lpDst;
    ic.xDst = xDst;
    ic.yDst = yDst;
    ic.dxDst = dxDst;
    ic.dyDst = dyDst;

    // note that ICM swaps round the length and pointer
    // length in lparam2, pointer in lparam1
    return ICSendMessage(hic, ICM_DECOMPRESSEX_QUERY, (DWORD)&ic, sizeof(ic));


#define ICDecompressExEnd(hic) \
    ICSendMessage(hic, ICM_DECOMPRESSEX_END, 0, 0)

/************************************************************************

    drawing functions

************************************************************************/

/*
 *  ICDrawBegin()
 *
 *  start decompressing data with format (lpbiInput) directly to the screen
 *
 *  return zero if the decompressor supports drawing.
 *
 */

#define ICDRAW_QUERY        0x00000001L   // test for support
#define ICDRAW_FULLSCREEN   0x00000002L   // draw to full screen
#define ICDRAW_HDC          0x00000004L   // draw to a HDC/HWND

DWORD VFWAPIV ICDrawBegin(
        HIC                 hic,
        DWORD               dwFlags,        // flags
        HPALETTE            hpal,           // palette to draw with
        HWND                hwnd,           // window to draw to
        HDC                 hdc,            // HDC to draw to
        int                 xDst,           // destination rectangle
        int                 yDst,
        int                 dxDst,
        int                 dyDst,
        LPBITMAPINFOHEADER  lpbi,           // format of frame to draw
        int                 xSrc,           // source rectangle
        int                 ySrc,
        int                 dxSrc,
        int                 dySrc,
        DWORD               dwRate,         // frames/second = (dwRate/dwScale)
        DWORD               dwScale);

/*
 *  ICDraw()
 *
 *  decompress data directly to the screen
 *
 */

#define ICDRAW_HURRYUP      0x80000000L   // don't draw just buffer (hurry up!)
#define ICDRAW_UPDATE       0x40000000L   // don't draw just update screen

DWORD VFWAPIV ICDraw(
        HIC                 hic,
        DWORD               dwFlags,        // flags
        LPVOID		    lpFormat,       // format of frame to decompress
        LPVOID              lpData,         // frame data to decompress
        DWORD               cbData,         // size of data
        LONG                lTime);         // time to draw this frame

// ICMessage is not supported on Win32, so provide a static inline function
// to do the same job
static __inline LRESULT VFWAPI
ICDrawSuggestFormat(
            HIC hic,
            LPBITMAPINFOHEADER lpbiIn,
            LPBITMAPINFOHEADER lpbiOut,
            int dxSrc,
            int dySrc,
            int dxDst,
            int dyDst,
            HIC hicDecomp)
{
    ICDRAWSUGGEST ic;

    ic.lpbiIn = lpbiIn;
    ic.lpbiSuggest = lpbiOut;
    ic.dxSrc = dxSrc;
    ic.dySrc = dySrc;
    ic.dxDst = dxDst;
    ic.dyDst = dyDst;
    ic.hicDecompressor = hicDecomp;

    // note that ICM swaps round the length and pointer
    // length in lparam2, pointer in lparam1
    return ICSendMessage(hic, ICM_DRAW_SUGGESTFORMAT, (DWORD)&ic, sizeof(ic));
}{

/*
 *  ICDrawQuery()
 *
 *  determines if the compressor is willing to render the specified format.
 *
 */
#define ICDrawQuery(hic, lpbiInput) \
    ICSendMessage(hic, ICM_DRAW_QUERY, (DWORD)(LPVOID)(lpbiInput), 0L)

#define ICDrawChangePalette(hic, lpbiInput) \
    ICSendMessage(hic, ICM_DRAW_CHANGEPALETTE, (DWORD)(LPVOID)(lpbiInput), 0L)

#define ICGetBuffersWanted(hic, lpdwBuffers) \
    ICSendMessage(hic, ICM_GETBUFFERSWANTED, (DWORD)(LPVOID)(lpdwBuffers), 0)

#define ICDrawEnd(hic) \
    ICSendMessage(hic, ICM_DRAW_END, 0, 0)

#define ICDrawStart(hic) \
    ICSendMessage(hic, ICM_DRAW_START, 0, 0)

#define ICDrawStartPlay(hic, lFrom, lTo) \
    ICSendMessage(hic, ICM_DRAW_START_PLAY, (DWORD)(lFrom), (DWORD)(lTo))

#define ICDrawStop(hic) \
    ICSendMessage(hic, ICM_DRAW_STOP, 0, 0)

#define ICDrawStopPlay(hic) \
    ICSendMessage(hic, ICM_DRAW_STOP_PLAY, 0, 0)

#define ICDrawGetTime(hic, lplTime) \
    ICSendMessage(hic, ICM_DRAW_GETTIME, (DWORD)(LPVOID)(lplTime), 0)

#define ICDrawSetTime(hic, lTime) \
    ICSendMessage(hic, ICM_DRAW_SETTIME, (DWORD)lTime, 0)

#define ICDrawRealize(hic, hdc, fBackground) \
    ICSendMessage(hic, ICM_DRAW_REALIZE, (DWORD)(UINT)(HDC)(hdc), (DWORD)(BOOL)(fBackground))

#define ICDrawFlush(hic) \
    ICSendMessage(hic, ICM_DRAW_FLUSH, 0, 0)

#define ICDrawRenderBuffer(hic) \
    ICSendMessage(hic, ICM_DRAW_RENDERBUFFER, 0, 0)

/************************************************************************

    Status callback functions

************************************************************************/

/*
 *  ICSetStatusProc()
 *
 *  Set the status callback function
 *
 */

// ICMessage is not supported on NT
static __inline LRESULT VFWAPI
ICSetStatusProc(
            HIC hic,
            DWORD dwFlags,
            LRESULT lParam,
            LONG (CALLBACK *fpfnStatus)(LPARAM, UINT, LONG) )
{
    ICSETSTATUSPROC ic;

    ic.dwFlags = dwFlags;
    ic.lParam = lParam;
    ic.Status = fpfnStatus;

    // note that ICM swaps round the length and pointer
    // length in lparam2, pointer in lparam1
    return ICSendMessage(hic, ICM_SET_STATUS_PROC, (DWORD)&ic, sizeof(ic));
} {

/************************************************************************

helper routines for DrawDib and MCIAVI...

************************************************************************/

#define ICDecompressOpen(fccType, fccHandler, lpbiIn, lpbiOut) \
    ICLocate(fccType, fccHandler, lpbiIn, lpbiOut, ICMODE_DECOMPRESS)

#define ICDrawOpen(fccType, fccHandler, lpbiIn) \
    ICLocate(fccType, fccHandler, lpbiIn, NULL, ICMODE_DRAW)
}

function ICLocate(fccType: DWORD; fccHandler: DWORD; lpbiIn: PBITMAPINFOHEADER; lpbiOut: PBITMAPINFOHEADER; wflags: WORD): HIC; stdcall; external 'msvfw32.dll';
function ICGetDisplayFormat(hic: HIC; lpbiIn: PBITMAPINFOHEADER; lpbiOut: PBITMAPINFOHEADER; BitDepth, dx, dy: integer): HIC; stdcall; external 'msvfw32.dll';



{
/************************************************************************
Higher level functions
************************************************************************/

HANDLE VFWAPI ICImageCompress(
        HIC                 hic,        // compressor to use
        UINT                uiFlags,    // flags (none yet)
        LPBITMAPINFO	    lpbiIn,     // format to compress from
        LPVOID              lpBits,     // data to compress
        LPBITMAPINFO        lpbiOut,    // compress to this (NULL ==> default)
        LONG                lQuality,   // quality to use
        LONG FAR *          plSize);     // compress to this size (0=whatever)
            }

function ICImageDecompress(hic: HIC;        // compressor to use
                           uiFlags: Integer;    // flags (none yet)
                           lpbiIn: PBITMAPINFO;    // format to decompress from
                           lpBits: PChar;     // data to decompress
                           lpbiOut: PBITMAPINFO): THandle; stdcall; external 'msvfw32.dll';  // decompress to this (NULL ==> default)
{
//
// Structure used by ICSeqCompressFrame and ICCompressorChoose routines
// Make sure this matches the autodoc in icm.c!
//
typedef struct {
    LONG		cbSize;		// set to sizeof(COMPVARS) before
					// calling ICCompressorChoose
    DWORD		dwFlags;	// see below...
    HIC			hic;		// HIC of chosen compressor
    DWORD               fccType;	// basically ICTYPE_VIDEO
    DWORD               fccHandler;	// handler of chosen compressor or
					// "" or "DIB "
    LPBITMAPINFO	lpbiIn;		// input format
    LPBITMAPINFO	lpbiOut;	// output format - will compress to this
    LPVOID		lpBitsOut;
    LPVOID		lpBitsPrev;
    LONG		lFrame;
    LONG		lKey;		// key frames how often?
    LONG		lDataRate;	// desired data rate KB/Sec
    LONG		lQ;		// desired quality
    LONG		lKeyCount;
    LPVOID		lpState;	// state of compressor
    LONG		cbState;	// size of the state
}{ COMPVARS, FAR *PCOMPVARS;

// FLAGS for dwFlags element of COMPVARS structure:
// set this flag if you initialize COMPVARS before calling ICCompressorChoose
#define ICMF_COMPVARS_VALID	0x00000001	// COMPVARS contains valid data

//
//  allows user to choose compressor, quality etc...
//
BOOL VFWAPI ICCompressorChoose(
        HWND        hwnd,               // parent window for dialog
        UINT        uiFlags,            // flags
        LPVOID      pvIn,               // input format (optional)
        LPVOID      lpData,             // input data (optional)
        PCOMPVARS   pc,                 // data about the compressor/dlg
        LPSTR       lpszTitle);         // dialog title (optional)

// defines for uiFlags
#define ICMF_CHOOSE_KEYFRAME	0x0001	// show KeyFrame Every box
#define ICMF_CHOOSE_DATARATE	0x0002	// show DataRate box
#define ICMF_CHOOSE_PREVIEW	0x0004	// allow expanded preview dialog
#define ICMF_CHOOSE_ALLCOMPRESSORS	0x0008	// don't only show those that
						// can handle the input format
						// or input data

BOOL VFWAPI ICSeqCompressFrameStart(PCOMPVARS pc, LPBITMAPINFO lpbiIn);
void VFWAPI ICSeqCompressFrameEnd(PCOMPVARS pc);

LPVOID VFWAPI ICSeqCompressFrame(
    PCOMPVARS               pc,         // set by ICCompressorChoose
    UINT                    uiFlags,    // flags
    LPVOID                  lpBits,     // input DIB bits
    BOOL FAR 		    *pfKey,	// did it end up being a key frame?
    LONG FAR		    *plSize);	// size to compress to/of returned image

void VFWAPI ICCompressorFree(PCOMPVARS pc);

#else
    #include <compman.h>
#endif  /* not _WIN32 */
#endif  /* NOCOMPMAN */

  }








{/**************************************************************************
 *
 *  DRAWDIB - Routines for drawing to the display.
 *
 *************************************************************************/}

{/*********************************************************************

  DrawDib Flags

**********************************************************************/}
const
DDF_UPDATE          = $0002;           //* re-draw the last DIB */
DDF_SAME_HDC        = $0004;           //* HDC same as last call (all setup) */
DDF_SAME_DRAW       = $0008;           //* draw params are the same */
DDF_DONTDRAW        = $0010;           //* dont draw frame, just decompress */
DDF_ANIMATE         = $0020;           //* allow palette animation */
DDF_BUFFER          = $0040;           //* always buffer image */
DDF_JUSTDRAWIT      = $0080;           //* just draw it with GDI */
DDF_FULLSCREEN      = $0100;           //* use DisplayDib */
DDF_BACKGROUNDPAL   = $0200;	       //* Realize palette in background */
DDF_NOTKEYFRAME     = $0400;           //* this is a partial frame update, hint */
DDF_HURRYUP         = $0800;           //* hurry up please! */
DDF_HALFTONE        = $1000;           //* always halftone */

DDF_PREROLL         = DDF_DONTDRAW;    //* Builing up a non-keyframe */
DDF_SAME_DIB        = DDF_SAME_DRAW;
DDF_SAME_SIZE       = DDF_SAME_DRAW;

{/*********************************************************************

    DrawDib functions

*********************************************************************/}
{/*
**  DrawDibOpen()
**
*/}

function DrawDibOpen: THandle; stdcall;

{/*
**  DrawDibClose()
**
*/}
function DrawDibClose(hDD: THandle): LongBool; stdcall;

{/*
** DrawDibGetBuffer()
**
*/}
function DrawDibGetBuffer(hDD: THandle; pbmih: PBITMAPINFOHEADER;
                                    dwSize, dwFlags: LongInt): Pointer; stdcall;

{/*
**  DrawDibGetPalette()
**
**  get the palette used for drawing DIBs
**
*/}
function DrawDibGetPalette(hDD: THandle): HPALETTE; stdcall;

{/*
**  DrawDibSetPalette()
**
**  get the palette used for drawing DIBs
**
*/}
function DrawDibSetPalette(hDD: THandle; hPal: HPALETTE): LongBool; stdcall;

{/*
**  DrawDibChangePalette()
*/}
function DrawDibChangePalette(hDD: THandle; iStart, iLen: LongInt; pPalEntry: Pointer): Longbool; stdcall;

{/*
**  DrawDibRealize()
**
**  realize the palette in a HDD
**
*/}
function DrawDibRealize(hDD: THandle; hDC: THandle; fBackground: LongBool): LongInt; stdcall;

{/*
**  DrawDibStart()
**
**  start of streaming playback
**
*/}
function DrawDibStart(hDD: THandle; rate: LongInt): LongBool; stdcall;

{/*
**  DrawDibStop()
**
**  start of streaming playback
**
*/}
function DrawDibStop(hDD: THandle): LongBool; stdcall;

{/*
**  DrawDibBegin()
**
**  prepare to draw
**
*/}
function DrawDibBegin(hDD: THandle; hDC: THandle; dxDst, dyDst: LongInt;
                                    pbmih: PBITMAPINFOHEADER; dxSrc, dySrc, wFlags: Longint): LongBool; stdcall;
{/*
**  DrawDibDraw()
**
**  actualy draw a DIB to the screen.
**
*/}
function DrawDibDraw(hDD: THandle; hDC:THandle; xDst, yDst, dxDst, dyDst: LongInt;
                               pbmih: PBITMAPINFOHEADER; pBits: Pointer;
                               xSrc, ySrc, dxSrc, dySrc, dwFlags: Longint): LongBool; stdcall;

{/*
**  DrawDibUpdate()
**
**  redraw the last image (may only be valid with DDF_BUFFER)
*/}
//#define DrawDibUpdate(hdd, hdc, x, y) \
//        DrawDibDraw(hdd, hdc, x, y, 0, 0, NULL, NULL, 0, 0, 0, 0, DDF_UPDATE)

function DrawDibUpdate(hDD: THandle; hDC: THandle; x,y: LongInt): LongBool;

{/*
**  DrawDibEnd()
*/}
function DrawDibEnd(hDD: THandle): LongBool; stdcall;

{/*
**  DrawDibTime()  [for debugging purposes only]
*/}
type
TDRAWDIBTIME=record
  timeCount,
  timeDraw,
  timeDecompress,
  timeDither,
  timeStretch,
  timeBlt,
  timeSetDIBits: LongInt;
end;

PDRAWDIBTIME = ^TDRAWDIBTIME;

function DrawDibTime(hDD: THandle; pddtime: PDRAWDIBTIME): LongBool; stdcall;

//* display profiling */
const
  PD_CAN_DRAW_DIB =        $0001;      //* if you can draw at all */
  PD_CAN_STRETCHDIB =      $0002;      //* basicly RC_STRETCHDIB */
  PD_STRETCHDIB_1_1_OK =   $0004;      //* is it fast? */
  PD_STRETCHDIB_1_2_OK =   $0008;      //* ... */
  PD_STRETCHDIB_1_N_OK =   $0010;      //* ... */

function DrawDibProfileDisplay(pbmih: PBITMAPINFOHEADER): Longint; stdcall;












implementation

{/*********************************************************************

    DrawDib functions

*********************************************************************/}
function DrawDibOpen: THandle; external 'MSVFW32.DLL';
function DrawDibClose(hDD: THandle): LongBool; external 'MSVFW32.DLL';
function DrawDibGetBuffer(hDD: THandle; pbmih: PBITMAPINFOHEADER;
                                    dwSize, dwFlags: LongInt): Pointer; stdcall; external 'MSVFW32.DLL';
function DrawDibGetPalette(hDD: THandle): HPALETTE; stdcall; external 'MSVFW32.DLL';
function DrawDibSetPalette(hDD: THandle; hPal: HPALETTE): LongBool; stdcall; external 'MSVFW32.DLL';
function DrawDibChangePalette(hDD: THandle; iStart, iLen: LongInt; pPalEntry: Pointer): Longbool; stdcall; external 'MSVFW32.DLL';
function DrawDibRealize(hDD: THandle; hDC: THandle; fBackground: LongBool): LongInt; stdcall; external 'MSVFW32.DLL';
function DrawDibStart(hDD: THandle; rate: LongInt): LongBool; stdcall; external 'MSVFW32.DLL';
function DrawDibStop(hDD: THandle): LongBool; stdcall; external 'MSVFW32.DLL';
function DrawDibBegin(hDD: THandle; hDC: THandle; dxDst, dyDst: LongInt;
                                    pbmih: PBITMAPINFOHEADER; dxSrc, dySrc, wFlags: Longint): LongBool; stdcall; external 'MSVFW32.DLL';
function DrawDibDraw(hDD: THandle; hDC:THandle; xDst, yDst, dxDst, dyDst: LongInt;
                               pbmih: PBITMAPINFOHEADER; pBits: Pointer;
                               xSrc, ySrc, dxSrc, dySrc, dwFlags: Longint): LongBool; stdcall; external 'MSVFW32.DLL';
function DrawDibUpdate(hDD: THandle; hDC: THandle; x,y: LongInt): LongBool;
begin
  Result:=DrawDibDraw(hDD, hDC, x, y, 0, 0, nil, nil, 0, 0, 0, 0, DDF_UPDATE);
end;
function DrawDibEnd(hDD: THandle): LongBool; stdcall; external 'MSVFW32.DLL';
function DrawDibTime(hDD: THandle; pddtime: PDRAWDIBTIME): LongBool; stdcall; external 'MSVFW32.DLL';
function DrawDibProfileDisplay(pbmih: PBITMAPINFOHEADER): Longint; stdcall; external 'MSVFW32.DLL';


end.
