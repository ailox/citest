all: bin/main test

bin/main: main.go
	go build -o $@ .

bin/main.exe: main.go
	GOOS=windows GOARCH=amd64 go build -o $@ .

test:
	go test ./...

clean:
	rm -rf bin/
	docker rmi ailox/citest:dev | true

container:
	docker build -t ailox/citest:dev .

.PHONY: all container clean test bin/main bin/main.exe
