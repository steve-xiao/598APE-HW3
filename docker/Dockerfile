FROM ubuntu:24.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential git python3 python3-matplotlib valgrind gdb \
    linux-tools-generic && rm -rf /var/lib/apt/lists/*
WORKDIR /host
