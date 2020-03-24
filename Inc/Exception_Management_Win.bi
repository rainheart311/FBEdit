'Exception_Management_Win.inc

'remind  the following define  must be placed before the first inclusion of that file
'#define _EXCEPTIONS_INIT_CODE_ 	' has to be placed before #include once "Exception_Management_Win.inc"
'												 and only 1 time
'																		at the first code source file of project, multi .o compiled files
'																		or main file .bas if others sources files are included


#ifndef _EXCEPTION_MANAGEMENT_WIN_INC_
#define _EXCEPTION_MANAGEMENT_WIN_INC_

#pragma once

#include once "windows.bi"
#Include once "crt/setjmp.bi"
#Include once "crt/string.bi"    'memmove usage



#define VERBOSE 			1   	' 0 not verbose , else  verbose mode


#Define TRY do : my_except_class.e_ptr = get_set_excep(1) : _
	my_except_class.e_data[my_except_class.e_pos].icod = setjmp2(my_except_class.e_data[my_except_class.e_pos].jump) : _
	If my_except_class.e_data[my_except_class.e_pos].icod = 0 Then : _
	if VERBOSE THEN print space(my_except_class.e_pos) & "in Try block , e_pos = " & my_except_class.e_pos

#Macro CATCH(e , _type)
	elseif  my_except_class.e_data[my_except_class.e_pos].got = 1 and  my_except_class.e_data[my_except_class.e_pos].icod = _type Then  		/' get_epos() = _e_pos_ and '/
		Dim As exdata_type e =  my_except_class.e_data[my_except_class.e_pos]
		if VERBOSE THEN print space(my_except_class.e_pos) & " in Catch block , e_pos = " & my_except_class.e_pos
#EndMacro

#Macro CATCH_ANY(e)
	ElseIf my_except_class.e_data[my_except_class.e_pos].got = 1 then     													/' get_epos() = _e_pos_ and  '/
		Dim As exdata_type e = my_except_class.e_data[my_except_class.e_pos]
		if VERBOSE THEN print space(my_except_class.e_pos) & " in Catch_any block , e_pos = " & my_except_class.e_pos
#EndMacro

#Define FINALLY End If:  If my_except_class.e_pos Then

#Define END_TRY  if my_except_class.e_pos then :  my_except_class.e_ptr = get_set_excep(-1) : end if : End If  : exit do : loop

#Define THROW(_type)  set_throw ( __FILE__, __FUNCTION__, __LINE__, "", _type)

#Define THROW_MSG(_type , mess)  set_throw ( __FILE__, __FUNCTION__, __LINE__, mess, _type)

#Define RETHROW   set_rethrow()


Type exdata_type
	jump   As jmp_buf Ptr
	icod   As long
	file   As String
	proc   As String
	msg    As String
	line   As long
	h1		 AS any ptr
	got    As byte
End Type


Type my_except_class
	public:
		declare constructor()
		declare destructor()

		declare sub back_except()
		declare sub decrease_except()
		declare sub increase_except()

		Static e_pos   As long
		Static e_data  As exdata_type Ptr
		Static e_ptr	As my_except_class Ptr
		Static countID As long

	private:
		e_size As long
End Type

declare function raise cdecl alias "raise"(byval signal as long) as long
declare function setjmp2 cdecl alias "_setjmp" (byval as jmp_buf ptr, byval as any ptr = 0) as long


declare function get_set_excep(byval iflag as long = 0) as my_except_class ptr
declare sub show_catch(byref e as exdata_type, byval flag as integer = 1)
declare sub set_throw( byref sfile as string, byref sproc as string, byval iline as long, byref smess as string, byval lcode as long)
declare sub set_rethrow()

