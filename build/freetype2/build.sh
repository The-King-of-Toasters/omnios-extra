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

# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Copyright 2025 OmniOS Community Edition (OmniOSce) Association.

. ../../lib/build.sh

PROG=freetype
VER=2.13.3
PKG=ooce/library/freetype2
SUMMARY="$PROG"
DESC="A Free, High-Quality, and Portable Font Engine"

# we don't want freetype2 to have any runtime dependencies
# on omnios-extra packages. since openjdk bundles freetype2 and
# therefore would end up having runtime dependencies on -extra packages
PKG_CONFIG_PATH=()

XFORM_ARGS="-DPREFIX=${PREFIX#/}"

export CC_BUILD=/opt/gcc-$DEFAULT_GCC_VER/bin/gcc

CONFIGURE_OPTS="
    --prefix=$PREFIX
    --includedir=$PREFIX/include
    --disable-static
    --with-png=no
    --with-harfbuzz=no
"
CONFIGURE_OPTS[i386]="
    --bindir=$PREFIX/bin/i386
"
CONFIGURE_OPTS[amd64]="
    --bindir=$PREFIX/bin
"
CONFIGURE_OPTS[aarch64]+="
    --bindir=$PREFIX/bin
"
LDFLAGS[i386]+=" -lssp_ns"

pre_configure() {
    typeset arch=$1

    CONFIGURE_OPTS[$arch]+=" --libdir=$PREFIX/${LIBDIRS[$arch]}"
    LDFLAGS[$arch]+=" -L${SYSROOT[$arch]}/usr/${LIBDIRS[$arch]}"
}

init
download_source ${PROG}2 $PROG $VER
patch_source
prep_build
build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
