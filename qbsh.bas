_Title "QBSH - Quick Basic Shell"

GoSub WELCOME

MAIN:
Do
    Clear
    Color 14
    Print _CWD$ + " ";
    user$ = Environ$("USER")
    If user$ = "root" Then
        Color 12
        Print "root> # ";
    Else
        Color 10
        Print user$ + "> $ ";
    End If
    Color 15
    Line Input ""; cmd$
    If cmd$ = "exit" Or cmd$ = "QUIT" Then
        GoSub quit
    ElseIf cmd$ = "HELP" Then
        GoSub HELP1
    ElseIf cmd$ = "CLEAR" Then
        GoSub CLEARSCR
    ElseIf cmd$ = "ENV" Then
        GoSub ENV
    ElseIf InStr(cmd$, "PRINT ") = 1 Then
        GoSub OUT1
    ElseIf InStr(cmd$, "READFILE ") = 1 Or InStr(cmd$, "cat ") = 1 Then
        GoSub READFILE1
    Else GoSub CMDOUT
    End If
Loop

CLEARSCR:
Cls
GoSub WELCOME
Return

CMDOUT:
Shell "SHELL='qbsh'; " + cmd$ + " >/tmp/foo"
Open "/tmp/foo" For Binary As #1
x$ = Space$(LOF(1))
Get #1, , x$
Close #1
Print x$
Return

ENV:
Do
    I = I + 1
    setting$ = Environ$(I)
    If InStr(setting$, "SHELL=") = 1 Then
        Print "SHELL=qbsh"
    Else
        Print setting$
    End If
    If I Mod 20 = 0 Then
        Return
    End If
Loop Until setting$ = ""
Return

HELP1:
Print "Try One of These Commands:"
Print "CLEAR - Clear the current screen"
Print "ENV - Print Environment"
Print "PRINT - Output some text"
Print "READFILE <file> - Output some text file to terminal"
Print
Print "To exit the shell, run `exit`"
Return

OUT1:
Print Right$(cmd$, Len(cmd$) - 6)
Return

READFILE1:
If InStr(cmd$, "READFILE ") = 1 Then
    tmpfileloc$ = Right$(cmd$, Len(cmd$) - 9)
Else
    tmpfileloc$ = Right$(cmd$, Len(cmd$) - 4)
End If
Open tmpfileloc$ For Binary As #1
x$ = Space$(LOF(1))
Get #1, , x$
Close #1
Print x$
Return

quit:
Stop
End

WELCOME:
Print "WELCOME TO Quick Basic Shell, " + Environ$("USER")
Print "Type HELP to see a list of commands."
Print
Return
