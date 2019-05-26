# Makefile was copied from a random github repository. If something doesn't work this can be the reason...

export GO111MODULE=on

APPLICATION_NAME:=quizservice

.PHONY: test
test: ## Run all the tests
	echo 'mode: atomic' > coverage.txt && go test -covermode=atomic -coverprofile=coverage.txt -v -race -timeout=30s ./...

.PHONY: cover
cover: test ## Run all the tests and opens the coverage report
	go tool cover -html=coverage.txt

.PHONY: fmt
fmt: ## Run goimports on all go files
	find . -name '*.go' -not -wholename './vendor/*' | while read -r file; do goimports -w "$$file"; done

.PHONY: lint
lint: ## Run all the linters
	golangci-lint run

.PHONY: build
build: ## Build a version
	go build -v .

.PHONY: clean
clean: ## Remove temporary files
	go clean

# Absolutely awesome: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := build

.PHONY: docker-build
docker-build:
	docker pull alpine:latest
	docker build -t gremiumsoft/${APPLICATION_NAME} .

.PHONY: docker-deploy
docker-deploy: docker-build
	docker push gremiumsoft/${APPLICATION_NAME}

.PHONY: deploy-latest
deploy-latest:
	kubectl patch deployment ${APPLICATION_NAME} -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"

.PHONY: kube-apply
kube-apply:
	kubectl apply -f k8s/
