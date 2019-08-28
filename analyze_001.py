#!/usr/bin/env python

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

import os
import sys

# TODO This might need to be changed after adding more logs or more cameras. This solution is bad, but simple.
# If two HARD failures occurs in logs in distance smaller than this number,
# they are considered to belong to consecutive attempts
MIN_LINES_BETWEEN_CONSECUTIVE_HARD_FAILURES = 50

assert os.path.exists(sys.argv[1])
f=open(sys.argv[1], 'r')
lines = f.readlines()
f.close()

xhci_resets=[]
hard_resets=[]
consecutive_resets=[]
unsolveable_periods=[]

# Calculate amount of XHCI and HARD resets.
# Each time we detect a missing camera, we start from XHCI reset,
# so amount of XHCI resets is equal to amount of detected problems
for l in range(len(lines)):
    if "MISSING CAMERA! XHCI RESET" in lines[l]:
        xhci_resets.append(l)
    if "MISSING CAMERA! HARD RESET" in lines[l]:
        hard_resets.append(l)

# Calculate amount of problems that were not solved even by hard reset.
# This happens if two consecutive iterations are finishing with hard reset
if len(hard_resets) > 1:
    for r in range(1, len(hard_resets)):
        if hard_resets[r] - hard_resets[r-1] < MIN_LINES_BETWEEN_CONSECUTIVE_HARD_FAILURES:
            consecutive_resets.append(hard_resets[r])

# Calculate amount of periods, during which missing camera could not be resolved by hard reset
# Periods are separated by the attempts where all cameras were OK.
if len(consecutive_resets) > 0:
    unsolveable_periods.append(consecutive_resets[0])
if len(consecutive_resets) > 1:
    for f in range(1, len(consecutive_resets)):
        if consecutive_resets[f] - consecutive_resets[f-1] > MIN_LINES_BETWEEN_CONSECUTIVE_HARD_FAILURES:
            unsolveable_periods.append(consecutive_resets[f])

# Print a summary of the experiment:
print("---")
for reset in xhci_resets:
    print("XHCI reset applied in line: {}".format(reset))
print("---")
for reset in hard_resets:
    print("HARD reset applied in line: {}".format(reset))
print("---")
for reset in consecutive_resets:
    print("Consecutive HARD reset applied in line: {}".format(reset))
print("---")
print("All problems: {}".format(len(xhci_resets)))
print("Problems solved by XHCI reset: {}".format(len(xhci_resets)-len(hard_resets)))
print("Problems solved by HARD reset: {}".format(len(hard_resets)-len(consecutive_resets)))
print("Problems NOT solved by HARD reset: {}".format(len(consecutive_resets)))
print("Unsolveable camera problem periods: {}".format(len(unsolveable_periods)))
