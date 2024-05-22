#! /bin/bash

########################################

# Color variables beginnings

export C_RED="\033[91m"
export C_GREEN="\033[92m"
export C_CYAN="\033[96m"
export C_YELLOW="\033[93m"
export C_PINK="\033[95m"
export C_WHITE="\033[97m"

# End of the color sequence

export NO_FORMAT="\033[0m"

########################################

# Global variables

noInternet=
pressYN=

########################################

export UEFI=0
export filesystem="BTRFS"
export BTRFSsubvols=0
export diskToUse=""
export LVM=0
export SSD=0
export HDD=0
export partitionType=""

export wantEncrypted=0
export bootloader=""
export cpuBrand="UNKNOWN"

export finalDisk=""
export finalPartBoot=""
export finalPartRoot=""
########################################

LVM_deletion() {

    # FORMATTING DONE
    while true; do
        read -p "Do you want to try automatic LVM deletion? It will also try to close a LUKS volume. [y/N] -> " response
        response="${response:-N}"
        case "$response" in
            [nN])
                echo -e "${C_WHITE}> ${NO_FORMAT}No LVM will be deleted automatically. ${C_WHITE}Skipping.${NO_FORMAT}\n"
                break
                ;;
            [yY])
                echo -e "\n${C_RED}= WARNING, THIS WILL PERFORM A COMPLETE ERASING OF ANY EXISTENT LVM =${NO_FORMAT}\n"
                read -p "If you have a LVM on another disk, type 'n' [y/NNN] -> " response2
                response2="${response2:-N}"
                case "$response2" in 
                    [nN])
                    echo -e "${C_WHITE}> ${NO_FORMAT}No LVM will be deleted automatically. ${C_WHITE}Skipping.${NO_FORMAT}\n"
                    break
                    ;;
                    [yY])
                        lvremove -f -y /dev/mapper/VG_Archlinux-* &> /dev/null
                        vgremove -f -y VG_Archlinux &> /dev/null
                        pvremove -f -y ${finalDisk} &> /dev/null
                        cryptsetup close root &> /dev/null

                        echo -e "\n"
                        lsblk -f
                        echo -e "\n${C_WHITE}> ${C_PINK}If it did not work, exit the script and manually delete it.${NO_FORMAT}\n"
                        sleep 1
                        break
                        ;;
                    *)
                        echo -e "${C_WHITE}> ${C_RED}Not a valid answer.${NO_FORMAT}"
                        ;;
                esac
                ;;
            *)
                echo -e "${C_WHITE}> ${C_RED}Not a valid answer.${NO_FORMAT}"
                ;;
        esac
    done
}

test_internet() {

    # NEED TO BE REDONE
    attempts=0
    maxAttempts=3
    while true; do
        echo -e "${C_WHITE}> ${C_YELLOW}Testing Internet connection...${NO_FORMAT}"
        if ping -c 1 1.1.1.1 &> /dev/null; then
            echo -e "${C_WHITE}> ${C_GREEN}Internet connection established.${NO_FORMAT}"
            break
        else
            attempts=$((attempts+1))
            echo -e "${C_WHITE}> ${C_YELLOW}Internet connection not detected. Opening iwctl...${NO_FORMAT}"
            iwctl
            if [ $attempts -ge "$maxAttempts" ]; then
                read -p "Failed to establish an internet connection after $attempts attempts. Do you want to try again? [y/N] -> " response
                response=${response:-N}
                case "$response" in
                    [yY])
                        attempts=0  # Reset attempts
                        ;;
                    [nN])
                        echo -e "${C_WHITE}> ${C_RED}No Internet connection. Aborting.${NO_FORMAT}"
                        exit 1
                        ;;
                    *)
                        echo -e "${C_WHITE}> ${C_YELLOW}You must press 'y' or 'n'.${NO_FORMAT}\n"
                        ;;
                esac
            fi
        fi
     done
}

setup_internet() {

    # NEED TO BE REDONE
    while true; do
        echo -e "${C_WHITE}> ${C_YELLOW}Testing Internet connection...${NO_FORMAT}"
        if ping -c 1 1.1.1.1 &> /dev/null; then
            echo -e "${C_WHITE}> ${C_GREEN}Internet connection established.${NO_FORMAT}\n"
            break
        else
            read -p "It seems that you are not connected to the Internet.If you're in a VM, you should check your settings.Choosing 'No' will open the iwctl utility to configure the wifi. [y/N] -> " response
            response=${response:-N}
            case "$response" in
                [yY])
                    echo -e "${C_WHITE}> ${C_RED}No Internet connection. Aborting.${NO_FORMAT}"
                    exit 1
                    ;;
                [nN])
                    iwctl
                    test_internet
                    break
                    ;;
                *)
                    echo -e "${C_WHITE}> ${C_YELLOW}You must press 'y' or 'n'.${NO_FORMAT}\n"
                    setup_internet
                    ;;
            esac
        fi
    done
}

