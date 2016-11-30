#!/bin/bash

############################################################################################
##### SAMPLE CONFIG FOR UPDATING CONFIGS FROM ENVIRONMENT VARIABLES ########################
############################################################################################

CONFIGFILETEMPLATE=/opt/config_templates/graylog/server.conf
CONFIGFILE=/etc/graylog/server/server.conf
VARIABLEPREFIX=GRAYLOG_
SETTINGS_START_SEPERATOR='#<-- START SETTINGS -->'
SETTINGS_END_SEPERATOR='#<-- END SETTINGS -->'

# If Configuration files dont exist, then copy the default package config to appropriate location
if [ ! -f ${CONFIGTEMPLATE} ]; then
  cp ${CONFIGTEMPLATE} /etc/graylog/server/
fi

# Modify Configuration Files with Environment Variables that were passed
#if [[ ! $(grep -Pzo '####\nCUSTOM SETTINGS\n####' $CONFIGFILE) ]]; then echo -e "\n\n#### CUSTOM SETTINGS ####\n" >> $CONFIGFILE; fi

# Remove Existing Custom Config Starting at Seperator to end of file
sed -i "/${SETTINGS_START_SEPERATOR}.*/,$ d" $CONFIG

# Start Custom Config Section
echo -e "${SETTINGS_START_SEPERATOR}" >> $CONFIG

for ENVVARIABLE in ${!VARIABLEPREFIX*}
do

	# Remove Graylog_ Prefix from Environment Variables
        CONFIGVARIABLE="$(echo ${ENVVARIABLE,,} | sed "s/${VARIABLEPREFIX}//i")"
        # Get Value for Variable
        CONFIGVALUE="$(printenv $ENVVARIABLE)"

        # Check If Config Variable is in configuration and not commented out.
        if [[ $(egrep "^${CONFIGVARIABLE}" $CONFIGFILE) ]]; then
 	       # Comment it out so it can be added to the end of the file
               sed -i "s|^${CONFIGVARIABLE}|#${CONFIGVARIABLE}|g" $CONFIGFILE
	fi

	# Write Variable
	echo "${CONFIGVARIABLE} = ${CONFIGVALUE}" >> $CONFIGFILE

done

# End Custom Config Section
echo -e "${SETTINGS_END_SEPERATOR}" >> $CONFIGFILE
