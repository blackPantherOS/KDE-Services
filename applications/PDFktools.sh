#!/bin/bash
# Service menu for PDF Tools : script file
# Adjusted for Extra-Services integration by Geovani Barzaga Rodriguez
# <igeo.cu@gmail.com>, 2013-01-09
# Improved bash script code by Geovani Barzaga Rodriguez <igeo.cu@gmail.com>, 2014-03-06

# This file is part of PDFktools.
# PDFktools was created by Sylvain Vidal < garion @ mailoo.org >
#
# PDFktools is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# PDFktools is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


######### INITIALIZATION #########
export TEXTDOMAIN=pdfktools
KDE="--title PDF_Tools --icon=/usr/share/icons/hicolor/scalable/apps/ks-pdf.svgz"
LOG="$(kde4-config --path tmp)pdfktools.log"
WIDTH=$(xrandr |grep '*'|awk -F " " '{print $1}'|awk -Fx '{print $1}')
HEIGHT=$(xrandr |grep '*'|awk -F " " '{print $1}'|awk -Fx '{print $2}')

action=''
kdbus='no'
obj=''
option=$1
out=''
pdflevel='1.4'
shift
nbfiles=$#

######### FUNCTIONS #########
directories_write(){
    for f in "$@"; do
        if [ ! -w "${f%/*}" ]; then
            pydialog $KDE --error $"${f%/*} is not writable"
            exit 1
        fi
    done
}

error(){
    if [ "$?" -ne 0 ]; then
        if [ $kdbus = 'yes' ]; then qdbus $dbusRef close; fi
        pydialog $KDE --error "$1"
        exit 1
    fi
}

error_log(){
    if [ "$?" -ne 0 ]; then
        if [ $kdbus = 'yes' ]; then qdbus $dbusRef close; fi
        pydialog $KDE --error "$1"
        pydialog $KDE --textbox $LOG --geometry 800x600+$((WIDTH/2-800/2))+$((HEIGHT/2-600/2))
        exit 1
    fi
}

exit_silent(){
    if [ $? -ne 0 ]; then
        echo "Operation aborted" >> $LOG
	exit 2
    fi
}

files_read(){
    for f in "$@"; do
        if [ ! -r "$f" ]; then
            pydialog $KDE --error $"$f is not readable"
            exit 1
        fi
    done
}

files_write(){
    for f in "$@"; do
        if [ ! -w $f ]; then
            pydialog $KDE --error $"$f is not writable"
            exit 1
        fi
    done
}

ghostscript_compress(){
	gs -q -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite\
	-dUseCIEColor -dPDFSETTINGS=/$quality -dCompatibilityLevel=$pdflevel\
        -sOUTPUTFILE="$out" "$@"
}

ghostscript(){
	gs -q -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite\
	-dUseCIEColor -dCompatibilityLevel=$pdflevel\
        -sOUTPUTFILE="$out" "$@";
}

ghostscript_pages(){
    gs -q -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dFirstPage=$2 -dLastPage=$3\
       -dUseCIEColor -dCompatibilityLevel=$pdflevel\
       -sOUTPUTFILE="$out" "$1"
}

init_dbus(){
    kdbus='yes'
    count=0
    dbusRef=$(pydialog $KDE --progressbar $"						" /ProgressDialog)
    qdbus $dbusRef showCancelButton true
}

init_files_dbus(){
    let count=count+1
    if [ "$(qdbus $dbusRef wasCancelled)" = "true" ]; then error $"Operation aborted"; fi
}

metadata_edit_all(){
    for typexmp in title subject author creator producer keywords ; do
        case $typexmp in
            'title')    display_label=$"Title for ${1##*/}"    ;;
            'subject')  display_label=$"Subject for ${1##*/}"  ;;
            'author')   display_label=$"Author for ${1##*/}"   ;;
            'creator')  display_label=$"Creator for ${1##*/}"  ;;
            'producer') display_label=$"Producer for ${1##*/}" ;;
            'keywords') display_label=$"Keywords for ${1##*/}" ;;
        esac
        oldmeta="$(exiftool -PDF:$typexmp "$1" | cut -b 35-)"
        meta="$(pydialog $KDE --textinputbox "$display_label" "$oldmeta")"
	exit_silent
        exiftool -P -overwrite_original -PDF:$typexmp="$meta" "$1"
        error_log $"Error during the metadata edition of $obj"
    done
}

metadata_save(){
    for typexmp in title subject author creator producer keywords ; do
        meta="$(exiftool -PDF:$typexmp $1 | cut -b 35-)"
        exiftool -P -overwrite_original -PDF:$typexmp="$meta" "$out"
        error_log $"Error during the metadata backup of $obj"
    done
}

metadata_view_all(){
    for typexmp in title subject author creator producer keywords ; do
        case $typexmp in
            'title')    display_label=$"Title:"    ;;
            'subject')  display_label=$"Subject:"  ;;
            'author')   display_label=$"Author:"   ;;
            'creator')  display_label=$"Creator:"  ;;
            'producer') display_label=$"Producer:" ;;
            'keywords') display_label=$"Keywords:" ;;
        esac
        exif=$(exiftool -PDF:$typexmp "$1"| cut -b 35-)
        echo "$display_label $exif" >> "${out}"
        error_log $"Error during the metadata view of""$obj"
    done
}

notification_dbus(){
	pydialog $KDE --title "PDF Tools - $option" --passivepopup $"[Finished]   $nbfiles files processed."
}