setup_ssh() {

    # FORMATTING DONE
    while true; do
        read -p "Would you like to setup SSH? [y/N] -> " response
        response=${response:-N}
        case "$response" in 
            [yY])
                echo -e "${C_WHITE}> ${C_GREEN}Changing root password.${NO_FORMAT}"
                passwd 
                echo -e "\n${C_WHITE}> ${C_YELLOW}Starting sshd.service${NO_FORMAT}"
                if systemctl start sshd; then
                    echo -e "${C_WHITE}> ${NO_FORMAT}sshd.service - OpenSSH Daemon is ${C_GREEN}active (running)${NO_FORMAT}"
                    echo -e "${C_WHITE}> ${NO_FORMAT}Your ${C_CYAN}IP address${NO_FORMAT} should be one of the followings:\n"
                    ip address show | sed -n 's/.*inet \([0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}\)\/.*/\1/p' | grep -v -E "127\."
                    echo -e "\n"
                    break
                else
                    echo -e "${C_WHITE}> ${C_RED}sshd.service did not start, skipping this step.${NO_FORMAT}\n"
                    break
                fi
                ;;
            [nN])
                echo -e "${C_WHITE}> ${C_YELLOW}SSH will stay inactive.${NO_FORMAT}\n"
                break
                ;;
            *)
                echo -e "${C_WHITE}> ${C_YELLOW}You must press 'y' or 'n'.${NO_FORMAT}\n"
                ;;
        esac
    done
}

test_UEFI() {

    # FORMATTING DONE
    if cat /sys/firmware/efi/fw_platform_size &> /dev/null; then
        echo -e "${C_WHITE}> ${NO_FORMAT}Running in ${C_CYAN}UEFI${NO_FORMAT} mode."
        echo -e "${C_CYAN}You are using UEFI mode, you have the choice...${NO_FORMAT}\n"
        UEFI=1
    else
        echo -e "${C_WHITE}> ${NO_FORMAT}Running in ${C_RED}BIOS${NO_FORMAT} mode."
        echo -e "${C_YELLOW}No choice for you. You would have been better off using UEFI mode. We will install GRUB2.${NO_FORMAT}\n"
        UEFI=0
    fi
}

bootloader_choice() {

    # FORMATTING DONE
    if [[ UEFI -eq 1 ]]; then
        while true; do
            read -p "Do you prefer GRUB2 (0) or rEFInd (1)? [0/1=default] -> " response
            response=${response:-1}
            case "$response" in
                [0])
                    echo -e "${C_WHITE}> ${NO_FORMAT}We will install ${C_GREEN}GRUB2${NO_FORMAT}\n"
                    bootloader="GRUB"
                    break
                    ;;
                [1])
                    echo -e "${C_WHITE}> ${NO_FORMAT}We will install ${C_CYAN}rEFInd${NO_FORMAT}\n"
                    bootloader="REFIND"
                    break
                    ;;
                *)
                    echo -e "${C_WHITE}> ${C_RED}Not a valid answer. Asking again...${NO_FORMAT}\n"
                    ;;
            esac
        done
    elif [[ UEFI -eq 0 ]]; then
        bootloader="GRUB"
    fi
}

luks_choice() {

    # FORMATTING DONE
    while true; do
        read -p "Do you want your system to be encrypted with LUKS? [y/N] -> " response
        response=${response:-N}
        case "$response" in
            [yY])
                echo -e "${C_WHITE}> ${C_GREEN}cryptsetup${NO_FORMAT} will be installed.\n"
                wantEncrypted=1
                break
                ;;
            [nN])
                echo -e "${C_WHITE}> ${C_RED}cryptsetup${NO_FORMAT} won't be installed.\n"
                wantEncrypted=0
                break
                ;;
            *)
                echo -e "${C_WHITE}> ${C_YELLOW}You must press 'y' or 'n'.${NO_FORMAT}\n"
                ;;
        esac
    done
}

get_cpu_brand() {
    local vendor
    vendor=$(lscpu | grep -i vendor | awk '{ print $3 }')

    case "$vendor" in
        "GenuineIntel")
            echo -e "${C_WHITE}> ${C_CYAN}INTEL CPU${NO_FORMAT} detected."
            cpuBrand="INTEL"
            ;;
        "AuthenticAMD")
            echo -e "${C_WHITE}> ${C_RED}AMD CPU${NO_FORMAT} detected."
            cpuBrand="AMD"
            ;;
        *)  
            echo -e "${C_WHITE}> ${C_YELLOW}Could not detect your CPU vendor. No microcode will be installed.${NO_FORMAT}"
            cpuBrand="UNKNOWN"
            ;;
    esac
}

