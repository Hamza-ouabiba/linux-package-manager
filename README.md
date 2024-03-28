# Debian Package Installer Script

## Overview
The Debian Package Installer Script is a Bash script designed to simplify the installation of Debian packages on Linux systems. It offers two installation methods: one for installing packages directly from `.deb` files and another using the `apt` package manager.

## Features
- **Custom Installation**: Download and install Debian packages directly from `.deb` files.
- **Dependency Handling**: Attempt to resolve and install missing dependencies automatically.
- **Offline Installation**: Facilitate package installations on systems without internet access.
- **Simple Interface**: Easy-to-use command-line interface for package installation.

## Prerequisites
- **Bash**: The script requires a Bash-compatible shell to run.
- **curl**: Used for downloading package information and links from the Debian packages website.
- **wget**: Required for downloading `.deb` files.
- **apt**: If using the `apt` installation method, ensure `apt` is installed and functioning correctly.

## Usage
1. **Clone the Repository**: Clone the repository containing the script onto your system.
   ```bash
   git clone https://github.com/Hamza-ouabiba/linux-package-manager/
