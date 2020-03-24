Dim Shared szDlgName As ZString * MAX_PATH
Dim Shared szTemplate As ZString * MAX_PATH
Dim Shared szFile As ZString * MAX_PATH
Dim Shared szProc As ZString * MAX_PATH

Function JumpToCode(szProc As String = "") As Boolean
	Dim rapn As RAPNOTIFY

	If Len(szProc) Then
		If SendMessage(ah.hpr,PRM_FINDFIRST,Cast(WPARAM,StrPtr("p")),Cast(LPARAM,@szProc)) Then
			rapn.nid=SendMessage(ah.hpr,PRM_FINDGETOWNER,0,0)
			rapn.nline=SendMessage(ah.hpr,PRM_FINDGETLINE,0,0)
			rapn.nmhdr.hwndFrom=ah.hpr
			rapn.nmhdr.idFrom=IDC_PROPERTY
			rapn.nmhdr.code=LBN_DBLCLK
			SendMessage(ah.hwnd,WM_NOTIFY,rapn.nmhdr.idFrom,Cast(LPARAM,@rapn))
			Return TRUE
		EndIf
	EndIf
	Return FALSE
End Function

Sub SetTextToFile(hMem As String)
	Dim chrg As CHARRANGE
	
	Print ah.hred
	
	chrg.cpMin=-1
	chrg.cpMax=-1
	If SendMessage(ah.hred,WM_GETTEXTLENGTH,0,0) Then
	Print SendMessage(ah.hred,EM_EXSETSEL,0,Cast(LPARAM,@chrg))
	Print SendMessage(ah.hred,EM_SCROLLCARET,0,0)
	Print SendMessage(ah.hred,EM_REPLACESEL,TRUE,Cast(LPARAM,@hMem))
	Else
	    SendMessage(ah.hred,WM_SETTEXT,Len(hMem) + 1,Cast(LPARAM,@hMem)) 
	End If
End Sub

Sub DoOnResEdClick(lpCTLDBLCLICK As CTLDBLCLICK Ptr)
	Dim As Integer x,id

'	If lstrlen(lpCTLDBLCLICK->lpDlgName) Then       '窗体名是否为空
'		lstrcpy(@szDlgName,lpCTLDBLCLICK->lpDlgName)
'	Else
'		szDlgName=Str(lpCTLDBLCLICK->nDlgId)
'	EndIf
'	
'
'	GetPrivateProfileString(StrPtr("ReallyRad"),@szDlgName,@szNULL,@buff,SizeOf(buff),@ad.ProjectFile)
'	If Len(buff) Then
'		x=InStr(buff,",")
'		If x Then
'			szTemplate=Left(buff,x-1)
'			buff=Mid(buff,x+1)
'			x=InStr(buff,",")
'			If x Then
'				szFile=Left(buff,x-1)
'				szProc=Mid(buff,x+1)
'			EndIf
'		EndIf
'	EndIf
''获取文件名
'    If szFile = "" Then
'    	id=1
'    	Do While id<256
'    		GetPrivateProfileString(StrPtr("File"),Str(id),@szNULL,@buff,SizeOf(buff),@ad.ProjectFile)
'    		If Len(buff) Then
'    			If LCase(Right(buff,4))=".bas" Then
'                    szFile = buff 
'                    WritePrivateProfileString(StrPtr("ReallyRad"),@szDlgName,@buff,@ad.ProjectFile)
'                    Exit Do
'    			EndIf
'    			id+=1
'    		End If
'    	Loop
'    End If

	If lstrlen(lpCTLDBLCLICK->lpDlgName) Then
		x=lstrcmp(lpCTLDBLCLICK->lpDlgName,lpCTLDBLCLICK->lpCtlName)
	Else
		x=lpCTLDBLCLICK->nCtlId-lpCTLDBLCLICK->nDlgId
	EndIf

	If x=0 Then  ' Dialog dblclicked
	    Print "窗体ID";lpCTLDBLCLICK->nDlgId	 
        Print "窗体名";*lpCTLDBLCLICK->lpDlgName 
        
        If JumpToCode("frmMainProc") Then '找到frmMainProc
        	
        Else                              '没有找到frmMainProc
        	Dim sMainText As String = "#include once ""windows.bi"""
        	
        	SetTextToFile(sMainText)
        	
        	
        	sMainText = "#define " & *lpCTLDBLCLICK->lpDlgName & Chr(9,9) & lpCTLDBLCLICK->nDlgId
        	SetTextToFile(sMainText)
        	
        EndIf
		
	Else         ' Control dblclicked	
	    Print "控件ID ";lpCTLDBLCLICK->nCtlId	 
        Print "控件名 ";*lpCTLDBLCLICK->lpCtlName
    	If JumpToCode = FALSE Then
    		
    	EndIf
	End If
End Sub