ask_filesystem() {
    echo -e "${C_WHITE}> ${NO_FORMAT}I will now partition the disks, but before, I need some informations."
    while true; do
        read -p "What filesystem do you want to use? [BTRFS=default/XFS/EXT4] -> " response
        response=${response^^} # Convert to uppercase
        response=${response:-BTRFS} # Default is BTRFS if no response given
        case "$response" in
            BTRFS|XFS|EXT4)
                filesystem=$response
                echo -e "${C_WHITE}> ${NO_FORMAT}You chose ${C_CYAN}${filesystem}${NO_FORMAT}.\n" 
                break
                ;;
            *)
                echo -e "${C_WHITE}> ${C_RED}Not a valid answer, type it correctly.${NO_FORMAT}\n"
                ;;
        esac
    done
}

ask_disk() {

    # NEED TO BE REDONE
    while true; do
        lsblk
        read -p "Do you have a NVMe SSD (0) or a HDD (1=default)? (e.g., nvmeXn1 for NVMe SSD or sdX for HDD) -> " diskType
        # Check if disk exists and is not sr0 or loop0
        diskType=${diskType:-1}
        case "$diskType" in
            [0])
                SSD=1
                echo -e "You have a NVMe SSD."
                partitionType="p"
                break
                ;;
            [1])
                HDD=1
                echo -e "You have a HDD or a M.2 SSD."
                break
                ;;
            *)
                echo -e "${C_RED}Not a valid answer.${NO_FORMAT}"
                ;;
        esac
    done

    while true; do
        lsblk
        read -p "Enter the name of the disk to format (e.g., nvmeXn1, sdX (default=sda)) -> " disk
        # Check if disk exists and is not sr0 or loop0
        disk=${disk:-sda}
        if lsblk | grep -q "^$disk" && [[ ! $disk =~ ^(sr0|loop0)$ ]]; then 
            diskToUse="$disk"
            break
        else
            echo -e "${C_RED}Disk not found. Please, enter a valid disk name.${NO_FORMAT}"
        fi
    done

    finalDisk="/dev/${diskToUse}"
    finalPartBoot="/dev/${diskToUse}${partitionType}1"
    finalPartRoot="/dev/${diskToUse}${partitionType}2"
}

auto_partition_disk() {

    # FORMATTING DONE
    echo -e "\n"

    if [[ $UEFI -eq 1 ]]; then
        echo -e "${C_WHITE}> Creating two partitions for GPT disk.${NO_FORMAT}"
        
        parted -s $finalDisk mklabel gpt
        parted -s $finalDisk mkpart primary 1Mib 512Mib
        parted -s $finalDisk mkpart primary 512Mib 100%
        
        echo -e "${C_WHITE}> ${C_GREEN}Partitions created successfully for UEFI mode (GPT).${NO_FORMAT}\n"
    elif [[ $UEFI -eq 0 ]]; then
        echo -e "${C_WHITE}> Creating two partitions for MBR disk.${NO_FORMAT}"
        
        parted -s $finalDisk mklabel msdos
        parted -s $finalDisk mkpart primary 1Mib 512Mib
        parted -s $finalDisk mkpart primary 512Mib 100%
        
        echo -e "${C_WHITE}> ${C_GREEN}Partitions created successfully for BIOS mode (MBR).${NO_FORMAT}\n"
    fi
    sleep 1
}

format_partitions() {

    # FORMATTING DONE
    echo -e "${C_WHITE}> ${C_CYAN}Formatting ${finalPartBoot} to FAT32.${NO_FORMAT}\n"
    mkfs.fat -F 32 -n ESP ${finalPartBoot}1 &> /dev/null
    
    if [[ $wantEncrypted -eq 1 ]]; then
        LUKS_handling
    fi

    if [[ $filesystem == 'BTRFS' ]]; then
        BTRFS_handling
    elif [[ $filesystem == 'XFS' ]]; then
        XFS_handling
    elif [[ $filesystem == 'EXT4' ]]; then
        EXT4_handling
    fi
}

LUKS_handling() {

    # FORMATTING DONE
    # MAYBE NEED TO BE MERGED TO LUKS_CHOICE
    echo -e "${C_WHITE}> ${NO_FORMAT}Starting to encrypt your new system..."
    cryptsetup luksFormat ${finalPartRoot}

    echo -e "\n${C_WHITE}> ${NO_FORMAT}Opening the new encrypted volume."
    cryptsetup open ${finalPartRoot} root
    
    echo -e "\n${C_WHITE}> ${NO_FORMAT}Replacing ${finalPartRoot} by ${C_PINK}/dev/mapper/root.${NO_FORMAT}\n"
    export finalPartRoot="/dev/mapper/root"
}

mount_default() {
    
    # FORMATTING DONE
    echo -e "${C_WHITE}> ${NO_FORMAT}Mounting ${C_GREEN}${finalPartRoot}${NO_FORMAT} to /mnt"
    mount ${finalPartRoot} /mnt 
        
    echo -e "${C_WHITE}> ${NO_FORMAT}Mounting ${C_GREEN}${finalPartBoot}${NO_FORMAT} to /mnt/boot\n"
    mount --mkdir ${finalPartBoot} /mnt/boot
}

