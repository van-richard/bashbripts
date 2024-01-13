# bashbripts

```
To-Do:

* Generalize dotfile 
* Add bash scripts
* Check conda envs
```

**tmux implmentated only for local macos**

## Purpose

To maintain consistency of configuration/scripting/analysis files across multiple devices (MacOS/Linux).

* Prepare user configuration files for `bash`, `vim`, and `tmux`
* Generate the `~/Programs/` directory for general programs, like:
    * Conda (miniforge3)

Includes some analysis scripts to check current state of MD simulation trajectories

## Overview

Attempting to write helpful bash scripts for general command line and computational chemistry applications.

Copy this to `~/Scripts`:

```
mkdir -p ~/Scripts
git@github.com:van-richard/bashbripts.git ~/Scripts/bashbripts
```

### Directory Tree

```
./bashbripts
├── bin/            # General bash scripts
├── setup/          # Setup dotfiles, conda, conda environments
└── templates/      # Templates for dotfiles
    ├── aliases/    # ~/.bash_aliases
    ├── profile/    # ~/.bash_profile
    ├── runcom/     # ~/.bashrc
    ├── vimrc       # ~/.vimrc
    └── tmux_conf   # ~/.tmux.conf
```


## Import to Environment

To have bash scripts available in your environmnent, append `$PATH` to `~/.bashrc`

```
echo '# My Bash Scripts
export PATH="~/Scripts/bashbripts/bin:${PATH}"' >> ~/.bashrc
```

