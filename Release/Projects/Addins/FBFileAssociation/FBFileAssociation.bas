
#include "FBFileAssociation.bi"

#Define BAS_FILE "FBEditBasFile"
#Define BAS_FILE_D "FreeBasic Source File"
#Define BI_FILE "FBEditBiFile"
#Define BI_FILE_D "FreeBasic Header File"
#define RC_FILE "FBEditRcFile"
#Define RC_FILE_D "FreeBasic Resource File"
#define FBP_FILE "FBEditFbpFile"
#Define FBP_FILE_D "FBedit Project File"




function DlgProc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as integer
	dim as long id, event
	Dim regBasName  as RegLib=RegLib(HKEY_CLASSES_ROOT,".bas")
	Dim regBasClass as RegLib=RegLib(HKEY_CLASSES_ROOT,BAS_FILE)
	Dim regBasIcon  as RegLib=RegLib(HKEY_CLASSES_ROOT,BAS_FILE+"\DefaultIcon")
	Dim regBasCmd   as RegLib=RegLib(HKEY_CLASSES_ROOT,BAS_FILE+"\shell\open\command")
	Dim regBiName   as RegLib=RegLib(HKEY_CLASSES_ROOT,".bi")
	Dim regBiClass  as RegLib=RegLib(HKEY_CLASSES_ROOT,BI_FILE)
	Dim regBiIcon   as RegLib=RegLib(HKEY_CLASSES_ROOT,BI_FILE+"\DefaultIcon")
	Dim regBiCmd    as RegLib=RegLib(HKEY_CLASSES_ROOT,BI_FILE+"\shell\open\command")
	Dim regRcName   as RegLib=RegLib(HKEY_CLASSES_ROOT,".rc")
	Dim regRcClass  as RegLib=RegLib(HKEY_CLASSES_ROOT,RC_FILE)
	Dim regRcIcon   as RegLib=RegLib(HKEY_CLASSES_ROOT,RC_FILE+"\DefaultIcon")
	Dim regRcCmd    as RegLib=RegLib(HKEY_CLASSES_ROOT,RC_FILE+"\shell\open\command")
	Dim regFbpName  as RegLib=RegLib(HKEY_CLASSES_ROOT,".fbp")
	Dim regFbpClass as RegLib=RegLib(HKEY_CLASSES_ROOT,FBP_FILE)
	Dim regFbpIcon  as RegLib=RegLib(HKEY_CLASSES_ROOT,FBP_FILE+"\DefaultIcon")
	Dim regFbpCmd   as RegLib=RegLib(HKEY_CLASSES_ROOT,FBP_FILE+"\shell\open\command")
	Dim Cmd as String=Chr(34)+lpData->AppPath+"\FBEdit.exe"+Chr(34)+" "+Chr(34)+"%1"+Chr(34)
	Dim basIco as String=Chr(34)+lpData->AppPath+"\Addins\FBFileAssociation.dll"+Chr(34)+",0"
	Dim biIco as String=Chr(34)+lpData->AppPath+"\Addins\FBFileAssociation.dll"+Chr(34)+",1"
	Dim fbpIco as String=Chr(34)+lpData->AppPath+"\Addins\FBFileAssociation.dll"+Chr(34)+",2"
	Dim rcIco as String=Chr(34)+lpData->AppPath+"\Addins\FBFileAssociation.dll"+Chr(34)+",3"
	Dim buff As ZString*256

	select case uMsg
		case WM_INITDIALOG
			lpFunctions->TranslateAddinDialog(hDlg,"FBFileAssociation")
			'.bas
			if regBasName.exists AndAlso Cast(Boolean,regBasName.default=BAS_FILE) AndAlso _
				regBasClass.exists AndAlso Cast(Boolean,regBasClass.default=BAS_FILE_D) AndAlso _
				regBasIcon.exists AndAlso Cast(Boolean,regBasIcon.default=basIco) AndAlso _
				regBasCmd.exists AndAlso Cast(Boolean,regBasCmd.default=Cmd) then
				CheckDlgButton(hDlg,baBAS,BST_CHECKED)
			else
				CheckDlgButton(hDlg,baBAS,BST_UNCHECKED)
			endif
			'.bi
			if regBiName.exists AndAlso Cast(Boolean,regBiName.default=BI_FILE) AndAlso _
				regBiClass.exists AndAlso Cast(Boolean,regBiClass.default=BI_FILE_D) AndAlso _
				regBiIcon.exists AndAlso Cast(Boolean,regBiIcon.default=biIco) AndAlso _
				regBiCmd.exists AndAlso Cast(Boolean,regBiCmd.default=Cmd) then
				CheckDlgButton(hDlg,baBI,BST_CHECKED)
			else
				CheckDlgButton(hDlg,baBI,BST_UNCHECKED)
			endif			
			'.fbp
			if regFbpName.exists AndAlso Cast(Boolean,regFbpName.default=FBP_FILE) AndAlso _
				regFbpClass.exists AndAlso Cast(Boolean,regFbpClass.default=FBP_FILE_D) AndAlso _
				regFbpIcon.exists AndAlso Cast(Boolean,regFbpIcon.default=fbpIco) AndAlso _
				regFbpCmd.exists AndAlso Cast(Boolean,regFbpCmd.default=Cmd) then
				CheckDlgButton(hDlg,baFBP,BST_CHECKED)
			else
				CheckDlgButton(hDlg,baFBP,BST_UNCHECKED)
			endif		
			'.rc
			if regRcName.exists AndAlso Cast(Boolean,regRcName.default=RC_FILE) AndAlso _
				regRcClass.exists AndAlso Cast(Boolean,regRcClass.default=RC_FILE_D) AndAlso _
				regRcIcon.exists AndAlso Cast(Boolean,regRcIcon.default=rcIco) AndAlso _
				regRcCmd.exists AndAlso Cast(Boolean,regRcCmd.default=Cmd) then
				CheckDlgButton(hDlg,baRC,BST_CHECKED)
			else
				CheckDlgButton(hDlg,baRC,BST_UNCHECKED)
			endif					
		case WM_CLOSE
			EndDialog(hDlg, 0)
			'
		case WM_COMMAND
			id=loword(wParam)
			event=hiword(wParam)
			select case id
				case baCLOSE
					EndDialog(hDlg, 0)
				case baDOIT
					if IsDlgButtonChecked(hDlg,baBAS) then
						regBasName.createMe()
						regBasClass.createMe()
						regBasIcon.createMe()
						regBasCmd.createMe()
						regBasName.default=BAS_FILE
						regBasClass.default=BAS_FILE_D
						regBasIcon.default=basIco
						regBasCmd.default=Cmd							
					else
						regBasCmd.deleteMe()
						regBasIcon.deleteMe()
						Dim tmp as RegLib=RegLib(HKEY_CLASSES_ROOT,BAS_FILE+"\shell\open")
						tmp.deleteMe()
						tmp=RegLib(HKEY_CLASSES_ROOT,BAS_FILE+"\shell")
						tmp.deleteMe()
						regBasClass.deleteMe()
						regBasName.deleteMe()
					endif
					if IsDlgButtonChecked(hDlg,baBI) then
						regBiName.createMe()
						regBiClass.createMe()
						regBiIcon.createMe()
						regBiCmd.createMe()
						regBiName.default=BI_FILE
						regBiClass.default=BI_FILE_D
						regBiIcon.default=biIco
						regBiCmd.default=Cmd							
					else
						regBiCmd.deleteMe()
						regBiIcon.deleteMe()
						Dim tmp as RegLib=RegLib(HKEY_CLASSES_ROOT,BI_FILE+"\shell\open")
						tmp.deleteMe()
						tmp=RegLib(HKEY_CLASSES_ROOT,BI_FILE+"\shell")
						tmp.deleteMe()
						regBiClass.deleteMe()
						regBiName.deleteMe()
					endif
					if IsDlgButtonChecked(hDlg,baFBP) then
						regFbpName.createMe()
						regFbpClass.createMe()
						regFbpIcon.createMe()
						regFbpCmd.createMe()
						regFbpName.default=FBP_FILE
						regFbpClass.default=FBP_FILE_D
						regFbpIcon.default=fbpIco
						regFbpCmd.default=Cmd							
					else
						regFbpCmd.deleteMe()
						regFbpIcon.deleteMe()
						Dim tmp as RegLib=RegLib(HKEY_CLASSES_ROOT,FBP_FILE+"\shell\open")
						tmp.deleteMe()
						tmp=RegLib(HKEY_CLASSES_ROOT,FBP_FILE+"\shell")
						tmp.deleteMe()
						regFbpClass.deleteMe()
						regFbpName.deleteMe()
					endif		
					if IsDlgButtonChecked(hDlg,baRC) then
						regRcName.createMe()
						regRcClass.createMe()
						regRcIcon.createMe()
						regRcCmd.createMe()
						regRcName.default=RC_FILE
						regRcClass.default=RC_FILE_D
						regRcIcon.default=rcIco
						regRcCmd.default=Cmd							
					else
						regRcCmd.deleteMe()
						regRcIcon.deleteMe()
						Dim tmp as RegLib=RegLib(HKEY_CLASSES_ROOT,RC_FILE+"\shell\open")
						tmp.deleteMe()
						tmp=RegLib(HKEY_CLASSES_ROOT,RC_FILE+"\shell")
						tmp.deleteMe()
						regRcClass.deleteMe()
						regRcName.deleteMe()
					EndIf
					buff=lpFunctions->FindString(lpData->hLangMem,"FBFileAssociation","10001")
					If buff="" Then
						buff="File Association changed!"+Chr(13)+"FBEdit path is:"
					EndIf

					MessageBox(hDlg,buff+Chr(13)+lpData->AppPath,"FBEdit",MB_OK)
					EndDialog(hDlg, 0)
			end select
		case WM_SIZE
			'
		case else
			return FALSE
			'
	end select
	return TRUE

