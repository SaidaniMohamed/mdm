#!/bin/bash

# Define color codes
RED='\033[1;31m'
GRN='\033[1;32m'
BLU='\033[1;34m'
YEL='\033[1;33m'
PUR='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

# Function to get the system volume name
get_system_volume() {
    system_volume=$(diskutil info / | grep "Volume Name" | awk -F': ' '{print $2}' | tr -d ' ')
    echo "$system_volume"
}

# Get the system volume name
system_volume=$(get_system_volume)

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
            echo -e "${YEL}Bypass MDM from Recovery"
            if [ -d "/Volumes/${system_volume} - Data" ]; then
                diskutil rename "/Volumes/${system_volume} - Data" "Data"
            fi

            # Create Temporary User
            echo -e "${NC}Create a Temporary User"
            read -p "Enter Temporary Fullname (Default is 'Apple'): " realName
            realName="${realName:=Apple}"
            read -p "Enter Temporary Username (Default is 'Apple'): " username
            username="${username:=Apple}"
            read -p "Enter Temporary Password (Default is '1234'): " passw
            passw="${passw:=1234}"

            # Create User
            dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default'
            echo -e "${GRN}Creating Temporary User"
            sudo dscl . -create "/Users/$username"
            sudo dscl . -create "/Users/$username" UserShell "/bin/zsh"
            sudo dscl . -create "/Users/$username" RealName "$realName"
            sudo dscl . -create "/Users/$username" UniqueID "501" # Ensure ID is unique
            sudo dscl . -create "/Users/$username" PrimaryGroupID "20"
            sudo mkdir "/Volumes/Data/Users/$username"
            sudo dscl . -create "/Users/$username" NFSHomeDirectory "/Users/$username"
            sudo dscl . -passwd "/Users/$username" "$passw"
            sudo dscl . -append /Groups/admin GroupMembership "$username"

            # Block MDM domains
            echo "0.0.0.0 deviceenrollment.apple.com" | sudo tee -a /Volumes/"$system_volume"/etc/hosts
            echo "0.0.0.0 mdmenrollment.apple.com" | sudo tee -a /Volumes/"$system_volume"/etc/hosts
            echo "0.0.0.0 iprofiles.apple.com" | sudo tee -a /Volumes/"$system_volume"/etc/hosts
            echo -e "${GRN}Successfully blocked MDM & Profile Domains"

            # Remove configuration profiles
            sudo touch /Volumes/Data/private/var/db/.AppleSetupDone
            sudo rm -rf /Volumes/"$system_volume"/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
            sudo rm -rf /Volumes/"$system_volume"/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
            sudo touch /Volumes/"$system_volume"/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
            sudo touch /Volumes/"$system_volume"/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

            echo -e "${GRN}MDM enrollment has been bypassed!${NC}"
            echo -e "${NC}Exit terminal and reboot your Mac.${NC}"
            break
            ;;
        "Reboot & Exit")
            # Reboot & Exit
            echo "Rebooting..."
            sudo reboot
            break
            ;;
        *) echo "Invalid option $REPLY" ;;
    esac
done
