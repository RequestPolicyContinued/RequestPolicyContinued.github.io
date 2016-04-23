SHELL := /bin/bash
server_port := 27283

all: build 404s

build:
	@echo "### Building HTML documentation"
	@./build.sh



start-server: .server.$(server_port).PID

.server.$(server_port).PID:
	@echo "### Starting server"
	@python -m SimpleHTTPServer $(server_port) > /dev/null 2>&1 & echo $$! > $@
	@sleep 1

stop-server: .server.$(server_port).PID
	@echo "### Stopping server"
	@kill -15 `cat $<` && rm $<

wget-404:
	@echo "### 404 errors"
	@wget --no-verbose --spider --recursive --page-requisites \
	http://127.0.0.1:$(server_port)/index.html 2>&1 | \
	grep -B1 404
	@echo

404s: start-server wget-404 stop-server

.PHONY: all build start-server stop-server wget-404 404s