BTRFS_handling() {

    # FORMATTING DONE
    while true; do
        read -p "It seems that you've picked BTRFS, do you want a clean installation with subvolumes (0) or a regular one with only the filesystem (1)? [0=default/1] -> " response
        response=${response:-0}
        case "$response" in
            [0])
                BTRFSsubvols=1
                echo -e "\n${C_WHITE}> ${C_GREEN}You chose to make subvolumes. Good choice.${NO_FORMAT}"
                break
                ;;
            [1])
                BTRFSsubvols=0
                echo -e "\n${C_WHITE}> ${C_YELLOW}No subvolume will be created.${NO_FORMAT}"
                break
                ;;
            *)
                echo -e "\n${C_WHITE}> ${C_RED}Not a valid answer.${NO_FORMAT}\n"
                ;;
        esac
    done

    echo -e "${C_WHITE}> ${C_CYAN}Formatting ${finalPartRoot} to ${filesystem}.${NO_FORMAT}\n"
    mkfs.btrfs -f -L Archlinux ${finalPartRoot} &> /dev/null
    
    if [[ $BTRFSsubvols -eq 1 ]]; then
        mount ${finalPartRoot} /mnt &> /dev/null
        btrfs subvolume create /mnt/{@,@home,@usr,@tmp,@var,.snapshots} &> /dev/null
        
        echo -e "${C_WHITE}> Creating${NO_FORMAT} subvolume ${C_GREEN}@${NO_FORMAT}"
        echo -e "${C_WHITE}> Creating${NO_FORMAT} subvolume ${C_GREEN}@home${NO_FORMAT}"
        echo -e "${C_WHITE}> Creating${NO_FORMAT} subvolume ${C_GREEN}@usr${NO_FORMAT}"
        echo -e "${C_WHITE}> Creating${NO_FORMAT} subvolume ${C_GREEN}@tmp${NO_FORMAT}"
        echo -e "${C_WHITE}> Creating${NO_FORMAT} subvolume ${C_GREEN}@var${NO_FORMAT}"
        echo -e "${C_WHITE}> Creating${NO_FORMAT} subvolume ${C_GREEN}.snapshots${NO_FORMAT}\n"

        umount -R /mnt &> /dev/null
        
        echo -e "${C_WHITE}> Mounting ${C_GREEN}@${NO_FORMAT} to /mnt"
        mount -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@ ${finalPartRoot} /mnt
        
        echo -e "${C_WHITE}> Mounting ${C_GREEN}@home${NO_FORMAT} to /mnt/home"
        mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@home ${finalPartRoot} /mnt/home
       
        echo -e "${C_WHITE}> Mounting ${C_GREEN}@usr${NO_FORMAT} to /mnt/usr"
        mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@usr ${finalPartRoot} /mnt/usr
      
        echo -e "${C_WHITE}> Mounting ${C_GREEN}@tmp${NO_FORMAT} to /mnt/tmp"
        mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@tmp ${finalPartRoot} /mnt/tmp
      
        echo -e "${C_WHITE}> Mounting ${C_GREEN}@var${NO_FORMAT} to /mnt/var"
        mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@var ${finalPartRoot} /mnt/var
     
        echo -e "${C_WHITE}> Mounting ${C_GREEN}.snapshots${NO_FORMAT} to /mnt/var/snapshots"
        mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=.snapshots ${finalPartRoot} /mnt/var/.snapshots
     
        echo -e "${C_WHITE}> Mounting ${C_GREEN}/dev/sda1${NO_FORMAT} to /mnt/boot\n"
        mount --mkdir ${finalPartBoot} /mnt/boot
    
        lsblk -f
    elif [[ $BTRFSsubvols -eq 0 ]]; then
        mount_default
    fi
}

XFS_handling() {

    # FORMATTING DONE
    while true; do
        read -p "It seems that you've picked XFS, do you want to use LVM? [Y/n] -> " response
        response=${response:-Y}
        case "$response" in
            [yY])
                LVM=1
                break
                ;;            
            [nN])
                LVM=0
                echo -e "${C_WHITE}> ${NO_FORMAT}You won't use LVM.\n"
                break
                ;;
            *)
                echo -e "${C_WHITE}> ${C_RED}Not a valid answer.${NO_FORMAT}\n"
                ;;
        esac
    done
        LVM_handling
}

EXT4_handling() {

    # FORMATTING DONE
    while true; do
        read -p "It seems that you've picked EXT4, do you want to use LVM? [Y/n] -> " response
        response=${response:-Y}
        case "$response" in
            [Yy])
                LVM=1
                break
                ;;            
            [Nn])
                LVM=0
                echo -e "${C_WHITE}> ${NO_FORMAT}You won't use LVM.\n"
                break
                ;;
            *)
                echo -e "${C_WHITE}> ${C_RED}Not a valid answer.${NO_FORMAT}\n"
                ;;
        esac
    done
    LVM_handling
}

