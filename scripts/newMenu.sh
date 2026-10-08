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
CACHE=$"$SCRIPT_DIR/../cache"
# echo $CACHE
# echo $(cat $CACHE)
# SHORTENED_COMMAND() {
# 	sudo nixos-rebuild switch --impure --flake "${SCRIPT_DIR}"/../.#
# }


# ls $SCRIPT_DIR/../.#

# FLAKE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )/..
# FLAKE_REBUILD=$(sudo nixos-rebuild switch --impure --flake $(FLAKE_DIR))

# sudo nixos-rebuild switch --impure --flake

# sudo nixos-rebuild switch --impure --flake ${SCRIPT_DIR}/..
# FLAKE=${nixos-rebuild switch --impure --flake ${SCRIPT_DIR}/../.#}

cock="$(cat $CACHE)"
# sudo $FLAKE_DIR plasma

# 1. Define the prompt (PS3 is the special variable for select prompts)
PS3="Current configuration: $cock "

# 2. Define the options as an array
options=(
	"cancel"
	"change profile"
	"apply changes and rebuild selected profile"
	"update flake.lock and rebuild selected profile"
)
select opt in "${options[@]}"; do
	case $opt in
		"cancel")
			# clear
			echo cancelled
			break
		;;
		"change profile")
			# clear
			profiles=(
				"cancel"
				wsl
				"headless"
				# "plasma"
			)
			select opt in "${profiles[@]}"; do
				case $opt in
					"cancel")
						# clear
						echo cancelled
						break
					;;
					"headless")
						# clear
						echo "headless" > $CACHE
						cock="$(cat $CACHE)"
						PS3="Current configuration: $cock "
						break
					;;
					"wsl")
						# clear
						echo "wsl" > $CACHE
						cock="$(cat $CACHE)"
						PS3="Current configuration: $cock "
						break
					;;
				esac
			done
		;;
		*)
			clear
			echo "Invalid option. Try another one."
		;;
	esac
done
