![qbsh icon](icons/qbsh-128.png) 

QBSH - Quick BASIC Shell
========================

This is an attempt at making a command line shell with [QB64](https://www.qb64.org).  Unhandled commands are offloaded to the native shell (bash, etc.).  This is a very early project, so your mileage may vary and use this at your own risk!

Try it with podman or docker:

`podman run --pull=always --rm -it quay.io/vwbusguy/qbsh`

# Compiling

To compile this with qb64 (Windows users, use `qb64.exe`):

`qb64 -x $PWD/qbsh.bas -o $PWD/qbsh`

It's also possible to load this into the QB64 GUI and then press F11 to compile it from there if a GUI is preferred.

## Containerize it

qbsh is now available through [quay.io](https://quay.io/repository/vwbusguy/qbsh?tab=info).  You can now run it with podman or Docker:

`podman run --pull=always --rm -it quay.io/vwbusguy/qbsh`

### Build it yourself

A portable Containerfile is provided for use in podman or docker with `podman build -t qbsh .` .  Note that this is a multi-stage Containerfile so older Docker versions (such as in RHEL 7) will not work, but podman should generally work.

Once it's done, you can run it with:

`podman run --rm -it localhost/qbsh`

# Shell Syntax

The syntax is very, well, basic.  It's simple commands (usually upper-case) with simple arguments.  If all else fails, it will attempt to run the command in the default system shell for the user (ie, bash, cmd, etc.), but anything interactive with the system shell likely won't work.

## Commands

Typing "HELP" (or "help") will bring up a quick list of some command possibilities.  While this is periodically updated, it is not an exhaustive list.

* `CALC` - Add, Subtract, Multiply, and Divide
* `CD` - Change working directory
* `CLEAR` - Clear the current screen
* `DATE` - Today's Date
* `DELETE` - Delete a file
* `DEVICES` - Display info about attached input devices
* `ENV <Optional Key>` - Print Environment
* `MAKEDIR <directory>` - Make a new directory
* `OS` - Print the operating system type
* `PLAY <Notes>` - Make some music and rock out
* `PRINT` - Output some text (is there an echo in here?)
* `RAND <Optional Limit>` - Random number generator, defaults to 0-10 and supports negative numbers
* `READFILE <file>` - Output some text file to terminal (cat also works)
* `RENAME <File/Dir> <New Name>` - Rename a file or directory (also, MOVE or NAME)
* `RMDIR <Directory>` - Delete a directory
* `TIME` - Current time
* `WHO AM I` - Sometimes we all forget, right? (USER also works)

# Development

Current code architecture is that the MAIN loop routes the input to the appropriate sub via GoSub and a loop, so no GoTo's are currently used.  Eventually this may get big enough to refactor into other files, but for now all sub/labels are given alphabetically with a one line code comment above describing what they do.

Here's a list of low hanging fruit for ways this can be improved:

* ~~Optionally break out of the GUI window on launch and use existing terminal~~
* Eliminate the file buffer from system shell calls as this is not great for security and less cross-compatible with Windows, etc.
* Add native means of listing contents of the current directory 
* Add a means of storing output to a re-usable var in the shell
* Feed commands through the shell in a script file
* ~~Ship container images on quay.io and/or Docker Hub~~
