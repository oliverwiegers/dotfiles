#!/usr/bin/env bash

if ! [ "$(command -v stow)" ] || ! [ "$(command -v git)" ]; then
    printf '\e[31mYou need to have GNU stow and git installed.\nExiting...\n'
    exit 1
fi

echo -e "\e[34m"
echo '.___                   __           .__   .__   .__'
echo '|   |  ____    _______/  |_ _____   |  |  |  |  |__|  ____     ____'
echo '|   | /    \  /  ___/\   __\\__  \  |  |  |  |  |  | /    \   / ___\'
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

dotfiles_target="$HOME/.dotfiles"
printf '\e[32mCloning repo into: \e[34m"%s"\e[0m\n' "${dotfiles_target}"
git clone https://github.com/oliverwiegers/dotfiles "${dotfiles_target}" \
    || exit 1
cd "${dotfiles_target}" || exit 1

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

omz_target="$HOME/.oh-my-zsh"
printf '\e[32mCloning oh-my-zsh into: \e[34m%s\e[0m\n' "${omz_target}"
git clone https://github.com/robbyrussell/oh-my-zsh.git "${omz_target}" \
    || exit 1
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

cd "$HOME/.dotfiles" || exit 1

printf '"Automatically create symlinks via GNU Stow? (1/2).\n'

select choice in "Yes" "No"; do
    case $choice in
        "Yes" )
            if [ "$(uname)" = "Linux" ]; then
                stow homedir
                stow config
            elif [ "$(uname)" = "Darwin" ]; then
                if [ ! -d "$HOME/.config" ]; then
                    mkdir -p "$HOME/.config/"
                fi
                ln -s "$HOME/.dotfiles/config/.config/zsh/" "$HOME/.config/zsh"
                ln -s "$HOME/.dotfiles/homedir/.zshrc" "$HOME/.zshrc"
                ln -s "$HOME/.dotfiles/config/.config/neofetch/" \
                    "$HOME/.config/neofetch"
                ln -s "$HOME/.dotfiles/config/.config/ranger/" \
                    "$HOME/.config/ranger"
            fi
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

if [ "$(uname)" = "Linux" ]; then
    printf 'Want to download and install Source Code Pro Nerdfont too? (1/2).\n'
    select choice in "Yes" "No"; do
        case ${choice} in
            "Yes" )
                curl -O https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf
                curl -O https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Light-Italic/complete/Sauce%20Code%20Pro%20Light%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
                curl -O https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
                if [ ! -d '/usr/share/fonts/TTF/' ]; then
                    mkdir -p '/usr/share/fonts/TTF/'
                fi
                mv ./*.ttf /usr/share/fonts/TTF/
                fc-cache -f
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
fi

printf 'Want to install Vim config too? (1/2).\n'

select choice in 'Yes' 'No'; do
    case "${choice}" in
        'Yes' )
            cd "$HOME" || exit 1
            git clone --recursive https://github.com/oliverwiegers/vim_config \
                .vim || exit 1
            cd "$HOME/.vim" || exit 1
            stow vimrc
            printf '\e[32mDone installing Vim config..\n\e[0m'
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

printf 'Want to install .tmuxist too? (1/2).\n'

select choice in 'Yes' 'No'; do
    case "${choice}" in
        'Yes' )
            cd "$HOME" || exit 1
            git clone --recursive https://github.com/chrootzius/.tmuxist \
                .tmuxist || exit 1
            cd "$HOME/.tmuxist" || exit 1
            stow tmux
            printf '\e[32mDone installing Tmux config..\n\e[0m'
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

printf 'Want to install helper scripts too? (1/2).\n'

select choice in 'Yes' 'No'; do
    case "${choice}" in
        'Yes' )
            cd "$HOME" || exit 1
            if [ ! -d "$HOME/Documents" ]; then
                mkdir -p "$HOME/Documents/"
            fi
            git clone https://github.com/oliverwiegers/scripts \
                "$HOME/Documents/scripts" || exit 1
            printf '\e[32mDone installing scripts..\n\e[0m'
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

printf '\e[32mFinally done.\e[0m\n'
