#!/bin/bash

#################################################################
# For Extra-Services. 2011-2016.					#
# By Geovani Barzaga Rodriguez <igeo.cu@gmail.com>		#
#################################################################

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/$USER/bin
DESTINATION=""
DIR=""
PID="$$"
BEGIN_TIME=""
FINAL_TIME=""
ELAPSED_TIME=""
DBUSREF=""
COUNT=""
COUNTFILES=""
LOG=""
LOGERROR=""
ANGLE=""

###################################
############ Functions ############
###################################

logs() {
    LOG="/tmp/${i##*/}.log"
    LOGERROR="${i##*/}.err"
    rm -f $LOGERROR
}

if-cancel-exit() {
    if [ "$?" != "0" ]; then
        exit 1
    fi
}

if-ffmpeg-cancel() {
    if [ "$?" != "0" ]; then
        pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-error.svgz --title="Rotting video file ${i##*/} to $ANGLE" \
                       --passivepopup="[Canceled]   Check the path and filename not contain whitespaces. Check error log $LOGERROR. Try again"
        mv $LOG $DESTINATION/$LOGERROR
        continue
    fi
}

progressbar-start() {
    COUNT="0"
    COUNTFILES=$(echo $FILES|wc -w)
    COUNTFILES=$((++COUNTFILES))
    DBUSREF=$(pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-video-rotate.svgz --title="Rotate Video Files" --progressbar "				" $COUNTFILES)
}

progressbar-close() {
    qdbus $DBUSREF Set "" value $COUNTFILES
    sleep 1
    qdbus $DBUSREF close
}

qdbusinsert() {
    qdbus $DBUSREF setLabelText "Rotting video file:  ${i##*/}  [$COUNT/$((COUNTFILES-1))]"
    qdbus $DBUSREF Set "" value $COUNT
}

elapsedtime() {
    if [ "$ELAPSED_TIME" -lt "60" ]; then
        pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-video-rotate.svgz --title="Rotate Video Files" \
                       --passivepopup="[Finished]  ${i##*/}   Elapsed Time: ${ELAPSED_TIME}s"
    elif [ "$ELAPSED_TIME" -gt "59" ] && [ "$ELAPSED_TIME" -lt "3600" ]; then
        ELAPSED_TIME=$(echo "$ELAPSED_TIME/60"|bc -l|sed 's/...................$//')
        pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-video-rotate.svgz --title="Rotate Video Files" \
                       --passivepopup="[Finished]   ${i##*/}   Elapsed Time: ${ELAPSED_TIME}m"
    elif [ "$ELAPSED_TIME" -gt "3599" ]; then
        ELAPSED_TIME=$(echo "$ELAPSED_TIME/3600"|bc -l|sed 's/...................$//')
        pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-video-rotate.svgz --title="Rotate Video Files" \
                       --passivepopup="[Finished]   ${i##*/}   Elapsed Time: ${ELAPSED_TIME}h"
    fi
    rm -f $LOG
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

FILES=$(pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-video-rotate.svgz --title="Rotate Video Files" --multiple --getopenfilename "$DIR" "*.3GP *.3gp *.AVI *.avi *.DAT *.dat *.DV *.dv *.FLV *.flv *.M2V *.m2v *.M4V *.m4v \
  *.MKV *.mkv *.MOV *.mov *.MP4 *.mp4 *.MPEG *.mpeg *.MPEG4 *.mpeg4 *.MPG *.mpg *.OGV *.ogv *.VOB *.vob *.WEBM *.webm *.WMV *.wmv|*.3gp *.avi *.dat *.dv *.flv *.m2v *.m4v *.mkv *.mov *.mp4 *.mpeg *.mpeg4 *.mpg *.ogv *.vob *.webm *.wmv" 2> /dev/null)
if-cancel-exit

DESTINATION=$(pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-video-rotate.svgz --title="Destination Video Files" --getexistingdirectory "$DIR" 2> /dev/null)
if-cancel-exit

ANGLE=$(pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-video-rotate.svgz --title="Rotate Video Files" \
                --combobox="Select rotation degree angle" "90 Clockwise" "180 Clockwise" "90 AntiClockwise" "180 AntiClockwise" --default "90 Clockwise")
if-cancel-exit

if [ "$ANGLE" = "90 Clockwise" ]; then
    progressbar-start

    for i in $FILES; do
        logs
        COUNT=$((++COUNT))
        BEGIN_TIME=$(date +%s)
        qdbusinsert
        DST_FILE="${i%.*}"
        ffmpeg -y -i $i -metadata:s:v rotate="90" -c copy "$DESTINATION/${DST_FILE##*/}_90-Clockwise.${i:${#i}-3}" > $LOG 2>&1
        if-ffmpeg-cancel
        FINAL_TIME=$(date +%s)
        ELAPSED_TIME=$((FINAL_TIME-BEGIN_TIME))
        elapsedtime
    done
elif [ "$ANGLE" = "180 Clockwise" ]; then
    progressbar-start

    for i in $FILES; do
        logs
        COUNT=$((++COUNT))
        BEGIN_TIME=$(date +%s)
        qdbusinsert
        DST_FILE="${i%.*}"
        ffmpeg -y -i $i -metadata:s:v rotate="180" -c copy "$DESTINATION/${DST_FILE##*/}_180-Clockwise.${i:${#i}-3}" > $LOG 2>&1
        if-ffmpeg-cancel
        FINAL_TIME=$(date +%s)
        ELAPSED_TIME=$((FINAL_TIME-BEGIN_TIME))
        elapsedtime
    done
elif [ "$ANGLE" = "90 AntiClockwise" ]; then
    progressbar-start

    for i in $FILES; do
        logs
        COUNT=$((++COUNT))
        BEGIN_TIME=$(date +%s)
        qdbusinsert
        DST_FILE="${i%.*}"
        ffmpeg -y -i $i -metadata:s:v rotate="-90" -c copy "$DESTINATION/${DST_FILE##*/}_90-AntiClockwise.${i:${#i}-3}" > $LOG 2>&1
        if-ffmpeg-cancel
        FINAL_TIME=$(date +%s)
        ELAPSED_TIME=$((FINAL_TIME-BEGIN_TIME))
        elapsedtime
    done
elif [ "$ANGLE" = "180 AntiClockwise" ]; then
    progressbar-start

    for i in $FILES; do
        logs
        COUNT=$((++COUNT))
        BEGIN_TIME=$(date +%s)
        qdbusinsert
        DST_FILE="${i%.*}"
        ffmpeg -y -i $i -metadata:s:v rotate="-180" -c copy "$DESTINATION/${DST_FILE##*/}_180-AntiClockwise.${i:${#i}-3}" > $LOG 2>&1
        if-ffmpeg-cancel
        FINAL_TIME=$(date +%s)
        ELAPSED_TIME=$((FINAL_TIME-BEGIN_TIME))
        elapsedtime
    done
fi
progressbar-close
echo "Finish Rotate Video Files" > /tmp/speak
text2wave -F 48000 -o /tmp/speak.wav /tmp/speak
play /tmp/speak.wav
rm -fr /tmp/speak*

exit 0
