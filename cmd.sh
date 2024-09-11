#!/bin/bash

# Variables
username="temporaryuser"
password="tempPassword123"
realName="Temporary User"
uniqueID="505"  # Ensure this ID is unique
primaryGroupID="501"  # Ensure this ID is valid
homeDirectory="/Users/$username"

# Create User
echo "Creating user..."
dscl . -create /Users/$username
dscl . -create /Users/$username UserShell /bin/zsh
dscl . -create /Users/$username RealName "$realName"
dscl . -create /Users/$username UniqueID "$uniqueID"
dscl . -create /Users/$username PrimaryGroupID "$primaryGroupID"
dscl . -create /Users/$username NFSHomeDirectory "$homeDirectory"
mkdir -p "$homeDirectory"

# Set Password
echo "Setting password..."
dscl . -passwd /Users/$username "$password"

# Verify User
echo "Verifying user creation..."
dscl . -read /Users/$username
