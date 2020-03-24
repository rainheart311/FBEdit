Console
Creates an console project with main.
[*BEGINPRO*]
[*BEGINDEF*]
[Project]
Version=2
Api=fb (FreeBASIC),win (Windows)
[Make]
Module=Module Build,fbc -c
Recompile=0
Current=1
1=Windows Console,fbc -s console
Output=
Run=
[*ENDDEF*]
[*BEGINTXT*]
[*PRONAME*].bas
Function Main(ByVal argc As Integer,ByVal argv As ZString Ptr Ptr) As Integer      
    print "param";argc,**argv
    print "end"   
    Sleep     
	Return True    
End Function
End Main(__FB_ARGC__,__FB_ARGV__)  
[*ENDTXT*]
[*ENDPRO*]
