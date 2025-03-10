![qbsh icon](icons/qbsh-128.png) 

[![Docker Repository on Quay](https://quay.io/repository/vwbusguy/qbsh/status "Docker Repository on Quay")](https://quay.io/repository/vwbusguy/qbsh)

QBSH - Quick BASIC Shell
========================

This is an attempt at making a command line shell with [QB64](https://git.qb64.dev/QB64).  Unhandled commands are offloaded to the native shell (bash, etc.).  While it's reached a point of mild sanity, your mileage may vary, so use this at your own risk. 

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

* `8BALL` - Answers to life's deepest questions
* `CALC` - Add, Subtract, Multiply, and Divide
* `CHDIR` - Change working directory (also, CD)
* `CLEAR` - Clear the current screen
* `DATE` - Today's Date
* `DIR <Optional directory>` - List files in directory
* `DELETE` - Delete a file.  (ERA and ERASE also work.)
* `DEVICES` - Display info about attached input devices
* `ENV <Optional Key>` - Print Environment
* `MAKEDIR <directory>` - Make a new directory
* `OS` - Print the operating system type
* `PIP <DEST>=<SRC>` - Copy a file to a new path, CP/M style.
* `PLAY <Notes>` - Make some music and rock out
* `PRINT` - Output some text (is there an echo in here?)
* `RAND <Optional Limit>` - Random number generator, defaults to 0-10 and supports negative numbers
* `READFILE <file>` - Output some text file to terminal (cat and TYPE also work)
* `RENAME <File/Dir> <New Name>` - Rename a file or directory (also, MOVE, NAME, or REN)
* `RMDIR <Directory>` - Delete a directory
* `RUN <file.qbsh>` - Run a qbsh script from within a script or interactive shell
* `TIME` - Current time
* `XDIR <Optional directory>` - List detailed directory info
* `WHO AM I` - Sometimes we all forget, right? (USER also works)

Commands can also be ran ad-hoc apart from scripting or interactive shell by passing them with `qbsh -x`.

## Scripting

qbsh can be scripted using the above commands in a file.  See the examples directory to get started.  To run a script just run qbsh with the script file.  

`$ qbsh examples/hello.qsh`

Scripts can be padded with empty lines or indents.  To add comments, just begin the line with a single quote (').

Use `RUN` to call a qbsh script from within another qbsh script or interactive shell.

### Scripting specific commands

Additional commands specific to scripts:

* `LPRINT` - Output some text without a new space after.  Useful for chaining command outputs on the same line of output.

# Development

Current code architecture is that the MAIN loop routes the input to the appropriate sub via GoSub and a loop, so no GoTo's are currently used.  Eventually this may get big enough to refactor into other files, but for now all sub/labels are given alphabetically with a one line code comment above describing what they do.

Here's a list of low hanging fruit for ways this can be improved:

* ~~Optionally break out of the GUI window on launch and use existing terminal~~
* Eliminate the file buffer from system shell calls as this is not great for security and less cross-compatible with Windows, etc.
* Add native means of listing contents of the current directory 
* Add a means of storing output to a re-usable var in the shell
* ~~Feed commands through the shell in a script file~~
* ~~Ship container images on quay.io and/or Docker Hub~~

## Testing
Run-time tests are in /test .  They can be ran during Container build time with podman (or docker):

`podman build --tag qbsh --skip-unused-stages=false .`

# How To Pronounce it

"Queue Bee Shell"