LVM_handling() {

    # FORMATTING DONE
    if [[ $LVM -eq 0 ]]; then
        echo -e "${C_WHITE}> ${C_CYAN}Formatting ${finalPartRoot} to ${filesystem}.${NO_FORMAT}\n"
        case "$filesystem" in
            XFS)
                mkfs.xfs -f -L Archlinux ${finalPartRoot} &> /dev/null
                ;;
            EXT4)
                mkfs.ext4 -L Archlinux ${finalPartRoot} &> /dev/null
                ;;
        esac 
        mount_default

    elif [[ $LVM -eq 1 ]]; then
        echo -e "${C_WHITE}> ${NO_FORMAT}You will use LVM.\n"
        echo -e "${C_CYAN}Creating LVM to ${finalPartRoot} with ${filesystem}...${NO_FORMAT}"
        
        pvcreate ${finalPartRoot}
        vgcreate VG_Archlinux ${finalPartRoot}
        lvcreate -l 20%FREE VG_Archlinux -n root
        lvcreate -l 40%FREE VG_Archlinux -n home
        lvcreate -l 20%FREE VG_Archlinux -n usr
        lvcreate -l 10%FREE VG_Archlinux -n var
        lvcreate -l 10%FREE VG_Archlinux -n tmp

        case "$filesystem" in
            XFS)
                mkfs.xfs -f -L Arch_root /dev/mapper/VG_Archlinux-root &> /dev/null
                mkfs.xfs -f -L Arch_home /dev/mapper/VG_Archlinux-home &> /dev/null
                mkfs.xfs -f -L Arch_usr /dev/mapper/VG_Archlinux-usr &> /dev/null
                mkfs.xfs -f -L Arch_var /dev/mapper/VG_Archlinux-var &> /dev/null
                mkfs.xfs -f -L Arch_tmp /dev/mapper/VG_Archlinux-tmp &> /dev/null
                ;;
            EXT4)
                mkfs.ext4 -L Arch_root /dev/mapper/VG_Archlinux-root &> /dev/null
                mkfs.ext4 -L Arch_home /dev/mapper/VG_Archlinux-home &> /dev/null
                mkfs.ext4 -L Arch_usr /dev/mapper/VG_Archlinux-usr &> /dev/null
                mkfs.ext4 -L Arch_var /dev/mapper/VG_Archlinux-var &> /dev/null
                mkfs.ext4 -L Arch_tmp /dev/mapper/VG_Archlinux-tmp &> /dev/null
                ;;
        
        esac 

        echo -e "\n${C_WHITE}> Mounting ${C_CYAN}VG_Archlinux-root${NO_FORMAT} to /mnt"
        mount /dev/mapper/VG_Archlinux-root /mnt
        
        echo -e "${C_WHITE}> Mounting ${C_CYAN}VG_Archlinux-home${NO_FORMAT} to /mnt/home"
        mount --mkdir /dev/mapper/VG_Archlinux-home /mnt/home
        
        echo -e "${C_WHITE}> Mounting ${C_CYAN}VG_Archlinux-usr${NO_FORMAT} to /mnt/usr"
        mount --mkdir /dev/mapper/VG_Archlinux-usr /mnt/usr
        
        echo -e "${C_WHITE}> Mounting ${C_CYAN}VG_Archlinux-var${NO_FORMAT} to /mnt/var"
        mount --mkdir /dev/mapper/VG_Archlinux-var /mnt/var
        
        echo -e "${C_WHITE}> Mounting ${C_CYAN}VG_Archlinux-tmp${NO_FORMAT} to /mnt/tmp"
        mount --mkdir /dev/mapper/VG_Archlinux-tmp /mnt/tmp

        echo -e "${C_WHITE}> Mounting ${C_CYAN}${finalPartBoot}${NO_FORMAT} to /mnt/boot"
        mount --mkdir ${finalPartBoot} /mnt/boot
    fi
}

