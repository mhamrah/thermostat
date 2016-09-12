
.PHONY: generate

generate:
	@echo Generating
	@go generate
	@go build .
