#!/bin/bash

############################################################################################
##### SAMPLE CONFIG FOR UPDATING CONFIGS FROM ENVIRONMENT VARIABLES ########################
############################################################################################

CONFIG_FILES=('/etc/php/7.0/fpm/php.ini' '/etc/php/7.0/cli/php.ini') # Configuration File Location of what will be modified.
CONFIG_VARIABLE_SEPERATOR='.' # If the config file variables have a seperator such as date.timezone
CONFIG_COMMENT_PREFIX=';' # Prefix used to comment out lines in the configuration file.

ENV_VARIABLEPREFIX=MYCNF_PHP_ # What environment variables will be prefixed with to denote use. EX: MYCNF_PHP_DATE___TIMEZONE
ENV_VARIABLE_SEPERATOR='___' # Seperator used to denote variables with seperation such as date.timezone the environment variable would be MYCNF_PHP_DATE___TIMEZONE

# Iterate Through Files Listed
for CONFIG_FILE in "${CONFIG_FILES[@]}"
do

        for ENVVARIABLE in `eval echo '${!'$ENV_VARIABLEPREFIX'*}'`
        do

                # Remove Prefix from Environment Variables
                CONFIGVARIABLE="$(echo ${ENVVARIABLE,,} | sed "s/${ENV_VARIABLEPREFIX}//i" | sed "s/${ENV_VARIABLE_SEPERATOR}/${CONFIG_VARIABLE_SEPERATOR}/i")"

                #echo $CONFIGVARIABLE

                # Get Value for Variable
                CONFIGVALUE="$(printenv $ENVVARIABLE)"

                #echo $CONFIGVALUE

                # Check If Config Variable is in configuration file and not commented out.
                if [[ $(egrep "^${CONFIGVARIABLE}" $CONFIG_FILE) ]]; then
                        # If Found Comment it out so it can be added to the end of the file
                        echo "Previous Variable in Config $CONFIG_FILE Found, Commenting Out..."
                        sed -i "s|^${CONFIGVARIABLE}|${COMMENT_PREFIX}${CONFIGVARIABLE}|g" $CONFIG_FILE
                fi

                # Locate and change the config file which should be commented out.
                sed -i -r "s|^${CONFIG_COMMENT_PREFIX}\s?${CONFIGVARIABLE}.*|${CONFIGVARIABLE} = ${CONFIGVALUE}|" $CONFIG_FILE

        done

done

echo '####################################################################'
echo "####### Environment Variables for $ENV_VARIABLEPREFIX ##############"
echo '####################################################################'
set | egrep -i ^$ENV_VARIABLEPREFIX
echo '####################################################################'
echo '####################################################################'
