SHELL:=/bin/bash
D=docker
RUN=${D} run --rm -v "${PWD}"/go:/go golang

.PHONY: help

help:
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"


install: ## install go environement
	${RUN} mkdir -p /go/src /go/bin
	${RUN} chmod 777 /go
	${RUN} go get github.com/derekparker/delve/cmd/dlv
	${RUN} go get github.com/revel/revel
	${RUN} go get github.com/revel/cmd/revel
	${RUN} go get github.com/mattn/go-sqlite3
	${RUN} go get github.com/go-gorp/gorp
	${RUN} go get github.com/bradfitz/gomemcache/memcache
	${RUN} go get github.com/valyala/fasthttp

runrevel: ## start revel on a project (eg. make start project=myapp port=8080)
	test ${project}                                         
	test ${port}                                         
	${D} run --rm -p ${port}:8080 -v "${PWD}"/go:/go golang revel run ${project}

buildrevel: ## build revel
	test ${project}                                         
	${D} run --rm -v "${PWD}"/go:/go golang revel build ${project}

delve: ## start delve (eg. make delve port=8080)
	${D} run --rm -v "${PWD}"/go:/go --security-opt=seccomp:unconfined golang dlv debug --headless --listen=:${port} --api-version=2 ${project}

