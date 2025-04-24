#!/bin/bash

# Step 1: Install SNMP, SNMP daemon, and other required packages
echo "Installing SNMP and SNMPD..."
sudo apt update
sudo apt install -y snmp snmpd snmp-mibs-downloader lldpd

# Step 2: Start and enable SNMPD
echo "Starting and enabling SNMPD..."
sudo systemctl start snmpd
sudo systemctl enable snmpd

# Step 3: Download MIB files using snmp-mibs-downloader
echo "Downloading MIB files..."
sudo download-mibs

# Step 4: Configure /etc/snmp/snmp.conf
echo "Configuring /etc/snmp/snmp.conf..."
sudo bash -c 'cat > /etc/snmp/snmp.conf << EOF
# As the snmp packages come without MIB files due to license reasons, loading
# of MIBs is disabled by default. If you added the MIBs you can reenable
# loading them by commenting out the following line.
#mibs :

# If you want to globally change where snmp libraries, commands and daemons
# look for MIBS, change the line below. Note you can set this for individual
# tools with the -M option or MIBDIRS environment variable.
#
mibdirs /usr/share/snmp/mibs:/usr/share/snmp/mibs/iana:/usr/share/snmp/mibs/ietf
EOF'

# Step 5: Configure /etc/snmp/snmpd.conf
echo "Configuring /etc/snmp/snmpd.conf..."
sudo bash -c 'cat > /etc/snmp/snmpd.conf << EOF
###########################################################################
#
# snmpd.conf
# An example configuration file for configuring the Net-SNMP agent ('snmpd')
# See snmpd.conf(5) man page for details
#
###########################################################################
# SECTION: System Information Setup
#
sysLocation    Sitting on the Dock of the Bay
sysContact     Me <me@example.org>
sysServices    72

###########################################################################
# SECTION: Agent Operating Mode
#
master  agentx
agentaddress  udp:161,udp6:[::1]:161

###########################################################################
# SECTION: Access Control Setup
#
view all    included  .1                               80
rocommunity OND default 
rocommunity6 OND default  
rouser OND
includeDir /etc/snmp/snmpd.conf.d
EOF'

# Step 6: Install and configure LLDP
echo "Installing and configuring LLDP..."
sudo apt install -y lldpd
wget https://mibbrowser.online/mibdb_search.php?mib=LLDP-MIB -O /tmp/LLDP-MIB.mib
sudo mv /tmp/LLDP-MIB.mib /usr/share/snmp/mibs/ietf

# Step 7: Configure /etc/default/lldpd
echo "Configuring /etc/default/lldpd..."
sudo bash -c 'echo "DAEMON_ARGS=\"-x -c -s -e\"" > /etc/default/lldpd'

# Step 8: Restart services
echo "Restarting SNMPD and LLDP services..."
sudo systemctl restart snmpd
sudo systemctl restart lldpd

echo "Setup completed successfully!"

