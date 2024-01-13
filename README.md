# bashbripts

Attempting to write helpful bash scripts for general command line and computational chemistry applications.

<details>

<summary>To-Do List:</summary>
- [] Generalize dotfile 
- [] Add bash scripts
- [] Check conda envs

**NOTE: `tmux` implmentated only for local macos**

</details>

## [Purpose](#purpose)

A personal set of scripts to help maintain configuration/scripting/analysis files across multiple devices (MacOS/Linux). 

These scripts are geared towards:

Operating Systems (OS) - MacOS (Darwin), Linux (CentOS)
`$SHELL` - `/bin/bash`
Editor - `vi/vim`
Terminal Multiplexer - `tmux`
Conda - `miniforge3`


### Goals

* Prepare user configuration files for `bash`, `vim`, and `tmux`
* Generate the `~/Programs/` directory for general programs, like:
    * Conda (miniforge3)

Including some analysis scripts to check current state of MD simulation trajectories


### Installation

Clone to `~/Scripts`:

```
mkdir -p ~/Scripts
git@github.com:van-richard/bashbripts.git ~/Scripts/bashbripts
```

### Overview

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


## Import Commands to `$SHELL` Environment

Commands can be made accessible within the `$SHELL` environmnent by appending the directory path to `~/.bashrc`

```
echo '# My Bash Scripts
export PATH="~/Scripts/bashbripts/bin:${PATH}"' >> ~/.bashrc
```

