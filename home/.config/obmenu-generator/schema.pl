#!/usr/bin/perl

# obmenu-generator - schema file

=for comment
    item:      add an item inside the menu               {item => ["command", "label", "icon"]},
    cat:       add a category inside the menu             {cat => ["name", "label", "icon"]},
    sep:       horizontal line separator                  {sep => undef}, {sep => "label"},
    pipe:      a pipe menu entry                         {pipe => ["command", "label", "icon"]},
    raw:       any valid Openbox XML string               {raw => q(xml string)},
    begin_cat: begin of a category                  {begin_cat => ["name", "icon"]},
    end_cat:   end of a category                      {end_cat => undef},
    obgenmenu: generic menu settings                {obgenmenu => ["label", "icon"]},
    exit:      default "Exit" action                     {exit => ["label", "icon"]},
=cut

# NOTE:
#    * Keys and values are case sensitive. Keep all keys lowercase.
#    * ICON can be a either a direct path to an icon or a valid icon name
#    * Category names are case insensitive. (X-XFCE and x_xfce are equivalent)

require "$ENV{HOME}/.config/obmenu-generator/config.pl";

## Text editor
my $editor = $CONFIG->{editor};

our $SCHEMA = [
    {item => ['gmrun', 'Run Program', 'gmrun']},	
    {sep => undef},	
    {item => ['x-terminal-emulator', 'Terminal', 'terminal']},
    {item => ['x-www-browser', 'Web Browser', 'web-browser']},
    {item => ['bl-file-manager', 'File Manager', 'file-manager']},
    {item => ['bl-text-editor', 'Text Editor', 'text-editor']},
    {item => ['bl-media-player', 'Media Player', 'media-player']},
    {sep => undef},
    {cat => ['utility',     'Accessories', 'applications-utilities']},
    {cat => ['development', 'Development', 'applications-development']},
    {cat => ['education',   'Education',   'applications-science']},
    {cat => ['graphics',    'Graphics',    'applications-graphics']},
    {cat => ['audiovideo',  'Multimedia',  'applications-multimedia']},
    {cat => ['network',     'Network',     'applications-internet']},
    {cat => ['office',      'Office',      'applications-office']},
    {cat => ['other',       'Other',       'applications-other']},
    {sep => undef},
    {obgenmenu => ['Openbox Settings', 'openbox']},
    {sep => undef},
    {pipe => ['bl-places-pipemenu', 'Places', 'places']},
    {pipe => ['bl-recent-files-pipemenu', 'Recent Files', 'recent-files']},
    {cat => ['settings',    'Settings',    'applications-accessories']},
    {cat => ['system',      'System',      'applications-system']},
    {sep => undef},
    {raw => q(<menu id="preferences" label="Preferences"> <menu id="obConfig" label="Openbox"> <item label="Edit menu.xml"> <action name="Execute"> <command> bl-text-editor ~/.config/openbox/menu.xml </command> </action> </item> <item label="Edit rc.xml"> <action name="Execute"> <command> bl-text-editor ~/.config/openbox/rc.xml </command> </action> </item> <item label="Edit autostart"> <action name="Execute"> <command> bl-text-editor ~/.config/openbox/autostart </command> </action> </item> <separator/> <item label="GUI Menu Editor"> <action name="Execute"> <command> obmenu </command> </action> </item> <item label="GUI Config Tool"> <action name="Execute"> <command> obconf </command> </action> </item> <item label="How to Edit Menu"> <action name="Execute"> <command> yad --button="OK":0 --center --window-icon=distributor-logo-bunsenlabs --text-info --title=&quot;How to Edit the Menu&quot; --filename=&quot;/usr/share/bunsen/bunsen-docs/helpfile-menu.txt&quot; --width=900 --height=700 --fontname=Monospace </command> </action> </item> <separator/> <item label="Reconfigure"> <action name="Reconfigure"/> </item> <item label="Restart"> <action name="Restart"/> </item> </menu> <menu execute="bl-compositor" id="CompositingPipeMenu" label="Compositor"/> <menu execute="bl-conky-pipemenu" id="pipe-conkymenu" label="Conky"/> <menu execute="bl-tint2-pipemenu" id="pipe-tint2menu" label="Tint2"/> <item label="Appearance"> <action name="Execute"> <command> lxappearance </command> </action> </item> <item label="Choose Wallpaper"> <action name="Execute"> <command> nitrogen </command> </action> </item> <item label="Notifications"> <action name="Execute"> <command>xfce4-notifyd-config</command> </action> </item> <item label="Power Management"> <action name="Execute"> <command> xfce4-power-manager-settings </command> </action> </item> <menu id="dmenuconfig" label="dmenu"> <item label="Edit Start-up Script"> <action name="Execute"> <command> bl-text-editor ~/.config/dmenu/dmenu-bind.sh </command> </action> </item> <separator label="Help?"/> <item label="man page"> <action name="Execute"> <command> x-terminal-emulator -T 'man dmenu' -e man dmenu </command> </action> </item> </menu> <menu id="gmrunconfig" label="gmrun"> <item label="Edit Config File"> <action name="Execute"> <command> bl-text-editor ~/.gmrunrc </command> </action> </item> <separator label="Help?"/> <item label="man page"> <action name="Execute"> <command> x-terminal-emulator -T 'man gmrun' -e man gmrun </command> </action> </item> </menu> <menu id="DisplaySettings" label="Display"> <item label="ARandR Screen Layout Editor"> <action name="Execute"> <command> arandr </command> </action> </item> <separator label="Help?"/> <item label="man xrandr"> <action name="Execute"> <command> x-terminal-emulator -T 'man xrandr' -e man xrandr </command> </action> </item> </menu> </menu>)},
    {item => ['bl-lock', 'Lock Screen', 'lock-screen']},
    {item => ['bl-exit', 'Exit', 'exit']},
]