pacstrap_install() {
    
    # FORMATTING DONE
    # List of additional packages depending on parameters specified by the user, avoiding installation of useless things
    additionalPackages=""
    
    if [[ $filesystem == 'BTRFS' ]]; then
        additionalPackages="$additionalPackages btrfs-progs"
    elif [[ $filesystem == 'XFS' ]]; then
        additionalPackages="$additionalPackages xfsprogs"
    fi

    if [[ $LVM -eq 1 ]]; then
        additionalPackages="$additionalPackages lvm2"
    fi

    if [[ $wantEncrypted -eq 1 ]]; then
        additionalPackages="$additionalPackages cryptsetup"
    fi

    if [[ $bootloader == 'REFIND' ]]; then
        additionalPackages="$additionalPackages refind"
    elif [[ $bootloader == 'GRUB' && $UEFI -eq 1 ]]; then
        additionalPackages="$additionalPackages grub efibootmgr"
    elif [[ $bootloader == 'GRUB' && $UEFI -eq 0 ]]; then
        additionalPackages="$additionalPackages grub"
    fi

    if [[ $cpuBrand == 'INTEL' ]]; then
        additionalPackages="$additionalPackages intel-ucode"
    elif [[ $cpuBrand == 'AMD' ]]; then
        additionalPackages="$additionalPackages amd-ucode"
    fi
    
    # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf
    #sed -i '/^\s*#\(Color\|ParallelDownloads\)/ s/^#//' /etc/pacman.conf
    sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' /etc/pacman.conf
    # Display additional packages
    echo -e "${C_WHITE}>>> Additional packages are${C_CYAN}${additionalPackages}${NO_FORMAT}\n"
    sleep 4
    # Perform the installation of the customized system
    pacstrap -K /mnt linux{,-{firmware,lts{,-headers}}} base{,-devel} git terminus-font openssh zsh{,-{syntax-highlighting,autosuggestions,completions,history-substring-search}} \
    btop htop bmon nmon nload nethogs jnettop iptraf-ng tcpdump nmap bind-tools vim man{,-{db,pages}} tree texinfo tldr fastfetch networkmanager tmux ${additionalPackages}
    echo -e "\n${C_WHITE}> ${C_RED}Sorry, nano has been deleted from the Arch repository, you will have to learn${NO_FORMAT} ${C_GREEN}Vim${NO_FORMAT}.\n"
}

before_chrooting() {
    # Generate /etc/fstab of the new system
    echo -e "${C_WHITE}> ${NO_FORMAT}Generating ${C_PINK}/mnt/etc/fstab${NO_FORMAT} file."
    genfstab -U /mnt > /mnt/etc/fstab

    # Setting up /mnt/etc/hostname
    read -p "Enter your hostname with domain (optional). Recommended hostname length: 15 chars. (e.g., MH1DVMARXXX001O.home.arpa). Default is 'localhost.home.arpa'. " hostname
    hostname=${hostname:-'localhost.home.arpa'}
    if [[ -n $hostname ]]; then
            echo $hostname > /mnt/etc/hostname
            echo -e "${C_WHITE}> ${NO_FORMAT}Your hostname will be ${C_CYAN}${hostname}${NO_FORMAT}.\n" 
    fi    
    
    # Setting up /mnt/etc/hosts
    echo -e "${C_WHITE}> ${NO_FORMAT}Setting up ${C_PINK}/mnt/etc/hosts${NO_FORMAT}\n"

    echo "127.0.0.1 localhost.localdomain localhost localhost-ipv4" > /mnt/etc/hosts
    echo "::1       localhost.localdomain localhost localhost-ipv6" >> /mnt/etc/hosts
    echo "127.0.0.1 $hostname.localdomain  $hostname  $hostname-ipv4" >> /mnt/etc/hosts
    echo "::1       $hostname.localdomain  $hostname  $hostname-ipv6" >> /mnt/etc/hosts

    cat /mnt/etc/hosts
    sleep 1

    # Uncomment #en_US.UTF-8 UTF-8 in /mnt/etc/locale.gen
    echo -e "\n${C_WHITE}> ${NO_FORMAT}Uncommenting ${C_RED}en_US.UTF-8 UTF-8${NO_FORMAT} in ${C_PINK}/mnt/etc/locale.gen${NO_FORMAT}..."
    sed -i '/^\s*#\(en_US.UTF-8 UTF-8\)/ s/^#//' /mnt/etc/locale.gen

    # Creating /mnt/etc/vconsole.conf
    echo -e "${C_WHITE}> ${NO_FORMAT}Creating the file ${C_PINK}/mnt/etc/vconsole.conf${NO_FORMAT}."
    echo "KEYMAP=us" > /mnt/etc/vconsole.conf

    # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf AGAIIIIN
    echo -e "${C_WHITE}> ${NO_FORMAT}Uncommenting ${C_WHITE}'Color'${NO_FORMAT} and ${C_WHITE}'ParallelDownloads 5'${NO_FORMAT} in ${C_PINK}/mnt/etc/pacman.conf${NO_FORMAT} AGAIIIIN.\n"
    #sed -i '/^\s*#\(Color\|ParallelDownloads\)/ s/^#//' /mnt/etc/pacman.conf
    sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' /etc/pacman.conf


    # Making a clean backup of /mnt/etc/mkinitcpio.conf
    echo -e "${C_WHITE}> ${NO_FORMAT}Making a backup of ${C_PINK}/mnt/etc/mkinitcpio.conf${NO_FORMAT}..."
    cp -a /mnt/etc/mkinitcpio.conf /mnt/etc/mkinitcpio.conf.bak

    # Setting up /mnt/etc/mkinitcpio.conf
    isBTRFS=""
    isLUKS=""
    isLVM=""

    if [[ $filesystem == 'BTRFS' ]]; then
        isBTRFS="btrfs "
    fi

    if [[ $wantEncrypted -eq 1 ]]; then
        isLUKS="sd-encrypt "
    fi

    if [[ $LVM -eq 1 ]]; then
        isLVM="lvm2 "
    fi
    
    echo -e "${C_WHITE}> ${NO_FORMAT}Updating ${C_PINK}/mnt/etc/mkinitcpio.conf${NO_FORMAT} with custom parameters..."
    mkcpioHOOKS="HOOKS=(base systemd ${isBTRFS}autodetect modconf kms keyboard sd-vconsole ${isLUKS}block ${isLVM}filesystems fsck)"
    awk -v newLine="$mkcpioHOOKS" '!/^#/ && /HOOKS/ { print newLine; next } 1' /mnt/etc/mkinitcpio.conf > tmpfile && mv tmpfile /mnt/etc/mkinitcpio.conf
}

