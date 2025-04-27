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

# Copyright 2024 OmniOS Community Edition (OmniOSce) Association.

. ../../lib/build.sh

PROG=nano
VER=8.4
PKG=ooce/editor/nano
SUMMARY="nano editor"
DESC="GNU implementation of nano, a text editor emulating pico"

BUILD_DEPENDS_IPS="library/ncurses"

set_arch 64
set_clangver

XFORM_ARGS="
    -DPREFIX=${PREFIX#/}
    -DPROG=$PROG
"

CONFIGURE_OPTS="
    --sysconfdir=/etc/$PREFIX
    --enable-color
    --enable-multibuffer
    --disable-libmagic
    get_wch=getwch
"

CPPFLAGS+=" -I/usr/include/ncurses"

save_function make_install _make_install
make_install() {
    _make_install
    logcmd mkdir -p $DESTDIR/etc$PREFIX || logerr "mkdir"
    logcmd cp doc/sample.nanorc $DESTDIR/etc$PREFIX/nanorc \
        || logerr "install nanorc"
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
