#!/bin/bash

# Copyright (c) 2017, NVIDIA CORPORATION. All rights reserved.
# Full license terms provided in LICENSE.md file.

MOVIDIUS_PATH=$1
if [[ -z "${NCSDK_PATH}" ]]; then
    echo "First argument is missing."
    echo "Usage  : build_movidius.sh <full_path_to_movidius>"
    echo "Example: build_movidius.sh /data/src/movidius"
    exit 1
fi

cd ${CATKIN_WS}

#if [[ ! -L "${CATKIN_WS}/src/caffe_ros" ]]; then
#    ln -s ${NCSDK_PATH}/ros/packages/caffe_ros ${CATKIN_WS}/src/
#    catkin_make caffe_ros_node -DCUDA_USE_STATIC_CUDA_RUNTIME=OFF
#fi

if [[ ! -L "${CATKIN_WS}/src/ros_intel_movidius_ncs" ]]; then
    ln -s ${NCSDK_PATH}/ros/packages/ros_intel_movidius_ncs ${CATKIN_WS}/src/
fi

#if [[ ! -L "${CATKIN_WS}/src/px4_controller" ]]; then
#    ln -s ${NCSDK_PATH}/ros/packages/px4_controller ${CATKIN_WS}/src/
#fi

catkin build
