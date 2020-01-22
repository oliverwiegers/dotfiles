# Dotfiles

> Dotfiles flying around

I use this repository to backup and restore my daily drivers and because I keep
forgetting things I keep all the information on my config in this readme.

I use the configuration mostly on my Linux systems but partly on a mac for work.
The install script is os aware and will only create symlinks for macOS useable
software if executed on macOS.

Furthermore the script will ask wether to install configuration files for Vim
and Tmux from other repositories listed down below.

## Look

Neofetch, alacritty, ZSH, oh-my-zsh, and Vim
![img](shots/buisy.png "Neofetch Alacritty Vim")
Clean desktop
![img](shots/clean.png "Clean")

## Installation

This script will clone this repo, [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting), [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) and will ask to clone my [Vim config](https://github.com/oliverwiegers/vim_config), my [Tmux config](https://github.com/oliverwiegers/.tmuxist) and my personnal [scripts](https://github.com/oliverwiegers/scripts).

```bash
$ curl -fsSL https://raw.githubusercontent.com/oliverwiegers/dotfiles/master/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

## Testing

This script of course can be tested inside a docker container.

```bash
$ docker container run -it ubuntu bash
$ apt update && apt install -y git curl fontconfig vim stow
$ curl -fsSL https://raw.githubusercontent.com/oliverwiegers/dotfiles/master/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

### Requirements

- git
- stow
- all the software this repository provides config files for

## Software list

This list provides links to the repositories/websites of software I use.

### Visible software

- [bspwm](https://github.com/baskerville/bspwm)
- [alacritty](https://github.com/alacritty/alacritty)
- [dmenu](https://tools.suckless.org/dmenu/)
- [Ranger](https://github.com/ranger/ranger)
- [Polybar](https://github.com/jaagr/polybar)
- [ZSH](https://github.com/zsh-users/zsh)
- [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

### Config files in other repositories

For Vim and Tmux I use different repositories.

- [Vim](https://github.com/oliverwiegers/vim_config)
- [Tmux](https://github.com/oliverwiegers/.tmuxist)

### Honorable mentions

This repository contains also my config files for the following software not 
seen in the screenshots.

- [Dunst](https://github.com/dunst-project/dunst.git)
- [Zathura](https://git.pwmt.org/pwmt/zathura)
- [gpicview](https://github.com/onlyshk/GPicView)
- [Ranger](https://github.com/ranger/ranger)
- [bat](https://github.com/sharkdp/bat)

### Software I also use

- [Glances](https://github.com/nicolargo/glances)
- [htop](https://github.com/hishamhm/htop)

A big shoutout to [dylanaraps](https://github.com/dylanaraps/) for 
[pywal](https://github.com/dylanaraps/pywal). This is an awesome tool. It took 
me some time to reconfigure my system to use the full potential, but it is worth
it a thousand times.
