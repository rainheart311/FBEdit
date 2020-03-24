DialogAsMain
Dialog as main window
[*BEGINPRO*]
[*BEGINDEF*]
[Project]
Version=2
Description=Dialog as main window
Api=fb (FreeBASIC),win (Windows)
Grouping=1
AddMainFiles=1
ResExport=
[Make]
Current=1
1=Windows GUI,fbc -s gui
Recompile=2
Module=Module Build,fbc -c
Output=
Run=
[*ENDDEF*]
[*BEGINTXT*]
[*PRONAME*].bas
'#Define UNICODE
#include once "windows.bi"
#Include Once "win/commctrl.bi"
#Include Once "win/commdlg.bi"
#Include Once "win/shellapi.bi"
#Include Once "[*PRONAME*].bi"

Function WndProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer

	Select Case uMsg
		Case WM_INITDIALOG
			hWndMain = hWin
			Dim As Integer cx = GetSystemMetrics( SM_CXFULLSCREEN )   ' 
            Dim As Integer cy = GetSystemMetrics( SM_CYFULLSCREEN )   ' 
			MoveWindow hWin, (cx - 1000) / 2,(cy - 600) / 2,1000,600,TRUE
			'
		Case WM_COMMAND
			Select Case HiWord(wParam)
				Case BN_CLICKED,1
					Select Case LoWord(wParam)
						Case IDM_FILE_EXIT
							SendMessage(hWin,WM_CLOSE,0,0)
							'
						Case IDM_HELP_ABOUT
							ShellAbout(hWin,Cast(LPCTSTR,@AppName),Cast(LPCTSTR,@AboutMsg),NULL)
							'
					End Select
					'
			End Select
			'
		Case WM_SIZE
			'
		Case WM_CLOSE
			DestroyWindow(hWin)
			'
		Case WM_DESTROY
			PostQuitMessage(NULL)
			'
		Case Else
			Return DefWindowProc(hWin,uMsg,wParam,lParam)
			'
	End Select
	Return 0

End Function

Sub InitApp(hInst As HINSTANCE)
	Dim zTemp As ZString * MAX_PATH
    Dim x     As Long
    
    App.CompanyName = "Write By RainHeart"
	App.ProductName = "MyFBEdit.exe"
	App.hInstance = hInst
	App.Major    = 1  'Version is 1.0.0.0
	App.Minor    = 0
	App.Revision = 0
	App.Build    = 0
	
	GetModuleFileName App.hInstance,zTemp,MAX_PATH
    x = InStrRev(zTemp, Any ":/\")
    If x Then 
        App.Path    =  Left(zTemp, x) 
        App.ExeName =  Mid(zTemp, x + 1)
    Else
        App.Path    =  "" 
        App.ExeName =  zTemp
    End If
	
	SetCurrentDirectory(@App.Path)
End Sub

Function WinMain(ByVal hInst As HINSTANCE,ByVal hPrevInst As HINSTANCE,ByVal CmdLine As LPCTSTR,ByVal CmdShow As Integer) As Integer
	Dim wc As WNDCLASSEX
	Dim msg As MSG
	
	InitApp(hInst)

	' Setup and register class for dialog
	wc.cbSize        = SizeOf(WNDCLASSEX)
	wc.style         = CS_HREDRAW or CS_VREDRAW
	wc.lpfnWndProc   = @WndProc
	wc.cbClsExtra    = 0
	wc.cbWndExtra    = DLGWINDOWEXTRA
	wc.hInstance     = hInst
	wc.hbrBackground = Cast(HBRUSH,COLOR_BTNFACE+1)
	wc.lpszMenuName  = Cast(LPCTSTR,IDM_MENU)
	wc.lpszClassName = Cast(LPCTSTR,@ClassName)
	wc.hIcon         = LoadIcon(NULL,IDI_APPLICATION)
	wc.hIconSm       = wc.hIcon
	wc.hCursor       = LoadCursor(NULL,IDC_ARROW)
	RegisterClassEx(@wc)
	' Create and show the dialog
	CreateDialogParam(hInst,MAKEINTRESOURCE(IDD_DIALOG),NULL,@WndProc,NULL)
	ShowWindow(hWndMain,SW_SHOWNORMAL)
	UpdateWindow(hWndMain)
	' Message loop
	Do While GetMessage(@msg,NULL,0,0)
		TranslateMessage(@msg)
		DispatchMessage(@msg)
	Loop
	Return msg.wParam

End Function

'{ Program start
    InitCommonControls
    WinMain(GetModuleHandle(NULL),NULL,GetCommandLine,SW_SHOWDEFAULT)
'    
	ExitProcess(0)
    End
'}
'Program End
[*ENDTXT*]
[*BEGINTXT*]
[*PRONAME*].rc
#define IDD_DIALOG     1000
#define IDR_MENU       10000
#define IDM_FILE_EXIT  10001
#define IDM_HELP_ABOUT 10101
IDD_DIALOG DIALOGEX 6,6,194,102
CAPTION "Dialog As Main"
FONT 8,"MS Sans Serif",0,0
CLASS "D"
MENU IDR_MENU
STYLE 0x10CF0000
BEGIN
END
IDR_MENU MENU
BEGIN
  POPUP "&File"
  BEGIN
    MENUITEM "&Exit",IDM_FILE_EXIT
  END
  POPUP "&Help"
  BEGIN
    MENUITEM "&About",IDM_HELP_ABOUT
  END
END
[*ENDTXT*]
[*BEGINTXT*]
[*PRONAME*].bi
Type APP_TYPE
	CompanyName As ZString * MAX_PATH      '???? 
	ProductName As ZString * MAX_PATH      '???? 
    ExeName     As ZString * MAX_PATH      'Exe?? 
    Path        As ZString * MAX_PATH      'Exe???? 
    hInstance   As HINSTANCE               ' 
    Major       As Long                    '????
    Minor       As Long                    '????  
    Revision    As Long                    '?????
    Build       As Long                    '?????
End Type

#Define IDD_DIALOG			1000

#Define IDM_MENU		    10000
#Define IDM_FILE_EXIT		10001
#Define IDM_HELP_ABOUT		10101

Dim Shared App As APP_TYPE
Dim Shared hWndMain As HWND

Const ClassName = "D"
Const AppName   = "Dialog as main"
Const AboutMsg  = !"FbEdit Dialog as main\13\10Copyright © FbEdit 2007"
[*ENDTXT*]
[*ENDPRO*]
