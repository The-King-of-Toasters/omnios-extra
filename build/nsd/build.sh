#!/usr/bin/bash
#
# {{{ CDDL HEADER
#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source. A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
# }}}

# Copyright 2025 OmniOS Community Edition (OmniOSce) Association.

. ../../lib/build.sh

PROG=nsd
VER=4.13.0
PKG=ooce/network/nsd
SUMMARY="Authoritative DNS server"
DESC="The NLnet Labs Name Server Daemon (NSD) is an authoritative "
DESC+="DNS name server."

MAJVER=${VER%.*}            # M.m
sMAJVER=${MAJVER//./}       # Mm

OPREFIX=$PREFIX
PREFIX+=/$PROG-$MAJVER
sPREFIX=$OPREFIX/$PROG

XFORM_ARGS="
    -DPREFIX=${PREFIX#/}
    -DOPREFIX=${OPREFIX#/}
    -DsPREFIX=${sPREFIX#/}
    -DPROG=$PROG
    -DPKGROOT=$PROG-$MAJVER
"

BUILD_DEPENDS_IPS="ooce/library/libev"

set_arch 64
# need msg_flags from struct msghdr and strcasecmp
set_standard XPG6

export MAKE

# nsd contains BMI instructions even when built on an older CPU
BMI_EXPECTED=1

CONFIGURE_OPTS="
    --sysconfdir=/etc$OPREFIX
    --with-run-dir=/var$sPREFIX
    --with-libevent=$OPREFIX
    --with-pthreads
    --localstatedir=/var$sPREFIX
    --with-configdir=/etc$sPREFIX
    --with-zonesdir=/var$sPREFIX/zone
    --with-xfrdir=/var$sPREFIX/xfr
    --with-dbfile=/var$sPREFIX/db/nsd.db
    --with-xfrdfile=/var$sPREFIX/db/xfrd.state
    --with-zonelistfile=/var$sPREFIX/db/zone.list
    --with-pidfile=/var$sPREFIX/run/nsd.pid
"

pre_configure() {
    typeset arch=$1

    LDFLAGS[$arch]+=" -L${SYSROOT[$arch]}$OPREFIX/${LIBDIRS[$arch]}"
    LDFLAGS[$arch]+=" -R$OPREFIX/${LIBDIRS[$arch]}"
}

post_install() {
    install_smf network dns-nsd.xml
}

init
download_source $PROG $PROG $VER
prep_build
patch_source
build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
