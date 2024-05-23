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