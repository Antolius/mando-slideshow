# Mando Slideshow

A bash script that will loop through wallpapers in a slideshow accompanied by a collection of wallpapers  of [The Mandalorian](https://www.starwars.com/series/the-mandalorian) closing credits concept art.

This mini-project is made as a companion to the [Star Wars viewing party](https://cassidyjames.com/starwars/) run by @cassidyjames that leads to the release of the second season of the Mandalorian. As such the wallpapers directory currently contains only images from the first episode; Chapter 1: The Mandalorian. I'll be adding images from the subsequent episodes weekly.

## Features

Slideshow script will:

* Change wallpaper image in configured intervals.
* Fill the portions of the screen not populated by the image with matching colors.
* Update the greeter picture on the lock screen with a cropped version of the current wallpaper.

## Prerequisites

The slideshow.sh script requires [Image Magic](https://imagemagick.org/index.php) for its image inspection and manipulations.

It's written and tested on [Elementary OS](https://elementary.io/) and might not work with other desktop environments. In particular it's using the `org.gnome.desktop.background` gsettings to set the wallpaper. The LightDM's lock screen background file is updated through AccountService D-Bus interface.

## Installation

You can clone this project from git and then add execution rights to the `slideshow.sh` script and move it somewhere more accessible. For example:

```sh
sudo chmod +x ./slideshow.sh \
&& sudo mv ./slideshow.sh /usr/local/bin/slideshow.sh
```

You might also want to move the images from the wallpapers directory somewhere inside your home dir.

Once you have the images and the slideshow.sh where you want them, you can set the script to run when the system starts. On Elementary you can do it from UI by going to `System Settings > Applications > Startup` and adding a `slideshow.sh` command. Zou can find more info over at Elementary's stack exchange: [link](https://elementaryos.stackexchange.com/a/10910). You can also set it up in any other non-gui way that you know.

## Usage

The `slideshow.sh` itself accepts 2 flags: `-d` for absolute path to the directory with wallpaper images and `-i` for slideshow interval. By default, if no flags are provided, it will look for wallpapers in `~/Pictures/Wallpapers` and will update every 5 minutes.

### Example

Running with default values (looping through images in `~/Pictures/Wallpapers`, changing wallpaper every 10 minutes):

```sh
slideshow.sh
```

Running with custom wallpapers directory:

```sh
slideshow.sh -d ~/wallpapers
```

Running with custom slideshow interval:

```sh
slideshow.sh -i 1m
```

Running with both custom directory and interval:

```sh
slideshow.sh -d ~/wallpapers -i 10s
```

## License

The slideshow script is distributed under the MIT License. The concept art wallpaper images are property of Disney.

## Authors

- Josip Antoliš - [Antolius](https://github.com/Antolius)
