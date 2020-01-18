#!/usr/bin/env bash

if ! [ "$(command -v stow)" ] || ! [ "$(command -v git)" ]; then
    printf '\e[31mYou need to have GNU stow and git installed.\nExiting...'
    exit 1
fi

header="
.___                   __           .__   .__   .__
|   |  ____    _______/  |_ _____   |  |  |  |  |__|  ____     ____
|   | /    \  /  ___/\   __\\__  \  |  |  |  |  |  | /    \   / ___\
|   ||   |  \ \___ \  |  |   / __ \_|  |__|  |__|  ||   |  \ / /_/  >
|___||___|  //____  > |__|  (____  /|____/|____/|__||___|  / \___  /
          \/      \/             \/                      \/ /_____/
________             __     _____ .__ .__
\______ \    ____  _/  |_ _/ ____\|__||  |    ____    ______
 |    |  \  /  _ \ \   __\\   __\ |  ||  |  _/ __ \  /  ___/
 |    |   \(  <_> ) |  |   |  |   |  ||  |__\  ___/  \___ \ 
/_______  / \____/  |__|   |__|   |__||____/ \___  >/____  >
        \/                                       \/      \/
 
 /\  /\  /\ 
 \/  \/  \/ "
printf '\e[34m%s\e[0m' "${header}"

sleep 1

backup_folder="$HOME/config_backup/"

printf '\e[32mCreating backup folder: \e[34m%s\e[0m\n' "${backup_folder}"
mkdir "${backup_folder}"

printf "Moving: \e[32m\n%s/.config \n%s/.fehbg \n%s/.themes\n %s/.xinitrc\n %s/.zshrc\n\e[0m to \e[34m%s.\e[0m.\n" \
    "$HOME" "$HOME" "$HOME" "$HOME" "$HOME" "${backup_folder}"
mv "$HOME/.config" "$HOME/.fehbg" "$HOME/.themes" "$HOME/.xinitrc" \
    "$HOME/.zshrc" "${backup_folder}" 2> /dev/null 

printf '\e[32mCloning oh-my-zsh into: \e[34m%s/.oh-my-zsh\e[0m' "$HOME"
git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"
printf '\e[32mDone.\n\e[0m'

prinf '\e[32mCloning zsh-syntax-highlighting into: \e[34m%s/.zsh-syntax-hihghlighting\e[0m' \
    "$HOME"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
	"$HOME/.zsh-syntax-highlighting"
printf '\e[32mDone.\n\e[0m'

printf '\e[32mCloning zsh-autosuggestions into: \e[34m%s/.zsh-autosuggestions\e[0m' \
    "$HOME"
git clone https://github.com/zsh-users/zsh-autosuggestions.git \
    "$HOME/.zsh-autosuggestions"
printf '\e[32mDone.\n\e[0m'

cd "$HOME/.dotfiles" || exit 1

printf '"Automatically create symlinks via GNU Stow? (1/2).'

select choice in "Yes" "No"; do
    case $choice in
        "Yes" )
            if [[ "$(uname)" == "Linux" ]]; then
                stow homedir
                stow config
            elif [[ "$(uname)" == "Darwin" ]]; then
                if [[ ! -d $HOME/.config ]]; then
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
            echo -e "Okay. Going on...\n"
            break
            ;;
        "*" )
            echo -e "\e[31mWrong input. Try again.\e[0m"
    esac
done

if [ "$(uname)" = "Linux" ]; then
    echo -e "Want to download and install Source Code Pro Nerdfont too? (1/2)."
    
    select choice in "Yes" "No"; do
        case $choice in
            "Yes" )
                curl -O https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf
                curl -O https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Light-Italic/complete/Sauce%20Code%20Pro%20Light%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
                curl -O https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
                mv ./*.ttf /usr/share/fonts/TTF/
                fc-cache -f
                break
                ;;
            "No" )
                echo -e "Okay. Going on...\n"
                break
                ;;
            "*" )
                echo -e "\e[31mWrong input. Try again.\e[0m"
        esac
    done
fi

printf 'Want to install Vim config too? (1/2).'

select choice in 'Yes' 'No'; do
    case "${choice}" in
        'Yes' )
            cd "$HOME" || exit 1
            git clone --recursive https://github.com/oliverwiegers/vim_config \
                .vim
            cd "$HOME/.vim" || exit 1
            stow vimrc
            printf '\e[32mDone installing Vim config..\n\e[0m'
            break
            ;;
        'No' )
            printf 'Okay. Going on...\n'
            break ;;
        '*' )
            printf '\e[31mWrong input. Try again.\e[0m'
    esac
done

printf 'Want to install .tmuxist too? (1/2).'

select choice in 'Yes' 'No'; do
    case "${choice}" in
        'Yes' )
            cd "$HOME" || exit 1
            git clone --recursive https://github.com/chrootzius/.tmuxist \
                .tmuxist
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
            printf '\e[31mWrong input. Try again.\e[0m'
    esac
done

printf 'Want to install helper scripts too? (1/2).'

select choice in 'Yes' 'No'; do
    case "${choice}" in
        'Yes' )
            cd "$HOME" || exit 1
            if [ ! -d "$HOME/Documents" ]; then
                mkdir -p "$HOME/Documents/"
            fi
            git clone https://github.com/oliverwiegers/scripts \
                "$HOME/Documents/scripts"
            printf '\e[32mDone installing scripts..\n\e[0m'
            break
            ;;
        'No' )
            printf 'Okay. Going on...\n'
            break
            ;;
        '*' )
            printf '\e[31mWrong input. Try again.\e[0m'
    esac
done

printf '\e[32mFinally done.\e[0m\n'
