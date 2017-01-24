#!/bin/bash

#################################################################
# For Extra-Services. 2011-2016.					#
# By Geovani Barzaga Rodriguez <igeo.cu@gmail.com>		#
#################################################################

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/$USER/bin
DIR=""
BEGIN_TIME=""
FINAL_TIME=""
ELAPSED_TIME=""
DBUSREF=""
COUNT=""
COUNTFILES=""
OPERATION=""
FILES=/tmp/afm.tmp
DESTINATION=""
KdialogPID=""
LOG=/tmp/afm.log
WIDTH=$(xrandr |grep '*'|awk -F " " '{print $1}'|awk -Fx '{print $1}')
HEIGHT=$(xrandr |grep '*'|awk -F " " '{print $1}'|awk -Fx '{print $2}')

###################################
############ Functions ############
###################################

if-cancel-exit() {
    if [ "$?" != "0" ]; then
	  kill -9 $KdialogPID 2> /dev/null
	  exit 1
    fi
}

if [ "$(pidof adb)" = "" ]; then
  kdesu -i /usr/share/icons/hicolor/scalable/apps/ks-android-push-pull.svgz --noignorebutton -d adb start-server
  if-cancel-exit
fi

SERIAL=$(adb get-serialno)

check-device() {
  if [ "$SERIAL" = "unknown" ]; then
	pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-error.svgz --title="Android File Manager" \
			--passivepopup="[Canceled]   Check if your device with Android system is connected on your PC and NOT bootloader mode. \
			[1]-Connect your device to PC USB. [2]-Go to device Settings. [3]-Go to Developer options. [4]-Enable USB debugging option. Try again."
	exit 1
  fi
}

check-device

progressbar-start() {
    COUNT="0"
    COUNTFILES=$(echo $FILES|wc -w)
    COUNTFILES=$((++COUNTFILES))
    DBUSREF=$(pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-android-push-pull.svgz --title="Android File Manager" --progressbar "				" $COUNTFILES)
}

progressbar-close() {
    qdbus $DBUSREF Set "" value $COUNTFILES
    sleep 1
    qdbus $DBUSREF close
}

qdbusinsert-push() {
    qdbus $DBUSREF setLabelText "Pushing ${i##*/} to device $SERIAL [$COUNT/$((COUNTFILES-1))]"
    qdbus $DBUSREF Set "" value $COUNT
}

qdbusinsert-pull() {
    qdbus $DBUSREF setLabelText "Pulling ${i##*/} to [$COUNT/$((COUNTFILES-1))]"
    qdbus $DBUSREF Set "" value $COUNT
}

elapsedtime() {
    if [ "$ELAPSED_TIME" -lt "60" ]; then
        pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-android-push-pull.svgz --title="Android File Manager" \
                       --passivepopup="[Finished]   $OPERATION ${i##*/}. $(cat $LOG)  Elapsed Time: ${ELAPSED_TIME}s"
    elif [ "$ELAPSED_TIME" -gt "59" ] && [ "$ELAPSED_TIME" -lt "3600" ]; then
        ELAPSED_TIME=$(echo "$ELAPSED_TIME/60"|bc -l|sed 's/...................$//')
        pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-android-push-pull.svgz --title="Android File Manager" \
                       --passivepopup="[Finished]   $OPERATION ${i##*/}. $(cat $LOG)  Elapsed Time: ${ELAPSED_TIME}m"
    elif [ "$ELAPSED_TIME" -gt "3599" ]; then
        ELAPSED_TIME=$(echo "$ELAPSED_TIME/3600"|bc -l|sed 's/...................$//')
        pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-android-push-pull.svgz --title="Android File Manager" \
                       --passivepopup="[Finished]   $OPERATION ${i##*/}. $(cat $LOG)  Elapsed Time: ${ELAPSED_TIME}h"
    fi
}

##############################
############ Main ############
##############################

DIR=$1
cd "$DIR"

mv "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")")")")")")")" \
    "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")")")")")")"|sed\
    's/ /_/g')" 2> /dev/null
