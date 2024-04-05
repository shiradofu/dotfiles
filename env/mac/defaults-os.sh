#!/bin/bash

set -x

#
#  アニメーション無効化
#  https://apple.stackexchange.com/questions/14001/how-to-turn-off-all-animations-on-os-x
#
###########################################

# opening and closing windows and popovers
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# showing and hiding sheets, resizing preference windows, zooming windows
# float 0 doesn't work
defaults write -g NSWindowResizeTime -float 0.001

# opening and closing Quick Look windows
defaults write -g QLPanelAnimationDuration -float 0

# rubberband scrolling (doesn't affect web views)
defaults write -g NSScrollViewRubberbanding -bool false

# showing a toolbar or menu bar in full screen
defaults write -g NSToolbarFullScreenAnimationDuration -float 0

# showing and hiding Mission Control, command+numbers
defaults write com.apple.dock expose-animation-duration -float 0

# at least AnimateInfoPanes
defaults write com.apple.finder DisableAllAnimations -bool true

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
chflags nohidden ~/Library

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

#
#  Keyboard & Trackpad
#
###########################################

# キーリピート速度を最大にする
defaults write -g KeyRepeat -int 2

# キーリピート開始までの速度を最短にする
defaults write -g InitialKeyRepeat -int 12

# キー長押し時に特殊文字候補を表示せずにキーリピートする
defaults write -g ApplePressAndHoldEnabled -bool true

# トラックパッドのカーソル速度を最大にする
defaults write -g com.apple.trackpad.scaling -int 3

# 3本指でタップして検索を無効化
defaults write com.apple.Apple MultitouchTrackpad -int 0

# システム設定のUIをキーボードで操作できるようにする（Tabで移動、Spaceで決定等）
defaults write -g AppleKeyboardUIMode -int 3

# システムのキーボードショートカット無効化
## Dock の表示非表示切り替え
sudo defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 52 "<dict><key>enabled</key><false/></dict>"
## Spotlight
sudo defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/></dict>"
sudo defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "<dict><key>enabled</key><false/></dict>"

#
#  Misc
#
###########################################

# クイックメモを無効化
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 1048576

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

for app in cfprefsd Dock Finder Safari SystemUIServer; do
  killall "$app" &> /dev/null
done
