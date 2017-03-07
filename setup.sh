#!/bin/bash

cd /tmp/

# Google chrome, not chromium.
echo "### Setup Google Chrome dependencies..."
sleep 4
sudo apt-get install libxss1 libappindicator1 libindicator7 -y
echo "### Download Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
echo "### Install Google Chrome..."
sleep 4
sudo dpkg -i google-chrome*.deb
## Add to startups as a background app.
echo "### Add Google Chrome as a background app in the openbox autostarted applications."
sleep 4
echo "(sleep 4 && /usr/bin/google-chrome-stable --no-startup-window) &" >> /home/$USER/.config/openbox/autostart
echo "### You must sign in to Google Chrome and have at least one extension that runs as a background app for chrome to start up correctly, please sign and and make sure you have a background app installed, then *quit* Google Chrome to resume this script..."
/usr/bin/google-chrome-stable

# vim and ag.
echo "### Install vim and ag for better development..."
sleep 4
sudo apt-get install vim silversearcher-ag -y

# Shutter.
echo "### Install shutter for better screenshots and setup preferences..."
sleep 4
mv bunsenlabs-setup-master/home/.shutter ~
sudo apt-get install shutter -y
sed -i '@<command>xfce4-screenshooter</command>@<command>shutter -f</command>@' ~/.config/openbox/rc.xml
sed -i '@<command>scrot.*</command>@<command>shutter -w</command>@' ~/.config/openbox/rc.xml
sed '/<command>shutter\s\-w<\/command>/{N;N;s/$/\
    <keybind key="S-Print">\
      <action name="Execute">\
        <command>shutter \-s<\/command>\
      <\/action>\
    <\/keybind>/}' ~/.config/openbox/rc.xml
shutter --min_at_startup &

# Virtualbox and virtualbox extension pack for usb support.
echo "### Install Virtualbox dependencies..."
sleep 4
sudo apt-get install build-essential libssl-dev linux-headers-`uname -r` -y
sudo apt-get install dkms -y
echo "### Install Virtualbox"
sleep 4
sudo apt-get install -t jessie-backports virtualbox virtualbox-dkms -y
sudo su <<CMD
 /etc/init.d/vboxdrv setup
 exit
CMD
sudo dpkg-reconfigure virtualbox-dkms && sudo modprobe vboxdrv

# Install virtualbox extension pack.
echo "### Installing Virtualbox extension pack for usb support..."
sleep 4
echo "### Downloading the Virtualbox extension pack, sometimes this can take a while..."
VBOXVERSION=`VBoxManage --version | sed -r 's/([0-9])\.([0-9])\.([0-9]{1,2}).*/\1.\2.\3/'`
wget -q -N "http://download.virtualbox.org/virtualbox/$VBOXVERSION/Oracle_VM_VirtualBox_Extension_Pack-$VBOXVERSION.vbox-extpack"
VBoxManage extpack install --replace Oracle*.vbox-extpack

# Make lightdm default the username to last logged in user
echo "### Make login default to last logged in user..."
sleep 4
sudo sed -i 's@greeter\-hide\-users=true@greeter-hide-users=false@' /etc/lightdm/lightdm.conf

# Setup plymouth for a better login experience in lvm encrypted drives.
echo "### Setup plymouth for a better login experience on an lvm encrypted drive..."
sleep 4
RESOLUTION=$(xdpyinfo | echo $(grep 'dimensions:') | sed -E "s@dimensions:\s([0-9]+)x([0-9]+).*@\1x\2@")
sudo aptitude install plymouth plymouth-themes bunsen-images-extra imagemagick -y
convert /usr/share/images/bunsen/wallpapers/default/flame-text-1920x1200-centre-blue.png -resize $RESOLUTION^ -gravity center -crop $RESOLUTION+0+0 ~/Pictures/wallpapers/bl-grub-$RESOLUTION.png
cp ~/Pictures/wallpapers/bl-grub-*.png ~/Pictures/wallpapers/bl-wallpaper.png
sudo cp ~/Pictures/wallpapers/bl-grub-*.png /boot/grub/
sudo sed -i -E "s@GRUB_CMDLINE_LINUX_DEFAULT=\"([a-z\s0-9]+)\"@GRUB_CMDLINE_LINUX_DEFAULT=\"\1 splash loglevel=3 vga=current\"@" /etc/default/grub
sudo update-grub
sudo su <<CMD
 cd /tmp/
 echo "GRUB_GFXMODE=$RESOLUTION" >> /etc/default/grub
 update-grub
 if [[ "$(lspci | echo $(grep -i -E 'vga|3d|2d') | sed -E 's@.*(intel|ati|nvidia)\s.*@\1@i')" == 'Intel' ]]; then printf "# KMS\nintel_agp\ndrm\ni915 modeset=1" >> /etc/initramfs-tools/modules; fi
 wget https://github.com/nalipaz/bunsen-plymouth-theme/archive/master.zip
 unzip master.zip
 rm master.zip
 mv bunsen-plymouth-theme-master/ /usr/share/plymouth/themes/bunsen
 /usr/sbin/plymouth-set-default-theme bunsen
 update-initramfs -u
 exit
