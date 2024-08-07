#!/bin/bash

# Define the base URL of the GitHub repository
REPO_URL="https://github.com/XCORNN/MCS_Master_TFM"

# List of scripts to execute
SCRIPTS=(
    "install_Harvester.sh"
    "install_Maltego.sh"
    "install_exiftool.sh"
    "install_photon.sh"
    "install_spiderfoot.sh"
    "install_tor_service.sh"
    "install_tor_browser.sh"
    "install_Recon-NG.sh"
    "install_FOCA.sh"
    "Foca_sqlExpress.sh"
)

# Function to check if the script executed successfully
check_success() {
    if [ $? -eq 0 ]; then
        echo "$1 executed successfully."
    else
        echo "Error executing $1."
        exit 1
    fi
}

# Clone the repository (if not already cloned)
if [ ! -d "MCS_Master_TFM" ]; then
    echo "Cloning the repository..."
    git clone "$REPO_URL.git"
    check_success "git clone"
fi

# Navigate to the directory containing the scripts
cd MCS_Master_TFM/Instalaciones_desatendidas || { echo "Failed to change directory"; exit 1; }

# Make all scripts executable
echo "Setting execute permissions for all scripts..."
chmod +x *.sh
check_success "chmod +x *.sh"

# Navigate back to the main directory
cd ../.. || { echo "Failed to return to the main directory"; exit 1; }

# Execute each script in the sequence
for script in "${SCRIPTS[@]}"; do
    echo "Executing $script..."
    bash "MCS_Master_TFM/Instalaciones_desatendidas/$script"
    check_success "$script"
done

echo "All scripts executed successfully."
