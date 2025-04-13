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

PROG=tidy
VER=5.8.0
PKG=ooce/application/tidy
SUMMARY="tidy"
DESC="Application that corrects and cleans up HTML and XML documents by "
DESC+="fixing markup errors and upgrading legacy code to modern standards"

BUILD_DEPENDS_IPS="
    ooce/developer/cmake
"

SKIP_LICENCES=W3C

set_builddir "$PROG-html5-$VER"

CONFIGURE_OPTS="
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_PREFIX=$PREFIX
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
"
CONFIGURE_OPTS[i386]="
    -DLIB_INSTALL_DIR=$PREFIX/lib
"
CONFIGURE_OPTS[amd64]="
    -DLIB_INSTALL_DIR=$PREFIX/lib/amd64
"

LDFLAGS[i386]+=" -R$PREFIX/lib"
LDFLAGS[amd64]+=" -R$PREFIX/lib/amd64"

init
download_source $PROG $VER
patch_source
prep_build cmake+ninja
build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
