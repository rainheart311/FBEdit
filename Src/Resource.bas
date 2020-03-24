#Define IDD_DLGRESED            1300
#define IDC_RARESED             1301

Dim Shared ressize As WINSIZE '= Type<WINSIZE>(300,175,0,52,100,100)

'Function ResourceProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer
'	Dim lret As Integer
'	Dim id As Integer
'	Dim hItem As Integer
'	Dim ht As TVHITTESTINFO
'	Dim tvi As TV_ITEM
'	Dim sFile As String*260
'	Dim fCtrl As Boolean
'
'	Select Case uMsg
'		Case WM_LBUTTONDBLCLK
'			lret=CallWindowProc(lpOldResourceProc,hWin,uMsg,wParam,lParam)
'			ht.pt.x=LoWord(lParam)
'			ht.pt.y=HiWord(lParam)
'			If SendMessage(hWin,TVM_HITTEST,0,Cast(Integer,@ht)) Then
'				tvi.hItem=ht.hItem
'				tvi.mask=TVIF_PARAM Or TVIF_TEXT
'				tvi.pszText=@buff
'				tvi.cchTextMax=260
'				SendMessage(hWin,TVM_GETITEM,0,Cast(Integer,@tvi))
'				If tvi.lParam Then
'					If nProjectGroup<>1 Then
'						If Mid(buff,2,2)=":\" Then
'							sFile=buff
'						Else
'							sFile=MakeProjectFileName(buff)
'						EndIf
'					Else
'						Dim path As String
'						path = ModPath.GetPathFromProjectFile(ah.hprj, tvi.hItem)
'						sFile = *StrPtr(path)
'						If Mid(sFile,2,2)=":\" Then
'						Else
'							sFile=MakeProjectFileName(sFile)
'						EndIf
'					EndIf 
'					OpenTheFile(sFile,FALSE)
'					fTimer=1
'				EndIf
'			EndIf
'			Return lret
'		Case WM_RBUTTONDOWN
'			ht.pt.x=LoWord(lParam)
'			ht.pt.y=HiWord(lParam)
'			SendMessage(hWin,TVM_HITTEST,0,Cast(Integer,@ht))
'			SendMessage(hWin,TVM_SELECTITEM,TVGN_CARET,Cast(Integer,ht.hItem))
'			'
'		Case Else
'			Return CallWindowProc(lpOldResourceProc,hWin,uMsg,wParam,lParam)
'			'
'	End Select
'	Return 0
'
'End Function

