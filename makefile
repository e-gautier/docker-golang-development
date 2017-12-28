SHELL:=/bin/bash
D=docker
RUN=${D} run --rm -v "${PWD}"/go:/go golang

.PHONY: help

help:
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"


install: ## install go environement
	${RUN} mkdir -p /go/src /go/bin
	${RUN} go get github.com/derekparker/delve/cmd/dlv
	${RUN} go get github.com/revel/revel
	${RUN} go get github.com/revel/cmd/revel
	${RUN} go get github.com/mattn/go-sqlite3
	${RUN} go get github.com/go-gorp/gorp

revel: ## start revel on a project (eg. make start project=myapp)
	${D} run --rm -p 80:80 -v "${PWD}"/go:/go golang revel run ${project}