end function


' Returns info on what messages the addin hooks into (in an ADDINHOOKS type).
function InstallDll CDECL alias "InstallDll" (byval hWin as HWND,byval hInst as HINSTANCE) as ADDINHOOKS ptr EXPORT
	Dim buff As ZString*256
	' Get pointer to ADDINHANDLES
	lpHandles=Cast(ADDINHANDLES ptr,SendMessage(hWin,AIM_GETHANDLES,0,0))
	' Get pointer to ADDINDATA
	lpData=Cast(ADDINDATA ptr,SendMessage(hWin,AIM_GETDATA,0,0))
	' Get pointer to ADDINFUNCTIONS
	lpFunctions=Cast(ADDINFUNCTIONS ptr,SendMessage(hWin,AIM_GETFUNCTIONS,0,0))
	dim hMnu as HMENU
	
	' Get handle to 'Tools' popup
	hMnu=GetSubMenu(lpHANDLES->hmenu,8)
	' Add our menu item to Tools menu
	IDM_FILEASSOC=SendMessage(hWin,AIM_GETMENUID,0,0)
	buff=lpFunctions->FindString(lpData->hLangMem,"FBFileAssociation","10000")
	If buff="" Then
		buff="File Association"
	EndIf
	AppendMenu(hMnu,MF_STRING,IDM_FILEASSOC,StrPtr(buff))
	' Messages this addin will hook into
	hooks.hook1=HOOK_COMMAND
	hooks.hook2=0
	hooks.hook3=0
	hooks.hook4=0
	return @hooks

end function

' FbEdit calls this function for every addin message that this addin is hooked into.
' Returning TRUE will prevent FbEdit and other addins from processing the message.
function DllFunction CDECL alias "DllFunction" (byval hWin as HWND,byval uMsg as UINT,byval wParam as WPARAM,byval lParam as LPARAM) as bool EXPORT

	select case uMsg
		case AIM_COMMAND
			if loword(wParam)=IDM_FILEASSOC then
'				MessageBox(hWin,"Cool","caption",MB_OK)
				DialogBoxParam(hInstance,Cast(zstring ptr,IDD_DLG1),hWin,@DlgProc,NULL)
			endif
		case AIM_CLOSE
			'
	end select
	return FALSE

end Function

Function DllMain(ByVal hModule As HANDLE, ByVal fwdReason As Dword, ByVal lpReserved As LPVOID) As BOOL Export 
    Select Case fwdReason
    	Case DLL_PROCESS_ATTACH  'DLL被加载
            hInstance=hModule
    	Case DLL_PROCESS_DETACH  'DLL被卸载
            
    	Case DLL_THREAD_ATTACH   '单个线程启动
            
    	Case DLL_THREAD_DETACH   '单个线程终止
    		
    	Case Else
    End Select  
    Function = TRUE
End Function
