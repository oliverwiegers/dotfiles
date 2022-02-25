#!/usr/bin/env sh

####
#### Sanity checks.
####

# Check for supported OSes
os="$(uname)"
free_oses='FreeBSD Linux'
mac_os='Darwin'
all_oses="${free_oses} ${mac_os}"

support='false'
for item in ${all_oses}; do
    if echo "${item}" | grep -wq "${os}"; then
        support='true'
    fi
done

if [ "${support}" = 'false' ]; then
    printf 'OS: '\''%s'\'' is not supported.\n' "${os}"
    printf 'Supported OS are: '\''%s'\''.\n' "${all_oses}"
    exit 1
fi

# Set os family
os_family='free'

if [ "${os}" = 'Darwin' ]; then
    os_family="${os}"
fi

# Check for minimum needed software.
if ! [ "$(command -v stow)" ] || ! [ "$(command -v git)" ] || ! [ "$(command -v wget)" ]; then
    printf '\e[31mYou need to have GNU stow, wget and git installed.\nExiting...\n'
    exit 1
fi

# Parse environment variables for repo branch to use.
if [ -z "${GIT_BRANCH}" ]; then
    GIT_BRANCH='prod'
fi

####
#### Function definitions.
####
_clone_dotfiles() {
    dotfiles_target="$HOME/.dotfiles"
    printf '\e[32mCloning repo into: \e[34m"%s"\e[0m\n' "${dotfiles_target}"
    git clone --recursive https://github.com/oliverwiegers/dotfiles \
        "${dotfiles_target}" || exit 1
    cd "${dotfiles_target}" || exit 1
    git checkout "${GIT_BRANCH}"
    git pull origin "${GIT_BRANCH}"
    cd "$HOME" || exit 1
}

_clone_omz() {
    omz_target="$HOME/.oh-my-zsh"
    printf '\e[32mCloning oh-my-zsh into: \e[34m%s\e[0m\n' "${omz_target}"
    git clone https://github.com/robbyrussell/oh-my-zsh.git "${omz_target}" \
        || exit 1
    printf '\e[32mDone.\n\e[0m'
    cd "$HOME" || exit 1
}

_create_symlinks() {
    cd "$HOME/.dotfiles" || exit 1
    if [ "$(os_family)" = 'free' ]; then
        stow homedir
        stow config
        mkdir "$HOME/.themes"
        ln -s "$HOME/.dotfiles/extra/gruvbox-gtk" "$HOME/.themes/"
    elif [ "${os_family}" = 'Darwin' ]; then
        if [ ! -d "$HOME/.config" ]; then
            mkdir -p "$HOME/.config/"
        fi
        ln -s "$HOME/.dotfiles/config/.config/zsh/" "$HOME/.config/zsh"
        ln -s "$HOME/.dotfiles/homedir/.zshrc" "$HOME/.zshrc"
        ln -s "$HOME/.dotfiles/homedir/.p10k.zsh" "$HOME/.p10k.zsH"
        ln -s "$HOME/.dotfiles/homedir/.taskrc" "$HOME/.taskrc"
        ln -s "$HOME/.dotfiles/config/.config/neofetch/" \
            "$HOME/.config/neofetch"
        ln -s "$HOME/.dotfiles/config/.config/ranger/" \
            "$HOME/.config/ranger"
    fi
}

_install_fonts() {
    if [ "$(os_family)" = 'free' ]; then
        if [ ! -d "${HOME}/.local/share/fonts/" ]; then
            mkdir -p "${HOME}/.local/share/fonts/"
        fi

        wget -O "${HOME}/.local/share/fonts/source_code_pro_bold.ttf" \
            https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
        wget -O "${HOME}/.local/share/fonts/source_code_pro_regular.ttf" \
            https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf

        fc-cache -r
    fi
}

_install_vim_config() {
    cd "$HOME" || exit 1

    if [ -d "$HOME/.vim" ]; then
        rm -r "$HOME/.vim"
    fi

    git clone --recursive https://github.com/oliverwiegers/vim_config \
        .vim || exit 1
    cd "$HOME/.vim" || exit 1
    stow vimrc
    ./helper-scripts/manage-coc.sh -i
    printf '\e[32mDone installing Vim config..\n\e[0m'
}

_install_tmux_config() {
    cd "$HOME" || exit 1
    git clone --recursive https://github.com/chrootzius/.tmuxist \
        .tmuxist || exit 1
    cd "$HOME/.tmuxist" || exit 1
    stow tmux
    printf '\e[32mDone installing Tmux config..\n\e[0m'
}

_install_scripts() {
    cd "$HOME" || exit 1
    if [ ! -d "$HOME/.local/bin/" ]; then
        mkdir -p "$HOME/.local/bin/"
    fi
    ln -s "$HOME/.dotfiles/extra/bin/scripts" "$HOME/.local/bin/"
    printf '\e[32mDone installing scripts..\n\e[0m'
}

_output_header() {
    printf '%b' '\033[34m'
    echo '.___                   __           .__   .__   .__'
    echo '|   |  ____    _______/  |_ _____   |  |  |  |  |__|  ____     ____'
    echo '|   | /    \  /  ___/\   __\\\__  \  |  |  |  |  |  | /    \   / ___\ '
    echo '|   ||   |  \ \___ \  |  |   / __ \_|  |__|  |__|  ||   |  \ / /_/  >'
    echo '|___||___|  //____  > |__|  (____  /|____/|____/|__||___|  / \___  /'
    echo '          \/      \/             \/                      \/ /_____/'
    echo '________             __     _____ .__ .__'
    echo '\______ \    ____  _/  |_ _/ ____\|__||  |    ____    ______'
    echo ' |    |  \  /  _ \ \   __\\\   __\ |  ||  |  _/ __ \  /  ___/'
    echo ' |    `   \(  <_> ) |  |   |  |   |  ||  |__\  ___/  \___ \ '
    echo '/_______  / \____/  |__|   |__|   |__||____/ \___  >/____  >'
    echo '        \/                                       \/      \/'
    echo ' '
    echo ' /\  /\  /\ '
    echo ' \/  \/  \/ '
    printf '%b' '\033[0m'
}

_main() {
    # Print header.
    _output_header
    
    # Install configuration
    _clone_dotfiles
    _clone_omz
    _create_symlinks
    _install_fonts
    _install_vim_config
    _install_tmux_config
    _install_scripts
    
    printf '\e[32mFinally done.\e[0m\n'
}

####
#### Actually run all the stuff.
####
main "$@"
