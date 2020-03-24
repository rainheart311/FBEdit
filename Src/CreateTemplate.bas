
#Define IDD_CREATETEMPLATE      6000
#Define IDC_EDTTPLDESCRIPTION   1000
#Define IDC_LSTTPLFILES         1001
#Define IDC_BTNTPLADD           1002
#Define IDC_BTNTPLREMOVE        1003
#Define IDC_BTNTPLFILENAME      1005
#Define IDC_EDTTPLFILENAME      1004

Sub AddTemplateFile(ByVal lpFile As ZString Ptr,ByVal hFile As HANDLE)
	Dim hSrc As HANDLE
	Dim nSize As Integer
	Dim b As Byte
	Dim n As DWORD
	Dim i As DWORD
	Dim hMem As HGLOBAL
	Dim p As ZString Ptr
	Dim szBuff As ZString*260
	Dim szExt As ZString*260
	Dim szTxt As ZString*260
	Dim szBin As ZString*260

	szBuff=ad.ProjectPath & "\"
	lstrcat(@szBuff,lpFile)
	hSrc=CreateFile(@szBuff,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0)
	If hSrc<>INVALID_HANDLE_VALUE Then
		nSize=GetFileSize(hSrc,@n)
		hMem=MyGlobalAlloc(GMEM_FIXED Or GMEM_ZEROINIT,nSize+3)
		ReadFile(hSrc,hMem,nSize,@n,NULL)
		CloseHandle(hSrc)
		szExt=GetFileExt(szBuff) & "."
		GetPrivateProfileString(StrPtr("Template"),StrPtr("txtfiles"),StrPtr(".bas.bi.rc.txt.xml."),@szTxt,SizeOf(szTxt),@ad.IniFile)
		GetPrivateProfileString(StrPtr("Template"),StrPtr("binfiles"),StrPtr(".bmp.jpg.ico.cur."),@szBin,SizeOf(szBin),@ad.IniFile)
		If InStr(UCase(szTxt),UCase(szExt)) Then
			buff=szBTXT & CRLF
			lstrcat(@buff,lpFile)
			buff=buff & CRLF
			WriteFile(hFile,@buff,Len(buff),@n,NULL)
			p=hMem
			p=p+Len(*p)
			If lstrcmp(p-2,@CRLF) Then
				lstrcpy(p,@CRLF)
				nSize=nSize+2
			EndIf
			WriteFile(hFile,hMem,nSize,@n,NULL)
			buff=szETXT & CRLF
			WriteFile(hFile,@buff,Len(buff),@n,NULL)
		ElseIf InStr(UCase(szBin),UCase(szExt)) Then
			buff=szBBIN & CRLF
			lstrcat(@buff,lpFile)
			buff=buff & CRLF
			WriteFile(hFile,@buff,Len(buff),@n,NULL)
			buff=""
			n=0
			i=0
			While n<nSize
				CopyMemory(@b,hMem+n,1)
				buff=buff & Right("0" & Hex(b),2)
				n=n+1
				i=i+1
				If i=32 Then
					buff=buff & CRLF
					WriteFile(hFile,@buff,Len(buff),@i,NULL)
					i=0
					buff=""
				EndIf
			Wend
			If i Then
				buff=buff & CRLF
				WriteFile(hFile,@buff,Len(buff),@i,NULL)
				i=0
				buff=""
			EndIf
			buff=szEBIN & CRLF
			WriteFile(hFile,@buff,Len(buff),@n,NULL)
		Else
			buff="Unknown filetype:" & CRLF
			lstrcat(@buff,lpFile)
			MessageBox(ah.hwnd,@buff,@szAppName,MB_OK)
		EndIf
		GlobalFree(hMem)
	EndIf

End Sub

