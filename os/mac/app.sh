#!/bin/bash

set -x

#
#  アプリのキーボードショートカット設定
#  https://gist.github.com/scottrbaxter/8a150546cd4a306cbd8adcf3ce52fe8b
#
###########################################

app_list=""
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
  fi
  bundle_id=$(mdls -raw -name kMDItemCFBundleIdentifier "$1")
  appList+="$bundle_id\n"
  echo "$app_full_path: $bundle_id"
  defaults write "$bundle_id" NSUserKeyEquivalents "$keybindings"
}

add_keyboard_shortcut '/Applications/Google Chrome.app' "{
  'Bookmark This Tab…' = '${CMD}s';
  'Bookmark All Tabs…' = '${CMD}${SHIFT}s';
  'Pin Tab' = '${CMD}${SHIFT}p';
  'Duplicate Tab' = '${CMD}${SHIFT}o';
  'Extensions' = '${CMD}${SHIFT}x';
  'Downloads' = '${CMD}${SHIFT}d';
  'Mute Site' = '${CMD}m';
  'Developer Tools' = '${CMD}i';
  'JavaScript Console' = '${CMD}${SHIFT}j';
  'Save Page As…' = '${CMD}${ALT}s';
  'Minimize' = '${CMD}${SHIFT}${OPT}${CTRL}m';
  'Email Link' = '${CMD}${SHIFT}${OPT}${CTRL}i';
  'Hide Google Chrome' = '${CMD}${SHIFT}${OPT}h';
  'Hide Others' = '${CMD}${SHIFT}${OPT}${CTRL}h';
}"

add_keyboard_shortcut '/System/Library/CoreServices/Finder.app' "{
  'Downloads' = '${CMD}${SHIFT}d';
}"

add_keyboard_shortcut '/Applications/Obsidian.app' "{
  'Force Reload' = '${CMD}r';
}"

# check if universal access / custom menu key exists
if defaults read com.apple.universalaccess com.apple.custommenu.apps > /dev/null 2>&1; then
  defaults delete com.apple.universalaccess com.apple.custommenu.apps
fi
defaults write com.apple.universalaccess com.apple.custommenu.apps -array
# write all apps to custommenu
defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "$(echo -e "$app_list")"

for app in cfprefsd Dock Finder 'Google Chrome' SystemUIServer; do
  killall "$app" &> /dev/null
done

#
#  AltTab
#
###########################################

# グローバルな設定
defaults write com.lwouis.alt-tab-macos menubarIcon -int 3
defaults write com.lwouis.alt-tab-macos alignThumbnails -int 0
defaults write com.lwouis.alt-tab-macos arrowKeysEnabled -bool true
defaults write com.lwouis.alt-tab-macos mouseHoverEnabled -bool false
defaults write com.lwouis.alt-tab-macos cursorFollowFocusEnabled -bool false
defaults write com.lwouis.alt-tab-macos hideSpaceNumberLabels -bool false
defaults write com.lwouis.alt-tab-macos hideThumbnails -bool false
defaults write com.lwouis.alt-tab-macos shortcutStyle -int 0
defaults write com.lwouis.alt-tab-macos showOnScreen -int 1

# ショートカットごとの設定
defaults write com.lwouis.alt-tab-macos holdShortcut "\\U2318"
defaults write com.lwouis.alt-tab-macos nextWindowShortcut "\\U21e5"
defaults write com.lwouis.alt-tab-macos nextWindowShortcut2 "\\U21e5"
defaults write com.lwouis.alt-tab-macos appsToShow -int 0
defaults write com.lwouis.alt-tab-macos appsToShow2 -int 1
defaults write com.lwouis.alt-tab-macos spacesToShow -int 1
defaults write com.lwouis.alt-tab-macos spacesToShow2 -int 1
defaults write com.lwouis.alt-tab-macos screensToShow -int 0
defaults write com.lwouis.alt-tab-macos screensToShow2 -int 0
defaults write com.lwouis.alt-tab-macos showMinimizedWindows -int 1
defaults write com.lwouis.alt-tab-macos showMinimizedWindows2 -int 1
defaults write com.lwouis.alt-tab-macos showHiddenWindows -int 1
defaults write com.lwouis.alt-tab-macos showHiddenWindows2 -int 1
defaults write com.lwouis.alt-tab-macos showFullscreenWindows -int 1
defaults write com.lwouis.alt-tab-macos showFullscreenWindows2 -int 1;

# ウィンドウを持たないアプリは非表示
# なぜかうまく設定できないことがあるのでこれだけ手動かも
defaults write com.lwouis.alt-tab-macos hideWindowlessApps -bool true
