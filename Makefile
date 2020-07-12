.PHONY: container-push
container-push:
	docker push peterhoward42/smeapi

.PHONY: container-build
container-build:
	docker build -t peterhoward42/smeapi .

.PHONY: test-unit
test-unit: lint
	go test -mod=vendor ./...

.PHONY: test-functional
test-functional:
	cd functional-tests && ./orchestrate-functional-tests.sh

.PHONY: run-local
run-local: build
	./build/smeapi-cmd

.PHONY: vendor
vendor:
	go mod vendor

.PHONY: build
build:
	go build -mod=vendor -o ./build/smeapi-cmd cmd/smeapi.go

# Replacing ./... (below) with the $$(...) thing to make it avoid going
# into the vendor directory.
.PHONY: fmt
fmt:
	go fmt  $$(go list ./...)

# Replacing ./... (below) with the $$(...) thing to make it avoid going
# into the vendor directory.
.PHONY: lint
lint:
	golint $$(go list ./...)
