#!/bin/bash

# Define the base URL of the GitHub repository
REPO_URL="https://github.com/XCORNN/MCS_Master_TFM"

# List of scripts to execute
SCRIPTS=(
    "V2_install_Harvester.sh"
    "V2_install_Maltego.sh"
    "V2_install_exiftool.sh"
    "V2_install_Photon.sh"
    "V2_install_Spiderfoot.sh"
    "V2_install_sublist3r.sh"
    "V2_install_GooHak.sh"
    "V2_install_tor_service.sh"
    "V2_install_tor_browser.sh"
    "V2_install_Recon_NG.sh"
    "V2_install_sslscan.sh"
    "V2_install_dmitry.sh"
    "V2_install_sherlock.sh"
    "V2_install_FOCA.sh"
    "V2_Foca_sqlExpress.sh"
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

# Function to clone the repository
clone_repo() {
    echo "Cloning the repository..."
    git clone "$REPO_URL"
    check_success "git clone"
}

# Check if inside MCS_Master_TFM and if Instalaciones_desatendidas exists
if [ -d "Instalaciones_desatendidas" ]; then
    echo "Already inside the repository directory."
else
    # Navigate up to see if we're in a subdirectory
    cd .. || { echo "Failed to navigate up a directory"; exit 1; }
    
    if [ -d "MCS_Master_TFM" ]; then
        echo "Navigating to the repository directory."
        cd MCS_Master_TFM || { echo "Failed to change to MCS_Master_TFM directory"; exit 1; }
    else
        # If not in a subdirectory of the repo, clone it
        clone_repo
        cd MCS_Master_TFM || { echo "Failed to change to MCS_Master_TFM directory"; exit 1; }
    fi
    
    # Check again if Instalaciones_desatendidas exists
    if [ ! -d "Instalaciones_desatendidas" ]; then
        echo "Failed to find Instalaciones_desatendidas after cloning."
        exit 1
    fi
fi

# Navigate to the directory containing the scripts
cd Instalaciones_desatendidas || { echo "Failed to change directory to Instalaciones_desatendidas"; exit 1; }

# Make all scripts executable
echo "Setting execute permissions for all scripts..."
chmod +x *.sh
check_success "chmod +x *.sh"

# Execute each script in the sequence
for script in "${SCRIPTS[@]}"; do
    echo "Executing $script..."
    bash "./$script"
    check_success "$script"
done

echo "All scripts executed successfully."
