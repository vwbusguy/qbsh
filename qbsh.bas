_Title "QBSH - Quick Basic Shell"
_ConsoleTitle "QBSH - Quick Basic Shell"
$Console:Only
_Dest _Console
_Source _Console
Screen 0

GoSub INIT

MAIN:
script_mode = False
If _Trim$(Command$) = "" Then
    GoSub WELCOME
    Do
        On Error GoTo GENERALERROR
        GoSub PROMPT
        Line Input ""; cmd$
        GoSub ROUTECMD
    Loop
ElseIf InStr(_Trim$(Command$), "-x") = 1 Then
    cmd$ = Right$(_Trim$(Command$), Len(_Trim$(Command$)) - 2)
    GoSub ROUTECMD
ElseIf _FileExists(_Trim$(Command$)) Then
    script_mode = True
    Open _Trim$(Command$) For Input As #5
    Do Until EOF(5)
        Line Input #5, cmd$ 'read entire text file line
        GoSub ROUTECMD
    Loop
    Close #5
Else
    Print "QBSH - Quick BASIC Shell"
    Print
    Print "Run without args to run qbsh interactively."
    Print "Pass a script file as an argument to run a script."
    Print "Run a single command with -x."
    Print
    GoSub HELP
End If
System

'Very important 8Ball function
EIGHTBALL:
Dim BALLREPLY$(1 To 20)
BALLREPLY$(1) = "It is certain."
BALLREPLY$(2) = "It is decidedly so."
BALLREPLY$(3) = "Without a doubt."
BALLREPLY$(4) = "Yes definitely."
BALLREPLY$(5) = "Very doubtful."
BALLREPLY$(6) = "You may rely on it."
BALLREPLY$(7) = "As I see it, yes."
BALLREPLY$(8) = "Most likely."
BALLREPLY$(9) = "Outlook good."
BALLREPLY$(10) = "Yes."
BALLREPLY$(11) = "Signs point to yes."
BALLREPLY$(12) = "Reply hazy, try again."
BALLREPLY$(13) = "Ask again later."
BALLREPLY$(14) = "Better not tell you now."
BALLREPLY$(15) = "Cannot predict now."
BALLREPLY$(16) = "Concentrate and ask again."
BALLREPLY$(17) = "Don't count on it."
BALLREPLY$(18) = "My reply is no."
BALLREPLY$(19) = "My sources say no."
BALLREPLY$(20) = "Outlook not so good."
BALLREPLYSEL% = Int(Rnd * 20) + 1
Print BALLREPLY$(BALLREPLYSEL%)
Return

'Add, Subtract, Multiply, and Divide
CALC:
baseval$ = args$
If InStr(baseval$, " ") < 2 Then
    Print "Improper CALC Syntax.  Ex: 1 + 2"
    Return
End If
v1# = Val(Left$(baseval$, InStr(baseval$, " ")))
baseval2$ = Right$(baseval$, Len(baseval$) - InStr(baseval$, " "))
If InStr(baseval2$, " ") < 2 And InStr(baseval2$, "r") <> 1 Then
    Print "Improper CALC Syntax.  Ex: 1 + 2"
    Return
