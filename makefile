all:
		docker build -t dind .
		docker run --privileged -d --name dind dind
stop:
		docker stop dind
		docker rm dind
