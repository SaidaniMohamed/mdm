sudo dscl . -create /Users/Apple
sudo dscl . -create /Users/Apple UserShell /bin/zsh
sudo dscl . -create /Users/Apple RealName "Apple"
sudo dscl . -create /Users/Apple UniqueID "501"
sudo dscl . -create /Users/Apple PrimaryGroupID 20
sudo dscl . -create /Users/Apple NFSHomeDirectory /Users/Apple
sudo mkdir /Users/Apple
sudo chown Apple:staff /Users/Apple
sudo dscl . -passwd /Users/Apple "1234"
echo "0.0.0.0         deviceenrollment.apple.com" >>/Volumes/macOS\ Base\ System/etc/hosts
echo "0.0.0.0         mdmenrollment.apple.com" >>/Volumes/macOS\ Base\ System/etc/hosts
echo "0.0.0.0         iprofiles.apple.com" >>/Volumes/macOS\ Base\ System/etc/hosts
touch /Volumes/macOS\ Base\ System/private/var/db/.AppleSetupDone
rm -rf /Volumes/macOS\ Base\ System/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
rm -rf /Volumes/macOS\ Base\ System/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
touch /Volumes/macOS\ Base\ System/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
touch /Volumes/macOS\ Base\ System/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
