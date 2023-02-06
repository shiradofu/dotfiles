#!/bin/bash

msg()    { printf "\033[1;3$((i++%6+1))m%s\033[0m\n" "$1"; }
brew_i() { for X; do msg $'\n🍺  Installing '"$X"$':\n'; brew install "$X"; done }

script_dir=$(cd "$(dirname "$0")" && pwd)

brew_i install binutils coreutils findutils grep gawk gnu-sed gnu-tar gzip wget gpg

msg $'\n🔑  Setting git credential helper:'
git config --file "${XDG_CONFIG_HOME}/git/credentials.gitconfig" credential.helper osxkeychain

msg $'\n☁️  Deploying Mackup config:'
if [ ! -e "$HOME/.mackup" ]; then ln -s "$script_dir/.mackup" "$HOME/"; fi
if [ ! -e "$HOME/.mackup.cfg" ]; then ln -s "$script_dir/.mackup.cfg" "$HOME/"; fi

msg $'\n🧰  System Preference:'

#
#  Menu Bar
#
###########################################

# バッテリーの％表示
defaults -currentHost write com.apple.controlcenter.plist BatteryShowPercentage -bool true

# 時計をアナログ表示にする
defaults write com.apple.menuextra.clock IsAnalog -bool true

# Spotlight を消す
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1

#
#  Dock & Mission Control
#
###########################################

# Dock を隠す
defaults write com.apple.dock autohide -bool true

# Dock の実質無効化（表示条件を満たしてから3600秒後に表示）
defaults write com.apple.Dock autohide-delay -float 3600

# Dock にデフォルトで入っているアプリを除去
defaults write com.apple.dock persistent-apps -array

# Dock には開いているアプリのみ表示する
defaults write com.apple.dock static-only -bool true

# 最近使ったアプリを Dock に追加しない
defaults write com.apple.dock show-recents -bool false

# Mission Control で使用頻度に応じた並び替えをしない
defaults write com.apple.dock mru-spaces -bool false

#
#  Finder
#
###########################################

# 隠しファイルを表示する
defaults write com.apple.finder AppleShowAllFiles YES

# すべての拡張子のファイルを表示する
defaults write -g AppleShowAllExtensions -bool true

# ~/Library フォルダを表示する
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

# /Volumes フォルダを表示する
# sudo chflags nohidden /Volumes

# 各種情報表示
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowTabView -bool true

# デフォルトでリストビューを使用する
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# 名前で並べ替えを選択時にディレクトリを前に置くようにする
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# 検索実行時はデフォルトで現在のフォルダを対象とする
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# クイックルックでテキストを選択可能にする
defaults write com.apple.finder QLEnableTextSelection -bool TRUE

# 拡張子変更時の警告を無効化する
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# ネットワークまたは USB で接続したボリュームには .DS_Store を作らない
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# 新しいウィンドウでデフォルトでホームフォルダを開く
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# アニメーションを無効化
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

#
#  Keyboard & Trackpad
#
###########################################

# キーリピート速度を最大にする
defaults write KeyRepeat 2

# キーリピート開始までの速度を最短にする
defaults write InitialKeyRepeat 15

# トラックパッドのカーソル速度を最大にする
defaults write com.apple.trackpad.scaling 3

# 3本指でタップして検索を無効化
defaults write com.apple.Apple MultitouchTrackpad 0

# システム設定のUIをキーボードで操作できるようにする（Tabで移動、Spaceで決定等）
defaults write -g AppleKeyboardUIMode -int 3

# システムのキーボードショートカット無効化
## Dock の表示非表示切り替え
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 52 "<dict><key>enabled</key><false/></dict>"
## Spotlight
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "<dict><key>enabled</key><false/></dict>"

# アプリのキーボードショートカット設定
# https://gist.github.com/scottrbaxter/8a150546cd4a306cbd8adcf3ce52fe8b
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
  'JavaScript Console' = '${CMD}j';
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

#
#  Misc
#
###########################################

# Safari の開発者機能有効化
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

# Safari のコンテキストメニューに Web Inspector を表示
defaults write -g WebKitDeveloperExtras -bool true

# 未確認のアプリケーションを実行する際のダイアログを無効にする
defaults write com.apple.LaunchServices LSQuarantine -bool false

# 保存パネルをデフォルトで開いた状態にする
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# 印刷パネルをデフォルトで開いた状態にする
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

# スクリーンショットの保存場所を変更
defaults write com.apple.screencapture location ~/Downloads/

# 印刷が終了したら、自動的にプリンターアプリを終了する
# defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

for app in cfprefsd Dock Finder 'Google Chrome' Safari SystemUIServer; do
  killall "$app" &> /dev/null
done
