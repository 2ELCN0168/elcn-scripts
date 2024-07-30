#! /bin/bash

source_files() {
        
        local f_path="./functions"

        source ./config/c_config.sh
        source ./config/c_formatting.sh

        source ${f_path}/f_starting.sh
        source ${f_path}/f_pmanager_detector.sh
}

source_files

# BEGINNING
starting

# DETECT PACKAGE MANAGER
pmanager_detector