create_chroot_script() {

    cat << EOF_SCRIPT > /mnt/root/archpostinstall.sh
#! /bin/bash

post_install() {
    echo -e "\${C_GREEN}Welcome to your new system! The work isn't done yet, I have some more questions...\${NO_FORMAT}"

    echo -e "hwclock --systohc"
    hwclock --systohc

    echo -e "systemctl \${C_GREEN}enable\${NO_FORMAT} NetworkManager"
    systemctl enable NetworkManager &> /dev/null

    echo -e "\${C_GREEN}Generating locales...\${NO_FORMAT}"
    locale-gen &> /dev/null
    echo -e "\${C_GREEN}Locales generated successfully.\${NO_FORMAT}"

    echo -e "\${C_YELLOW}Changing root password...\${NO_FORMAT}"
    while true; do
        if passwd; then
            break
        fi
    done

    # Generate initramfs
    mkinitcpio -P

    # Install bootloader  
    install_refind() {
        refind-install &> /dev/null
        #lsblk -f 
        #read -p "Type your root partition name (e.g., sda2, nvmeOn1p2 (default=sda2)) -> " partition
        #partition="\${partition:-sda2}"
        #partition="/dev/\${partition}"

        rootLine=""
        isMicrocode=""
        isBTRFS=""
        isEncrypt=""
        isEncryptEnding=""

        if [[ \$cpuBrand == 'INTEL' ]]; then
            isMicrocode=" initrd=intel-ucode.img"
        elif [[ \$cpuBrand == 'AMD' ]]; then
            isMicrocode=" initrd=amd-ucode.img"
        fi

        if [[ \$wantEncrypted -eq 1 ]]; then
            rootLine=""
            isEncrypt="rd.luks.name="
            isEncryptEnding="=root root=/dev/mapper/root"
        elif [[ \$wantEncrypted -eq 0 ]]; then
            rootLine="root=UUID="
        fi

        if [[ \$filesystem == 'BTRFS' && \$BTRFSsubvols -eq 1 ]]; then
            isBTRFS=" rootflags=subvol=@"
        fi

        #uuid=\$(blkid -o value -s UUID "\$partition")
        uuid=\$(blkid -o value -s UUID "\$finalPartRoot")
        
        # This is interesting, it generates the proper refind_linux.conf file with custom parameters, e.g., filesystem and microcode
        echo -e \"Arch Linux\" \"\$rootLine\$isEncrypt\$uuid\$isEncryptEnding rw initrd=initramfs-linux.img\$isBTRFS\$isMicrocode\"
        echo -e \"Arch Linux\" \"\$rootLine\$isEncrypt\$uuid\$isEncryptEnding rw initrd=initramfs-linux.img\$isBTRFS\$isMicrocode\" > /boot/refind_linux.conf

        echo -e "\${C_GREEN}rEFInd configuration created successfully.\${NO_FORMAT}"
    }

    install_grub() {
        if [[ \$UEFI -eq 1 ]]; then
            echo -e "Installing grub for EFI to /boot."
            grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &> /dev/null
            if [[ ! \$? -eq 0 ]]; then
                echo -e "GRUB installation failed, trying another method..."
                grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable --force &> /dev/null
                if [[ ! \$? -eq 0 ]]; then
                    echo -e "GRUB installation failed even with different parameters, you will have to install and configure a bootloader manually. Good luck."
                    while true; do
                        read -p "Should we install REFIND? [Y/n] -> " installrefind
                        installrefind="\${installrefind:-Y}"
                        case "\$installrefind" in 
                            [yY])
                                bootloader="REFIND"
                                install_refind
                                break
                                ;;
                            [nN])
                                echo -e "Fine, I guess you know what you're doing."
                                break
                                ;;
                            *)
                                echo -e "Please answer properly."
                                ;;
                        esac
                    done
                fi
            fi
        
        elif [[ \$UEFI -eq 0 ]]; then
            echo -e "Installing grub for BIOS to /boot."
            grub-install --target=i386-pc /dev/\$diskToUse &> /dev/null
        fi

        # Add a verifcation for partition name with testing if ls /dev/\$partname returns error or not instead of lsblk
        #read -p "Type your root partition name (e.g., sda2, nvme0n1p2 (default=sda2)) -> " partition
        #partition="\${partition:-sda2}"
        #partition="/dev/\${partition}"

        rootLine=""
        isMicrocode=""
        isBTRFS=""
        isEncrypt=""
        isEncryptEnding=""

        # Make a backup of /etc/default/grub
        cp -a /etc/default/grub /etc/default/grub.bak

        if [[ \$cpuBrand == 'INTEL' ]]; then
            isMicrocode=" initrd=intel-ucode.img"
        elif [[ \$cpuBrand == 'AMD' ]]; then
            isMicrocode=" initrd=amd-ucode.img"
        fi

        if [[ \$wantEncrypted -eq 1 ]]; then
            rootLine=""
            isEncrypt="rd.luks.name="
            isEncryptEnding="=root root=/dev/mapper/root"
            sed -i '/^\s*#\(GRUB_ENABLE_CRYPTODISK\)/ s/^#//' /etc/default/grub
        elif [[ \$wantEncrypted -eq 0 ]]; then
            rootLine="root=UUID="
        fi

        if [[ \$filesystem == 'BTRFS' && \$BTRFSsubvols -eq 1 ]]; then
            isBTRFS=" rootflags=subvol=@"
        fi

        # uuid=\$(blkid -o value -s UUID "\$partition")
        uuid=\$(blkid -o value -s UUID "\$finalPartRoot")
        
        export grubKernelParameters="\$rootLine\$isEncrypt\$uuid\$isEncryptEnding rw initrd=initramfs-linux.img\$isBTRFS\$isMicrocode"
        echo -e "\${grubKernelParameters}"

        # VERY IMPORTANT LINE, SO ANNOYING TO GET IT WORKING, DO NOT DELETE!
        awk -v params="\$grubKernelParameters" '/GRUB_CMDLINE_LINUX=""/{\$0 = "GRUB_CMDLINE_LINUX=\"" params "\""} 1' /etc/default/grub > tmpfile && mv tmpfile /etc/default/grub
        
        grub-mkconfig -o /boot/grub/grub.cfg
    }

    if [[ \$bootloader == 'REFIND' ]]; then
        install_refind
    elif [[ \$bootloader == 'GRUB' ]]; then
        install_grub
    fi
}

