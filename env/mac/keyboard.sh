#!/bin/bash

#
#  アプリのキーボードショートカット設定
#  https://gist.github.com/scottrbaxter/8a150546cd4a306cbd8adcf3ce52fe8b
#
###########################################

apps="NSGlobalDomain"
CMD="@"
CTRL="^"
OPT="~"
SHIFT="$"
# UP='\U2191'
# DOWN='\U2193'
# LEFT='\U2190'
# RIGHT='\U2192'
# TAB='\U21e5'

add_keyboard_shortcut() {
  app_full_path=$1
  keybindings=$2
  if [ ! -e "$app_full_path" ]; then
    echo "$app_full_path does not exist."
    return 1
  fi
  bundle_id=$(mdls -raw -name kMDItemCFBundleIdentifier "$app_full_path")
  apps=$(printf "%s,\n'%s'" "$apps" "$bundle_id" )
  defaults write "$bundle_id" NSUserKeyEquivalents "$keybindings"
}

add_keyboard_shortcut '/Applications/Google Chrome.app' "{
  'Pin Tab' = '${CMD}${SHIFT}p';
  'Duplicate Tab' = '${CMD}${SHIFT}o';
  'Extensions' = '${CMD}${SHIFT}x';
  'Downloads' = '${CMD}${SHIFT}d';
  'Mute Site' = '${CMD}m';
  'Developer Tools' = '${CMD}${SHIFT}i';
  'JavaScript Console' = '${CMD}${SHIFT}j';
  'Save Page As…' = '${CMD}${ALT}s';
  'Minimize' = '${CMD}${SHIFT}${OPT}${CTRL}m';
  'Email Link' = '${CMD}${SHIFT}${OPT}${CTRL}i';
  'Hide Google Chrome' = '${CMD}${SHIFT}${OPT}h';
  'Hide Others' = '${CMD}${SHIFT}${OPT}${CTRL}h';
}"

# add_keyboard_shortcut '/Applications/Safari.app' "{
#   'Show Start Page' = '${CMD}${SHIFT}h';
#   'Add Bookmark…' = '${CMD}s';
#   'Add Bookmarks For These Tabs…' = '${CMD}${SHIFT}s';
#   'Pin Tab' = '${CMD}${SHIFT}p';
#   'Duplicate Tab' = '${CMD}${SHIFT}o';
#   'Show Downloads' = '${CMD}${SHIFT}d';
#   'Mute This Tab' = '${CMD}m';
#   'Show Web Inspector' = '${CMD}i';
#   'Show JavaScript Console' = '${CMD}${SHIFT}j';
#   'Save As…' = '${CMD}${ALT}s';
#   'Merge All Windows' = '${CMD}${SHIFT}m';
#   'Minimize' = '${CMD}${SHIFT}${OPT}${CTRL}m';
#   'Email Link' = '${CMD}${SHIFT}${OPT}${CTRL}i';
#   'Hide Safari' = '${CMD}${SHIFT}${OPT}h';
#   'Hide Others' = '${CMD}${SHIFT}${OPT}${CTRL}h';
# }"

add_keyboard_shortcut '/System/Library/CoreServices/Finder.app' "{
  'Downloads' = '${CMD}${SHIFT}d';
}"

add_keyboard_shortcut '/Applications/Obsidian.app' "{
  'Force Reload' = '${CMD}r';
}"

echo "$apps"
set -x

if defaults read com.apple.universalaccess com.apple.custommenu.apps > /dev/null 2>&1; then
  defaults delete com.apple.universalaccess com.apple.custommenu.apps
fi
defaults write com.apple.universalaccess com.apple.custommenu.apps -array
defaults write com.apple.universalaccess com.apple.custommenu.apps "(
  $apps
)"

for app in cfprefsd Dock Finder 'Google Chrome' Safari SystemUIServer; do
  killall "$app" &> /dev/null
done
