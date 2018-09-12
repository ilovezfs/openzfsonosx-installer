#!/bin/bash

if [[ $(id -u) -ne 0 ]]
then
	sudo "$0" "$@"
	exit $?
fi

sudo ntpdate -u time.apple.com

should_make_108=1
should_make_109=1
should_make_1010=1
should_make_1011=1
should_make_1012=1
should_make_1013=1
should_make_1014=1
should_make_dmg=1
require_version2_signature=1
os_release_major_version=`uname -r | awk -F '.' '{print $1;}'`

if [ -z $os_release_major_version ]
then
       echo "Could not determine operating system release major version"
       exit 1
fi

if [ $require_version2_signature -eq 1 -a $os_release_major_version -lt 14 -a $should_make_109 -eq 1 ]
then
       echo "It is necessary to sign code while running OS X Mavericks or higher to get a version 2 signature."
       exit 1
fi

if [ $require_version2_signature -eq 1 -a $os_release_major_version -lt 14 -a $should_make_1010 -eq 1 ]
then
       echo "It is necessary to sign code while running OS X Mavericks or higher to get a version 2 signature."
       exit 1
fi

READLINK=`which greadlink 2>/dev/null`
if test x$READLINK = "x" ; then
	READLINK=`which readlink 2>/dev/null`
fi

if ! test x$READLINK = "x" ; then
	$READLINK -f . > /dev/null 2>&1
	if ! test x$? = "x0" ; then
		unset READLINK
	else
		CANONICALIZE="$READLINK -f"
	fi
fi

if test x$READLINK = "x" ; then
	REALPATH=`which grealpath 2>/dev/null`
	if test x$REALPATH = "x" ; then
		REALPATH=`which realpath 2>/dev/null`
	fi
	if test x$REALPATH = "x" ; then
		CANONICALIZE=readlink
	else
		CANONICALIZE=$REALPATH
	fi
fi

topdir=`dirname "$($CANONICALIZE "$0")"`

if test x$topdir = x"." ; then
	if ! test -d resources -a -d scripts -a -f README.md ; then
		printf "cd into the zfs installer repository or install GNU readlink or realpath.\n"
		printf "Homebrew: brew install coreutils\n"
		printf "MacPorts: port install coreutils\n"
		printf "Gentoo Prefix: emerge sys-apps/coreutils\n"
		exit 1
	fi
fi

set -e

cd "${topdir}"

HOME_DIR="$(dscl . -read /Users/"$(logname)" NFSHomeDirectory | cut -d ' ' -f2)"

make_only=0

MLDEV="${HOME_DIR}"/Developer/mountainlion
MAVDEV="${HOME_DIR}"/Developer/mavericks
YOSDEV="${HOME_DIR}"/Developer/yosemite
ELCAPDEV="${HOME_DIR}"/Developer/elcapitan
SIERRADEV="${HOME_DIR}"/Developer/sierra
HIGHSIERRADEV="${HOME_DIR}"/Developer/highsierra
MOJAVEDEV="${HOME_DIR}"/Developer/mojave

MLPAK="${topdir}"/packages-o3x-108
MLDESTDIR="${MLPAK}"/108

MAVPAK="${topdir}"/packages-o3x-109
MAVDESTDIR="${MAVPAK}"/109

YOSPAK="${topdir}"/packages-o3x-1010
YOSDESTDIR="${YOSPAK}"/1010

ELCAPPAK="${topdir}"/packages-o3x-1011
ELCAPDESTDIR="${ELCAPPAK}"/1011

SIERRAPAK="${topdir}"/packages-o3x-1012
SIERRADESTDIR="${SIERRAPAK}"/1012

HIGHSIERRAPAK="${topdir}"/packages-o3x-1013
HIGHSIERRADESTDIR="${HIGHSIERRAPAK}"/1013

MOJAVEPAK="${topdir}"/packages-o3x-1014
MOJAVEDESTDIR="${MOJAVEPAK}"/1014

SPL_TAG=spl-1.7.4
ZFS_TAG=zfs-1.7.4

