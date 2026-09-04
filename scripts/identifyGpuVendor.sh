# !/bin/bash

# Detect GPU vendor
gpu_info=$(lspci -k | grep -A 2 -E "VGA|3D")

# Extract the vendor
if echo "$gpu_info" | grep -iq "nvidia"; then
  vendor="nvidia"
elif echo "$gpu_info" | grep -iq "amd"; then
  vendor="amd"
elif echo "$gpu_info" | grep -iq "intel"; then
  vendor="intel"
else
  vendor="unknown"
fi

# # Update configuration file
# config_file="/home/feather/nixjourney/config.conf"

# if [ -f "$config_file" ]; then
#   # Backup the existing configuration file
#   mv "$config_file" "$config_file.bak"
# fi

# Write the new configuration
# echo "gpu_vendor=$vendor" > "$config_file"

echo "Detected GPU vendor: $vendor"
