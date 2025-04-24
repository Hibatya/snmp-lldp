# snmp-lldp
script to install snmp and lldp
1-clone the repository
2-Make the Script Executable:
    chmod +x setup_snmp_lldpd.sh
3-Run the Script:
    ./setup_snmp_lldpd.sh
test:
snmp : snmpwalk -v2c -c public 127.0.0.1 .
lldp: snmpwalk -v2c -c public 127.0.0.1 .1.0.8802.1.1.2.1.4