if [ $make_only -eq 1 ]
then
	[ $should_make_108 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.8 -d "${MLDEV}" -i /System/Library/Extensions -m -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_109 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.9 -d "${MAVDEV}" -i /Library/Extensions -m -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_1010 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.10 -d "${YOSDEV}" -i /Library/Extensions -m -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_1011 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.11 -d "${ELCAPDEV}" -i /Library/Extensions -m -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_1012 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.12 -d "${SIERRADEV}" -i /Library/Extensions -m -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_1013 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.13 -d "${HIGHSIERRADEV}" -i /Library/Extensions -m -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_1014 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.14 -d "${MOJAVEDEV}" -i /Library/Extensions -m -s $SPL_TAG -z $ZFS_TAG -p off
else
	[ $should_make_108 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.8 -d "${MLDEV}" -i /System/Library/Extensions -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_109 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.9 -d "${MAVDEV}" -i /Library/Extensions -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_1010 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.10 -d "${YOSDEV}" -i /Library/Extensions -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_1011 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.11 -d "${ELCAPDEV}" -i /Library/Extensions -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_1012 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.12 -d "${SIERRADEV}" -i /Library/Extensions -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_1013 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.13 -d "${HIGHSIERRADEV}" -i /Library/Extensions -s $SPL_TAG -z $ZFS_TAG -p off
	[ $should_make_1014 -eq 1 ] && ./scripts/zfsadm-for-installer.sh -t 10.14 -d "${MOJAVEDEV}" -i /Library/Extensions -s $SPL_TAG -z $ZFS_TAG -p off
fi

if [ $should_make_108 -eq 1 ]
then
	rm -rf "${MLDESTDIR}"
	cd "${MLDEV}"

	cd spl
	sudo make DESTDIR="${MLDESTDIR}" install
	cd ..

	cd zfs
	sudo make DESTDIR="${MLDESTDIR}" install
fi

if [ $should_make_109 -eq 1 ]
then
	rm -rf "${MAVDESTDIR}"
	cd "${MAVDEV}"

	cd spl
	sudo make DESTDIR="${MAVDESTDIR}" install
	cd ..

	cd zfs
	sudo make DESTDIR="${MAVDESTDIR}" install
fi

if [ $should_make_1010 -eq 1 ]
then
	rm -rf "${YOSDESTDIR}"
	cd "${YOSDEV}"

	cd spl
	sudo make DESTDIR="${YOSDESTDIR}" install
	cd ..

	cd zfs
	sudo make DESTDIR="${YOSDESTDIR}" install
fi

if [ $should_make_1011 -eq 1 ]
then
	rm -rf "${ELCAPDESTDIR}"
	cd "${ELCAPDEV}"

	cd spl
	sudo make DESTDIR="${ELCAPDESTDIR}" install
	cd ..

	cd zfs
	sudo make DESTDIR="${ELCAPDESTDIR}" install
fi

if [ $should_make_1012 -eq 1 ]
then
	rm -rf "${SIERRADESTDIR}"
	cd "${SIERRADEV}"

	cd spl
	sudo make DESTDIR="${SIERRADESTDIR}" install
	cd ..

	cd zfs
	sudo make DESTDIR="${SIERRADESTDIR}" install
fi

if [ $should_make_1013 -eq 1 ]
then
	rm -rf "${HIGHSIERRADESTDIR}"
	cd "${HIGHSIERRADEV}"

	cd spl
	sudo make DESTDIR="${HIGHSIERRADESTDIR}" install
	cd ..

	cd zfs
	sudo make DESTDIR="${HIGHSIERRADESTDIR}" install
fi

if [ $should_make_1014 -eq 1 ]
then
	rm -rf "${MOJAVEDESTDIR}"
	cd "${MOJAVEDEV}"

	cd spl
	sudo make DESTDIR="${MOJAVEDESTDIR}" install
	cd ..

	cd zfs
	sudo make DESTDIR="${MOJAVEDESTDIR}" install
fi

cd "${topdir}"
[ $should_make_108 -eq 1 ] && ./scripts/make-pkg.sh 108
ret108=$?
[ $should_make_109 -eq 1 ] && ./scripts/make-pkg.sh 109
ret109=$?
[ $should_make_1010 -eq 1 ] && ./scripts/make-pkg.sh 1010
ret1010=$?
[ $should_make_1011 -eq 1 ] && ./scripts/make-pkg.sh 1011
ret1011=$?
[ $should_make_1012 -eq 1 ] && ./scripts/make-pkg.sh 1012
ret1012=$?
[ $should_make_1013 -eq 1 ] && ./scripts/make-pkg.sh 1013
ret1013=$?
[ $should_make_1014 -eq 1 ] && ./scripts/make-pkg.sh 1014
ret1014=$?

[ $should_make_1014 -eq 1 -a $ret1014 -ne 0 ] && exit $ret1014
[ $should_make_1013 -eq 1 -a $ret1013 -ne 0 ] && exit $ret1013
[ $should_make_1012 -eq 1 -a $ret1012 -ne 0 ] && exit $ret1012
[ $should_make_1011 -eq 1 -a $ret1011 -ne 0 ] && exit $ret1011
[ $should_make_1010 -eq 1 -a $ret1010 -ne 0 ] && exit $ret1010
[ $should_make_109 -eq 1 -a $ret109 -ne 0 ] && exit $ret109
[ $should_make_108 -eq 1 -a $ret108 -ne 0 ] && exit $ret108

if [ $should_make_dmg -eq 1 ]
then
	./scripts/make-dmg.sh
	ret=$?
else
	ret=0
fi

exit $ret
