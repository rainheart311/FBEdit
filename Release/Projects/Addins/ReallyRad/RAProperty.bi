
' Messages
#Define PRM_SELECTPROPERTY		WM_USER+0		' wParam=dwType, lParam=0
#Define PRM_ADDPROPERTYTYPE	WM_USER+1		' wParam=dwType, lParam=lpszType
#Define PRM_ADDPROPERTYFILE	WM_USER+2		' wParam=dwType, lParam=lpszFile
#Define PRM_SETGENDEF			WM_USER+3		' wParam=0, lParam=lpGENDEF
#Define PRM_ADDIGNORE			WM_USER+4		' wParam=IgnoreType, lParam=lpszWord
#Define PRM_ADDDEFTYPE			WM_USER+5		' wParam=0, lParam=lpTYPEDEF
#Define PRM_PARSEFILE			WM_USER+6		' wParam=Owner, lParam=lpFileData
#Define PRM_SETCHARTAB			WM_USER+7		' wParam=0, lParam=lpCharTab
#Define PRM_DELPROPERTY			WM_USER+8		' wParam=nOwner (0=All), lParam=0
#Define PRM_REFRESHLIST			WM_USER+9		' wParam=0, lParam=0
#Define PRM_SELOWNER				WM_USER+10		' wParam=nOwner, lParam=0
#Define PRM_GETSELBUTTON		WM_USER+11		' wParam=0, lParam=0
#Define PRM_SETSELBUTTON		WM_USER+12		' wParam=nButton, lParam=0
#Define PRM_FINDFIRST			WM_USER+13		' wParam=lpszTypes, lParam=lpszText
#Define PRM_FINDNEXT				WM_USER+14		' wParam=0, lParam=0
#Define PRM_FINDGETTYPE			WM_USER+15		' wParam=0, lParam=0
#Define PRM_GETWORD				WM_USER+16		' wParam=pos, lParam=lpszLine
#Define PRM_GETTOOLTIP			WM_USER+17		' wParam=0, lParam=lpTOOLTIP
#Define PRM_SETBACKCOLOR		WM_USER+18		' wParam=0, lParam=nColor
#Define PRM_GETBACKCOLOR		WM_USER+19		' wParam=0, lParam=0
#Define PRM_SETTEXTCOLOR		WM_USER+20		' wParam=0, lParam=nColor
#Define PRM_GETTEXTCOLOR		WM_USER+21		' wParam=0, lParam=0
#Define PRM_ISINPROC				WM_USER+22		' wParam=0, lParam=lpISINPROC
#Define PRM_GETSTRUCTWORD		WM_USER+23		' wParam=pos, lParam=lpszLine
#Define PRM_FINDITEMDATATYPE	WM_USER+24		' wParam=lpszItemName, lParam=lpszItemList
#Define PRM_MEMSEARCH			WM_USER+25		' wParam=0, lParam=lpMEMSEARCH
#Define PRM_FINDGETOWNER		WM_USER+26		' wParam=0, lParam=0
#Define PRM_FINDGETLINE			WM_USER+27		' wParam=0, lParam=0
#Define PRM_ISINWITHBLOCK		WM_USER+28		' wParam=nOwner, lParam=nLine
#Define PRM_FINDGETENDLINE		WM_USER+29		' wParam=0, lParam=0
#Define PRM_ADDISWORD			WM_USER+30		' wParam=nType, lParam=lpszWord
#Define PRM_SETOPRCOLOR			WM_USER+31		' wParam=0, lParam=nColor
#Define PRM_GETOPRCOLOR			WM_USER+32		' wParam=0, lParam=0
#Define PRM_CLEARWORDLIST		WM_USER+33		' wParam=0, lParam=0
#Define PRM_GETSTRUCTSTART		WM_USER+34		' wParam=pos, lParam=lpszLine
#Define PRM_GETCURSEL			WM_USER+35		' wParam=0, lParam=0
#Define PRM_GETSELTEXT			WM_USER+36		' wParam=0, lParam=lpBuff
#Define PRM_GETSORTEDLIST		WM_USER+37		' wParam=lpTypes, lParam=lpCount
#Define PRM_FINDINSORTEDLIST	WM_USER+38		' wParam=nCount, lParam=lpMEMSEARCH
#Define PRM_ISTOOLTIPMESSAGE	WM_USER+39		' wParam=lpMESSAGE, lParam=lpTOOLTIP

