#!/usr/bin/env bash

# Check for minimum needed software.
if ! [ "$(command -v stow)" ] || ! [ "$(command -v git)" ]; then
    printf '\e[31mYou need to have GNU stow and git installed.\nExiting...\n'
    exit 1
fi

# Parse environment variables for repo branch to use and noninteractive mode.
if [ -z "${GIT_BRANCH}" ]; then
    GIT_BRANCH='prod'
fi

if [ -z "${NON_INTERACTIVE}" ]; then
    interactive='true'
fi

# Function definitions.

_create_symlinks() {
    if [ "$(uname)" = "Linux" ]; then
        stow homedir
        stow config
        mkdir "$HOME/.themes"
        ln -s "$HOME/.dotfiles/gruvbox-gtk" "$HOME/.themes/"
    elif [ "$(uname)" = "Darwin" ]; then
        if [ ! -d "$HOME/.config" ]; then
            mkdir -p "$HOME/.config/"
        fi
        ln -s "$HOME/.dotfiles/config/.config/zsh/" "$HOME/.config/zsh"
        ln -s "$HOME/.dotfiles/homedir/.zshrc" "$HOME/.zshrc"
        ln -s "$HOME/.dotfiles/homedir/.p10k.zsh" "$HOME/.p10k.zsH"
        ln -s "$HOME/.dotfiles/config/.config/neofetch/" \
            "$HOME/.config/neofetch"
        ln -s "$HOME/.dotfiles/config/.config/ranger/" \
            "$HOME/.config/ranger"
    fi
}

_install_fonts() {
    if [ ! -d "${HOME}/.local/share/fonts/" ]; then
        mkdir -p "${HOME}/.local/share/fonts/"
    fi

    wget -O "${HOME}/.local/share/fonts/source_code_pro_bold.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
    wget -O "${HOME}/.local/share/fonts/source_code_pro_regular.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf

    fc-cache -r
}

_install_vim_config() {
    cd "$HOME" || exit 1
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
    if [ ! -d "$HOME/Documents" ]; then
        mkdir -p "$HOME/Documents/"
    fi
    git clone https://github.com/oliverwiegers/scripts \
        "$HOME/Documents/scripts" || exit 1
    printf '\e[32mDone installing scripts..\n\e[0m'
}

_print_header() {
    echo -e "\e[34m"
    echo '.___                   __           .__   .__   .__'
    echo '|   |  ____    _______/  |_ _____   |  |  |  |  |__|  ____     ____'
    echo '|   | /    \  /  ___/\   __\\__  \  |  |  |  |  |  | /    \   / ___\ '
    echo '|   ||   |  \ \___ \  |  |   / __ \_|  |__|  |__|  ||   |  \ / /_/  >'
    echo '|___||___|  //____  > |__|  (____  /|____/|____/|__||___|  / \___  /'
    echo '          \/      \/             \/                      \/ /_____/'
    echo '________             __     _____ .__ .__'
    echo '\______ \    ____  _/  |_ _/ ____\|__||  |    ____    ______'
    echo ' |    |  \  /  _ \ \   __\\   __\ |  ||  |  _/ __ \  /  ___/'
    echo ' |    `   \(  <_> ) |  |   |  |   |  ||  |__\  ___/  \___ \ '
    echo '/_______  / \____/  |__|   |__|   |__||____/ \___  >/____  >'
    echo '        \/                                       \/      \/'
    echo ' '
    echo ' /\  /\  /\ '
    echo ' \/  \/  \/ '
    echo -e "\e[0m "
}

# Print header.
_print_header

dotfiles_target="$HOME/.dotfiles"
printf '\e[32mCloning repo into: \e[34m"%s"\e[0m\n' "${dotfiles_target}"
git clone --recursive https://github.com/oliverwiegers/dotfiles \
    "${dotfiles_target}" || exit 1
cd "${dotfiles_target}" || exit 1

git checkout "${GIT_BRANCH}"
git pull origin "${GIT_BRANCH}"

if [ -n "${interactive}" ]; then
    printf 'Going on will potentially overwrite files in "%s" Proceed? (1/2).\n' \
        "$HOME"
    select choice in 'Yes' 'No'; do
        case "${choice}" in
            'Yes' )
                printf 'Okay. Going on...\n'
                break
                ;;
            'No' )
                printf 'Okay. Exiting...\n'
                exit 0
                ;;
            '*' )
                printf '\e[31mWrong input. Try again.\e[0m\n'
        esac
    done