cd ./
mv "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")")")")")")" "$(dirname \
    "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")")")")")"|sed 's/ /_/g')" 2> /dev/null
cd ./
mv "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")")")")")" "$(dirname "$(dirname \
    "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")")")")"|sed 's/ /_/g')" 2> /dev/null
cd ./
mv "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")")")")" "$(dirname "$(dirname "$(dirname \
    "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")")")"|sed 's/ /_/g')" 2> /dev/null
cd ./
mv "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")")")" "$(dirname "$(dirname "$(dirname "$(dirname "$(dirname\
    "$(pwd|grep " ")")")")")"|sed 's/ /_/g')" 2> /dev/null
cd ./
mv "$(dirname "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")")" "$(dirname "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")"\
    |sed 's/ /_/g')" 2> /dev/null
cd ./
mv "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")")" "$(dirname "$(dirname "$(dirname "$(pwd|grep " ")")")"|sed 's/ /_/g')" 2> /dev/null
cd ./
mv "$(dirname "$(dirname "$(pwd|grep " ")")")" "$(dirname "$(dirname "$(pwd|grep " ")")"|sed 's/ /_/g')" 2> /dev/null
cd ./
mv "$(dirname "$(pwd|grep " ")")" "$(dirname "$(pwd|grep " ")"|sed 's/ /_/g')" 2> /dev/null
cd ./
mv "$(pwd|grep " ")" "$(pwd|grep " "|sed 's/ /_/g')" 2> /dev/null
cd ./

for i in *; do
    mv "$i" "${i// /_}" 2> /dev/null
done

DIR="$(pwd)"

if [ "$DIR" == "/usr/share/applications" ]; then
    DIR="~/"
fi

OPERATION=$(pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-android-push-pull.svgz --title="Android File Manager" \
       --combobox="Select Operation" Push Pull --default Push 2> /dev/null)
if-cancel-exit

if [ "$OPERATION" = "Push" ]; then
	FILES=$(pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-android-push-pull.svgz --title="Android File Manager - Select Files" --multiple --getopenfilename "$DIR" "*.*|*.*" 2> /dev/null)
	if-cancel-exit
	progressbar-start

    for i in $FILES; do
        COUNT=$((++COUNT))
        qdbusinsert-push
        BEGIN_TIME=$(date +%s)
        adb push $i /mnt/sdcard/ 2> $LOG
        check-device
        FINAL_TIME=$(date +%s)
        ELAPSED_TIME=$((FINAL_TIME-BEGIN_TIME))
        elapsedtime
    done
elif [ "$OPERATION" = "Pull" ]; then
	adb shell ls /mnt/sdcard*/*.* > $FILES
	DESTINATION=$(pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-android-push-pull.svgz --title="Android File Manager - Files Destination" --getexistingdirectory "$DIR" 2> /dev/null)
	if-cancel-exit
    pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-android-push-pull.svgz --title="Android File Manager - $(cat $FILES|wc -l)" --textbox=$FILES --geometry 300x200+$((WIDTH/2-300/2))+$((HEIGHT/2-200/2)) 2> /dev/null &
 	KdialogPID=$(ps aux|grep "afm.tmp"|grep -v grep|awk -F" " '{print $2}')
 	FILES=$(pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-android-push-pull.svgz --title="Android File Manager" --inputbox="Enter absolute path filenames from textbox separated by whitespace." 2> /dev/null)
 	if-cancel-exit
 	kill -9 $KdialogPID 2> /dev/null
    progressbar-start
     
    for i in $FILES; do
        COUNT=$((++COUNT))
        qdbusinsert-pull
        BEGIN_TIME=$(date +%s)
        adb pull $i $DESTINATION/ 2> $LOG
        check-device
        FINAL_TIME=$(date +%s)
        ELAPSED_TIME=$((FINAL_TIME-BEGIN_TIME))
        elapsedtime
    done
    rm -f $FILES
fi
progressbar-close
echo "Finish Android File Manager Operation" > /tmp/speak
text2wave -F 48000 -o /tmp/speak.wav /tmp/speak
play /tmp/speak.wav
rm -f /tmp/speak* $LOG
exit 0