#ifdef _EXCEPTIONS_INIT_CODE_

	declare function Intercept_Exceptions(byval pexp as PEXCEPTION_POINTERS) as long

	Dim As long 				my_except_class.countID = 0
	Dim As long 				my_except_class.e_pos = 0
	Dim As exdata_type Ptr 		my_except_class.e_data = 0
	Dim As my_except_class Ptr  my_except_class.e_ptr = 0

	Private Constructor my_except_class()
		if my_except_class.countID = 0 then
			e_size = 4     'initial level setting normally not needed more , but reallocation is installed
			my_except_class.e_data = callocate (sizeof(exdata_type) * e_size)
			my_except_class.e_data[0].jump = 0
			my_except_class.e_data[0].h1 = AddVectoredExceptionHandler(0 , @Intercept_Exceptions)
			my_except_class.e_data[0].file = ""
			my_except_class.e_data[0].proc = ""
			my_except_class.e_data[0].msg = ""
			my_except_class.e_data[0].line = 0
			my_except_class.e_data[0].icod = 0
			my_except_class.e_data[0].got = 0
			my_except_class.countID = 1
			my_except_class.e_pos = 0
		end if
	End Constructor

	Private Destructor my_except_class()
		if my_except_class.e_data <> 0 and my_except_class.countID = 1 then
			while my_except_class.e_pos >= 0
				if my_except_class.e_data[my_except_class.e_pos].jump THEN delete my_except_class.e_data[my_except_class.e_pos].jump
				if my_except_class.e_data[my_except_class.e_pos].h1 then RemoveVectoredExceptionHandler(my_except_class.e_data[my_except_class.e_pos].h1)
				my_except_class.e_pos -= 1
			wend
			e_size = 0
			deallocate(my_except_class.e_data)
		end if
		my_except_class.countID = 0
		my_except_class.e_data = 0
		my_except_class.e_pos = 0
	End Destructor


	Private sub my_except_class.back_except()
		if my_except_class.e_pos < 2 then exit sub
		if my_except_class.e_data[my_except_class.e_pos].jump THEN delete my_except_class.e_data[my_except_class.e_pos].jump
		if my_except_class.e_data[my_except_class.e_pos].h1 then RemoveVectoredExceptionHandler(my_except_class.e_data[my_except_class.e_pos].h1)
		my_except_class.e_data[my_except_class.e_pos].jump = 0
		my_except_class.e_data[my_except_class.e_pos].h1 = 0
		my_except_class.e_data[my_except_class.e_pos - 1].icod = my_except_class.e_data[my_except_class.e_pos].icod
		my_except_class.e_data[my_except_class.e_pos].icod = 0
		my_except_class.e_data[my_except_class.e_pos - 1].got = my_except_class.e_data[my_except_class.e_pos].got
		my_except_class.e_data[my_except_class.e_pos].got = 0
		my_except_class.e_data[my_except_class.e_pos - 1].file = my_except_class.e_data[my_except_class.e_pos].file
		my_except_class.e_data[my_except_class.e_pos].file = ""
		my_except_class.e_data[my_except_class.e_pos - 1].proc = my_except_class.e_data[my_except_class.e_pos].proc
		my_except_class.e_data[my_except_class.e_pos].proc = ""
		my_except_class.e_data[my_except_class.e_pos - 1].msg = my_except_class.e_data[my_except_class.e_pos].msg
		my_except_class.e_data[my_except_class.e_pos].msg = ""
		my_except_class.e_data[my_except_class.e_pos - 1].line = my_except_class.e_data[my_except_class.e_pos].line
		my_except_class.e_data[my_except_class.e_pos].line = 0
		my_except_class.e_pos -= 1
	end sub

	Private sub my_except_class.decrease_except()
		if my_except_class.e_pos < 1 then exit sub
		if my_except_class.e_data[my_except_class.e_pos].jump THEN delete my_except_class.e_data[my_except_class.e_pos].jump
		if my_except_class.e_data[my_except_class.e_pos].h1 then RemoveVectoredExceptionHandler(my_except_class.e_data[my_except_class.e_pos].h1)
		my_except_class.e_data[my_except_class.e_pos].jump = 0
		my_except_class.e_data[my_except_class.e_pos].h1 = 0
		my_except_class.e_data[my_except_class.e_pos].icod = 0
		my_except_class.e_data[my_except_class.e_pos].got = 0
		my_except_class.e_data[my_except_class.e_pos].file = ""
		my_except_class.e_data[my_except_class.e_pos].proc = ""
		my_except_class.e_data[my_except_class.e_pos].msg = ""
		my_except_class.e_data[my_except_class.e_pos].line = 0
		my_except_class.e_pos-= 1
	end sub

	Private sub my_except_class.increase_except()
		if my_except_class.e_pos + 1 = e_size  THEN
			dim as exdata_type Ptr ptemp2 = callocate(sizeof(exdata_type) * e_size * 2)
			if ptemp2 = 0 THEN
				messagebox 0, "Close to abort !", "error .... reallocating", MB_ICONERROR
				raise(4)
			else
				memmove(ptemp2, my_except_class.e_data, sizeof(exdata_type) * e_size)
         END IF
			my_except_class.e_data = ptemp2
			e_size *= 2
			if VERBOSE then print "reallocating... done"
		END IF
		my_except_class.e_pos += 1
		my_except_class.e_data[my_except_class.e_pos].jump = new jmp_buf
		my_except_class.e_data[my_except_class.e_pos].h1 = AddVectoredExceptionHandler(my_except_class.e_pos , @Intercept_Exceptions)
		my_except_class.e_data[my_except_class.e_pos].icod = 0
		my_except_class.e_data[my_except_class.e_pos].got = 0
		my_except_class.e_data[my_except_class.e_pos].file = ""
		my_except_class.e_data[my_except_class.e_pos].proc = ""
		my_except_class.e_data[my_except_class.e_pos].msg = ""
		my_except_class.e_data[my_except_class.e_pos].line = 0
	end sub



	Private function get_set_excep(byval iflag as long = 0) as my_except_class ptr
		if iflag = 0  and my_except_class.e_ptr = 0 THEN
			'print "init0 here "
			my_except_class.e_ptr = new my_except_class
		elseif iflag < 0 and my_except_class.e_ptr <> 0 then
			'print "decrease here "
			my_except_class.e_ptr->decrease_except()
		elseif iflag > 0 and my_except_class.e_ptr <> 0 then
			'print "increase here "
			my_except_class.e_ptr->increase_except()
		elseif iflag > 0 and my_except_class.e_ptr = 0 then
			'print "init1 here "
			my_except_class.e_ptr = new my_except_class
			my_except_class.e_ptr->increase_except()
		END IF
		return my_except_class.e_ptr
	end function



	Private sub set_throw( byref sfile as string, byref sproc as string, byval iline as long, byref smess as string, byval lcode as long)
		dim as long _e_pos_ = my_except_class.e_pos
		dim as exdata_type Ptr _exdata_type_ptr_ = my_except_class.e_data

		_exdata_type_ptr_[_e_pos_].file = sfile
		_exdata_type_ptr_[_e_pos_].proc = sproc
		_exdata_type_ptr_[_e_pos_].line = iline
		_exdata_type_ptr_[_e_pos_].msg = smess
		_exdata_type_ptr_[_e_pos_].icod = lcode
		_exdata_type_ptr_[_e_pos_].got = 1
		if _e_pos_ > 0 THEN
			longjmp(_exdata_type_ptr_[_e_pos_].jump, lcode)
		else
			show_catch(_exdata_type_ptr_[0], 0)
		end if
	end sub

	Private sub set_rethrow()
		dim as my_except_class ptr  _except_ptr_ = my_except_class.e_ptr
		dim as long _e_pos_ = my_except_class.e_pos
		dim as exdata_type Ptr _exdata_type_ptr_ = my_except_class.e_data

		if _e_pos_ > 1 and _exdata_type_ptr_[_e_pos_].got = 1 THEN
			_except_ptr_->back_except()
			_e_pos_ -= 1
			longjmp(_exdata_type_ptr_[_e_pos_].jump, _exdata_type_ptr_[_e_pos_].icod)
		end if
	end sub


	Private sub show_catch(byref e as exdata_type, byval flag as integer = 1)
		dim as string status
		dim as long e_pos = my_except_class.e_pos
		if flag THEN
			if VERBOSE THEN Print space(e_pos) & "  e_exceptions message : " ; e.msg
			status = "e_exceptions message : " & e.msg
		else
			if VERBOSE THEN Print space(e_pos) & "  error exceptions : Throw outside Try-Catch bloc   "  & e.msg
			status =  "error exceptions : Throw outside Try-Catch bloc"  & chr(10,10) & "e_exceptions message : " & e.msg
		END IF
		if VERBOSE THEN Print space(e_pos) & "   e_exception code = " ; Str(e.icod)
		status &= chr(10,10) & "   e_exception code = " & Str(e.icod)
		if VERBOSE THEN Print space(e_pos) & "   file = " ; e.file
		status &= chr(10) & "   file = " & e.file
		if VERBOSE THEN Print space(e_pos) & "   proc = " ; e.proc
		status &= chr(10) & "   proc = " & e.proc
		if VERBOSE THEN Print space(e_pos) & "   line = " ; Str(e.line)
		status &= chr(10) & "   line = " & Str(e.line)
		if flag THEN
			messagebox 0, status, "Catched Exception ", MB_ICONWARNING
		else
			messagebox 0, status, "Catched Exception  wihout Try_Catch", MB_ICONWARNING
		end if
	end sub


	Private function Intercept_Exceptions(byval pexp as PEXCEPTION_POINTERS) as long
		dim as PEXCEPTION_RECORD pexr = pexp -> ExceptionRecord
		dim as PCONTEXT pctxr = pexp -> ContextRecord
		dim as long iflag
		dim as string status
		if VERBOSE THEN print "Exception code : &h" ; hex(pexr -> ExceptionCode)

		select case(pexr -> ExceptionCode)
			case EXCEPTION_ACCESS_VIOLATION
			  status = "Error: EXCEPTION_ACCESS_VIOLATION"
			case EXCEPTION_ARRAY_BOUNDS_EXCEEDED
				status = "Error: EXCEPTION_ARRAY_BOUNDS_EXCEEDED"
			case EXCEPTION_BREAKPOINT
				status = "EXCEPTION_BREAKPOINT"
				iflag = -1
			case EXCEPTION_DATATYPE_MISALIGNMENT
			  status = "Error: EXCEPTION_DATATYPE_MISALIGNMENT"
			case EXCEPTION_ILLEGAL_INSTRUCTION
			  status = "Error: EXCEPTION_ILLEGAL_INSTRUCTION"
			case EXCEPTION_IN_PAGE_ERROR
				status = "Error: EXCEPTION_IN_PAGE_ERROR"
			case EXCEPTION_INT_DIVIDE_BY_ZERO
				status = "Error: EXCEPTION_INT_DIVIDE_BY_ZERO"
			case EXCEPTION_INT_OVERFLOW
				status = "Error: EXCEPTION_INT_OVERFLOW"
			case EXCEPTION_INVALID_DISPOSITION
				status = "Error: EXCEPTION_INVALID_DISPOSITION"
			case EXCEPTION_NONCONTINUABLE_EXCEPTION
				status = "Error: EXCEPTION_NONCONTINUABLE_EXCEPTION"
			case EXCEPTION_PRIV_INSTRUCTION
				status = "Error: EXCEPTION_PRIV_INSTRUCTION"
			case EXCEPTION_SINGLE_STEP
				status = "Error: EXCEPTION_SINGLE_STEP"
			case EXCEPTION_STACK_OVERFLOW
				status = "Error: EXCEPTION_STACK_OVERFLOW"
			case else
				status = "Error: UNDEFINED"
		end select

		if iflag = 0 then
			if VERBOSE THEN
				Dim RetVal As long
				RetVal = MessageBox(0,  chr(10) & "   Warning ..." & chr(10,10)  _
							& "          Ok to Abort now !" & chr(10,10) & "          Cancel to try to continue", _
							status, MB_ICONERROR OR MB_OKCANCEL Or MB_APPLMODAL Or MB_TOPMOST)
				IF RetVal = IDOK THEN
					raise(4) 'signal abort
				else
					iflag = -1
				end if
			else
				messagebox 0, "Close to abort !", status, MB_ICONERROR
				raise(4) 'signal abort
			end if
		end if

		if VERBOSE THEN print "Exception address : &h" ;
		''--------------------------------------------------------------------
		'' Increment the instruction pointer in the context record past the
		'' 1-byte breakpoint instruction to avoid having the exception recur.
		''--------------------------------------------------------------------
		#ifndef __FB_64BIT__
			if VERBOSE THEN print hex(pctxr -> Eip)
			pctxr -> Eip += 1
		#else
			if VERBOSE THEN print hex(pctxr -> Rip)
			pctxr -> Rip += 1
		#endif
		'return EXCEPTION_CONTINUE_EXECUTION '-1
		'return EXCEPTION_CONTINUE_SEARCH '0
		if iflag = -1  THEN  THROW_MSG( - 1, status)
		return - 1
	end function


#undef _EXCEPTIONS_INIT_CODE_
	if my_except_class.countID = 0 THEN
		if VERBOSE then print "initialisation "
		my_except_class.e_ptr = get_set_excep()
		my_except_class.countID = 1
	end if
#endif

#endif  /' _EXCEPTION_MANAGEMENT_WIN_  '/
'**********************************************************************************************
'End of the commun part to put into an include header
'********************************************************************************************** 