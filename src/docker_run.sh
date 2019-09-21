#!/bin/bash

# Copyright 2019 NoMagic Sp. z o.o.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

docker run \
	--rm \
	--name roe \
	--privileged \
	--network=host \
	-e EXP_CAM_1 \
	-e EXP_CAM_2 \
	-e EXP_CAM_3 \
	-e EXP_CAM_4 \
	-v $(pwd)/1_cameras.launch:/code/src/realsense-ros/realsense2_camera/launch/1_cameras.launch \
	-v $(pwd)/1_cameras.sh:/code/1_cameras.sh \
	-v $(pwd)/4_cameras.launch:/code/src/realsense-ros/realsense2_camera/launch/4_cameras.launch \
	-v $(pwd)/4_cameras.sh:/code/4_cameras.sh \
	nomagic-realsense-ros-base-aarch64 \
	$@