Function CreateTemplateDlgProc(ByVal hWin As HWND,ByVal uMsg As UINT,ByVal wParam As WPARAM,ByVal lParam As LPARAM) As Integer
	Dim ofn As OPENFILENAME
	Dim szBuff As ZString*260
	Dim hFile As HANDLE
	Dim p As ZString Ptr
	Dim n As DWORD

	Select Case uMsg
		Case WM_INITDIALOG
			TranslateDialog(hWin,IDD_CREATETEMPLATE)
			'
		Case WM_COMMAND
			Select Case LoWord(wParam)
				Case IDOK
					GetDlgItemText(hWin,IDC_EDTTPLFILENAME,@buff,260)
					If Len(buff) Then
						hFile=CreateFile(@buff,GENERIC_WRITE,FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0)
						If hFile<>INVALID_HANDLE_VALUE Then
							buff=ad.ProjectFile
							buff=GetFileName(buff,FALSE) & CRLF
							p=@buff
							p=p+Len(*p)
							GetDlgItemText(hWin,IDC_EDTTPLDESCRIPTION,p,1024)
							p=p+Len(*p)
							If lstrcmp(p-2,@CRLF) Then
								lstrcpy(p,@CRLF)
								p=p+2
							EndIf
							WriteFile(hFile,@buff,Len(buff),@n,NULL)
							buff=szBPRO & CRLF
							buff=buff & szBDEF & CRLF
							buff=buff & "[Project]" & CRLF
							GetPrivateProfileSection(StrPtr("Project"),@s,4096,@ad.ProjectFile)
							p=@s
							While Len(*p)
								lstrcat(@buff,p)
								lstrcat(@buff,@CRLF)
								p=p+Len(*p)+1
							Wend
							buff=buff & "[Make]" & CRLF
							GetPrivateProfileSection(StrPtr("Make"),@s,4096,@ad.ProjectFile)
							p=@s
							While Len(*p)
								lstrcat(@buff,p)
								lstrcat(@buff,@CRLF)
								p=p+Len(*p)+1
							Wend
							buff=buff & szEDEF & CRLF
							WriteFile(hFile,@buff,Len(buff),@n,NULL)
							n=1
							While n<256
								szBuff=GetProjectFile(n)
								If Len(szBuff) Then
									AddTemplateFile(@szBuff,hFile)
								EndIf
								n=n+1
							Wend
							buff=szEPRO & CRLF
							WriteFile(hFile,@buff,Len(buff),@n,NULL)
							n=0
							While TRUE
								If SendDlgItemMessage(hWin,IDC_LSTTPLFILES,LB_GETTEXT,n,Cast(LPARAM,@szBuff))<>LB_ERR Then
									AddTemplateFile(@szBuff,hFile)
								Else
									Exit While
								EndIf
								n=n+1
							Wend
							CloseHandle(hFile)
							EndDialog(hWin,0)
						EndIf
					EndIf
					'
				Case IDCANCEL
					EndDialog(hWin,0)
					'
				Case IDC_BTNTPLADD
					ofn.lStructSize=SizeOf(OPENFILENAME)
					ofn.hwndOwner=hWin
					ofn.hInstance=hInstance
					szBuff=ad.ProjectPath
					ofn.lpstrInitialDir=@szBuff
					ofn.lpstrDefExt=@szNULL
					buff=""
					ofn.lpstrFile=StrPtr(buff)
					ofn.nMaxFile=260
					ofn.lpstrFilter=StrPtr(ALLFilterString)
					ofn.Flags=OFN_EXPLORER Or OFN_FILEMUSTEXIST Or OFN_HIDEREADONLY Or OFN_PATHMUSTEXIST Or OFN_ALLOWMULTISELECT Or OFN_EXPLORER
					If GetOpenFileName(@ofn) Then
						buff=RemoveProjectPath(buff)
						SendDlgItemMessage(hWin,IDC_LSTTPLFILES,LB_ADDSTRING,0,Cast(LPARAM,@buff))
					EndIf
					'
				Case IDC_BTNTPLREMOVE
					If SendDlgItemMessage(hWin,IDC_LSTTPLFILES,LB_GETCOUNT,0,0) Then
						n=SendDlgItemMessage(hWin,IDC_LSTTPLFILES,LB_GETCURSEL,0,0)
						If n<>LB_ERR Then
							SendDlgItemMessage(hWin,IDC_LSTTPLFILES,LB_DELETESTRING,n,0)
						EndIf
					EndIf
					'
				Case IDC_BTNTPLFILENAME
					ofn.lStructSize=SizeOf(OPENFILENAME)
					ofn.hwndOwner=hWin
					ofn.hInstance=hInstance
					szBuff=ad.AppPath & "\Templates"
					ofn.lpstrInitialDir=@szBuff
					ofn.lpstrFilter=@TPLFilterString
					ofn.lpstrDefExt=StrPtr("tpl")
					buff=""
					ofn.lpstrFile=StrPtr(buff)
					ofn.nMaxFile=260
					ofn.Flags=OFN_EXPLORER Or OFN_HIDEREADONLY Or OFN_PATHMUSTEXIST Or OFN_OVERWRITEPROMPT
					If GetSaveFileName(@ofn) Then
						SetDlgItemText(hWin,IDC_EDTTPLFILENAME,@buff)
					EndIf
					'
			End Select
			'
		Case WM_CLOSE
			EndDialog(hWin, 0)
			'
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function
