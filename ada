FROM ubuntu
RUN apt-get update && apt-get upgrade -y
RUN apt-get install gnat gprbuild -y
VOLUME ["/src"]
WORKDIR /src
CMD gprbuild -P default.gpr