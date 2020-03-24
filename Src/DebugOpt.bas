
#Define IDD_DLGDEBUGOPT						5100
#Define IDC_BTNDEBUGOPT						1003
#Define IDC_EDTDEBUGOPT						1001

#Define IDC_EDTQUICKRUN						1005
#Define IDC_BTNQUICKRUN						1006

Function DebugOptDlgProc(ByVal hWin As HWND, ByVal uMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As Integer
	Dim As Long id, Event
	Dim ofn As OPENFILENAME

	Select Case uMsg
		Case WM_INITDIALOG
			TranslateDialog(hWin,IDD_DLGDEBUGOPT)
			CenterOwner(hWin)
			SetDlgItemText(hWin,IDC_EDTDEBUGOPT,@ad.smakerundebug)
			SetDlgItemText(hWin,IDC_EDTQUICKRUN,@ad.smakequickrun)
			'
		Case WM_CLOSE
			EndDialog(hWin, 0)
			'
		Case WM_COMMAND
			id=LoWord(wParam)
			Event=HiWord(wParam)
			Select Case id
				Case IDOK
					GetDlgItemText(hWin,IDC_EDTDEBUGOPT,@ad.smakerundebug,SizeOf(ad.smakerundebug))
					WritePrivateProfileString(StrPtr("Debug"),StrPtr("Debug"),@ad.smakerundebug,@ad.IniFile)
					GetDlgItemText(hWin,IDC_EDTQUICKRUN,@ad.smakequickrun,SizeOf(ad.smakequickrun))
					WritePrivateProfileString(StrPtr("Make"),StrPtr("QuickRun"),@ad.smakequickrun,@ad.IniFile)
					EndDialog(hWin, 0)
					'
				Case IDCANCEL
					EndDialog(hWin, 0)
					'
				Case IDC_BTNDEBUGOPT
					RtlZeroMemory(@ofn,SizeOf(ofn))
					ofn.lStructSize=SizeOf(ofn)
					ofn.hwndOwner=hWin
					ofn.hInstance=hInstance
					ofn.lpstrFilter=@EXEFilterString
					ofn.lpstrFile=@buff
					GetDlgItemText(hWin,IDC_EDTDEBUGOPT,@buff,256)
					ofn.nMaxFile=256
					ofn.Flags=OFN_EXPLORER Or OFN_FILEMUSTEXIST Or OFN_HIDEREADONLY Or OFN_PATHMUSTEXIST
					If GetOpenFileName(@ofn) Then
						SetDlgItemText(hWin,IDC_EDTDEBUGOPT,@buff)
					EndIf
					'
				Case IDC_BTNQUICKRUN
					id=DialogBoxParam(hInstance,Cast(ZString Ptr,IDD_DLGOPTMNU),hWin,@MenuOptionDlgProc,5)
					If id Then
						GetPrivateProfileString(StrPtr("Make"),Str(id),@szNULL,@buff,260,@ad.IniFile)
						id=InStr(buff,",")
						SetDlgItemText(hWin,IDC_EDTQUICKRUN,@buff[id])
					EndIf
					'
			End Select
		Case Else
			Return FALSE
			'
	End Select
	Return TRUE

End Function
