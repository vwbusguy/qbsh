'Functions/Helpers for qbsh related to IO

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
