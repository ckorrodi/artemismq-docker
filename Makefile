docker-build:
	@docker build -t artemis .

docker-create:
	@echo "-- Creating Container --"
	@docker create --name artemis-node-0 \
					-v $(shell pwd)/:/opt/artemis/:Z \
					-p 8080:80 -p 8161:8161 -p 5672:5672 -p 61613:61613 -p 61616:61616 \
					artemis

docker-start:
	@echo "-- Starting Container --"
	@docker start artemis-node-0

docker-enter:
	@echo "-- Entering Container --"
	@docker exec -it artemis-node-0 /bin/bash

docker-stop:
	@echo "-- Stopping Container --"
	@docker stop artemis-node-0
