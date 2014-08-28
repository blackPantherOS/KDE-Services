#!/bin/bash

#################################################################
# For KDE-Services. 2011-2013.									#
# By Geovani Barzaga Rodriguez <igeo.cu@gmail.com>				#
#################################################################

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/$USER/bin
HOST=""
SERVER=""
LOGIN=""

###################################
############ Functions ############
###################################

if-cancel-exit() {
    if [ "$?" -gt "0" ]; then
        exit 0
    fi
}

##############################
############ Main ############
##############################

if [ -s ~/.kde-services/machines ]; then
    SERVER=$(cat ~/.kde-services/machines)
    HOST=$(kdialog --icon=/usr/share/icons/hicolor/512x512/apps/ks-connect-to.png --caption="SSH Tools - Connect To" --combobox="Select Hostname or IP Address" $SERVER \
               --default $(head -n1 ~/.kde-services/machines) 2> /dev/null)
    if-cancel-exit
    LOGIN=$(kdialog --icon=/usr/share/icons/hicolor/512x512/apps/ks-connect-to.png --caption="SSH Tools - Connect To $HOST" --combobox="Select User" $USER root --default $USER 2> /dev/null)
    if-cancel-exit
    xterm -si -s -sl 1000000 -sb -bg black -fg white -e "ssh $LOGIN@$HOST"
    exit 0
else
        kdialog --icon=/usr/share/icons/hicolor/512x512/apps/ks-connect-to.png --caption="SSH Tools - Connect To" \
                       --sorry="No Find Server: First Public Key Generation and Install Public Key in Remote Server" 2> /dev/null
        exit 1
fi
