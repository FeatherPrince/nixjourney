{ pkgs, ... }:

{
    fonts.packages = with pkgs; [
		nerd-fonts.hack
		nerd-fonts.symbols-only
		nerd-fonts.noto
		noto-fonts
		noto-fonts-color-emoji
		noto-fonts-monochrome-emoji
		noto-fonts-cjk-sans
		noto-fonts-cjk-serif
		openmoji-color
		openmoji-black
		twitter-color-emoji
		twemoji-color-font
		#whatsapp-emoji-font #bugged
		unicode-emoji
		liberation_ttf
		fira-code
		fira-code-symbols
		mplus-outline-fonts.githubRelease
		dina-font
		proggyfonts
		ipafont
		ipaexfont
		weather-icons
#		noto-fonts
#		noto-fonts-lgc-plus
#		noto-fonts-cjk-sans
#		noto-fonts-cjk-serif
#		noto-fonts-color-emoji
#		noto-fonts-emoji-blob-bin
#		noto-fonts-monochrome-emoji
#		nerd-fonts.symbols-only
#		font-awesome
#		font-awesome_4
#		font-awesome_5
	];
}
