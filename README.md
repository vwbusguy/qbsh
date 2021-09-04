QBSH - Quick BASIC Shell
========================

This is an attempt at making a command line shell with [QB64](https://www.qb64.org).  Unhandled commands are offloaded to the native shell (bash, etc.).  This is a very early project, so your mileage may vary and use this at your own risk!

# Compiling

To compile this with qb64:

`qb64 -x $PWD/qbsh.bas -o $PWD/qbsh`

It's also possible to load this into the QB64 GUI and then press F5 to compile/run it from there if a GUI is preferred.

# Shell Syntax

The syntax is very, well, basic.  It's simple commands (usually upper-case) with simple arguments.  If all else fails, it will attempt to run the command in the default system shell for the user (ie, bash, cmd, etc.), but anything interactive with the system shell likely won't work.

## Commands

Typing "HELP" (or "help") will bring up a quick list of some command possibilities.

* `CALC` - Add, Subtract, Multiply, and Divide
* `CD` - Change working directory
* `CLEAR` - Clear the current screen
* `DATE` - Today's Date
* `ENV` - Print Environment
* `MAKEDIR <directory>` - Make a new directory
* `PLAY <Notes>` - Make some music and rock out
* `PRINT` - Output some text (is there an echo in here?)
* `RAND <Optional Limit>` - Random number generator, defaults to 0-10 and supports negative numbers
* `READFILE <file>` - Output some text file to terminal (cat also works)
* `RMDIR <Directory>` - Delete a directory
* `TIME` - Current time
* `WHO AM I` - Sometimes we all forget, right? (USER also works)

# Development

Current code architecture is that the MAIN loop routes the input to the appropriate sub via GoSub and a loop, so no GoTo's are currently used.  Eventually this may get big enough to refactor into other files, but for now all sub/labels are given alphabetically with a one line code comment above describing what they do.

Here's a list of low hanging fruit for ways this can be improved:

* Optionally break out of the GUI window on launch and use existing terminal
* Eliminate the file buffer from system shell calls as this is not great for security and less cross-compatible with Windows, etc.
* Add native means of listing contents of the current directory 
* Add a means of storing output to a re-usable var in the shell
* Feed commands through the shell in a script file