fi

omz_target="$HOME/.oh-my-zsh"
printf '\e[32mCloning oh-my-zsh into: \e[34m%s\e[0m\n' "${omz_target}"
git clone https://github.com/robbyrussell/oh-my-zsh.git "${omz_target}" \
    || exit 1
cp "$HOME/.dotfiles/oliverwiegers.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/"
printf '\e[32mDone.\n\e[0m'

powerlevel10k_target="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
printf '\e[32mCloning powerlevel10k into: \e[34m%s\e[0m\n' \
    "${powerlevel10k_target}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "${powerlevel10k_target}" || exit 1
printf '\e[32mDone.\n\e[0m'

highlight_target="$HOME/.zsh-syntax-highlighting"
printf '\e[32mCloning zsh-syntax-highlighting into: \e[34m%s\e[0m\n' \
    "${highlight_target}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${highlight_target}" || exit 1
printf '\e[32mDone.\n\e[0m'

suggest_target="$HOME/.zsh-autosuggestions"
printf '\e[32mCloning zsh-autosuggestions into: \e[34m%s\e[0m\n' \
    "${suggest_target}"
git clone https://github.com/zsh-users/zsh-autosuggestions.git \
    "${suggest_target}" || exit 1
printf '\e[32mDone.\n\e[0m'

ranger_devicons_target="$HOME/.config/ranger/plugins"
[ ! -d "${ranger_devicons_target}" ] && mkdir -p "${ranger_devicons_target}"
printf '\e[32mCloning ranger-devicons into: \e[34m%s\e[0m\n' \
    "${ranger_devicons_target}"
git clone https://github.com/alexanderjeurissen/ranger_devicons \
    "${ranger_devicons_target}" || exit 1
printf '\e[32mDone.\n\e[0m'

cd "$HOME/.dotfiles" || exit 1

if [ -n "${interactive}" ]; then
    printf '"Automatically create symlinks via GNU Stow? (1/2).\n'
    select choice in "Yes" "No"; do
        case $choice in
            "Yes" )
                _create_symlinks
                break
                ;;
            "No" )
                printf 'Okay. Going on...\n'
                break
                ;;
            "*" )
                printf '\e[31mWrong input. Try again.\e[0m\n'
        esac
    done
else
    _create_symlinks
fi

if [ "$(uname)" = "Linux" ]; then
    if [ -n "${interactive}" ]; then
        printf 'Want to download and install Source Code Pro Nerdfont too? (1/2).\n'
        select choice in "Yes" "No"; do
            case ${choice} in
                "Yes" )
                    _install_fonts
                    break
                    ;;
                "No" )
                    printf 'Okay. Going on...\n'
                    break
                    ;;
                "*" )
                    printf '\e[31mWrong input. Try again.\e[0m\n'
            esac
        done
    else
        _install_fonts
    fi
fi

if [ -n "${interactive}" ]; then
    printf 'Want to install Vim config too? (1/2).\n'
    select choice in 'Yes' 'No'; do
        case "${choice}" in
            'Yes' )
                _install_vim_config
                break
                ;;
            'No' )
                printf 'Okay. Going on...\n'
                break
                ;;
            '*' )
                printf '\e[31mWrong input. Try again.\e[0m\n'
        esac
    done
else
    _install_vim_config
fi


if [ -n "${interactive}" ];then
    printf 'Want to install .tmuxist too? (1/2).\n'
    select choice in 'Yes' 'No'; do
        case "${choice}" in
            'Yes' )
                _install_tmux_config
                break
                ;;
            'No' )
                printf 'Okay. Going on...\n'
                break
                ;;
            '*' )
                printf '\e[31mWrong input. Try again.\e[0m\n'
        esac
    done
else
    _install_tmux_config
fi

if [ -n "${interactive}" ];then
    printf 'Want to install helper scripts too? (1/2).\n'
    select choice in 'Yes' 'No'; do
        case "${choice}" in
            'Yes' )
                _install_scripts
                break
                ;;
            'No' )
                printf 'Okay. Going on...\n'
                break
                ;;
            '*' )
                printf '\e[31mWrong input. Try again.\e[0m\n'
        esac
    done
else
    _install_scripts
fi

printf '\e[32mFinally done.\e[0m\n'
