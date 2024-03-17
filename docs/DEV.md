# Building cbx-pycli package

## Pré-requis

### Before installing **Pyenv**

Installez Pyenv pour gérer les versions de Python.

#### Understanding PATH

When you run a command like `python` or `pip`, your operating system
searches through a list of directories to find an executable file with
that name. This list of directories lives in an environment variable
called `PATH`, with each directory in the list separated by a colon:

```bash
/usr/local/bin:/usr/bin:/bin
```

Directories in `PATH` are searched from left to right, so a matching
executable in a directory at the beginning of the list takes
precedence over another one at the end. In this example, the
`/usr/local/bin` directory will be searched first, then `/usr/bin`,
then `/bin`.

#### Understanding Shims

pyenv works by inserting a directory of _shims_ at the front of your `PATH`:

```bash
$(pyenv root)/shims:/usr/local/bin:/usr/bin:/bin
```

Through a process called _rehashing_, pyenv maintains shims in that
directory to match every Python command across every installed version
of Python—`python`, `pip`, and so on.

Shims are lightweight executables that simply pass your command along
to pyenv.
So with pyenv installed, when you run, say, `pip`, your
operating system will do the following:

- Search your `PATH` for an executable file named `pip`
- Find the pyenv shim named `pip` at the beginning of your `PATH`
- Run the shim named `pip`, which in turn passes the command along to pyenv

#### Understanding Python version selection

When you execute a shim, pyenv determines which Python version to use by
reading it from the following sources, in this order:

1. The `PYENV_VERSION` environment variable (if specified). You can use
   the [`pyenv shell`](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-shell) command to set this environment
   variable in your current shell session.

2. The application-specific `.python-version` file in the current
   directory (if present). You can modify the current directory's
   `.python-version` file with the [`pyenv local`](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-local)
   command.

3. The first `.python-version` file found (if any) by searching each parent
   directory, until reaching the root of your filesystem.

4. The global `$(pyenv root)/version` file. You can modify this file using
   the [`pyenv global`](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-global) command.
   If the global version file is not present, pyenv assumes you want to use the "system"
   Python (see below).

