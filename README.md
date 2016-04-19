# bunsenlabs-setup
Personal repo for my steps to setup Bunsenlabs on my computer

The setup.sh script is to be ran as follows:
```
cd /tmp/
wget https://github.com/nalipaz/bunsenlabs-setup/archive/master.zip && unzip master.zip && rm master.zip
./bunsenlabs-setup-master/setup.sh

```
Then follow the prompts (if any).

Running the script will do the following to the installation:

 * Install Google Chrome, official (not chromium)
 * Install vim
 * Install silver searcher ag
 * Install shutter and setup new screenshot keybindings in openbox which replace the stock screenshot keybindings
 * Install virtualbox and the virtualbox extension pack
 * Configure lightdm to default the login to the last user who logged in
 * Install/setup plymouth with a theme so that lvm encrypted drives have a nice looking bunsen login screen
 * Install/setup obmenu-generator so that the openbox menu is more organized and has icons
 * Alter tint2 bar to have two timezones (local and Tokyo)
 * Change the theme system-wide to use Bunsen Blue Dark
 * Change the desktop wallpaper to match the theme.
 * Setup Thunar preferences to be what I consider more desired defaults.

That is all for now.
