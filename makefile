include .env
export $(shell sed 's/=.*//' .env)


poe_path:
	@poetry env info --path

poe_executable:
	@poetry env list --full-path

py_list_full_path:
	@poetry env info --executable

poe_activate:
	@poetry shell

poe_install:
	@poetry install

poe_update:
	@poetry update

poe_add: lib ?= "undefined"
poe_add:
	@poetry add ${lib}

poe_rm: lib =?
poe_rm:
	@poetry remove ${lib}


poe_install_dev:
	@poetry install --no-root --without dev

poe_add_dev: lib =?
poe_add_dev:
	@poetry add ${lib} --group dev

poe_rm_dev: lib =?
poe_rm_dev:
	@poetry remove ${lib} --group dev

poe_build:
	@poetry build

local_install:
	@pipx install --user /home/athernatos/workspace/cyb-devtools/cbx-pycli/dist/cbx_pycli-0.1.0-py3-none-any.whl