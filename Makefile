.PHONY: setup
setup: install db-prepare

.PHONY: start
start:
	rm -rf tmp/pids/server.pid || true
	bin/rails s

.PHONY: install
install:
	bin/setup

.PHONY: db-prepare
db-prepare:
	bin/rails db:drop
	bin/rails db:create
	bin/rails db:migrate
	bin/rails db:fixtures:load

.PHONY: check
check: test lint

.PHONY: test
test:
	bin/rails test

.PHONY: lint
lint:
	bundle exec rubocop
	bundle exec slim-lint app/views/