A special version name "`system`" means to use whatever Python is found on `PATH`
after the shims `PATH` entry (in other words, whatever would be run if Pyenv
shims weren't on `PATH`). Note that Pyenv considers those installations outside
its control and does not attempt to inspect or distinguish them in any way.
So e.g. if you are on MacOS and have OS-bundled Python 3.8.9 and Homebrew-installed
Python 3.9.12 and 3.10.2 -- for Pyenv, this is still a single "`system`" version,
and whichever of those is first on `PATH` under the executable name you
specified will be run.

#### **NOTE:** You can activate multiple versions at the same time, including multiple versions of Python2 or Python3 simultaneously

This allows for parallel usage of
Python2 and Python3, and is required with tools like `tox`.

For example, to instruct
Pyenv to first use your system Python and Python3 (which are e.g. 2.7.9 and 3.4.2)
but also have Python 3.3.6, 3.2.1, and 2.5.2 available, you first `pyenv install`
the missing versions, then set `pyenv global system 3.3.6 3.2.1 2.5.2`.

Then you'll be able to invoke any of those versions with an appropriate `pythonX` or
`pythonX.Y` name.

You can also specify multiple versions in a `.python-version` file by hand,
separated by newlines. Lines starting with a `#` are ignored.

[`pyenv which <command>`](COMMANDS.md#pyenv-which) displays which real executable would be
run when you invoke `<command>` via a shim.

##### E.g. if you have 3.3.6, 3.2.1 and 2.5.2 installed of which 3.3.6 and 2.5.2 are selected and your system Python is 3.2.5

`pyenv which python2.5` should display `$(pyenv root)/versions/2.5.2/bin/python2.5`,
`pyenv which python3` -- `$(pyenv root)/versions/3.3.6/bin/python3` and
`pyenv which python3.2` -- path to your system Python due to the fall-through (see below).

Shims also fall through to anything further on `PATH` if the corresponding executable is
not present in any of the selected Python installations.

This allows you to use any programs installed elsewhere on the system as long as
they are not shadowed by a selected Python installation.

### Installing **Pyenv**

#### **1. Homebrew in macOS**

##### Consider installing with [Homebrew](https://brew.sh)

```sh
brew update
brew install pyenv
```

If you want to install (and update to) the latest development head of Pyenv
rather than the latest release, instead run:

```sh
brew install pyenv --head
```

##### OPTIONAL. To fix `brew doctor`'s warning _""config" scripts exist outside your system or Homebrew directories"_

If you're going to build Homebrew formulae from source that link against Python
like Tkinter or NumPy
_(This is only generally the case if you are a developer of such a formula,
or if you have an EOL version of MacOS for which prebuilt bottles are no longer provided
and you are using such a formula)._

To avoid them accidentally linking against a Pyenv-provided Python,
add the following line into your interactive shell's configuration:

- **Bash/Zsh**

    ```bash
    alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
    ```

- **Fish**

    ```fish
    alias brew="env PATH=(string replace (pyenv root)/shims '' \"\$PATH\") brew"
    ```

#### **2.Linux Automatic installer**

```bash
curl https://pyenv.run | bash
```

### Post-installation steps

#### **Upgrade note**: The startup logic and instructions have been updated for simplicity in 2.3.0

The previous, more complicated configuration scheme for 2.0.0-2.2.5 still works.

Define environment variable PYENV_ROOT to point to the path where Pyenv will store its data.

```sh
$HOME/.pyenv is the default.
```

If you installed Pyenv via Git checkout, we recommend to set it to the same location as where you cloned it.

Add the pyenv executable to your PATH if it's not already there run

```sh
eval "$(pyenv init -)"
```

To install pyenv into your shell as a shell function, enable shims and autocompletion.

You may run:

```sh
eval "$(pyenv init --path)"
```

instead to just enable shims, without shell integration.

The below setup should work for the vast majority of users for common use cases. See [Advanced configuration](https://github.com/pyenv/pyenv/blob/master/README.md#advanced-configuration) for details and more configuration options.

#### **For bash**

Stock Bash startup files vary widely between distributions in which
of them source which, under what circumstances, in what order and what
additional configuration they perform.

As such, the most reliable way to get Pyenv in all environments is
to append Pyenv configuration commands to both .bashrc (for interactive shells) and
the profile file that Bash would use (for login shells).

First, add the commands to ~/.bashrc by running the following in your terminal

```bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
```

Then, if you have **~/.profile**, **~/.bash_profile** or **~/.bash_login**, add the commands there as well

If you have none of these, add them to **~/.profile.**

To add to **~/.profile**

```bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init -)"' >> ~/.profile
```

To add to **~/.bash_profile**

```bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
```

#### **For Zsh**

Add the following to your ~/.zshrc to enable Pyenv if you are using Zsh:

```zsh
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
```

If you wish to get Pyenv in noninteractive login shells as well, also add the commands to ~/.zprofile or ~/.zlogin.

#### **For Fish shell**

If you have Fish 3.2.0 or newer, execute this interactively:

```fish
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
```

Otherwise, execute the snippet below:

```fish
set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
```

Now, add this to **~/.config/fish/config.fish**:

```fish
pyenv init - | source
```

**Bash warning**: There are some systems where the BASH_ENV variable is configured to point to .bashrc. On such systems, you should almost certainly put the eval "$(pyenv init -)" line into .bash_profile, and not into .bashrc.

Otherwise, you may observe strange behaviour, such as pyenv getting into an infinite loop. See #264 for details.

**Proxy note**: If you use a proxy, export http_proxy and https_proxy, too.

In **MacOS**, you might also want to install Fig which provides alternative shell completions for many command line tools with an IDE-like popup interface in the terminal window.
(Note that their completions are independent from Pyenv's codebase so they might be slightly out of sync for bleeding-edge interface changes.)

### Restart your shell

For the PATH changes to take effect:

```bash
exec "$SHELL"
```

### Suggested build environment

pyenv will try its best to download and compile the wanted Python version,
but sometimes compilation fails because of unmet system dependencies, or
compilation succeeds but the new Python version exhibits weird failures at
runtime. The following instructions are our recommendations for a sane build
environment.

- **Mac OS X:**

    If you haven't done so, install Xcode Command Line Tools
    (`xcode-select --install`) and [Homebrew](http://brew.sh/). Then:

    ```sh
    brew install openssl readline sqlite3 xz zlib tcl-tk
    ```

    For older operating systems `Homebrew` might not be available so install `pyenv` with:

    ```sh
    curl https://pyenv.run | bash
    ```

    `xcode-select --install` might not be available on older macOS's so use [this script](https://gist.github.com/rtrouton/f92f263414aaeb946e54) instead or [this page](https://xcodereleases.com/) as well as directly from Apple downloads:

    <https://developer.apple.com/download/more/>

    And search for:

    ```sh
    command line tools <version number>
    ```

    like `command line tools 10.9`

    For dependencies use [MacPorts](https://www.macports.org/install.php):

    sudo port install pkgconfig openssl zlib xz gdbm tcl tk +quartz sqlite3 sqlite3-tcl

- **Ubuntu/Debian/Mint:**

    ```sh
    sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    ```

    If you are going build PyPy from source or install other Python flavors that require CLang, also install `llvm`.

- **CentOS/Fedora 21 and below:**

    ```sh
    yum install gcc make patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
    ```

- **Amazon Linux 2:**

    ```sh
    yum install gcc make patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl11-devel tk-devel libffi-devel xz-devel
    ```

- **Fedora 22 and above:**

    ```sh
    dnf install make gcc patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel libuuid-devel gdbm-libs libnsl2
    ```

- **Fedora Silverblue**

    ```sh
    toolbox enter
    sudo dnf update vte-profile  # https://github.com/containers/toolbox/issues/390
    sudo dnf install "@Development Tools" zlib-devel bzip2 bzip2-devel readline-devel sqlite \
    sqlite-devel openssl-devel xz xz-devel libffi-devel findutils tk-devel
    ```

- **openSUSE:**

    ```sh
    zypper install gcc automake bzip2 libbz2-devel xz xz-devel openssl-devel ncurses-devel \
    readline-devel zlib-devel tk-devel libffi-devel sqlite3-devel gdbm-devel make findutils patch
    ```

- **Arch Linux:**

    ```sh
    pacman -S --needed base-devel openssl zlib xz tk
    ```

- **Solus:**

    ```sh
    sudo eopkg it -c system.devel
    sudo eopkg install git gcc make zlib-devel bzip2-devel readline-devel sqlite3-devel openssl-devel tk-devel
    ```

- **Alpine Linux:**

    ```sh
    apk add --no-cache git bash build-base libffi-dev openssl-dev bzip2-dev zlib-dev xz-dev readline-dev sqlite-dev tk-dev
    ```

- **Installation of Python 3.7** may fail due to Python 3.7.0 issue [#34555](https://bugs.python.org/issue34555). A workaround is to install the [linux system headers package](https://pkgs.alpinelinux.org/packages?name=linux-headers&branch=edge):

    ```sh
    apk add linux-headers
    ```

- **Void Linux:**

    ```sh
    xbps-install base-devel libffi-devel bzip2-devel openssl openssl-devel readline readline-devel sqlite-devel xz liblzma-devel zlib zlib-devel
    ```

See also [Common build problems](https://github.com/pyenv/pyenv/wiki/Common-build-problems) for further information.

**You can now begin using Pyenv!!!**

If you need, export USE_SSH to use <git@github.com>``(SSH pseudo-URL) instead of``https:// for git clone. (Need to have ssh installled.)

### Update

```bash
pyenv update
```

### Uninstall

``pyenv`` is installed within ``$PYENV_ROOT`` (default: ``~/.pyenv``).

To uninstall, just remove it:

```bash
rm -fr ~/.pyenv
```

then remove these three lines from ``.bashrc``:

```bash
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
```

and finally, restart your shell:

```bash
exec $SHELL
```

### **Python**

Assurez-vous que Python est installé sur votre système pour les scripts de construction et d'empaquetage

#### Locating Pyenv-provided Python installations

Once pyenv has determined which version of Python your application has
specified, it passes the command along to the corresponding Python
installation.

Each Python version is installed into its own directory under
`$(pyenv root)/versions`.

For example, you might have these versions installed:

- `$(pyenv root)/versions/2.7.8/`
- `$(pyenv root)/versions/3.4.2/`
- `$(pyenv root)/versions/pypy-2.4.0/`

As far as Pyenv is concerned, version names are simply directories under
`$(pyenv root)/versions`.

#### Install additional Python versions

To install additional Python versions, use [`pyenv install`](COMMANDS.md#pyenv-install).

For example, to download and install Python 3.10.4, run:

```sh
pyenv install 3.10.4
```

Running `pyenv install -l` gives the list of all available versions.

**NOTE:** Most Pyenv-provided Python releases are source releases and are built
from source as part of installation (that's why you need Python build dependencies preinstalled).
You can pass options to Python's `configure` and compiler flags to customize the build,
see [_Special environment variables_ in Python-Build's README](plugins/python-build/README.md#special-environment-variables)
for details.

**NOTE:** If you are having trouble installing a Python version,
please visit the wiki page about
[Common Build Problems](https://github.com/pyenv/pyenv/wiki/Common-build-problems).

**NOTE:** If you want to use proxy for download, please set the `http_proxy` and `https_proxy`
environment variables.

**NOTE:** If you'd like a faster interpreter at the cost of longer build times,
see [_Building for maximum performance_ in Python-Build's README](plugins/python-build/README.md#building-for-maximum-performance).

##### Prefix auto-resolution to the latest version

All Pyenv subcommands except `uninstall` automatically resolve full prefixes to the latest version in the corresponding version line.

`pyenv install` picks the latest known version, while other subcommands pick the latest installed version.

E.g. to install and then switch to the latest 3.10 release:

```sh
pyenv install 3.10
pyenv global 3.10
```

You can run [`pyenv latest -k <prefix>`](COMMANDS.md#pyenv-latest) to see how `pyenv install` would resolve a specific prefix, or [`pyenv latest <prefix>`](COMMANDS.md#pyenv-latest) to see how other subcommands would resolve it.

See the [`pyenv latest` documentation](COMMANDS.md#pyenv-latest) for details.

##### Python versions with extended support

For the following Python releases, Pyenv applies user-provided patches that add support for some newer environments.
Though we don't actively maintain those patches, since existing releases never change,
it's safe to assume that they will continue working until there are further incompatible changes
in a later version of those environments.

- _3.7.8-3.7.15, 3.8.4-3.8.12, 3.9.0-3.9.7_ : XCode 13.3
- _3.5.10, 3.6.15_ : MacOS 11+ and XCode 13.3
- _2.7.18_ : MacOS 10.15+ and Apple Silicon

#### Switch between Python versions

To select a Pyenv-installed Python as the version to use, run one
of the following commands:

- [`pyenv shell <version>`](COMMANDS.md#pyenv-shell) -- select just for current shell session
- [`pyenv local <version>`](COMMANDS.md#pyenv-local) -- automatically select whenever you are in the current directory (or its subdirectories)
- [`pyenv global <version>`](COMMANDS.md#pyenv-shell) -- select globally for your user account

E.g. to select the above-mentioned newly-installed Python 3.10.4 as your preferred version to use:

```bash
pyenv global 3.10.4
```

Now whenever you invoke `python`, `pip` etc., an executable from the Pyenv-provided
3.10.4 installation will be run instead of the system Python.

Using "`system`" as a version name would reset the selection to your system-provided Python.

See [Understanding shims](#understanding-shims) and
[Understanding Python version selection](#understanding-python-version-selection)
for more details on how the selection works and more information on its usage.

#### Uninstall Python versions

As time goes on, you will accumulate Python versions in your
`$(pyenv root)/versions` directory.

To remove old Python versions, use [`pyenv uninstall <versions>`](COMMANDS.md#pyenv-uninstall).

Alternatively, you can simply `rm -rf` the directory of the version you want
to remove. You can find the directory of a particular Python version
with the `pyenv prefix` command, e.g. `pyenv prefix 2.6.8`.
Note however that plugins may run additional operations on uninstall
which you would need to do by hand as well. E.g. Pyenv-Virtualenv also
removes any virtual environments linked to the version being uninstalled.

#### Other operations

Run `pyenv commands` to get a list of all available subcommands.
Run a subcommand with `--help` to get help on it, or see the [Commands Reference](COMMANDS.md).

Note that Pyenv plugins that you install may add their own subcommands.

----

### **Poetry**

#### Introduction

Poetry is a tool for **dependency management** and **packaging** in Python.
It allows you to declare the libraries your project depends on and it will manage (install/update) them for you.
Poetry offers a lockfile to ensure repeatable installs, and can build your project for distribution.

#### System requirements

Poetry requires **Python 3.8+**. It is multi-platform and the goal is to make it work equally well
on Linux, macOS and Windows.

#### Installation

##### **Linux, macOS, Windows (WSL)**

```bash
curl -sSL https://install.python-poetry.org | python3 -
```

Note: On some systems, `python` may still refer to Python 2 instead of Python 3.
We always suggest the `python3` binary to avoid ambiguity.

##### **Windows (Powershell)**

```powershell
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | py -
```

>If you have installed Python through the Microsoft Store, replace `py` with `python` in the >command above.

##### **Install Poetry (advanced)**

>You can skip this step, if you simply want the latest version and already installed Poetry >as described in the previous step. This step details advanced usages of this installation >method.
>For example, installing Poetry from
>source, using a pre-release build, configuring a different installation location etc.

By default, Poetry is installed into a platform and user-specific directory:

- `~/Library/Application Support/pypoetry` on MacOS.
- `~/.local/share/pypoetry` on Linux/Unix.
- `%APPDATA%\pypoetry` on Windows.

If you wish to change this, you may define the `$POETRY_HOME` environment variable:

```bash
curl -sSL https://install.python-poetry.org | POETRY_HOME=/etc/poetry python3 -
```

If you want to install prerelease versions, you can do so by passing the `--preview` option to the installation script
or by using the `$POETRY_PREVIEW` environment variable:

```bash
curl -sSL https://install.python-poetry.org | python3 - --preview
curl -sSL https://install.python-poetry.org | POETRY_PREVIEW=1 python3 -
```

Similarly, if you want to install a specific version, you can use `--version` option or the `$POETRY_VERSION`
environment variable:

```bash
curl -sSL https://install.python-poetry.org | python3 - --version 1.2.0
curl -sSL https://install.python-poetry.org | POETRY_VERSION=1.2.0 python3 -
```

You can also install Poetry from a `git` repository by using the `--git` option:

```bash
curl -sSL https://install.python-poetry.org | python3 - --git https://github.com/python-poetry/poetry.git@main
```

If you want to install different versions of Poetry in parallel, a good approach is the installation with pipx and suffix.

#### **Add Poetry to your PATH**

The installer creates a `poetry` wrapper in a well-known, platform-specific directory:

- `$HOME/.local/bin` on Unix.
- `%APPDATA%\Python\Scripts` on Windows.
- `$POETRY_HOME/bin` if `$POETRY_HOME` is set.

If this directory is not present in your `$PATH`, you can add it in order to invoke Poetry
as `poetry`.

Alternatively, the full path to the `poetry` binary can always be used:

- `~/Library/Application Support/pypoetry/venv/bin/poetry` on MacOS.
- `~/.local/share/pypoetry/venv/bin/poetry` on Linux/Unix.
- `%APPDATA%\pypoetry\venv\Scripts\poetry` on Windows.
- `$POETRY_HOME/venv/bin/poetry` if `$POETRY_HOME` is set.

#### **Verify the installation**

Once Poetry is installed and in your `$PATH`, you can execute the following:

```bash
poetry --version
```

If you see something like `Poetry (version 1.2.0)`, your install is ready to use!

#### **Update Poetry**

Poetry is able to update itself when installed using the official installer.

`!!! Warning !!!`

`Especially on Windows, self update may be problematic so that a re-install with the installer should be preferred`

```bash
poetry self update
```

If you want to install pre-release versions, you can use the `--preview` option.

```bash
poetry self update --preview
```

And finally, if you want to install a specific version, you can pass it as an argument
to `self update`.

```bash
poetry self update 1.2.0
```

`!!! Warning !!!`
`Poetry 1.1 series releases are not able to update in-place to 1.2 or newer series releases.`
`To migrate to newer releases, uninstall using your original install method, and then reinstall`
`using the [methods above]({{< ref "#installation" >}} "Installation").`

#### **Uninstall Poetry**

If you decide Poetry isn't your thing, you can completely remove it from your system
by running the installer again with the `--uninstall` option or by setting
the `POETRY_UNINSTALL` environment variable before executing the installer.

```bash
curl -sSL https://install.python-poetry.org | python3 - --uninstall
curl -sSL https://install.python-poetry.org | POETRY_UNINSTALL=1 python3 -
```

`!!! Warning !!!`

`If you installed using the deprecated get-poetry.py script, you should remove the path it uses manually, e.g.`

If you installed using the deprecated `get-poetry.py` script, you should remove the path it uses manually, e.g.

```bash
rm -rf "${POETRY_HOME:-~/.poetry}"
```

Also remove ~/.poetry/bin from your `$PATH` in your shell configuration, if it is present.

Poetry can be installed manually using `pip` and the `venv` module. By doing so you will essentially perform the steps carried out by the official installer.

As this is an advanced installation method, these instructions are Unix-only and omit specific
examples such as installing from `git`.

The variable `$VENV_PATH` will be used to indicate the path at which the virtual environment was created.

```bash
python3 -m venv $VENV_PATH
$VENV_PATH/bin/pip install -U pip setuptools
$VENV_PATH/bin/pip install poetry
```

Poetry will be available at `$VENV_PATH/bin/poetry` and can be invoked directly or symlinked elsewhere.

To uninstall Poetry, simply delete the entire `$VENV_PATH` directory.

Unlike development environments, where making use of the latest tools is desirable, in a CI environment reproducibility
should be made the priority. Here are some suggestions for installing Poetry in such an environment.

#### **Version pinning**

Whatever method you use, it is highly recommended to explicitly control the version of Poetry used, so that you are able
to upgrade after performing your own validation. Each install method has a different syntax for setting the version that
is used in the following examples.

#### **Using install.python-poetry.org**

>The official installer script ([install.python-poetry.org](https://install.python-poetry.org)) offers a streamlined and
>implified installation of Poetry, sufficient for developer use or for simple pipelines. >However, in a CI environment
>the other two supported installation methods (pipx and manual) should be seriously considered.

Downloading a copy of the installer script to a place accessible by your CI pipelines (or maintaining a copy of the
[repository](https://github.com/python-poetry/install.python-poetry.org)) is strongly suggested, to ensure your
pipeline's stability and to maintain control over what code is executed.

By default, the installer will install to a user-specific directory.

In more complex pipelines that may make accessing Poetry difficult (especially in cases like multi-stage container builds).
It is highly suggested to make use of `$POETRY_HOME` when using the official installer in CI, as that way the exact paths can be controlled.

```bash
export POETRY_HOME=/opt/poetry
python3 install-poetry.py --version 1.2.0
$POETRY_HOME/bin/poetry --version
```

#### **Using pip (aka manually)**

For maximum control in your CI environment, installation with `pip` is fully supported and something you should
consider. While this requires more explicit commands and knowledge of Python packaging from you, it in return offers the
best debugging experience, and leaves you subject to the fewest external tools.

```bash
export POETRY_HOME=/opt/poetry
python3 -m venv $POETRY_HOME
$POETRY_HOME/bin/pip install poetry==1.2.0
$POETRY_HOME/bin/poetry --version
```

>If you install Poetry via `pip`, ensure you have Poetry installed into an isolated environment that is **not the same**
>as the target environment managed by Poetry. If Poetry and your project are installed into the same environment, Poetry
>is likely to upgrade or uninstall its own dependencies (causing hard-to-debug and understand errors).

#### **Enable tab completion for Bash, Fish, or Zsh**

`poetry` supports generating completion scripts for Bash, Fish, and Zsh.

See `poetry help completions` for full details, but the gist is as simple as using one of the following:

##### **Bash**

- ###### **Auto-loaded (recommended)**

    ```bash
    poetry completions bash >> ~/.bash_completion
    ```

- ###### **Lazy-loaded**

    ```bash
    poetry completions bash > ${XDG_DATA_HOME:-~/.local/share}/bash-completion/completions/poetry
    ```

##### Fish

```fish
poetry completions fish > ~/.config/fish/completions/poetry.fish
```

##### **Zsh**

```zsh
poetry completions zsh > ~/.zfunc/_poetry
```

You must then add the following lines in your `~/.zshrc`, if they do not already exist:

```bash
fpath+=~/.zfunc
autoload -Uz compinit && compinit
```

##### **Oh My Zsh**

```zsh
mkdir $ZSH_CUSTOM/plugins/poetry
poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
```

- **You must then add `poetry` to your plugins array in `~/.zshrc`:**

    ```text
    plugins=(poetry...)
    ```

#### **prezto**

```zsh
poetry completions zsh > ~/.zprezto/modules/completion/external/src/_poetry
```

>You may need to restart your shell in order for these changes to take effect.

----

### **dpkg-dev**

Installez les outils nécessaires pour créer des paquets .deb sur un système basé sur Debian ou Ubuntu.

```bash
sudo apt update
sudo apt install dpkg-dev
```

## Utilisation de Poetry avec Pyenv

Laisser Poetry gérer l'environnement virtuel tout en utilisant une version spécifique de Python installée via Pyenv est effectivement une approche plus simple et plus propre pour développer et empaqueter des applications Python.

Cette méthode tire parti de la flexibilité et de la facilité d'utilisation de Poetry pour la gestion des dépendances et des environnements virtuels, tout en permettant à Pyenv de fournir la version exacte de Python nécessaire pour votre projet.

Voici pourquoi cette approche est avantageuse et comment elle peut être mise en œuvre :

### Simplicité

Poetry simplifie la gestion des dépendances et des environnements virtuels.

En laissant Poetry créer l'environnement virtuel, vous minimisez les risques d'erreurs manuelles et simplifiez le processus de développement.

### Version de Python spécifique

Pyenv vous permet d'installer et de sélectionner des versions spécifiques de Python pour différents projets.

En définissant la version de Python avec Pyenv avant de créer un environnement virtuel avec Poetry, vous vous assurez que Poetry utilise cette version spécifique pour l'environnement virtuel de votre projet.

### Isolation

En utilisant un environnement virtuel, vous isolez les dépendances de votre projet des autres projets et du système global.
Cela prévient les conflits entre les versions de packages et rend votre projet plus portable et reproductible.

### Facilité d'empaquetage

Lorsque vous empaquetez votre application pour la distribution, vous pouvez spécifier dans votre script de construction ou de déploiement que l'environnement virtuel de Poetry doit être utilisé.
Cela garantit que toutes les dépendances spécifiques au projet sont incluses et que l'application s'exécutera dans un environnement cohérent, indépendamment de l'environnement système de l'utilisateur final.

## Mise en œuvre

Pour implémenter cette approche :

### Configurer Pyenv

Installez la version spécifique de Python que vous souhaitez utiliser pour votre projet avec Pyenv et définissez-la comme version locale pour votre répertoire de projet

```bash
pyenv install 3.12.1
pyenv local 3.12.1
```

### Vérifiez la version de Python

Assurez-vous que la version de Python souhaitée est active.

```bash
python --version  # Devrait afficher Python 3.12.1
```

### Initialisez votre projet avec Poetry

Si ce n'est pas déjà fait, créez votre projet avec Poetry.

Poetry détectera automatiquement la version de Python utilisée par Pyenv et créera un environnement virtuel approprié pour cette version.

```bash
poetry new mon_projet
cd mon_projet
poetry install
```

Développez et testez votre application dans l'environnement géré par Poetry, en profitant de la version spécifique de Python configurée via Pyenv.

### Empaquetez votre application

Lorsque vous êtes prêt à empaqueter votre application, vous pouvez inclure l'environnement virtuel généré par Poetry ou spécifier les dépendances dans votre script de construction pour que l'environnement virtuel soit recréé lors de l'installation du paquet .deb.

En suivant cette approche, vous bénéficiez de la gestion simplifiée des environnements et des dépendances par Poetry, tout en ayant le contrôle précis sur la version de Python utilisée grâce à Pyenv, sans les complications liées à l'inclusion directe de Pyenv ou de Python dans votre paquet .deb.

## Structure de répertoire

Cette structure prend en compte les meilleures pratiques de développement Python, en incluant des répertoires pour le code source, les tests, et la documentation, ainsi que les fichiers de configuration pour Poetry et Pyenv.

```bash
mon_projet/
│
├── .python-version  # Fichier généré par Pyenv pour spécifier la version de Python
├── pyproject.toml   # Fichier de conf pour Poetry, définissant les dépendances du projet
│
├── mon_projet/      # Répertoire contenant le code source de votre application
│   ├── __init__.py  # Rend ce répertoire un package Python
│   └── main.py      # Le point d'entrée de votre application CLI, par exemple
│
├── tests/           # Répertoire contenant les tests de votre projet
│   ├── __init__.py  # Rend ce répertoire reconnaissable comme module de tests
│   └── test_main.py # Exemple de fichier de test
│
├── docs/            # Répertoire pour la documentation de votre projet
│   └── index.md     # Un exemple de fichier Markdown pour la documentation
│
├── scripts/         # Répertoire pour les scripts utiles, comme les scripts de déploiement
│   └── deploy.sh    # Script d'exemple pour le déploiement
│
├── .gitignore       # Fichier spécifiant intentionnellement les fichiers non suivis par Git
└── README.md        # Fichier .md fournissant des instructions pour votre projet
```

## Explications

### **.python-version**

Ce fichier est créé et utilisé par Pyenv pour définir la version de Python pour ce projet. Quand vous définissez une version locale avec Pyenv (pyenv local 3.12.1), Pyenv crée ce fichier.

### **pyproject.toml**

Le cœur de la configuration de votre projet avec Poetry. Il contient les métadonnées de votre projet, les dépendances, et peut également contenir la configuration d'outils supplémentaires comme les linters ou les formateurs de code.

### **Répertoire mon_projet/**

Contient le code source de votre application. Le nom de ce répertoire doit correspondre au nom de votre paquet ou projet. Le fichier **init**.py indique à Python que ce répertoire doit être traité comme un package.

### **Répertoire tests/**

Contient les tests pour votre application. Organiser les tests dans leur propre répertoire aide à les maintenir séparés du code source de l'application.

### **Répertoire docs/**

Pour la documentation de votre projet. Utiliser un répertoire dédié pour la documentation aide à organiser et à faciliter l'accès aux informations pour les utilisateurs et les contributeurs.

### **Répertoire scripts/**

Utile pour stocker des scripts qui assistent dans des tâches comme le déploiement, l'exécution de tâches automatisées, etc.

### **.gitignore**

Un fichier Git utilisé pour exclure certains fichiers ou répertoires du suivi de version. Typiquement, il inclurait des répertoires comme **pycache**/, des fichiers .env, ou le dossier venv/ de l'environnement virtuel si vous n'utilisez pas l'isolation de l'environnement virtuel de Poetry.

### **README.md**

Fournit une introduction à votre projet, des instructions d'installation, d'utilisation, et toute autre information importante pour les utilisateurs ou les contributeurs.

Cette structure est suffisamment flexible pour être adaptée à la taille et aux besoins spécifiques de votre projet, tout en fournissant une base solide pour le développement, le test, et la documentation de votre application Python.

## Modifications nécessaires pour empaqueter votre application Python en tant que paquet .deb

### 1. Préparer les métadonnées et les scripts Debian

Dans le répertoire racine de votre projet, vous devrez ajouter un répertoire spécial nommé DEBIAN qui contiendra des fichiers de contrôle et éventuellement des scripts qui seront exécutés lors de l'installation, de la mise à jour ou de la suppression du paquet.

### Structure de répertoire ajoutée

```bash
mon_projet/
│
├── DEBIAN/                  # Dossier pour les fichiers de contrôle et les script Debian
│   ├── control              # Fichier contenant les métadonnées du paquet
│   ├── postinst             # Script exécuté après l'installation du paquet (optionnel)
│   ├── prerm                # Script exécuté avant la suppression du paquet (optionnel)
│   └── postrm               # Script exécuté après la suppression du paquet (optionnel)
│
└── usr/
    └── local/
        └── bin/             # Destination pour les fichiers exécutables de l'application
            └── mon_projet   # L'exécutable de votre application
```

#### Créer le fichier de contrôle

Le fichier DEBIAN/control est essentiel pour la création d'un paquet .deb. Il contient des informations sur le paquet, telles que le nom, la version, la description, les dépendances, etc.

Exemple de fichier control :

```less
Package: mon-projet
Version: 1.0.0
Section: utils
Priority: optional
Architecture: all
Depends: python3 (>= 3.6), python3-pip
Maintainer: Votre Nom <votre.email@example.com>
Description: Une description plus détaillée de votre application.
```

#### Scripts optionnels

Vous pouvez inclure des scripts tels que postinst, prerm, et postrm pour gérer les actions après l'installation (postinst), avant la suppression (prerm), et après la suppression (postrm).
Ces scripts peuvent être utilisés pour des tâches comme la configuration de l'environnement, la migration de base de données, le nettoyage, etc.

#### Construire le paquet

Une fois que vous avez préparé votre structure de répertoire et les fichiers nécessaires, naviguez au répertoire parent de mon_projet et exécutez la commande suivante pour construire le paquet .deb :

```bash
dpkg-deb --build mon_projet
```

Cette commande générera un fichier .deb que vous pourrez distribuer et installer avec dpkg -i.

#### Effectuer des tests sur le paquet

Il est crucial de tester votre paquet .deb dans différents environnements pour s'assurer qu'il s'installe et fonctionne correctement. Installez votre paquet dans un environnement propre pour vérifier que toutes les dépendances sont correctement spécifiées et que les scripts de post-installation fonctionnent comme prévu.

### Remarques

Le répertoire usr/local/bin/ dans l'exemple ci-dessus est un emplacement standard pour installer les fichiers exécutables sur les systèmes Linux. Assurez-vous que votre script d'installation place les fichiers correctement.

Assurez-vous que le fichier exécutable de votre application (mon_projet dans l'exemple) est correctement empaqueté dans le répertoire usr/local/bin/ de votre paquet .deb et qu'il est exécutable.
Le champ Depends: dans le fichier control doit lister toutes les dépendances nécessaires au fonctionnement de votre application. Assurez-vous d'inclure les versions spécifiques de Python ou d'autres paquets requis.

En suivant ces étapes, vous transformerez efficacement votre projet Python en un paquet .deb distribuable, facilitant l'installation et la gestion de votre application sur les systèmes Debian et Ubuntu.
