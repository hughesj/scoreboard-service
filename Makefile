PORT = 32784
IMAGE = leaderboard:v1.0.0
CHART = chart/leaderboard

all: build docker deploy

.PHONY: clean
clean:
	mvn clean

.PHONY: build
build:
	mvn package

.PHONY: docker
docker:
	docker build -t $(IMAGE) .

.PHONY: run
run:
	docker run --rm -p$(PORT):9080 $(IMAGE)

.PHONY: verify
verify:
	mvn liberty:test-start-server
	mvn pact:verify
	mvn liberty:test-stop-server
	
.PHONY: deploy
deploy:
	helm dependency build $(CHART)
	helm upgrade --wait --install leaderboard $(CHART)
