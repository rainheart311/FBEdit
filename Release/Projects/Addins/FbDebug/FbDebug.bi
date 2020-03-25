
#Define IDM_MAKE_COMPILE					10142 'F5
#Define IDM_MAKE_RUN							10143 'Shift+F5
#Define IDM_MAKE_GO							10144 'Ctrl+F5
#Define IDM_MAKE_QUICKRUN					10147 'Shift+Ctrl+F5
#Define IDM_FILE_NEWPROJECT				10002
#Define IDM_FILE_OPENPROJECT				10003
#Define IDM_FILE_CLOSEPROJECT				10004

#Define MAX_MISS								10
#Define SOURCEMAX								250
#Define WATCHMAX								29

Declare Sub EnableDebugMenu
Declare Sub LockFiles(ByVal bLock As Boolean)
Declare Sub GetBreakPoints
Declare Function IsProjectFile(ByVal lpFile As ZString Ptr) As Integer

' Addin
Dim Shared hInstance As HINSTANCE
Dim Shared hooks As ADDINHOOKS
Dim Shared lpHandles As ADDINHANDLES Ptr
Dim Shared lpFunctions As ADDINFUNCTIONS Ptr
Dim Shared lpData As ADDINDATA Ptr
' Menu
Dim Shared nMnuToggle As Integer
Dim Shared nMnuClear As Integer
Dim Shared nMnuRun As Integer
Dim Shared nMnuStop As Integer
Dim Shared nMnuRunToCaret As Integer
Dim Shared nMnuStepInto As Integer
Dim Shared nMnuStepOver As Integer
' Misc
Dim Shared lpOldEditProc As Any Ptr
Dim Shared lpOldImmediateProc As Any Ptr

Const szCRLF=!"\13\10"
Const szNULL=!"\0"
' Debug
Type BP
	nInx		As Integer		' Project index
	sFile		As String		' Filename
	sBP		As String		' Breakpoints
End Type

Type WATCH
	sVar		As String
	sVal		As String
End Type

Dim Shared szFileName As ZString*MAX_PATH
Dim Shared hThread As HANDLE
Dim Shared hDebugFile As HANDLE
Dim Shared bp(SOURCEMAX) As BP
Dim Shared bpnb As Integer
Dim Shared nLnDebug As Integer
Dim Shared hLnDebug As HWND
Dim Shared nLnRunTo As Integer
Dim Shared ebp_this As UInteger
' Tooltip
Dim Shared ptcur As POINT
Dim Shared hTip As HWND
Dim Shared szTipText As ZString*256
Dim Shared fDone As Integer
Dim Shared fRun As Integer
Dim Shared fExit As Integer
Dim Shared W(WATCHMAX) As WATCH

Dim Shared mtid As Integer
Dim Shared mpid As Integer
