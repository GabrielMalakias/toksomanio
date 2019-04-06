.PHONY: help

APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`

help:
	@echo "$(APP_NAME):$(APP_VSN)-$(BUILD)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

lala: ## Build the Docker image
	@echo "**** Compile and Create Build artifact  ****";\
	docker build -t toksomanio-build -f build/Dockerfile.build . ;\
	echo "**** Copies Build Artifact from build step and bakes final image ****";\
	CONTAINER_ID=$$(docker create toksomanio-build);\
	docker cp $$CONTAINER_ID:/opt/app/_build/prod/rel/toksomanio/releases/0.1.0/toksomanio.tar.gz . ;\
	docker rm -v $$CONTAINER_ID;\
	docker build -t gabrielmalakias/$(APP_NAME):latest -f build/Dockerfile.release .;\

run: ## Run the app in Docker
	docker run --expose 4000 -p 4000:4000 \
		--rm -it gabrielmalakias/$(APP_NAME):latest



