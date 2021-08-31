_Title "QBSH - Quick Basic Shell"

WELCOME:
Print "WELCOME TO Quick Basic Shell, " + Environ$("USER")
Print "Type HELP to see a list of commands."
Print
GoTo lbl1
End

lbl1:
Clear
Input "$ ", cmd$
If cmd$ = "exit" GoTo quit
If cmd$ = "HELP" GoTo HELP1
If cmd$ = "CLEAR" GoTo CLEARSCR
If cmd$ = "ENV" GoTo ENV
If InStr(cmd$, "PRINT ") = 1 GoTo OUT1
If InStr(cmd$, "READFILE ") = 1 GoTo READFILE1
Shell "SHELL='qbsh'; " + cmd$ + " >/tmp/foo"
Open "/tmp/foo" For Binary As #1
x$ = Space$(LOF(1))
Get #1, , x$
Close #1
Print x$
GoTo lbl1
End

CLEARSCR:
Cls
GoTo WELCOME
End

ENV:
Do
    i = i + 1
    setting$ = Environ$(i) ' get a setting from the list
    If InStr(setting$, "SHELL=") = 1 Then
        Print "SHELL=qbsh"
    Else
        Print setting$
    End If
    If i Mod 20 = 0 GoTo lbl1
Loop Until setting$ = ""
End

HELP1:
Print "Try One of These Commands:"
Print "CLEAR - Clear the current screen"
Print "ENV - Print Environment"
Print "PRINT - Output some text"
Print "READFILE <file> - Output some text file to terminal"
Print
Print "To exit the shell, run `exit`"
GoTo lbl1
End

OUT1:
Print Right$(cmd$, Len(cmd$) - 6)
GoTo lbl1
End

READFILE1:
Open Right$(cmd$, Len(cmd$) - 9) For Binary As #1
x$ = Space$(LOF(1))
Get #1, , x$
Close #1
Print x$
GoTo lbl1
End

quit:
Stop
End