End If
oper$ = Left$(baseval2$, 1)
If oper$ <> "+" And oper$ <> "-" And oper$ <> "*" And oper$ <> "x" And oper$ <> "/" And oper$ <> "%" And oper$ <> "^" And oper$ <> "r" Then
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
    Case "^"
        Print v1# ^ v2#
    Case "r"
        Print Sqr(v1#)
End Select
Return

'Change working directory
CDIR:
dir$ = resolvePath$(args$)
If _DirExists(dir$) Then
    On Error GoTo CDIRERR
    ChDir dir$
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
Sleep 65
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
pathspec$ = resolvePath$(args$)
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

'General Error handler so xmessage doesn't get triggered
GENERALERROR:
Print "Something went terribly wrong.  Here's all we know:"
Print "Error"; Err; "on program file line"; _ErrorLine
Beep
Resume MAIN
Return

'Tell users some of what we can do
HELP:
Print "Try One of These Commands:"
Print "8BALL - Answers to life's deepest questions."
Print "CALC - Add, Subtract, Multiply, and Divide"
Print "CHDIR - Change working directory.  (Or CD)"
Print "CLEAR - Clear the current screen"
Print "DATE - Today's Date"
Print "DELETE - Delete a file"
Print "DEVICES - Display info about attached input devices"
Print "ENV <Optional Key> - Print Environment"
Print "MAKEDIR <directory> - Make a new directory"
Print "OS - Display the Operating System type"
Print "PIP <DEST>=<SRC> - Copy a file to a new path, CP/M style."
Print "PLAY <Notes> - Play sounds and rock out!"
Print "PRINT - Output some text"
Print "RAND <Optional Limit> - Random number generator"
Print "RENAME <File/Dir> <New Name> - Rename a file or directory"
Print "READFILE <file> - Output some text file to terminal"
Print "RMDIR <Directory> - Delete a directory"
Print "TIME - Current time"
Print "WHO AM I - Sometimes we all forget, right?"
Print
Print "To exit the interactive shell, run `QUIT`"
Return

'Get current path and change to proper place
INIT:
Randomize Timer
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

'List current input devices
LSDEV:
For I = 1 To _Devices
    Print _Device$(I)
    Print "Buttons:"; _LastButton(I); "Axis:"; _LastAxis(I); "Wheels:"; _LastWheel(I)
Next
Return

'Make a new directory
MAKEDIR:
dir$ = resolvePath$(args$)
If dir$ <> "" Then
    On Error GoTo MAKEDIRERR
    MkDir dir$
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
OUTCMD:
Print args$
Return

PIP:
If args$ = "" Or InStr(args$, "=") < 2 Then
    Print "PIP <DEST>=<SRC>"
    Return
End If
dest$ = resolvePath$(Left$(args$, InStr(args$, "=") - 1))
src$ = resolvePath$(Right$(args$, Len(args$) - InStr(args$, "=")))
If Not _FileExists(src$) Then
    If _DirExists(src$) Then
        Print src$; " is a directory.  Only regular files are supported for the source."
    Else
        Print src$; " does not exist or isn't readable."
    End If
    Return
End If
If Not script_mode And _FileExists(dest$) Then
    Print dest$; " exists."
    Input "Overwrite? (Y/N) ", confirm$
    If UCase$(confirm$) <> "YES" And UCase$(confirm$) <> "Y" Then
        Return
    End If
End If
If _DirExists(dest$) Then
    srcfile$ = src$
    If InStr(_OS$, "WINDOWS") > 0 Then
        dirchar$ = "\"
    Else
        dirchar$ = "/"
    End If
    While InStr(srcfile$, dirchar$) > 0:
        srcfile$ = Right$(srcfile$, Len(srcfile$) - InStr(srcfile$, dirchar$))
    Wend
    dest$ = dest$ + dirchar$ + srcfile$
End If
On Error GoTo PIPERR
Open src$ For Binary As #1
Open dest$ For Binary As #2
ffbc$ = Space$(LOF(1))
Get #1, , ffbc$
Put #2, , ffbc$
Close #1
Close #2
Return

PIPERR:
Print "Failed to copy "; src$; " to "; dest$; ".  Likely user lacks permissions or target path doesn't exist."
Beep
Resume MAIN
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
READFILE:
tmpfileloc$ = resolvePath$(args$)
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
path$ = resolvePath$(args$)
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

'Rename/Move a file or folder
RENAME:
If args$ = "" Then
    Print "RENAME <FILE/DIR> <NEW NAME>"
    Return
End If
If InStr(UCase$(args$), " AS ") = 0 Then
    sourcepath$ = _Trim$(Left$(args$, InStr(args$, " ")))
    targetpath$ = _Trim$(Right$(args$, Len(args$) - Len(sourcepath$)))
Else
    sourcepath$ = _Trim$(Left$(args$, InStr(UCase$(args$), " AS ")))
    targetpath$ = _Trim$(Right$(args$, Len(args$) - (InStr(UCase$(args$), " AS ") + 3)))
End If
sourcepath$ = resolvePath$(sourcepath$)
targetpath$ = resolvePath$(targetpath$)
If InStr(UCase$(args$), " AS ") = 0 And InStr(targetpath$, " ") > 0 Then
    Print "Syntax for paths with spaces: RENAME file/dir AS new name"
    Return
ElseIf Not _FileExists(sourcepath$) And Not _DirExists(sourcepath$) Then
    Print "Source path needs to be a file or directory."
    Return
Else
    On Error GoTo RENAMEERR
    Name sourcepath$ As targetpath$
End If
Return

RENAMEERR:
Print "Failed to rename "; sourcepath$; "to "; targetpath$; ".  Likely user lacks permissions or target path doesn't exist."
Beep
Resume MAIN
Return

'Route commands to right function
ROUTECMD:
cmd$ = _Trim$(cmd$)
If InStr(cmd$, " ") = 0 Then
    refcmd$ = cmd$
    args$ = ""
Else
    refcmd$ = Left$(cmd$, InStr(cmd$, " ") - 1)
    args$ = Right$(cmd$, Len(cmd$) - InStr(cmd$, " "))
End If
If cmd$ = "" Or InStr(cmd$, "'") = 1 Then Return
Select Case UCase$(refcmd$)
    Case "EXIT", "QUIT": GoSub QUIT
    Case "HELP": GoSub HELP
    Case "8BALL": GoSub EIGHTBALL
    Case "BEEP": Beep
    Case "CD", "CHDIR": GoSub CDIR
    Case "DEL", "DELETE", "RM", "ERA", "ERASE": GoSub DEL
    Case "CALC": GoSub CALC
    Case "CHRISTMAS": GoSub CHRISTMAS
    Case "CLEAR", "CLS": GoSub CLEARSCR
    Case "DATE": Print Date$
    Case "DEVICES": GoSub LSDEV
    Case "ENV": GoSub ENV
    Case "MAKEDIR": GoSub MAKEDIR
    Case "RENAME", "NAME", "MOVE", "REN": GoSub RENAME
    Case "OS": Print _OS$
    Case "PI": Print _Pi
    Case "PIP": GoSub PIP
    Case "PRINT": GoSub OUTCMD
    Case "PLAY": GoSub PLAYSOUND
    Case "RAND": GoSub RANDNUM
    Case "RMDIR": GoSub REMDIR
    Case "TIME": Print Time$
    Case "USER", "WHO": Print Environ$("USER")
    Case "READFILE", "CAT", "TYPE": GoSub READFILE
    Case Else: GoSub CMDOUT
End Select
Return

'Give a way to clo(se this because this isn't vim
QUIT:
System

'A friendly greeting
WELCOME:
Color 15
Print "WELCOME TO Quick Basic Shell, " + Environ$("USER")
Print "Type HELP to see a list of commands."
Print
Return

'$INCLUDE:'lib/io.bas'
