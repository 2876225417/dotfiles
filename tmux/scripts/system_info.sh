#!/bin/bash

# 获取发行版信息
if [ -f /etc/os-release ]; then
    . /etc/os-release
    distro_name=$NAME
    distro_version=$VERSION_ID
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    distro_name=$DISTRIB_ID
    distro_version=$DISTRIB_RELEASE
else
    distro_name=$(uname -s)
    distro_version=$(uname -r)
fi

# 简化发行版名称并选择图标
case "${distro_name,,}" in
    *arch*)
        icon="󰣇"
        short_name="Arch"
        ;;
    *manjaro*)
        icon="󱘊"
        short_name="Manjaro"
        ;;
    *ubuntu*)
        icon="󰕈"
        short_name="Ubuntu"
        ;;
    *debian*)
        icon="󰣚"
        short_name="Debian"
        ;;
    *fedora*)
        icon="󰣛"
        short_name="Fedora"
        ;;
    *centos*)
        icon="󱄅"
        short_name="CentOS"
        ;;
    *opensuse*)
        icon="󰃀"
        short_name="openSUSE"
        ;;
    *gentoo*)
        icon="󰣨"
        short_name="Gentoo"
        ;;
    *nixos*)
        icon="󱄅"
        short_name="NixOS"
        ;;
    *endeavouros*)
        icon="󰣇"
        short_name="EndeavourOS"
        ;;
    *garuda*)
        icon="󰣇"
        short_name="Garuda"
        ;;
    *linux*)
        icon="󰌽"
        short_name="Linux"
        ;;
    *darwin*|*macos*)
        icon="󰀵"
        short_name="macOS"
        ;;
    *)
        icon="󰌽"
        short_name="Unknown"
        ;;
esac

# 获取内核版本
kernel_version=$(uname -r | cut -d'-' -f1)

# 获取系统架构
arch=$(uname -m)

printf "%s %s %s" "$icon" "$short_name" "$kernel_version"

