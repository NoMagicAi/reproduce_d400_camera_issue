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

cameras_found=$(rs-enumerate-devices | grep Serial | wc -l)
if (( $cameras_found < 4 )); then
    echo "MISSING CAMERA! XHCI RESET IN 30 SECONDS!"
    sleep 30
    sudo ./realsense_restart_xhci.sh
    if (( $cameras_found < 4 )); then
        echo "MISSING CAMERA! HARD RESET IN 30 SECONDS!"
        sleep 30
        sudo ./realsense_restart_hard.sh
    fi
else
    echo "All cameras are OK"
fi
