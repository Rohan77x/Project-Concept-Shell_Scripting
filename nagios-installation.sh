#!/bin/bash

# This script automates the installation of Nagios on Red Hat-based systems (e.g., CentOS, RHEL).

# Function to install dependencies
install_dependencies() {
    echo "Installing required dependencies..."
    # Install the EPEL repository (Extra Packages for Enterprise Linux).
    sudo yum install -y epel-release
    # Install necessary packages using yum.
    sudo yum install -y httpd php gcc glibc glibc-common gd gd-devel make net-snmp unzip
}

# Function to download and install Nagios
install_nagios() {
    echo "Downloading Nagios..."
    cd /tmp
    # Download the Nagios tarball.
    wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.6.tar.gz
    # Extract the Nagios tarball.
    tar xzf nagios-4.4.6.tar.gz
    cd nagios-4.4.6

    echo "Configuring Nagios..."
    # Configure Nagios with the Apache configuration directory.
    ./configure --with-httpd-conf=/etc/httpd/conf.d

    echo "Compiling and installing Nagios..."
    # Compile Nagios and related utilities.
    make all
    # Install Nagios binaries.
    sudo make install
    # Install the init script for Nagios.
    sudo make install-init
    # Install external command mode for Nagios.
    sudo make install-commandmode
    # Install sample configuration files for Nagios.
    sudo make install-config
    # Install the Apache web server configuration for Nagios.
    sudo make install-webconf

    echo "Creating Nagios user and group..."
    # Create the Nagios user and the nagcmd group.
    sudo useradd nagios
    sudo groupadd nagcmd
    # Add the Nagios user to the nagcmd group.
    sudo usermod -aG nagcmd nagios
    # Add the Apache user to the nagcmd group to enable external command processing.
    sudo usermod -aG nagcmd apache

    echo "Setting permissions..."
    # Set appropriate permissions for Nagios directories.
    sudo chown -R nagios:nagios /usr/local/nagios
    sudo chown nagios:nagcmd /usr/local/nagios/var/rw
}

# Function to install Nagios Plugins
install_nagios_plugins() {
    echo "Downloading Nagios Plugins..."
    cd /tmp
    # Download the Nagios Plugins tarball.
    wget https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz
    # Extract the Nagios Plugins tarball.
    tar xzf nagios-plugins-2.3.3.tar.gz
    cd nagios-plugins-2.3.3

    echo "Configuring Nagios Plugins..."
    # Configure Nagios Plugins with the Nagios user and group.
    ./configure --with-nagios-user=nagios --with-nagios-group=nagios

    echo "Compiling and installing Nagios Plugins..."
    # Compile Nagios Plugins.
    make
    # Install Nagios Plugins.
    sudo make install
}

# Function to restart Apache
restart_apache() {
    echo "Restarting Apache..."
    # Restart Apache to apply the configuration changes made during Nagios installation.
    sudo systemctl restart httpd
}

# Main function
main() {
    # Call the functions to perform Nagios installation.
    install_dependencies
    install_nagios
    install_nagios_plugins
    restart_apache

    echo "Nagios installation completed!"
}

# Run the main function
main

