#!/bin/bash

# Google chrome, not chromium.
sudo apt-get install libxss1 libappindicator1 libindicator7 -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
## Add to startups as a background app.
echo "(sleep 4 && /usr/bin/google-chrome-stable --no-startup-window) &" >> .config/openbox/autostart

# vim.
sudo apt-get install vim -y

# Shutter.
mv bunsenlabs-setup/home/nicholas/.shutter ~
sudo apt-get install shutter -y 

# Virtualbox and virtualbox extension pack for usb support.
sudo apt-get install build-essential linux-headers-`uname -r` dkms libxml-xpath-perl -y
sudo apt-get install -t jessie-backports virtualbox -y
curl -LO $(curl -s "https://www.virtualbox.org/wiki/Downloads" | xmllint --xpath 'string((//div[@id="wikipage"]//a[@class="ext-link"])[4]/@href)' --html /tmp/vbox.html -)
VBoxManage extpack install --replace Oracle*.vbox-extpack

# Make lightdm default the username to last logged in user
sudo sed -i 's@greeter\-hide\-users=true@greeter-hide-users=false@' /etc/lightdm/lightdm.conf

# Setup plymouth for a better login experience in lvm encrypted drives.
sudo aptitude install plymouth plymouth-themes
convert ~/Pictures/wallpapers/shared/bunsen/bunsen-images/bl-default/bl-login-1920x1200.png -resize $(xdpyinfo | echo $(grep 'dimensions:') | sed -E "s@dimensions:\s([0-9]+)x([0-9]+).*@\1x\2@")^ -gravity center -crop $(xdpyinfo | echo $(grep 'dimensions:') | sed -E "s@dimensions:\s([0-9]+)x([0-9]+).*@\1x\2@")+0+0 ~/Pictures/wallpapers/bl-grub-$(xdpyinfo | echo $(grep 'dimensions:') | sed -E "s@dimensions:\s([0-9]+)x([0-9]+).*@\1x\2@").png
sudo cp ~/Pictures/wallpapers/bl-grub-*.png /boot/grub/
sudo sed -i -E "s@GRUB_CMDLINE_LINUX_DEFAULT=\"([a-z\s0-9]+)\"@GRUB_CMDLINE_LINUX_DEFAULT=\"\1 splash loglevel=3 vga=current\"@" /etc/default/grub
sudo su
echo $(xdpyinfo | echo $(grep 'dimensions:') | sed -E "s@dimensions:\s([0-9]+)x([0-9]+).*@GRUB_GFXMODE=\1x\2@") >> /etc/default/grub
update-grub
if [[ $(lspci | echo $(grep -i -E 'vga|3d|2d') | sed -E 's@.*(intel|ati|nvidia)\s.*@\1@i') == 'Intel' ]]; then printf "# KMS\nintel_agp\ndrm\ni915 modeset=1" >> /etc/initramfs-tools/modules; fi
cd /tmp/ && wget https://github.com/nalipaz/bunsen-plymouth-theme/archive/master.zip && unzip master.zip && rm master.zip
mv bunsen-plymouth-theme-master/ /usr/share/plymouth/themes/bunsen
/usr/sbin/plymouth-set-default-theme bunsen
update-initramfs -u
exit

# Setup better menu with icons using obmen-generator.
sudo aptitude install cpanminus build-essential
cd /tmp/ && wget https://github.com/trizen/obmenu-generator/archive/master.zip && unzip master.zip && rm master.zip
sudo mv obmenu-generator/obmenu-generator /usr/bin/
sudo cpanm Linux::DesktopFiles
sudo cpanm Data::Dump
