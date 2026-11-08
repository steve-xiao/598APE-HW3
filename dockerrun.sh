#!/usr/bin/env bash
# perf inside a container needs extra privileges
docker run -it --rm --cap-add SYS_ADMIN -v "$(pwd)":/host sandpile /bin/bash