post_install
echo -e "\${C_GREEN}Congratulations. The system has been installed without any error.\${NO_FORMAT}\n"

if fastfetch --version &> /dev/null; then
    fastfetch
fi

#rm -f /root/archpostinstall.sh

EOF_SCRIPT

    chmod +x /mnt/root/archpostinstall.sh
}

clear

echo -e "\n${C_CYAN}███${C_RED}█${C_CYAN}█${C_YELLOW}█${C_CYAN}█\n${NO_FORMAT}"
date
echo -e "\n${C_CYAN}> ${C_WHITE}Welcome to this classical automated ${C_CYAN}Arch/\Linux${NO_FORMAT} ${C_WHITE}installer. ${C_CYAN}<\n${NO_FORMAT}"

echo -e "${C_WHITE}> ${C_PINK}Before starting, make sure you have ${C_RED}any LVM ${C_PINK}configured on your disk, or it will ${C_RED}mess up${C_PINK} the script. You must delete any LV, VG and PV before starting.\n${NO_FORMAT}"
# Making sure nothing is mounted there before initializing.
umount -R /mnt &> /dev/null

LVM_deletion

# Testing Internet and ask for SSH.
setup_internet
setup_ssh

# Is that UEFI or BIOS ?
test_UEFI

timedatectl set-ntp true

bootloader_choice
luks_choice

# Touching the disks.
ask_filesystem
ask_disk
auto_partition_disk
format_partitions

# Install base system with the most important package: fastfetch
pacstrap_install

# Perform final customizations that don't need to be chrooted
before_chrooting

# Create the second script to be executed into the chrooted system
create_chroot_script



# Chrooting to the system and launch the second script
arch-chroot /mnt /root/archpostinstall.sh



# A FAIRE

# X Installer les microcodes 
# X Modifier les paramètres kernel en fonction du FS et de l'ucode
# Créer utilisateur
# Changer le skel pour avoir des beaux prompts
# X Finir installation GRUB : LUKS/Pas LUKS BIOS/UEFI
# X Paramétrer le cryptsetup
# X LVM
# X Subvol BTRFS
# X Supprimer choix utilisateur sur partitionnement
# Add a verifcation for partition name with testing if ls /dev/$partname returns error or not instead of lsblk
# Ajouter les guest agents si on est dans une VM VBox ou QEMU