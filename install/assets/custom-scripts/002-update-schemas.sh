#!/usr/bin/with-contenv bash

for s in /assets/functions/*; do source $s; done
PROCESS_NAME="openldap-fusiondirectory"

FUSIONDIRECTORY_INSTALLED="/etc/openldap/slapd.d/docker-openldap-fusiondirectory-was-installed" 

if [ -e "$FUSIONDIRECTORY_INSTALLED" ]; then
	  if [ -d /assets/fusiondirectory-custom/ ] ; then
	    mkdir -p /tmp/schema
	    mv /etc/openldap/schema/fusiondirectory/* /tmp/schema
	  
        for f in $(find /assets/fusiondirectory-custom/ -name \*.schema -type f); do
	        print_notice "Found Custom Schema: ${f}"
	        cp -R ${f} /etc/openldap/schema/fusiondirectory
        done
	    
	    cd /etc/openldap/schema/fusiondirectory
	    print_notice "Attempting to Install new Schemas"
	    silent fusiondirectory-insert-schema -i *.schema
	    silent fusiondirectory-insert-schema -m *.schema
	    cd /tmp
	    rm -rf /etc/openldap/schema/fusiondirectory/*
	    mv /tmp/schema/* /etc/openldap/schema/fusiondirectory/
	  fi
fi
