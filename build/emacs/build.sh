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

PROG=emacs
VER=30.2
PKG=ooce/editor/emacs
SUMMARY="Emacs editor"
DESC="An extensible, customizable, free/libre text editor - and more."

BUILD_DEPENDS_IPS="library/ncurses"
RUN_DEPENDS_IPS="
    file/gnu-findutils
    ooce/text/tree-sitter-langs
"

OPREFIX=$PREFIX
PREFIX+=/$PROG

set_arch 64

PKGDIFFPATH="${PREFIX#/}/share/$PROG"
PKGDIFF_HELPER="
    s:$PKGDIFFPATH/[0-9][0-9.]*:$PKGDIFFPATH/VERSION:
"

XFORM_ARGS="
    -DPREFIX=${PREFIX#/}
    -DOPREFIX=${OPREFIX#/}
    -DPROG=$PROG
    -DPKGROOT=$PROG
"

# source and pre-compiled files must preserve timestamps
PKG_INCLUDE_TS+=" *.el *.el.gz *.elc *.eln"

CONFIGURE_OPTS="
    --prefix=$PREFIX
    --without-x
    --with-gif=no
    --with-tree-sitter
    --with-json
    ac_cv_sys_long_file_names=yes
    ac_cv_header_sys_inotify_h=no
    ac_cv_func_inotify_init=no
"

# According to solaris-userland:
# ASLR should remain disabled for emacs. ASLR undermines emacs's dumping
# code, which requires every execution to have the same mappings. Since
# emacs is not network facing, or run with elevated privileges, this is
# not a security concern.
LDFLAGS="-z,aslr=disable"
LDFLAGS[amd64]+=" -R$OPREFIX/lib/amd64"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
