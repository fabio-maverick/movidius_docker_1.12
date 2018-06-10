#!/bin/bash

# Copyright (c) 2017, NVIDIA CORPORATION. All rights reserved.
# Full license terms provided in LICENSE.md file.

NCSDK_NAME=$1
if [[ -z "${NCSDK_NAME}" ]]; then
    NCSDK_NAME=movidius_sdk
fi

HOST_DATA_DIR=$2
if [[ -z "${HOST_DATA_DIR}" ]]; then
    HOST_DATA_DIR=/data/
fi

CONTAINER_DATA_DIR=$3
if [[ -z "${CONTAINER_DATA_DIR}" ]]; then
    CONTAINER_DATA_DIR=/data/
fi

echo "Container name    : ${NCSDK_NAME}"
echo "Host data dir     : ${HOST_DATA_DIR}"
echo "Container data dir: ${CONTAINER_DATA_DIR}"
NCSDK_ID=`docker ps -aqf "name=^/${NCSDK_NAME}$"`
if [ -z "${NCSDK_ID}" ]; then
    echo "Creating new redtail container."
    xhost +
    nvidia-docker run -it --privileged --network=host -v /dev:/dev -v ${HOST_DATA_DIR}:${CONTAINER_DATA_DIR}:rw -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix${DISPLAY} -p 14556:14556/udp --name=${NCSDK_NAME} ncsdk:ubuntu16.04 bash
else
    echo "Found redtail container: ${NCSDK_ID}."
    # Check if the container is already running and start if necessary.
    if [ -z `docker ps -qf "name=^/${NCSDK_NAME}$"` ]; then
        xhost +local:${NCSDK_ID}
        echo "Starting and attaching to ${NCSDK_NAME} container..."
        docker start ${NCSDK_ID}
        docker attach ${NCSDK_ID}
    else
        echo "Found running ${NCSDK_NAME} container, attaching bash..."
        docker exec -it ${NCSDK_ID} bash
    fi
fi

