NAME := "avtivka"
PKG := "veritas.icu/avtivka"
PKG_LIST := $(shell go list ${PKG}/... | grep -v /vendor/)
PKG_FILES := $(shell find . -name '*.go' | grep -v /vendor/ | grep -v _test.go)

include .env
export

.PHONY: bootstrap start build gen fmt dep test vet race msan

all: build start

bootstrap:
	go get github.com/golangci/golangci-lint/cmd/golangci-lint@v1.30.0

start: ## Start the application.
	@./${NAME}

build: ## Build the binary file.
	@go build -o ${NAME} -i -v ${PKG}

gen: ## Run code generation.
	@go generate ./...

fmt: ## Format everything.
	@goimports -w .

dep: ## Get the dependencies.
	@go get -u

test: ## Run unit tests.
	@go test -short ${PKG_LIST}

vet: ## Run the linters.
	@golangci-lint run

race: ## Run data race detector.
	@go test -race -short ${PKG_LIST}

msan: ## Run memory sanitizer.
	@go test -msan -short ${PKG_LIST}
