!/bin/bash

count=1

	clear
while [ $count -le 1 ]; do

	PS3="Please enter your choice (1-5): "

	options=(
		"exit"
		"menu"
		"headless"
		"plasma"
		"hyprland"
	)

	select opt in "${options[@]}"; do
		case $opt in
			"exit")
			((count++))
			clear
			break
			;;
			"menu")
			PS3="Please enter your choice (1-2): "
			echo
			echo cancel
			clear
			options=(
				"back"
				"cock"
			)
			select opt in "${options[@]}"; do
				case $opt in
					"back")
					clear
					break
					;;
					"cock")
					clear
					echo "		cock"
					break
					;;
				esac
			done
			break
			;;
			"headless")
			clear
			echo headless
			break
			;;
			"plasma")
			clear
			echo plasma
			break
			;;
			"hyprland")
			clear
			echo hyprland
			break
			;;
			*)
			clear
			echo "Invalid option. Try another one."
			break
			;;
		esac
	done
done
