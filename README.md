# Funkin Legacy

This is the repository for "Funkin Legacy",
a port of Friday Night Funkin 0.3.0+ and onward into 0.2.8,
cause why not? :)

Play FNF on Newgrounds here: https://www.newgrounds.com/portal/view/770371
Play FNF on Itch.io here: https://ninja-muffin24.itch.io/funkin

IF YOU MAKE A MOD AND DISTRIBUTE A MODIFIED / RECOMPILED VERSION, YOU MUST OPEN SOURCE YOUR MOD AS WELL

## Credits

### Programmers
- [Macohi](https://sphis-sinco.carrd.co)
- [Funni Boi](https://github.com/yeeterongithub)

### Artists / Animators
- [Djotta Flow](https://www.youtube.com/@djotta11)


## Build Instructions

A fleshed out doc will have to come later but here is the run down, 
I am going to assume you've already downloaded the repo .zip for this

- Install haxe
- Install haxeflixel
- Run `haxelib --global install hmm` and then `haxelib --global run hmm setup` to install hmm.json
- Make sure you have a command prompt open for the source code folder (not `source/`)
- Run `hmm install`
- Perform additional platform setup
	- For Windows, download the [Visual Studio Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe)
    	- When prompted, select "Individual Components" and make sure to download the following:
    		- MSVC v143 VS 2022 C++ x64/x86 build tools
    		- Windows 10/11 SDK
	- Mac: [`lime setup mac` Documentation](https://lime.openfl.org/docs/advanced-setup/macos/)
	- Linux: [`lime setup linux` Documentation](https://lime.openfl.org/docs/advanced-setup/linux/)
		- In order to build a application with `hxCodec` on Linux,
		you have to install libvlc and libvlccore
		from your distro's package manager.
		- Debian based distributions: `sudo apt-get install libvlc-dev libvlccore-dev`
		- Arch based distributions: `sudo pacman -S vlc`
    - HTML5: Compiles without any extra setup
