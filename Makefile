
all: deps lint test-deploy

deps:
	python -m pip install --upgrade pip
	pip install ansible==2.10.7
	printf '[defaults]\nroles_path=../' > ansible.cfg
	ansible-galaxy install infn-datacloud.containerd

lint: deps
	ansible-playbook tests/test.yml -i tests/inventory --syntax-check

test-deploy: deps
	ansible-playbook -b tests/test.yml -i tests/inventory