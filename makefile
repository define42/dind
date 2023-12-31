all:
	docker build -t dind .
	docker run -it --privileged dind /bin/sh
test:
	docker pull define42/dind:latest
	docker run -it --privileged define42/dind:latest /bin/sh
