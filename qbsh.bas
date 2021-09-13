_Title "QBSH - Quick Basic Shell"
_ConsoleTitle "QBSH - Quick Basic Shell"
$Console:Only
_Dest _Console
_Source _Console
Screen 0

GoSub INIT
GoSub WELCOME

MAIN:
Do
    On Error GoTo GENERALERROR
    GoSub PROMPT
    Line Input ""; cmd$
    cmd$ = _Trim$(cmd$)
    If InStr(cmd$, " ") = 0 Then
        refcmd$ = cmd$
        args$ = ""
    Else
        refcmd$ = Left$(cmd$, InStr(cmd$, " ") - 1)
        args$ = Right$(cmd$, Len(cmd$) - InStr(cmd$, " "))
    End If
    Select Case UCase$(refcmd$)
        Case "EXIT", "QUIT": GoSub quit
        Case "HELP": GoSub HELP1
        Case "CD": GoSub CDIR
        Case "DEL", "DELETE", "RM": GoSub DEL
        Case "CALC": GoSub CALC
        Case "CHRISTMAS": GoSub CHRISTMAS
        Case "CLEAR", "CLS": GoSub CLEARSCR
        Case "DATE": Print Date$
        Case "ENV": GoSub ENV
        Case "MAKEDIR": GoSub MAKEDIR
        Case "PRINT": GoSub OUT1
        Case "PLAY": GoSub PLAYSOUND
        Case "RAND": GoSub RANDNUM
        Case "RMDIR": GoSub REMDIR
        Case "TIME": Print Time$
        Case "USER", "WHO": Print Environ$("USER")
        Case "READFILE", "CAT": GoSub READFILE1
        Case Else: GoSub CMDOUT
    End Select
Loop
System

'Add, Subtract, Multiply, and Divide
CALC:
baseval$ = args$
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
If oper$ <> "+" And oper$ <> "-" And oper$ <> "*" And oper$ <> "x" And oper$ <> "/" And oper$ <> "%" Then
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
    Case "%"
        If v2# >= -0.5 And v2# <= 0.5 Then
            Print "Divide By Zero?  Are you insane?!?"
        Else
            Print v1# Mod v2#
        End If
End Select
Return

'Change working directory
CDIR:
If _DirExists(args$) Then
    On Error GoTo CDIRERR
    ChDir args$
Else
    Print "CD <DIRECTORY>"
End If
Return

CDIRERR:
Print "Couldn't change directory to "; args$; ".  It's likely that user doesn't have permissions."
Beep
Resume Next
Return

'Is it Easter or Christmas?
CHRISTMAS:
Play "t140o2p4g2e4.f8g4o3c2o2b8o3c8d4c4o2b4a8g2.o2b8o3c8d4c4o2b4a8a8g8o3c4o2e8e4g8a8g4f4e4f4g2.g2e4.f8g4o3c2o2b8o3c8d4c4o2b4a8g2.o2b8o3c8d4c4o2b4a8a8g8o3c4o2e8e4g8a8g4f4e4d4c2.c4a4a4o3c4c4o2b4a4g4e4f4a4g4f4e2.e8e8d4d4g4g4b4b4o3d4d8o2b8o3d4c4o2b4a4g4p4g2g2e4.f8g4o3c2o2b8o3c8d4c4o2b4a8g8g2.o2b8o3c8d4c4o2b4a8a8g8o3c4o2e8e4g8a8g4f4e4d4c2.p4t180g8g8g4g4g4a8g8g4g4g4a4g4e4g4d1t180g8g8g4g4g4a8g8g4g4g4g8g8g4a4b4o3c2c4p1"
Return

'Clear the screen and display welcome text
CLEARSCR:
Cls
GoSub WELCOME
Return

'Offload unhandled call to legacy system shell.  qbsh is the only shell of the future.
CMDOUT:
rndbuf = Rnd * 999999
buff_file$ = "/tmp/buff_qbsh_" + LTrim$(Str$(rndbuf))
If _FileExists(buff_file$) Then
    Kill buff_file$
