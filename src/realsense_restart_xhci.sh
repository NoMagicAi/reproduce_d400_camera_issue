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

echo "=== realsense-restart-xhci ==="
echo $(date)
echo "XHCI Realsense restart scheduled"
echo "Available Realsense cameras:"
rs-enumerate-devices | grep Serial

xhci_bind="/sys/bus/pci/drivers/xhci_hcd/bind"
xhci_unbind="/sys/bus/pci/drivers/xhci_hcd/unbind"
xhci_cameras=$(find /sys/bus/pci/drivers/xhci_hcd/ -name "*0000:*" -not -name "*0000:00:14.0" -printf "%f\n")

echo "Unbinding..."
for i in $xhci_cameras; do
    echo "echo $i > $xhci_unbind"
    echo "$i" > "$xhci_unbind"
done
sleep 1
echo "Binding..."
for i in $xhci_cameras; do
    echo "echo $i > $xhci_bind"
    echo "$i" > "$xhci_bind"
done
sleep 1
echo "XHCI restart finished. Available Realsense cameras:"
rs-enumerate-devices | grep Serial
