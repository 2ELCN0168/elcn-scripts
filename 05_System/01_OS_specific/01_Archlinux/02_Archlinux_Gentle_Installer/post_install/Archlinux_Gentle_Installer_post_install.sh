#! /bin/bash

source_files() {

    local f_path="./functions"

    source ./c_config.sh
    source $f_path/f_configs.sh
}

# SOURCE FILES
source_files

# START SECOND PART
greetings_pi

# CHANGE CONFIG FILES
make_config
