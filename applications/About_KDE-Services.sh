#!/bin/bash

#################################################################
# For KDE Services. 2013.					#
# By Geovani Barzaga Rodriguez <igeo.cu@gmail.com>		#
#################################################################

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/$USER/bin
VERSION=$(head -n1 /usr/share/doc/kde-services*/ChangeLog |awk '{print $10}')

cat > /tmp/about_kde-services << EOF

			KDE-Services, version $VERSION, (C) 2011-2013.
			http://sourceforge.net/projects/kde-services/

    Description:
        Enables the following functionalities on the Dolphin's right click menu of KDE-4.x:
    
        - Convert several video formats to MPEG-1, MPEG-4, AVI, VCD, SVCD, DVD, 3GP or FLV.
        - Extract the audio track of several video formats and convert them to MP3 or FLAC.
        - Convert several audio files to MP3 or FLAC.
        - Send file to Thunderbird as email attachment. (This service need Thunderbird installed)
        - Burn ISO image; in place ISO image mounting and unmounting, as well as the
            possibility of getting the MD5sum, SHA1sum, SHA256sum, SHA512sum of the ISO image.
        - Execution of scripts.
        - PDF tools.
        - AVI tools.
        - Low level information of video files.
        - Build an ISO image from a selected folder.
        - Text replacing.
        - Searching tools.
        - SSH tools.
        - CheckSum tools.
        - Dolphin tools.
        - Midnight tools (Midnight Commander).
        - Play videos from selected folder.
        - System Tools => Build Custom Kernel ( Now you can customize your own kernel easily,
            for create a system with more performance, more fast and more hardware support ),
            Check Kernel Update and more.
        - Network Tools => Connect Sentry ( Now can see on your notification widget,
            every established connection ).
        - [Backup|Restore] Tools.
        - SaMBa Tools.
        - Extract subtitle from MKV video files.
        - YouTube Tools.
        - Multiplex subtitle into MPEG-2 video file.
        - DVD Tools.
        - Multimedia Tools.
        - GPG Tools.
        - Secure send file or directory to Mailx as email attachment. (Need SMTP service running
            in LocalHost)
        - Add Timestamp Prefix To [File|Dir]name(s).
        - Paranoid Shredder.
        - HTTP Publisher.
        - Image Resizer.
        - The Sizer.
        - Package Tools.
        - The Converter.

    Requirements:
        - bash
        - bc
        - bzip2
        - cifs-utils
        - coreutils
        - diffutils
        - dmidecode
        - dvdauthor
        - festival
        - ffmpeg
        - file
        - fuse
        - fuseiso
        - fuse-sshfs
        - gawk
        - genisoimage
        - ghostscript
        - gnupg
        - htop
        - ImageMagick
        - iproute
        - isomd5sum
        - kde-baseapps
        - kde-runtime
        - kernel-tools
        - konsole
        - liberation-sans-fonts
        - lynx
        - mailx
        - mc
        - mkvtoolnix
        - mlocate
        - net-tools
        - pdftk
        - perl
        - perl-Image-ExifTool
        - poppler
        - poppler-utils
        - procps
        - psmisc
        - pv
        - recode
        - samba-client
        - sed
        - shared-mime-info
        - sox
        - tar
        - transcode
        - vlc
        - wodim
        - xdg-utils
        - xorg-x11-server-utils
        - xorg-x11-server-Xorg
        - xterm
        - youtube-dl
        - zip
        
    Author: 
        Geovani Bárzaga Rodríguez (geobarrod) <igeo.cu@gmail.com>, Developer and Fedora RPM Maintainer.

    Contributors:
        Sylvain Vidal <garion@mailoo.org> (Author of service menu PDFktools).
        David Baum <david.baum@naraesk.eu> (Service menu PDFktools bugfixer and author of the good idea
                                        of ​​integrating PDFktools on "PDF Tools").
                                        
    License:
        GPLv3+ (GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007)
        
EOF

kdialog --icon=kde-services --caption="About KDE-Services" --textbox /tmp/about_kde-services --geometry 800x600 2> /dev/null
rm -f /tmp/about_kde-services
exit 0
