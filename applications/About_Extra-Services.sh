#!/bin/bash

#################################################################
# For Extra-Services. 2013-2016.					#
# By Geovani Barzaga Rodriguez <igeo.cu@gmail.com>		#
#################################################################

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/$USER/bin
VERSION=$(head -n1 /usr/share/doc/kde-services*/ChangeLog |awk '{print $10}')
WIDTH=$(xrandr |grep '*'|awk -F " " '{print $1}'|awk -Fx '{print $1}')
HEIGHT=$(xrandr |grep '*'|awk -F " " '{print $1}'|awk -Fx '{print $2}')

cat > /tmp/about_kde-services << EOF

			        Extra-Services, version $VERSION, (C) 2011-2016.
			        http://sourceforge.net/projects/kde-services/

    Description:
        Enables the following functionalities on the Dolphin's (File Manager) right click menu of KDE 4.x/5.x:

        - Convert several video formats to MPEG-1, MPEG-2, MPEG-4, AVI, VCD, SVCD, DVD, 3GP, FLV or WebM.
        - Extract the audio track of several video formats and convert them to MP3, MP3(432Hz), FLAC, FLAC(432Hz), OGG or OGG (432Hz).
        - Convert several audio files to MP3, MP3(432Hz), FLAC, FLAC(432Hz), OGG or OGG (432Hz).
        - Send file as email attachment.
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
        - System tools => "Build Custom Kernel" ( Now you can customize your own kernel easily, for create a system
          with more performance, more fast and more hardware support ), Check kernel update and more.
        - Network tools => "Connect Sentry" ( Now can see on your notification widget, every established connection ).
        - Backup and restore tools.
        - SaMBa tools.
        - Extract subtitle from MKV video files.
        - YouTube tools.
        - Multiplex subtitle into MPEG-2 video file.
        - DVD tools.
        - Multimedia tools.
        - Security tools.
        - Secure send file or directory to Mailx as email attachment. (Need SMTP service running in LocalHost)
        - Add timestamp prefix to file|dir]name(s).
        - Paranoid shredder.
        - HTTP server.
        - Graphic tools.
        - The Sizer.
        - Package tools.
        - The Converter.
        - Dropbox tools.
        - Android tools.
        - Compressed file integrity check.
        - Rotate video files.
        - Edit time from media files.
        - Attach cover to MP3 files.
        - Clean metadata from media files.
        - Concatenate media files with same codec.
        - Encrypt directory.
        - Volume normalize of MP3 files.
        - Add Subtitle to MP4 File.

    Required dependencies:
        - android-tools
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
        - findutils
        - fuse
        - fuseiso
        - fuse-encfs
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
        - mp3gain
        - net-tools
        - openssh-askpass
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
        - unar
        - util-linux
        - vlc
        - wget
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
      Victor Guardiola (vguardiola) (Improved source code for "Mount ISO Image" and "Umount ISO Image"
	services menu; fixed the problem of [dir|file]name with whitespaces).
      Vasyl V. Vercynskyj <fuckel@ukr.net> (Translations to Russian and Ukrainian languages).
      Pawan Yadav <pawanyadav@gmail.com> (Research for KF5 support).
    License:
      GPLv3+ (GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007)

EOF

pydialog --icon=/usr/share/icons/hicolor/scalable/apps/ks-menu.svgz --title="About Extra-Services" --textbox /tmp/about_kde-services --geometry 900x600+$((WIDTH/2-900/2))+$((HEIGHT/2-600/2)) 2> /dev/null
rm -f /tmp/about_kde-services
exit 0
