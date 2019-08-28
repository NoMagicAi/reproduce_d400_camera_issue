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

source /code/devel/setup.bash

echo "Launching camera 1: $EXP_CAM_1"
echo "Launching camera 2: $EXP_CAM_2"
echo "Launching camera 3: $EXP_CAM_3"
echo "Launching camera 4: $EXP_CAM_4"

roslaunch realsense2_camera 4_cameras.launch \
serial_no_camera1:=$EXP_CAM_1 \
serial_no_camera2:=$EXP_CAM_2 \
serial_no_camera3:=$EXP_CAM_3 \
serial_no_camera4:=$EXP_CAM_4 \
