# Experiment that reproduces an issue of hanging Realsense D400 series cameras

## Hardware used for the experiment:
1. Desktop PC with Intel(R) Xeon(R) W-2133 6x3.6GHz CPU (HOST)
2. USB 3.0 PCI-E Card with 4 separate USB controllers Delock(R) 89365
3. 4 cables TetherPro(R) USB 3.0 to USB-C
4. 4 Intel(R) RealSense(TM) D415 Cameras with firmware 05.11.01.00
5. Any other PC with remote access to the HOST (CLIENT)

## Hardware arrangment:
1. PCI-E card is connected to HOST
2. Realsense cameras are connected with USB cables to PCI-E card on HOST
3. CLIENT is in the same network as HOST, and can SSH to HOST without a password

## Software used for the experiment:
HOST:
1. Ubuntu 16.04.6 LTS
2. SSH and SCP access from CLIENT without password
3. Bash version 4.3.48(1)-release
4. Docker version 18.09.1
5. Kernel version 4.4.0-131-generic (2.6.22 or newer with wakealarm enabled required for "HARD restart")

CLIENT:
1. Ubuntu 16.04.6 LTS
2. SSH and SCP access to HOST without password
3. Bash version 4.3.48(1)-release
4. Python version 2.7.12 (only for analysis)

## Overview of the experiment:
Experiment is controlled from CLIENT and performed on HOST with commands executed via SSH. 
This allows to reboot HOST during the experiment, without loosing any context.
All logs from the experiment are recorded on CLIENT.

At the beginning of the experiment, CLIENT copies experiment source files to HOST 
and build Docker image for the experiment on HOST. Next, in the loop, 
following actions are being executed on HOST:
1. Start docker container with 4 realsense_ros nodes and wait for short time.
2. Kill previously started container with SIGKILL.
3. Check if some camera is missing with rs-enumerate-devices.
4. Apply XHCI reset restart if some camera is missing (reset USB device driver).
5. Apply HARD if camera is still missing (shutdown HOST PC and boot it after 3 minutes with wakealarm).

## To start experiment, run on CLIENT:

`EXP_CAM_1=<1> EXP_CAM_2=<2> EXP_CAM_3=<3> EXP_CAM_4=<4> EXP_HOST=<5> EXP_ATTEMPTS=<6> EXP_ON_FILE=<7> ./experiment_001.sh`

where:
* <1> - ID of 1'st Realsense camera
* <2> - ID of 2'nd Realsense camera
* <3> - ID of 3'rd Realsense camera
* <4> - ID of 4'th Realsense camera
* <5> - combination `<user>@<hostname>` allowing to SSH to the HOST
* <6> - number of experiment attempts to perform (order of magnitude: 100 per hour)
* <7> - [Optional] path to existing file, after removing this file experiment will be stopped

Experiment will be running until finishing all requested attemtps, or until removing EXP_ON_FILE, if it was passed.
During the experiment, HOST PC might be shutdowned and woke up multiple times. 
All Experiment logs will be stored in `results` directory, under the format descibed in `results/README.md`

## To analyze experiment data, run on CLIENT:

`./analyze_001.py results/<1>_experiment.log`

where:
* <1> - date of experiment begin in format `<year><month><day>-<hour><minute><second>`

Output of analysis will include: 
* lines in the experiment log describing XHCI reset 
(reset by unbinding and binding XHCI USB driver)
* lines in the experiment log describing HARD reset 
(reset by shutting down PC and booting it up after 3 minutes with wakealarm)
* lines in the experiment log describing Consecutive HARD reset 
(HARD reset that happened in the iteration preceded by another HARD reset)
* summary presenting amount of detected problems and problems solved by available reset policies
