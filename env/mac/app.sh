#!/bin/bash

set -x

#
#  Safari
#
###########################################

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

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
