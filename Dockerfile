FROM ubuntu:20.04

RUN apt-get update && apt-get install -y git curl fontconfig vim stow zsh\
    shellcheck iproute2 taskwarrior bat

ARG GIT_BRANCH=prod
ENV GIT_BRANCH ${GIT_BRANCH}

WORKDIR /root/

RUN curl -fsSL\
    https://raw.githubusercontent.com/oliverwiegers/dotfiles/${GIT_BRANCH}/install.sh -o install.sh \
    && chmod +x install.sh && NON_INTERACTIVE=true ./install.sh \
    && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ./.fzf/install --no-update-rc --no-key-bindings --no-completion \
    && mkdir -p /usr/share/doc/fzf/examples/ \
    && cp ./.fzf/plugin/fzf.vim /usr/share/doc/fzf/examples/

CMD ["/bin/zsh"]
