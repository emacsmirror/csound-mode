[![License GPL 3][badge-license]][copying]
[![Melpa Status](http://melpa.milkbox.net/packages/csound-mode-badge.svg)](http://melpa.milkbox.net/#/csound-mode)


# csound-mode
This package provides both a basic major mode for editing Csound files,
as well as a REPL for fast feedback when composing/sound-designing using Csound.

`csound-mode` provides a set of essential features for interactive development:
* REPL
* Interactive code evaluation
* Code completion
* ElDoc
* Indentation rules
* Syntax highlighting and rainbow delimited score parameters

## Installation

You can install `csound-mode` from `MELPA` using the following command:

<kbd>M-x package-install [RET] csound-mode [RET]</kbd>

Alternatively, [download latest release.](https://github.com/hlolli/csound-mode/releases/download/v0.1.2/csound-mode-0.1.2.zip)
and add it manually to load-path like shown here:

```el
;; Change directory path according to csound-mode dir location.
(add-to-list 'load-path "~/.emacs.d/csound-mode/")
(require 'csound-mode)
```

### API Installation

`csound-mode` works out of the box for editing Csound files.
For live-evaluation and REPL functionalities an emacs module needs to be compiled. 
The requirements are:
* linux/mac operating system (Windows support will come later)
* Emacs **25.1+** installation with source files (this can be troublesome when using NixOs).
* Csound 6.00 or later.

`csound-mode` will try to do this automatically for you when you run the following command:
<kbd>M-x csound-repl-start [RET]</kbd>
If emacs didn't find the emacs module(`emacscsnd.so`) on your system, then you will be prompted for compilation.
If the compilation fails in any way, please write a ticket or if you know what you're doing, compile the `csoundAPI_emacsLisp` yourself from `https://github.com/hlolli/csoundAPI_emacsLisp`.

If your OS package manager (yum/dnf/apt-get/brew/scons etc..) does not distribute its prebuilt Emacs with modules,
then you will need to compile Emacs yourself!
1. [Download the latest Emacs release](http://alpha.gnu.org/gnu/emacs/pretest/) (eg. emacs-25.2-rc2.tar.xz) or if you are on [windows](http://alpha.gnu.org/gnu/emacs/pretest/windows/)

2. Unzip/Untar the file, go into the file and run `./configure --with-modules`

3. Then do `make` and `sudo make install`

If you want to be bold and get the newest (possibly unstable) Emacs from git.

1. `git clone https://git.savannah.gnu.org/git/emacs.git`

2. `cd emacs`

3. `./autogen.sh`

4. `./configure --with-modules`

5. `make` and `sudo make install`

## Usage

`csound-mode` comes with major-mode-hooks, meaning that every time a csound file(.csd/.orc/.sco) is opened in emacs, `csoun-mode` will be automatically loaded as major mode. While making it easier to install, this could potentially overwrite other major-mode you have set for csound files.

## Known bugs
* Only one REPL instance can run at each moment
* Unexpected crashing of csound within the repl can sometimes lead to Emacs crashing, if Csound crashes (example when the audio server crashes), save your work and restart Emacs.


[badge-license]: https://img.shields.io/badge/license-GPL_3-green.svg
[COPYING]: http://www.gnu.org/copyleft/gpl.html
