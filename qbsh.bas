_Title "QBSH - Quick Basic Shell"
_ConsoleTitle "QBSH - Quick Basic Shell"
$Console:Only
_Dest _Console
_Source CONSOLE


GoSub WELCOME

MAIN:
Do
    Clear
    GoSub PROMPT
    Line Input ""; cmd$
    If cmd$ = "exit" Or cmd$ = "QUIT" Then
        GoSub quit
    ElseIf cmd$ = "HELP" Or cmd$ = "help" Then
        GoSub HELP1
    ElseIf InStr(cmd$, "cd ") = 1 Or InStr(cmd$, "CD ") = 1 Then
        GoSub CDIR
    ElseIf InStr(cmd$, "CALC ") = 1 Then
        GoSub CALC
    ElseIf cmd$ = "CLEAR" Then
        GoSub CLEARSCR
    ElseIf cmd$ = "DATE" Then
        Print Date$
    ElseIf cmd$ = "ENV" Then
        GoSub ENV
    ElseIf InStr(cmd$, "MAKEDIR") = 1 Then
        GoSub MAKEDIR
    ElseIf InStr(cmd$, "PRINT ") = 1 Then
        GoSub OUT1
    ElseIf InStr(cmd$, "PLAY ") = 1 Then
        Play Right$(cmd$, Len(cmd$) - 5)
    ElseIf InStr(cmd$, "RAND") = 1 Then
        GoSub RANDNUM
    ElseIf InStr(cmd$, "RMDIR") = 1 Then
        GoSub REMDIR
    ElseIf cmd$ = "TIME" Then
        Print Time$
    ElseIf cmd$ = "USER" Or InStr(cmd$, "WHO ") = 1 Then
        Print Environ$("USER")
    ElseIf InStr(cmd$, "READFILE ") = 1 Or InStr(cmd$, "cat ") = 1 Then
        GoSub READFILE1
    Else GoSub CMDOUT
    End If
Loop

'Add, Subtract, Multiply, and Divide
CALC:
baseval$ = Right$(cmd$, Len(cmd$) - 5)
If InStr(baseval$, " ") < 2 Then
    Print "Improper CALC Syntax.  Ex: 1 + 2"
    Return
End If
v1# = Val(Left$(baseval$, InStr(baseval$, " ")))
baseval2$ = Right$(baseval$, Len(baseval$) - InStr(baseval$, " "))
If InStr(baseval2$, " ") < 2 Then
    Print "Improper CALC Syntax.  Ex: 1 + 2"
    Return
End If
oper$ = Left$(baseval2$, 1)
If oper$ <> "+" And oper$ <> "-" And oper$ <> "*" And oper$ <> "x" And oper$ <> "/" Then
    Print "Improper CALC Syntax.  Ex: 1 + 2"
    Return
End If
v2# = Val(Right$(baseval2$, Len(baseval2$) - 2))
Select Case oper$
    Case "+"
        Print v1# + v2#
    Case "-"
        Print v1# - v2#
    Case "*", "x"
        Print v1# * v2#
    Case "/"
        If v2# <> 0 Then
            Print v1# / v2#
        Else
            Print "Divide By Zero?  Are you insane?!?"
        End If
End Select
Return

'Change working directory
CDIR:
ChDir Right$(cmd$, Len(cmd$) - 3)
Return

'Clear the screen and display welcome text
CLEARSCR:
Cls
GoSub WELCOME
Return

'Offload unhandled call to legacy system shell.  qbsh is the only shell of the future.
CMDOUT:
Shell "SHELL='qbsh'; " + cmd$ + " >/tmp/foo"
Open "/tmp/foo" For Binary As #1
x$ = Space$(LOF(1))
Get #1, , x$
Close #1
Print x$
Return

'Take a look around at your environment.  And then print that.
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

'Tell users some of what we can do
HELP1:
Print "Try One of These Commands:"
Print "CALC - Add, Subtract, Multiply, and Divide"
Print "CLEAR - Clear the current screen"
Print "DATE - Today's Date"
Print "ENV - Print Environment"
Print "MAKEDIR <directory> - Make a new directory"
Print "PLAY <Notes> - Play sounds and rock out!"
Print "PRINT - Output some text"
Print "RAND <Optional Limit> - Random number generator"
Print "READFILE <file> - Output some text file to terminal"
Print "RMDIR <Directory> - Delete a directory"
Print "TIME - Current time"
Print "WHO AM I - Sometimes we all forget, right?"
Print
Print "To exit the shell, run `exit`"
Return

'Make a new directory
MAKEDIR:
MkDir Right$(cmd$, Len(cmd$) - 8)
Return

'Is there an echo in here?
OUT1:
Print Right$(cmd$, Len(cmd$) - 6)
Return

'So user knows where they are and who they are
PROMPT:
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
Return

'Return a Random Number
RANDNUM:
If Len(cmd$) > 5 Then
    randlimit = Int(Val(Right$(cmd$, Len(cmd$) - 5)))
Else
    randlimit = 10
End If
If randlimit < 0 Then
    randlimit = randlimit * -1
    posnegmod = Int(-1)
Else
    posnegmod = 1
End If
Print Int(Rnd * (randlimit + 1) * posnegmod)
Return

'This sub reads a file.
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

'Remove directory
REMDIR:
RmDir Right$(cmd$, Len(cmd$) - 6)
Return

'Give a way to close this because this isn't vim
quit:
Stop
End

'A friendly greeting
WELCOME:
Print "WELCOME TO Quick Basic Shell, " + Environ$("USER")
Print "Type HELP to see a list of commands."
Print
Return
