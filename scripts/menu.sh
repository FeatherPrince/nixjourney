!/bin/bash
# sudo nixos-rebuild switch --impure --flake $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )/..#plasma


# BINARY_PATH=$(readlink -f /proc/self/exe)
# BINARY_DIR=$(dirname "$BINARY_PATH")
# pwd -P
# read -p "configuration "$BALLS
# echo $BALLS

# Gets the absolute path of the currently running binary
clear
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )
# echo $SCRIPT_DIR
CACHE=$(cat $SCRIPT_DIR/../cache)
# echo $CACHE

# SHORTENED_COMMAND() {
# 	sudo nixos-rebuild switch --impure --flake "${SCRIPT_DIR}"/../.#
# }


# ls $SCRIPT_DIR/../.#

# FLAKE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )/..
# FLAKE_REBUILD=$(sudo nixos-rebuild switch --impure --flake $(FLAKE_DIR))

# sudo nixos-rebuild switch --impure --flake

# sudo nixos-rebuild switch --impure --flake ${SCRIPT_DIR}/..
# FLAKE=${nixos-rebuild switch --impure --flake ${SCRIPT_DIR}/../.#}


# sudo $FLAKE_DIR plasma

# 1. Define the prompt (PS3 is the special variable for select prompts)
PS3="Please enter your choice (1-9): "

# 2. Define the options as an array
options=(
	"cancel"
	"garbage collect all previous configurations"
	"rebuild, upgrade and reboot the current configuration"
	"rebuild the current configuration without upgrading or restarting"
	"headless - reboot"
	"gnome - reboot"
	"plasma - reboot"
	"hyprland - reboot - deprecated"
	"noctalia - reboot"
	"mangowm - reboot"
	"niri - reboot"
	"weston - reboot"
	"river - reboot"
)
# echo choose configuration
# 3. Create the select loop
# 'opt' will hold the text of the chosen option
# 'REPLY' will hold the number the user actually typed
# 'update' updates the package list
# 'upgrade' downloades presumably updated packages from a list
select opt in "${options[@]}"; do
	case $opt in
		"cancel")
			echo cancelled
			break
		;;
		"garbage collect all previous configurations")
			sudo nix-collect-garbage -d &&
			sudo nixos-rebuild switch --impure --flake ${SCRIPT_DIR}/../.#$CACHE &&
			break
		;;
		"rebuild, upgrade and reboot the current configuration")
			cd ${SCRIPT_DIR}/.. && nix flake update
			sudo nix-collect-garbage --delete-older-than 30d &&
			sudo nixos-rebuild boot --impure --flake ${SCRIPT_DIR}/../.#$CACHE &&
			sudo reboot now
			break
		;;
		"rebuild the current configuration without upgrading or restarting")
			# reloads the current configuration, for debugging purposes
			sudo nixos-rebuild switch --impure --flake ${SCRIPT_DIR}/../.#$CACHE &&
			break
			# sudo reboot now
		;;
		"headless - reboot")
			VAR="headless"
			sudo echo $VAR > ${SCRIPT_DIR}/../cache &&
			sleep 1 &&
			sudo nixos-rebuild boot --impure --flake ${SCRIPT_DIR}/../.#$VAR &&
			# break
			sudo reboot now
		;;
		"gnome - reboot")
			VAR="gnome"
			sudo echo $VAR > ${SCRIPT_DIR}/../cache &&
			sleep 1 &&
			sudo nixos-rebuild boot --impure --flake ${SCRIPT_DIR}/../.#$VAR &&
			# break
			sudo reboot now
		;;
		"plasma - reboot")
			VAR="plasma"
			sudo echo $VAR > ${SCRIPT_DIR}/../cache &&
			sleep 1 &&
			sudo nixos-rebuild boot --impure --flake ${SCRIPT_DIR}/../.#$VAR &&
			# break
			sudo reboot now
		;;
		"hyprland - reboot - deprecated")
			VAR="hyprland"
			sudo echo $VAR > ${SCRIPT_DIR}/../cache &&
			sleep 1 &&
			sudo nixos-rebuild boot --impure --flake ${SCRIPT_DIR}/../.#$VAR &&
			# break
			sudo reboot now
		;;
		"noctalia - reboot")
			VAR="noctalia"
			sudo echo $VAR > ${SCRIPT_DIR}/../cache &&
			sleep 1 &&
			sudo nixos-rebuild boot --impure --flake ${SCRIPT_DIR}/../.#$VAR &&
			# break
			sudo reboot now
		;;
		"mangowm - reboot")
			VAR="mangowm"
			sudo echo $VAR > ${SCRIPT_DIR}/../cache &&
			sleep 1 &&
			sudo nixos-rebuild boot --impure --flake ${SCRIPT_DIR}/../.#$VAR &&
			# break
			sudo reboot now
		;;
		"niri - reboot")
			VAR="niri"
			sudo echo $VAR > ${SCRIPT_DIR}/../cache &&
			sleep 1 &&
			sudo nixos-rebuild boot --impure --flake ${SCRIPT_DIR}/../.#$VAR &&
			# break
			sudo reboot now
		;;
		"weston - reboot")
			VAR="weston"
			sudo echo $VAR > ${SCRIPT_DIR}/../cache &&
			sleep 1 &&
			sudo nixos-rebuild boot --impure --flake ${SCRIPT_DIR}/../.#$VAR &&
			# break
			sudo reboot now
		;;
		"river - reboot")
			VAR="river"
			sudo echo $VAR > ${SCRIPT_DIR}/../cache &&
			sleep 1 &&
			sudo nixos-rebuild boot --impure --flake ${SCRIPT_DIR}/../.#$VAR &&
			# break
			sudo reboot now
		;;
		*)
			echo "Invalid option. Try another one."
		;;
	esac
done
