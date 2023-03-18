'Functions/Helpers for qbsh related to IO

'listDir$ - Returns tab delimited file list of directory specified
'	spec$ - Directory spec.  Pass "" to get current directory
FUNCTION listDir$ (spec$)
	rndbuf = Rnd * 999999
	buff_file$ = "/tmp/buff_qbsh_" + LTrim$(Str$(rndbuf))
	If _FileExists(buff_file$) Then
	    Kill buff_file$
	End If
	Shell "SHELL='" + SELFPATH$ + "'; dir -a " + spec$ + " 2>&1 >" + buff_file$
	Open buff_file$ For Binary As #1
	x$ = Space$(LOF(1))
	Get #1, , x$
	Close #1
	Kill buff_file$
	listDir$ = x$
END FUNCTION

'listXDir$ - Give more detailed listing output than listDir$
'	spec$ - Directory spec.  Pass "" to get current directory
FUNCTION listXDir$ (spec$)
	spec$ = "-l " +  spec$
	listXDir$ = listDir$(spec$)
END FUNCTION

'resolvePath$ - Expands ~ prefix to $HOME.  Useful before doing filesystem operations
'  RPATH$ - File-system path string
FUNCTION resolvePath$(RPATH$)
    If RPATH$ = "~" Then
        RPATH$ = Environ$("HOME") + "/"
    End If
    If InStr(RPATH$, "~") = 1 And InStr(RPATH$, "/") = 2 Then
        RPATH$ = Environ$("HOME") + "/" + Right$(RPATH$, Len(RPATH$) - 2)
    End If
    resolvePath = RPATH$
END FUNCTION
