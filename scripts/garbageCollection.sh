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
PS3="Please enter your choice (1-5): "

# 2. Define the options as an array
options=(
	"cancel"
	"garbage collect all previous configurations"
	"headless"
	"gnome"
	"plasma"
	"hyprland"
)
# echo choose configuration
# 3. Create the select loop
# 'opt' will hold the text of the chosen option
# 'REPLY' will hold the number the user actually typed
select opt in "${options[@]}"; do
	case $opt in
		"cancel")
			echo cancelled
			break
			;;
		"garbage collect all previous configurations")
			sudo nix-collect-garbage -d
			break
			;;
		"headless")
			sudo nixos-rebuild switch --impure --flake ${SCRIPT_DIR}/../.#headless
			break
			;;
		"gnome")
			sudo nixos-rebuild switch --impure --flake ${SCRIPT_DIR}/../.#gnome
			break
			;;
		"plasma")
			sudo nixos-rebuild switch --impure --flake ${SCRIPT_DIR}/../.#plasma
			break
			;;
		"hyprland")
			sudo nixos-rebuild switch --impure --flake ${SCRIPT_DIR}/../.#hyprland
			break
			;;
		*)
			echo "Invalid option. Try another one."
			;;
	esac
done
