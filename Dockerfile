FROM ubuntu:latest

RUN apt-get update && apt-get install -y git curl fontconfig vim stow zsh\
    shellcheck iproute2 taskwarrior

ARG GIT_BRANCH=prod
ENV GIT_BRANCH ${GIT_BRANCH}

WORKDIR /root/

RUN curl -fsSL\
    https://raw.githubusercontent.com/oliverwiegers/dotfiles/${GIT_BRANCH}/install.sh\
    -o install.sh && chmod +x install.sh

CMD ["/bin/zsh"]
