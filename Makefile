BIN_VERSION:=1.0.0
BIN_NAME:=msgbox
BUILD_DIR:=./bin
GO_VERSION:=1.24.3
BUILD_FLAGS:=-ldflags "-s -w -H windowsgui -X main.buildVersion=${BIN_VERSION}" -trimpath

ifneq (,$(wildcard .env))
    include .env
    export $(shell sed 's/=.*//' .env)
endif

.PHONY: all
all: build

build:
	@echo "Building..."
	@GOARCH=amd64 GOOS=windows CGO_ENABLED=0 \
	go build $(BUILD_FLAGS) -o ${BUILD_DIR}/${BIN_NAME}_syswin.exe cmd/main_syswin.go
	@GOARCH=amd64 GOOS=windows CGO_ENABLED=0 \
	go build $(BUILD_FLAGS) -o ${BUILD_DIR}/${BIN_NAME}_syscall.exe cmd/main_syscall.go

.PHONY: test
test:
	@echo "Run go test"
	go test -v ./...

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

.PHONY: clean
clean: confirm
	@echo "Cleaning up..."
	@rm -rf ${BUILD_DIR}

