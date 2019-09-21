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

# Check if proper ENV flags were passed
[ -z "$EXP_HOST" ] && echo "Missing env: EXP_HOST" && exit
[ -z "$EXP_ATTEMPTS" ] && echo "Missing env: EXP_ATTEMPTS" && exit
[ -z "$EXP_ON_FILE" ] && echo "Assuming no file to stop experiment."

[ -z "$EXP_CAM_1" ] && echo "Missing env: EXP_CAM_1" && exit

[ -z "$EXP_CAMERAS_NUMBER" ] && echo "Missing env: EXP_CAMERAS_NUMBER" && exit

# Define names of files, where experiment logs will be stored
start_date=$(date +%Y%m%d-%H%M%S)
log_experiment='results/'$start_date'_experiment.log'
log_realsense='results/'$start_date'_realsense.log'
server_test_path='tmp/realsense_test_'$start_date

# Copy source files of experiment to experiment host machine
echo "Copying sources to experiment's server"
ssh $EXP_HOST "mkdir -p $server_test_path"
rsync src/* $EXP_HOST:$server_test_path

# Build docker image for the experiment
echo "Building docker image for the experiment"
ssh $EXP_HOST "cd $server_test_path && ./docker_build.sh"

# Main loop of the experiment
for i in $(seq 1 $EXP_ATTEMPTS)
do

    # Write some debug info on screen and to file
    message="\
    ==========================\n\
    New attempt: $i/$EXP_ATTEMPTS\n\
    Date: $(date)"

    echo -e $message
    echo -e $message >> $log_experiment
    echo -e $message >> $log_realsense

    # Wait for the SSH  connection with experiment host
	until ssh $EXP_HOST "echo Connected."
	do
		sleep 5
		echo "Trying to SSH..."
	done

    # Check if the file allowing to continue the experiment exists
    if [ -z "$EXP_ON_FILE" ]; then
        echo "No file to stop experiment defined. Continuing experiment."
    else
        if [ -f "$EXP_ON_FILE" ]; then
            echo "File $EXP_ON_FILE found! Continuing experiment."
        else
            echo "File $EXP_ON_FILE not found! Stopping experiment."
            echo "File $EXP_ON_FILE not found! Stopping experiment." >> $log_experiment
            exit
        fi
    fi

    # Remove all running and existing containers on experiment host machine
	echo "Removing existing docker containers"
	ssh $EXP_HOST 'docker rm -f $(docker ps -aq)'

    # Start realsense nodes for defined cameras
	echo "Starting cameras"
	ssh $EXP_HOST "cd $server_test_path && \
	EXP_CAM_1=$EXP_CAM_1 \
	./docker_run.sh ./1_cameras.sh" >> $log_realsense 2>> $log_realsense &
    sleep 60

    # If some cameras are missing, apply XHCI reset. If this does not help, apply HARD reset.
	echo "Checking if some camera is missing"

    while (( $(ssh $EXP_HOST "(rs-enumerate-devices | grep Serial | wc -l)") == $EXP_CAMERAS_NUMBER ))
    do
        echo "Attempt $i; Date: $(date); All cameras OK" >> $log_experiment
        sleep 5
            # Check if the file allowing to continue the experiment exists
        if [ -z "$EXP_ON_FILE" ]; then
            echo "No file to stop experiment defined. Continuing experiment."
        else
            if [ -f "$EXP_ON_FILE" ]; then
                echo "File $EXP_ON_FILE found! Continuing experiment."
            else
                echo "File $EXP_ON_FILE not found! Stopping experiment."
                echo "File $EXP_ON_FILE not found! Stopping experiment." >> $log_experiment
                exit
            fi
        fi

    done

    echo "Attempt $i; Date: $(date); Broken camera detected" >> $log_experiment

	ssh $EXP_HOST "cd $server_test_path && ./realsense_restart_hard.sh" >> $log_experiment 2>> $log_experiment

done
