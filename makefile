include .env
export $(shell sed 's/=.*//' .env)


py_path:
	@poetry env info --path

py_executable:
	@poetry env list --full-path

py_list_full_path:
	@poetry env info --executable

activate:
	@poetry env use $(shell poetry env info --executable)

install:
	@poetry install

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


run_main:
	@poetry run start