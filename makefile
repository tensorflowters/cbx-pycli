include .env
export $(shell sed 's/=.*//' .env)


install:
	@poetry install --no-root

update:
	@poetry update

add: lib ?= "undefined"
add:
	@poetry add ${lib}

rm: lib =?
rm:
	@poetry remove ${lib}


install_dev:
	@poetry install --no-root --without dev

add_dev: lib =?
add_dev:
	@poetry add ${lib} --group dev

rm_dev: lib =?
rm_dev:
	@poetry remove ${lib} --group dev