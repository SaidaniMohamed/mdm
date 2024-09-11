#!/bin/bash

# Define color codes
RED='\033[1;31m'
GRN='\033[1;32m'
BLU='\033[1;34m'
YEL='\033[1;33m'
PUR='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

# Define fixed volume name with escaped spaces
volume_name="macOS\ Base\ System"

# Display header
echo -e "${CYAN}Bypass MDM By Assaf Dori (assafdori.com)${NC}"
echo ""

# Prompt user for choice
PS3='Please enter your choice: '
options=("Bypass MDM from Recovery" "Reboot & Exit")
select opt in "${options[@]}"; do
    case $opt in
        "Bypass MDM from Recovery")
            # Bypass MDM from Recovery
            echo -e "${YEL}Bypass MDM from Recovery${NC}"
            if [ -d "/Volumes/${volume_name} - Data" ]; then
                diskutil rename "/Volumes/${volume_name} - Data" "Data"
            fi

            # Create Temporary User
            echo -e "${NC}Create a Temporary User${NC}"
            read -p "Enter Temporary Fullname (Default is 'John Doe'): " realName
            realName="${realName:=John Doe}"
            read -p "Enter Temporary Username (Default is 'temporaryuser'): " username
            username="${username:=temporaryuser}"
            read -p "Enter Temporary Password (Default is 'password123'): " passw
            passw="${passw:=password123}"

            # Choose Unique IDs
            uniqueID="600"
            primaryGroupID="600"

            # Create User
            echo -e "${GRN}Creating Temporary User${NC}"
            dscl . -create /Users/$username
            dscl . -create /Users/$username UserShell /bin/zsh
            dscl . -create /Users/$username RealName "$realName"
            dscl . -create /Users/$username UniqueID "$uniqueID" # Ensure ID is unique
            dscl . -create /Users/$username PrimaryGroupID "$primaryGroupID"
            mkdir -p "/Volumes/${volume_name}/Users/$username"
            dscl . -create /Users/$username NFSHomeDirectory "/Users/$username"
            dscl . -passwd /Users/$username "$passw"
            dscl . -append /Groups/admin GroupMembership "$username"

            # Block MDM domains
            echo "0.0.0.0 deviceenrollment.apple.com" >> "/Volumes/${volume_name}/etc/hosts"
            echo "0.0.0.0 mdmenrollment.apple.com" >> "/Volumes/${volume_name}/etc/hosts"
            echo "0.0.0.0 iprofiles.apple.com" >> "/Volumes/${volume_name}/etc/hosts"
            echo -e "${GRN}Successfully blocked MDM & Profile Domains${NC}"

            # Remove configuration profiles
            touch "/Volumes/${volume_name}/private/var/db/.AppleSetupDone"
            rm -rf "/Volumes/${volume_name}/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord"
            rm -rf "/Volumes/${volume_name}/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound"
            touch "/Volumes/${volume_name}/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled"
            touch "/Volumes/${volume_name}/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound"

            echo -e "${GRN}MDM enrollment has been bypassed!${NC}"
            echo -e "${NC}Exit terminal and reboot your Mac.${NC}"
            break
            ;;
        "Reboot & Exit")
            # Reboot & Exit
            echo "Rebooting..."
            reboot
            break
            ;;
        *) echo "Invalid option $REPLY" ;;
    esac
done
