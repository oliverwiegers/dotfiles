Nothing:

all: Nothing

.SILENT:

lint: shellcheck markdownlint

shellcheck:
	docker container run --rm -it -v $(shell pwd):/mnt \
		koalaman/shellcheck\
		install.sh

markdownlint:
	docker container run --rm -it -v $(shell pwd):/data \
		markdownlint/markdownlint \
		README.md

install:
	NON_INTERACTIVE=true ./install.sh

test-remote:
	docker build -t install_test:"prod" --build-arg GIT_BRANCH="prod" .
	docker container run -it install_test:"prod"\
		bash -c 'NON_INTERACTIVE=true ./install.sh && zsh'

test-local:
	export branch="$(git rev-parse --abbrev-ref HEAD)"
	docker build -t install_test:"${branch}" --build-arg GIT_BRANCH="${branch}" .
	docker container run -v $PWD:/root/.dotfiles -it install_test:"${branch}"\
		bash -c 'cd .dotfiles && NON_INTERACTIVE=true ./install.sh && zsh'
