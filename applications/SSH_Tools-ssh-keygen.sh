#!/bin/bash

#################################################################
# For Extra-Services. 2011-2016.					#
# By Geovani Barzaga Rodriguez <igeo.cu@gmail.com>		#
#################################################################

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/$USER/bin

###################################
############ Functions ############
###################################

if-cancel-exit() {
    if [ "$?" != "0" ]; then
        exit 1
    fi
}

##############################
############ Main ############
##############################

LOGIN=$(pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-keygen.svgz --title="SSH Tools - Public Key Generation" --combobox="Select User" $USER root --default $USER 2> /dev/null)
if-cancel-exit

if [ "$LOGIN" = "$USER" ]; then
    xterm -si -s -sl 1000000 -sb -T "SSH Tools - Public Key Generation For $LOGIN" -bg black -fg white -e ssh-keygen
    pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-keygen.svgz --title="SSH Tools" --passivepopup="[Finished]   Public Key Generation For $LOGIN"
elif [ "$LOGIN" = "root" ]; then
    kdesu --noignorebutton -d xterm -si -s -sl 1000000 -sb -T "SSH Tools - Public Key Generation For $LOGIN" -bg black -fg white -e ssh-keygen
    if-cancel-exit
    pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-keygen.svgz --title="SSH Tools" --passivepopup="[Finished]   Public Key Generation For $LOGIN"
fi
exit 0