' Styles
#Define PRSTYLE_FLATTOOLBAR	1
#Define PRSTYLE_DIVIDERLINE	2
#Define PRSTYLE_PROJECT			4

Type DEFGEN
	szCmntBlockSt	As ZString*16
	szCmntBlockEn	As ZString*16
	szCmntChar		As ZString*16
	szString			As ZString*16
	szLineCont		As ZString*16
End Type

#Define TYPE_NAMEFIRST				1
#Define TYPE_OPTNAMEFIRST			2
#Define TYPE_NAMESECOND				3
#Define TYPE_OPTNAMESECOND			4
#Define TYPE_TWOWORDS				5
#Define TYPE_ONEWORD					6

#Define DEFTYPE_PROC					1
#Define DEFTYPE_ENDPROC				2
#Define DEFTYPE_DATA					3
'#define DEFTYPE_MULTIDATA			4
#Define DEFTYPE_CONST				5
#Define DEFTYPE_ENDCONST			6
#Define DEFTYPE_STRUCT				7
#Define DEFTYPE_ENDSTRUCT			8
#Define DEFTYPE_TYPE					9
#Define DEFTYPE_ENDTYPE				10
#Define DEFTYPE_LOCALDATA			11
#Define DEFTYPE_NAMESPACE			12
#Define DEFTYPE_ENDNAMESPACE		13
#Define DEFTYPE_ENUM					14
#Define DEFTYPE_ENDENUM				15
#Define DEFTYPE_WITHBLOCK			16
#Define DEFTYPE_ENDWITHBLOCK		17
#Define DEFTYPE_MACRO				18
#Define DEFTYPE_ENDMACRO			19
#Define DEFTYPE_PROPERTY			20
#Define DEFTYPE_ENDPROPERTY		21
#Define DEFTYPE_OPERATOR			22
#Define DEFTYPE_ENDOPERATOR		23
#Define DEFTYPE_CONSTRUCTOR		24
#Define DEFTYPE_ENDCONSTRUCTOR	25
#Define DEFTYPE_DESTRUCTOR			26
#Define DEFTYPE_ENDDESTRUCTOR		27

Type DEFTYPE
	nType				As UByte
	nDefType			As UByte
	nDef				As UByte
	nlen				As UByte
	szWord			As ZString*32
End Type

' Ignore types
#Define IGNORE_LINEFIRSTWORD			1
#Define IGNORE_LINESECONDWORD			2
#Define IGNORE_FIRSTWORD				3
#Define IGNORE_SECONDWORD				4
#Define IGNORE_FIRSTWORDTWOWORDS		5
#Define IGNORE_SECONDWORDTWOWORDS	6
#Define IGNORE_PROCPARAM				7
#Define IGNORE_DATATYPEINIT			8
#Define IGNORE_STRUCTITEMFIRSTWORD	9
#Define IGNORE_STRUCTITEMSECONDWORD	10
#Define IGNORE_STRUCTTHIRDWORD		11
#Define IGNORE_STRUCTITEMINIT			12
#Define IGNORE_PTR						13
#Define IGNORE_STRUCTLINEFIRSTWORD	14

' Character table types
#Define CT_NONE					0
#Define CT_CHAR					1
#Define CT_OPER					2
#Define CT_HICHAR					3
#Define CT_CMNTCHAR				4
#Define CT_STRING					5
#Define CT_CMNTDBLCHAR			6
#Define CT_CMNTINITCHAR			7

Type RAPNOTIFY
	nmhdr				As NMHDR
	nid				As Integer
	nline				As Integer
End Type

Type ISINPROC
	nLine				As Integer
	nOwner			As Integer
	lpszType			As ZString Ptr
End Type

#Define TT_NOMATCHCASE			1
#Define TT_PARANTESES			2

Type OVERRIDE
	lpszParam		As ZString Ptr
	lpszRetType		As ZString Ptr
End Type

Type TOOLTIP
	lpszType			As ZString Ptr
	lpszLine			As ZString Ptr
	lpszApi			As ZString Ptr
	nPos				As Integer
	novr				As Integer
	ovr(32)			As OVERRIDE
End Type

Type MSGAPI
	nPos				As Integer
	lpszApi			As ZString Ptr
End Type

Type MESSAGE
	szType			As ZString*4
	lpMsgApi(31)	As MSGAPI
End Type

Type MEMSEARCH
	lpMem				As HGLOBAL
	lpFind			As ZString Ptr
	lpCharTab		As Any Ptr
	fr					As Integer
End Type

' Class
Const szClassName As String="RAPROPERTY"