Function ResEdProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer
	Dim rect As RECT
	Dim As Integer nInx,x,y
	Dim pt As Point
	Dim hMnu As HMENU
	Dim hDll As HMODULE
	Dim nBtn As Integer
	Dim tbxwt As Integer
	Dim lpCTLDBLCLICK As CTLDBLCLICK Ptr
	Dim fbcust As FBCUSTSTYLE
	Dim cust As CUSTSTYLE
	Dim fbrstype As FBRSTYPE
	Dim sType As ZString*32
	Dim sExt As ZString*64
	Dim sEdit As ZString*128
	Dim rarstype As RARSTYPE
	Dim buffer As ZString*256

	Select Case uMsg
		Case WM_INITDIALOG
			ah.hraresed=GetDlgItem(hWin,IDC_RARESED)

			'hProject = FindWindowEx(ah.hraresed,0,"PROJECTCLASS",NULL)     '��ȡ��Դ�༭�ؼ����̴��ھ��
			'SetWindowLong hProject,GWL_EXSTYLE,GetWindowLong(hProject,GWL_EXSTYLE) And Not WS_EX_CLIENTEDGE
			'lpOldResourceProc=Cast(Any Ptr,SetWindowLong(hProject,GWL_WNDPROC,Cast(Integer,@ResourceProc)))
	        'hProperty = FindWindowEx(ah.hraresed,0,"PROPERTYCLASS",NULL)   '��ȡ��Դ�༭�ؼ����Դ��ھ��

            'ressize.htpro = 0
            'ressize.wtpro = 0
            'ressize.htout = 0
            
			SendMessage(ah.hraresed,DEM_SETSIZE,0,Cast(LPARAM,@ressize))
			SetDialogOptions(hWin)
			SendMessage(ah.hraresed,DEM_SETPOSSTATUS,Cast(Integer,ah.hsbr),1)
			nInx=1
			x=0
			While nInx<=32
				GetPrivateProfileString(StrPtr("CustCtrl"),Str(nInx),@szNULL,@buff,260,@ad.IniFile)
				If Len(buff) Then
					hDll=Cast(HMODULE,SendMessage(ah.hraresed,DEM_ADDCONTROL,0,Cast(Integer,@buff)))
					If hDll Then
						hCustDll(x)=hDll
						x=x+1
					EndIf
				EndIf
				nInx=nInx+1
			Wend
			nInx=1
			While nInx<=64
				fbcust.lpszStyle=@buff
				buff=""
				LoadFromIni(StrPtr("CustStyle"),Str(nInx),"044",@fbcust,FALSE)
				If Len(buff) Then
					cust.szStyle=buff
					cust.nValue=fbcust.nValue
					cust.nMask=IIf(fbcust.nMask,fbcust.nMask,fbcust.nValue)
					SendMessage(ah.hraresed,DEM_ADDCUSTSTYLE,0,Cast(LPARAM,@cust))
				EndIf
				nInx+=1
			Wend
			nInx=1
			While nInx<=32
				fbcust.lpszStyle=@buff
				fbrstype.lpsztype=@sType
				fbrstype.nid=0
				fbrstype.lpszext=@sExt
				fbrstype.lpszedit=@sEdit
				sType=""
				LoadFromIni(StrPtr("ResType"),Str(nInx),"0400",@fbrstype,FALSE)
				If Len(sType)<>0 Or fbrstype.nid<>0 Then
					ZStrReplace(@sExt,Asc("!"),Asc(","))
					rarstype.sztype=sType
					rarstype.nid=fbrstype.nid
					rarstype.szext=sExt
					rarstype.szedit=sEdit
					SendMessage(ah.hraresed,PRO_SETCUSTOMTYPE,nInx-1,Cast(LPARAM,@rarstype))
					If Len(sExt)=0 And nInx>11 Then
						buffer="Add " & sType
						InsertMenu(ah.hmenu,IDM_RESOURCE_LANGUAGE,MF_BYCOMMAND,nInx+22000-12,@buffer)
					EndIf
				EndIf
				nInx+=1
			Wend
			'
		Case WM_CLOSE
			DestroyWindow(hWin)
			'
		Case WM_DESTROY
			DestroyWindow(ah.hraresed)
			'
		Case WM_SIZE
			GetClientRect(hWin,@rect)
			MoveWindow(ah.hraresed,0,0,rect.right,rect.bottom,TRUE)
			'Dim hDlgClass As HWND = FindWindowEx(ah.hraresed,0,"DLGEDITCLASS",NULL) 'to hide the property window space
			'If hDlgClass Then
	        '    GetWindowRect hDlgClass, @rect          '
	        '    MapWindowPoints NULL,GetParent(hDlgClass),Cast(LPPOINT,@rect),2
	        '    SetWindowPos(hDlgClass, 0, 0, 0, rect.right - rect.left + 4, rect.Bottom - rect.Top,SWP_NOZORDER Or SWP_NOMOVE Or SWP_NOACTIVATE)
			'EndIf
			'If hProject Then
			'	SetParent hProject,ah.hwnd
			'	MoveWindow(hProject,ProjRc.left,ProjRc.top,ProjRc.right,ProjRc.bottom,TRUE)
			'End If
			'If hProperty Then
			'    SetParent hProperty,ah.hwnd
			'	MoveWindow(hProperty,PropRc.left,PropRc.top,PropRc.right,PropRc.bottom,TRUE)
			'End If

'		Case EM_GETMODIFY
'			Return SendMessage(ah.hraresed,PRO_GETMODIFY,0,0)
'			'
		Case EM_SETMODIFY
			SendMessage(ah.hraresed,PRO_SETMODIFY,wParam,0)
			'
		Case EM_UNDO
			SendMessage(ah.hraresed,DEM_UNDO,0,0)
			'
		Case EM_REDO
			SendMessage(ah.hraresed,DEM_REDO,0,0)
			'
		Case WM_CUT
			SendMessage(ah.hraresed,DEM_CUT,0,0)
			'
		Case WM_COPY
			SendMessage(ah.hraresed,DEM_COPY,0,0)
			'
		Case WM_PASTE
			SendMessage(ah.hraresed,DEM_PASTE,0,0)
			'
		Case WM_CLEAR
			SendMessage(ah.hraresed,DEM_DELETECONTROLS,0,0)
			'
		Case WM_NOTIFY
			lpCTLDBLCLICK=Cast(CTLDBLCLICK Ptr,lParam)			
			If lpCTLDBLCLICK->nmhdr.code=NM_DBLCLK Then
				CallAddins(hWin,AIM_CTLDBLCLK,0,lParam,HOOK_CTLDBLCLK)
			EndIf
			If lpCTLDBLCLICK->nmhdr.code=NM_CLICK Then
				CallAddins(hWin,AIM_CTLDBLCLK,0,lParam,HOOK_CTLDBLCLK)
			EndIf
			ah.hrareseddlg=Cast(HWND,SendMessage(ah.hraresed,PRO_GETDIALOG,0,0))
			fTimer=1
			'
		Case WM_CONTEXTMENU
			If CallAddins(hWin,AIM_CONTEXTMEMU,wParam,lParam,HOOK_CONTEXTMEMU)=FALSE Then
				If lParam=-1 Then
					GetWindowRect(hWin,@rect)
					pt.x=rect.left+90
					pt.y=rect.top+90
				Else
					pt.x=Cast(Short,LoWord(lParam))
					pt.y=Cast(Short,HiWord(lParam))
				EndIf
				hMnu=GetSubMenu(ah.hcontextmenu,4)
				TrackPopupMenu(hMnu,TPM_LEFTALIGN Or TPM_RIGHTBUTTON,pt.x,pt.y,0,ah.hwnd,0)
			EndIf
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function
