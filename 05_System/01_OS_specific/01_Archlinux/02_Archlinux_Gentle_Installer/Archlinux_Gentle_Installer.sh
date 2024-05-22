#! /bin/bash

local f_path="./functions"

source ./c_config.sh
source ./functions/f_formatting.sh
source ./functions/f_logs.sh
source ./functions/f_run_command.sh

source ./functions/f_greetings.sh
source ./functions/f_internet.sh
source ./functions/f_lvm_luks_deletion.sh

# INIT
greetings

# TEST INTERNET CONNECTION
test_internet

# ASK FOR LVM AND LUKS DESTRUCTION
lvm_luks_try

