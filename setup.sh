#!/bin/bash

cd /tmp/

# Google chrome, not chromium.
echo "Setup Google Chrome dependencies..."
sudo apt-get install libxss1 libappindicator1 libindicator7 -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
## Add to startups as a background app.
echo "(sleep 4 && /usr/bin/google-chrome-stable --no-startup-window) &" >> /home/$USER/.config/openbox/autostart

# vim and ag.
sudo apt-get install vim silversearcher-ag -y

# Shutter.
mv bunsenlabs-setup-master/home/.shutter ~
sudo apt-get install shutter -y 

# Virtualbox and virtualbox extension pack for usb support.
sudo apt-get install build-essential linux-headers-`uname -r` dkms libxml2-utils -y
sudo apt-get install -t jessie-backports virtualbox -y
curl -LO $(curl -s "https://www.virtualbox.org/wiki/Downloads" | xmllint --xpath 'string((//div[@id="wikipage"]//a[@class="ext-link"])[4]/@href)' --html -)
VBoxManage extpack install --replace Oracle*.vbox-extpack

# Make lightdm default the username to last logged in user
sudo sed -i 's@greeter\-hide\-users=true@greeter-hide-users=false@' /etc/lightdm/lightdm.conf

# Setup plymouth for a better login experience in lvm encrypted drives.
sudo aptitude install plymouth plymouth-themes bunsen-images-extra -y
convert ~/Pictures/wallpapers/shared/bunsen/bunsen-images/bl-default/bl-login-1920x1200.png -resize $(xdpyinfo | echo $(grep 'dimensions:') | sed -E "s@dimensions:\s([0-9]+)x([0-9]+).*@\1x\2@")^ -gravity center -crop $(xdpyinfo | echo $(grep 'dimensions:') | sed -E "s@dimensions:\s([0-9]+)x([0-9]+).*@\1x\2@")+0+0 ~/Pictures/wallpapers/bl-grub-$(xdpyinfo | echo $(grep 'dimensions:') | sed -E "s@dimensions:\s([0-9]+)x([0-9]+).*@\1x\2@").png
cp ~/Pictures/wallpapers/bl-grub-*.png ~/Pictures/wallpapers/bl-wallpaper.png
sudo cp ~/Pictures/wallpapers/bl-grub-*.png /boot/grub/
sudo sed -i -E "s@GRUB_CMDLINE_LINUX_DEFAULT=\"([a-z\s0-9]+)\"@GRUB_CMDLINE_LINUX_DEFAULT=\"\1 splash loglevel=3 vga=current\"@" /etc/default/grub
sudo su <<CMD
 cd /tmp/
 echo $(xdpyinfo | echo $(grep 'dimensions:') | sed -E "s@dimensions:\s([0-9]+)x([0-9]+).*@GRUB_GFXMODE=\1x\2@") >> /etc/default/grub
 update-grub
 if [[ $(lspci | echo $(grep -i -E 'vga|3d|2d') | sed -E 's@.*(intel|ati|nvidia)\s.*@\1@i') == 'Intel' ]]; then printf "# KMS\nintel_agp\ndrm\ni915 modeset=1" >> /etc/initramfs-tools/modules; fi
 wget https://github.com/nalipaz/bunsen-plymouth-theme/archive/master.zip
 unzip master.zip
 rm master.zip
 mv bunsen-plymouth-theme-master/ /usr/share/plymouth/themes/bunsen
 /usr/sbin/plymouth-set-default-theme bunsen
 update-initramfs -u
 exit
CMD

# Setup better menu with icons using obmen-generator.
sudo aptitude install cpanminus build-essential
wget https://github.com/trizen/obmenu-generator/archive/master.zip && unzip master.zip && rm master.zip
chmod +x obmenu-generator/obmenu-generator
sudo mv obmenu-generator/obmenu-generator /usr/bin/
sudo cpanm Linux::DesktopFiles
sudo cpanm Data::Dump
rm obmenu-generator
mv bunsenlabs-setup-master/home/.config/obmenu-generator ~/.config/

# Alter tint2 preferences.
sed -r 's@^#time@time@' ~/.config/tint2/tint2rc
sed -r 's@^time([0-9])_format.*$@time\1_format = %a %l:%M %p %Z on %e %b %Y@' ~/.config/tint2/tint2rc
sed -r 's@^(time2_format.*)$@\1\ntime2_timezone = :Asia/Tokyo@' ~/.config/tint2/tint2rc
sed -r 's@time1_font\s=\s(.*)\s([0-9]+)@time1_font = \1 10@' ~/.config/tint2/tint2rc
sed -r 's@time2_font\s=\s(.*)\s([0-9]+)@time2_font = \1 9@' ~/.config/tint2/tint2rc

# Change everything to Bunsen-Blue-Dark theme.
sed '/<theme>/!b;n;c\    <name>Bunsen-Blue-Dark</name>' ~/.config/openbox/rc.xml
sed -r 's@^gtk-theme-name=Bunsen$@gtk-theme-name=Bunsen-Blue-Dark@' ~/.config/gtk-3.0/settings.ini
sed -r 's@^([^<]+)<property\sname="theme"\stype="string"\svalue="([a-zA-Z\-]+)"/>$@\1<property name="theme" type="string" value="Bunsen-Blue-Dark"/>@' .config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml

# Set wallpaper to image that matches Bunsen-Blue-Dark theme.
sed -r "s@file=.*@file=/home/$USER/Pictures/bl-wallpaper.png@" ~/.config/nitrogen/bg-saved.cfg

# Setup thunar preferences.
sed -i 's@ThunarLocationButtons@ThunarLocationEntry@' ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i 's@<property\sname="last-show-hidden"\stype="bool"\svalue="false"/>@<property name="last-show-hidden" type="bool" value="true"/>@' ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i 's@<property\sname="misc-single-click"\stype="bool"\svalue="true"/>@<property name="misc-single-click" type="bool" value="false"/>@' ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i '/<\/channel>/i \
  <property name="misc-middle-click-in-tab" type="bool" value="true"/>' ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
