#!/usr/bin/env bash
#
# MIT License
# 
# Copyright (c) 2020 Josip Antoliš
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

while getopts d:i: option; do
	case "${option}" in
		d) dir=${OPTARG};;
		i) interval=${OPTARG};;
	esac
done

dir=${dir:-$"$HOME/Pictures/Wallpapers"}
interval=${interval:-"5m"}

while [ 1 ]; do
	for file in $(ls $dir | shuf); do
		pic="$dir/$file"
		if identify -quiet -format "" $pic 2> /dev/null; then
			uri="file://$pic"
			gsettings set org.gnome.desktop.background picture-uri $uri
			gsettings set org.gnome.desktop.background picture-options scaled
			gsettings set org.gnome.desktop.background color-shading-type vertical
			regex="rgb\(\d+,\d+,\d+\)$"
			colors=$(convert $pic -colorspace RGB +dither -colors 2 histogram:- |\
				identify -format %c - |\
				grep -oP $regex)
			arr=($colors)
			gsettings set org.gnome.desktop.background primary-color ${arr[0]}
			gsettings set org.gnome.desktop.background secondary-color ${arr[1]-${arr[0]}}

			rm -f "$XDG_GREETER_DATA_DIR/wallpaper"/*
			greeter="$XDG_GREETER_DATA_DIR/wallpaper/$file"
			target_ratio=$(bc -l <<< '1280/720')
			dimen=$(identify -quiet -format "%wx%h" $pic)
			width="${dimen%%x*}"
			height="${dimen##*x}"
			ratio=$(bc -l <<< "$width/$height")
			if (( $(bc -l <<< "$ratio > $target_ratio") )); then
				new_width=$(bc -l <<< "scale=0; $target_ratio*$height")
				crop_to="${new_width}x$height"
			else
				new_height=$(bc -l <<< "scale=0; (1/$target_ratio)*width")
				crop_to="${width}x$new_height"
			fi
			convert $pic -gravity center -crop $crop_to+0+0 -resize 1280x720 $greeter

			dbus-send --system --print-reply \
				--dest=org.freedesktop.Accounts \
				/org/freedesktop/Accounts/User1000 \
				org.freedesktop.DBus.Properties.Set \
				string:org.freedesktop.DisplayManager.AccountsService \
				string:BackgroundFile \
				variant:string:"$greeter"
			sleep $interval
		fi
	done
done