quality_compress(){
    quality=$(pydialog $KDE --radiolist $"Compression quality" \
        'screen'   $"Low resolution"       off \
        'ebook'    $"Medium resolution"    off \
        'printer'  $"Good resolution"      on  \
        'prepress' $"Excellent resolution" off )
    exit_silent
}


######### MAIN #########
case $option in
    -c)  action='compress'        ;;
    -m)  action='merge-all'       ;;
    -me) action='metadata-edit'   ;;
    -mv) action='metadata-view'   ;;
    -s)  action='split-one'       ;;
    *)   error $"Invalid option"  ;;
esac

files_read "$@"
echo "$(date --rfc-3339=date)" > $LOG

case $action in
    compress) #http://pages.cs.wisc.edu/~ghost/doc/cvs/Ps2pdf.htm
	option="Compress file"
        echo "Compress selected files" | tee -a $LOG
        directories_write "$@"
        quality_compress
        init_dbus
        for f in "$@"; do
            echo "$f in progress..." | tee -a $LOG
            init_files_dbus
            obj="${f##*/}"
            out="${f%/*}"/"${obj%.*}_compressed.pdf"
	    if [ "$quality" = "screen" ]; then
		qdbus $dbusRef setLabelText $"Compressing $obj in low resolution"
	    elif [ "$quality" = "ebook" ]; then
		qdbus $dbusRef setLabelText $"Compressing $obj in medium resolution"
	    elif [ "$quality" = "printer" ]; then
		qdbus $dbusRef setLabelText $"Compressing $obj in good resolution"
	    elif [ "$quality" = "prepress" ]; then
		qdbus $dbusRef setLabelText $"Compressing $obj in excellent resolution"
	    fi
            ghostscript_compress "$f" | tee -a $LOG
            error_log $"Error during the compression of $obj"
            metadata_save "$f" | tee -a $LOG
            qdbus $dbusRef org.freedesktop.DBus.Properties.Set org.kde.pydialog.ProgressDialog value $count
        done
        qdbus $dbusRef close
        notification_dbus ;;

    merge-all)
	option="Merge files"
        echo "Merge all selected files" | tee -a $LOG
        files_read "$@"
        for f in "$@"; do obj="$obj \"$f\""; done
        out="$(pydialog $KDE --title "Destination" --getsavefilename "${f%/*}/New_File.pdf" $"*.pdf | PDF Files")"
        exit_silent
        directories_write "$out"
	echo $obj
	init_dbus
	init_files_dbus
	qdbus $dbusRef setLabelText $"Merging $nbfiles files in ${out##*/}"
        ghostscript "$@" | tee -a $LOG
        error_log $"Error during the merge of $obj"
	qdbus $dbusRef close
        notification_dbus ;;

    metadata-edit) #http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/PDF.html#Info
	option="Edit metadata"
        echo "Edit metadata" | tee -a $LOG
        files_read "$@"
        directories_write "$@"
        for f in "$@"; do
            echo "$f in progress..." | tee -a $LOG
            obj="${f##*/}"
            out="$f"
            files_write "$out"
            metadata_edit_all "$out" | tee -a $LOG
	done
        notification_dbus ;;
        
    metadata-view)
        echo "View metadata"
        files_read "$@"
        for f in "$@"; do
	    echo "$f in progress..." | tee -a $LOG
            obj="${f##*/}"
            out="$(kde4-config --path tmp)$obj.txt"
            file=$(file -bp "$f")
            echo -e "$f\n$file\n" > "${out}"
            metadata_view_all "$f"
            pydialog $KDE --textbox "$out" --geometry 400x250+$((WIDTH/2-400/2))+$((HEIGHT/2-250/2))
            rm -f $out
        done ;;

    split-one)
	option="Split file"
        echo "Split PDF files in single page per file" | tee -a $LOG
        files_read "$@"
        directories_write "$@"
        for f in "$@"; do
            echo "$f in progress..." | tee -a $LOG
            obj="${f##*/}"
            totalpage=$(exiftool "$f" | grep "Page Count" | cut -d: -f 2-)
            firstpage=$(pydialog $KDE --combobox $"Splitting of $obj from the page..." $(seq 1 $totalpage) --default 1)
            exit_silent
            lastpage=$(pydialog $KDE --combobox $"... to the page..." $(seq 1 $totalpage) --default $totalpage)
            exit_silent
	    init_dbus
	    init_files_dbus
	    qdbus $dbusRef setLabelText $"Splitting of $obj from the page $firstpage to the page $lastpage"
            pdftops "$f" "$(kde4-config --path tmp)$obj.ps" | tee -a $LOG
            error_log $"Error during the conversion of $obj into a PS file"
            ps2pdf14 -dPDFSETTINGS=/prepress "$(kde4-config --path tmp)$obj.ps" "$(kde4-config --path tmp)$obj.pdf" | tee -a $LOG
            error_log $"Error during the conversion of $obj into a PDF file without bookmark"
            for p in $(seq $firstpage $lastpage); do
                out="${f%%.pdf}_$p.pdf"
                ghostscript_pages "$(kde4-config --path tmp)$obj.pdf" $p $p | tee -a $LOG
                error_log $"Error during the split of $obj"
            done
            rm "$(kde4-config --path tmp)$obj.ps" "$(kde4-config --path tmp)$obj.pdf"
	    qdbus $dbusRef close
        done
	notification_dbus ;;
esac