CMD

# Setup better menu with icons using obmenu-generator.
echo "### Setup better menu with icons using obmenu-generator."
sleep 4
sudo aptitude install cpanminus build-essential -y
wget https://github.com/trizen/obmenu-generator/archive/master.zip && unzip master.zip && rm master.zip
chmod +x obmenu-generator-master/obmenu-generator
sudo mv obmenu-generator-master/obmenu-generator /usr/bin/
sudo cpanm Linux::DesktopFiles
sudo cpanm Data::Dump
rm obmenu-generator
mv bunsenlabs-setup-master/home/.config/obmenu-generator ~/.config/
obmenu-generator -p -i

# Alter tint2 preferences.
echo "### Setup tint2 to use our preferences..."
sleep 4
sed -i -r 's@^#time@time@' ~/.config/tint2/tint2rc
sed -i -r 's@^time([0-9])_format.*$@time\1_format = %a %l:%M %p %Z on %e %b %Y@' ~/.config/tint2/tint2rc
sed -i -r 's@^(time2_format.*)$@\1\ntime2_timezone = :Asia/Tokyo@' ~/.config/tint2/tint2rc
sed -i -r 's@time1_font\s=\s(.*)\s([0-9]+)@time1_font = \1 10@' ~/.config/tint2/tint2rc
sed -i -r 's@time2_font\s=\s(.*)\s([0-9]+)@time2_font = \1 9@' ~/.config/tint2/tint2rc

# Change everything to Bunsen-Blue-Dark theme.
echo "### Change theme to Bunsen-Blue-Dark system-wide..."
sleep 4
function reloadGTK(){
python - <<END
import gtk
events=gtk.gdk.Event(gtk.gdk.CLIENT_EVENT)
data=gtk.gdk.atom_intern("_GTK_READ_RCFILES", False)
events.data_format=8
events.send_event=True
events.message_type=data
events.send_clientmessage_toall()
END
}
sed -i '/<theme>/!b;n;c\    <name>Bunsen-Blue-Dark</name>' ~/.config/openbox/rc.xml
sed -i -r 's@^gtk-theme-name=Bunsen$@gtk-theme-name=Bunsen-Blue-Dark@' ~/.config/gtk-3.0/settings.ini
sed -i -r 's@^([^<]+)<property\sname="theme"\stype="string"\svalue="([a-zA-Z\-]+)"/>$@\1<property name="theme" type="string" value="Bunsen-Blue-Dark"/>@' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-notifyd.xml
sed -i -r 's@^gtk-theme-name="([^"]+)"$@gtk-theme-name="Bunsen-Blue-Dark"@' ~/.gtkrc-2.0
reloadGTK

# Set wallpaper to image that matches Bunsen-Blue-Dark theme.
nitrogen --save --set-zoom-fill "/home/$USER/Pictures/wallpapers/bl-wallpaper.png"

# Setup thunar preferences.
echo "### Setup Thunar preferences..."
sleep 4
sed -i 's@ThunarLocationButtons@ThunarLocationEntry@' ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i 's@<property\sname="last-show-hidden"\stype="bool"\svalue="false"/>@<property name="last-show-hidden" type="bool" value="true"/>@' ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i 's@<property\sname="misc-single-click"\stype="bool"\svalue="true"/>@<property name="misc-single-click" type="bool" value="false"/>@' ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
sed -i '/<\/channel>/i \
  <property name="misc-middle-click-in-tab" type="bool" value="true"/>' ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml

# Install some programs.
echo "### Installing gimp..."
sleep 2
sudo apt-get install gimp -y
# Basically just set gimp to single-window mode.
cp bunsenlabs-setup-master/home/.gimp-x.x/sessionrc ~/.gimp-*/ -r

echo "### Rebooting to apply all changes..."
sleep 4
sudo reboot

# Setup Docker
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
sudo apt-get -y install docker-ce
sudo mkdir -p /etc/systemd/system/docker.service.d/ &&\
printf '[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// -s devicemapper
' | sudo tee /etc/systemd/system/docker.service.d/execstart_override.conf
sudo systemctl daemon-reload
sudo systemctl start docker
