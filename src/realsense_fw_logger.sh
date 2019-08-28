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

log_fw_logger='/home/marvin/pwalczykk/_rs_fw_logger.log'
echo "===========================" >> $log_fw_logger
echo $(date) >> $log_fw_logger
echo "Start rs-fw-logger" >> $log_fw_logger
rs-fw-logger >> $log_fw_logger
echo $(date) >> $log_fw_logger
echo "Stopped rs-fw-logger" >> $log_fw_logger