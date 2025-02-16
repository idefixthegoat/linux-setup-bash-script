#!/bin/bash
set -e

# Function to update system packages
update_system() {
  if command -v apt &>/dev/null; then
    echo "Updating system using apt..."
    sudo apt update && sudo apt upgrade -y
  elif command -v dnf &>/dev/null; then
    echo "Updating system using dnf..."
    sudo dnf update -y
  else
    echo "No supported package manager found (apt or dnf). Please update your system manually."
  fi
}

# Function to install flatpak if missing
install_flatpak() {
  if ! command -v flatpak &>/dev/null; then
    echo "Flatpak not found. Installing flatpak..."
    if command -v apt &>/dev/null; then
      sudo apt install flatpak -y
    elif command -v dnf &>/dev/null; then
      sudo dnf install flatpak -y
    else
      echo "Unable to install Flatpak. Please install it manually."
      exit 1
    fi
  else
    echo "Flatpak is already installed."
  fi
}

# Function to add Flathub repository if not already added
add_flathub() {
  if ! flatpak remote-list | grep -q flathub; then
    echo "Adding Flathub repository..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  else
    echo "Flathub repository already added."
  fi
}

# Main script execution
update_system
install_flatpak
add_flathub

# List of apps to install (Flatpak IDs)
APPS=(
  "com.brave.Browser"
  "md.obsidian.Obsidian"
  "fr.handbrake.ghb"
  "com.jeffser.Alpaca"    # Verify this ID if installation fails.
  "com.makemkv.MakeMKV"
  "org.videolan.VLC"
  "org.mozilla.Thunderbird"
  "io.github.bytezz.IPLookup"
  "fr.romainvigier.MetadataCleaner"
  "com.github.huluti.Curtail"
  "com.discordapp.Discord"
  "net.nokyan.Resources"
  "com.github.louis77.tuner"
)

echo "Starting installation of applications from Flathub..."
for app in "${APPS[@]}"; do
  echo "Installing $app..."
  sudo flatpak install -y flathub "$app"
done

sudo reboot