End If
Shell "SHELL='" + SELFPATH$ + "'; " + cmd$ + " 2>&1 >" + buff_file$
Open buff_file$ For Binary As #1
x$ = Space$(LOF(1))
Get #1, , x$
Close #1
Print x$
Kill buff_file$
Return

'Delete a file path
DEL:
pathspec$ = args$
If _FileExists(pathspec$) Then
    On Error GoTo DELERR
    Kill pathspec$
ElseIf _DirExists(pathspec$) Then
    Print "Path is a directory.  Empty it and then use RMDIR instead."
Else
    Print "File not found."
End If
Return

DELERR:
Print "Could not delete "; args$; ".  It's likely that this user lacks permissions."
Beep
Resume Next
Return

'Take a look around at your environment.  And then print that.
ENV:
If args$ = "" Then
    I = 0
    Do
        I = I + 1
        setting$ = Environ$(I)
        If InStr(setting$, "SHELL=") = 1 Then
            Print "SHELL="; SELFPATH$
        Else
            Print setting$
        End If
    Loop Until setting$ = ""
ElseIf args$ = "SHELL" Then
    Print SELFPATH$
Else
    Print Environ$(args$)
End If
Return

GENERALERROR:
Print "Something went terribly wrong.  Here's all we know:"
Print "Error"; Err; "on program file line"; _ErrorLine
Beep
Resume MAIN
Return

'Tell users some of what we can do
HELP1:
Print "Try One of These Commands:"
Print "CALC - Add, Subtract, Multiply, and Divide"
Print "CLEAR - Clear the current screen"
Print "DATE - Today's Date"
Print "DELETE - Delete a file"
Print "ENV <Optional Key> - Print Environment"
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

INIT:
'Get current path and change to proper place
SELFPATH$ = Environ$("_")
If SELFPATH$ = "" Or InStr(SELFPATH$, ".") = 1 Then
    If InStr(Command$(0), ".") = 1 Then
        SELFPATH$ = _CWD$ + "/" + Right$(Command$(0), Len(Command$(0)) - 2)
    Else
        SELFPATH$ = _CWD$ + "/" + Command$(0)
    End If
End If
ChDir (_StartDir$)
Return

'Make a new directory
MAKEDIR:
If args$ <> "" Then
    On Error GoTo MAKEDIRERR
    MkDir args$
Else
    Print "MAKEDIR <New Directory Path>"
End If
Return

MAKEDIRERR:
Print "Unable to make "; args$; ".  Likely user doesn't have perms or parent path doesn't exist."
Beep
Resume Next
Return

'Is there an echo in here?
OUT1:
Print args$
Return

'Make tunes and rock out
PLAYSOUND:
If args$ <> "" Then
    On Error GoTo PLAYSOUNDERR
    Play args$
Else
    Print "PLAY <NOTES>"
End If
Return

PLAYSOUNDERR:
Print "Could not parse the notes to play."
Beep
Resume Next
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
If args$ <> "" Then
    randlimit = Int(Val(args$))
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
tmpfileloc$ = args$
If Not _FileExists(tmpfileloc$) Then
    Print "File not found."
    Return
End If
On Error GoTo READFILEERR
Open tmpfileloc$ For Binary As #1
x$ = Space$(LOF(1))
Get #1, , x$
Close #1
Print x$
Return

READFILEERR:
Print "Could not read "; args$; ".  Likely user lacks permissions."
Resume MAIN
Return

'Remove directory
REMDIR:
path$ = args$
If path$ <> "" And _DirExists(path$) Then
    On Error GoTo REMDIRERR
    RmDir path$
Else
    Print "RMDIR must be called against an empty directory"
End If
Return

REMDIRERR:
Print "Couldn't remove "; args$; ".  Likely the directory is not empty or user lacks permissions."
Beep
Resume Next
Return

'Give a way to clo(se this because this isn't vim
quit:
System

'A friendly greeting
WELCOME:
Color 15
Print "WELCOME TO Quick Basic Shell, " + Environ$("USER")
Print "Type HELP to see a list of commands."
Print
Return
