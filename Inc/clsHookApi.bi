
Type clsHookApi
Private:
    m_hProcess As HANDLE
    
    m_OldCode(5) As Byte
    m_NewCode(5) As Byte
    m_OldFunAddr As UInteger
Public:
    Declare Destructor
    Declare Function Hook(sDllName As String,sFunName As String,nNewFunAddr As UInteger,hProcess As HANDLE = Null) As Boolean
    Declare Sub SetHook(ByVal bIsHook As Boolean)
End Type

Destructor clsHookApi
    SetHook(False) '�ָ�
End Destructor

Function clsHookApi.Hook(sDllName As String,sFunName As String,nNewFunAddr As UInteger,hProcess As HANDLE = Null) As Boolean
    Dim hModule As HMODULE, dwJmpAddr As ULongInt
    '���ý��̾��
    m_hProcess = hProcess
    If hProcess = Null Then
        m_hProcess = GetCurrentProcess() 
    End If    
    '��ȡģ�鼰������ַ
    hModule = LoadLibrary(sDllName)
    If hModule = 0 Then Hook = False: Exit Function
    m_OldFunAddr = Cast(UInteger,GetProcAddress(hModule,sFunName))
    If m_OldFunAddr = 0 Then Hook = False: Exit Function
                  
    memcpy @m_OldCode(0),m_OldFunAddr,5
    Dim nJmpAddr As UInteger = nNewFunAddr - m_OldFunAddr - 5  '��ת��ַ
    m_NewCode(0) = &HE9         '//ʵ����0xe9���൱��jmpָ��
    memcpy @m_NewCode(1),@nJmpAddr,4
    
    SetHook True
    Function = True
End Function
'//�رչ��ӵĺ���
Sub clsHookApi.SetHook(bIsHook As Boolean)
    Assert(m_hProcess <> Null) 
 
    Dim As DWord dwTemp = 0 
    Dim As DWord dwOldProtect 
    
    If bIsHook Then '//�޸�API�������ǰ5���ֽ�Ϊjmp xxxxxx
        VirtualProtectEx(m_hProcess,m_OldFunAddr,5,PAGE_READWRITE,@dwOldProtect)  
        WriteProcessMemory(m_hProcess,m_OldFunAddr,@m_NewCode(0),5,0) 
        VirtualProtectEx(m_hProcess,m_OldFunAddr,5,dwOldProtect,@dwTemp) 
    Else '//�ָ�API�������ǰ5���ֽ�
        VirtualProtectEx(m_hProcess,m_OldFunAddr,5,PAGE_READWRITE,@dwOldProtect)
        WriteProcessMemory(m_hProcess,m_OldFunAddr,@m_OldCode(0),5,0) 
        VirtualProtectEx(m_hProcess,m_OldFunAddr,5,dwOldProtect,@dwTemp) 
    End If
End Sub