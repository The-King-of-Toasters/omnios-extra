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

PROG=onig
VER=6.9.10
PKG=ooce/library/onig
SUMMARY="Oniguruma"
DESC="A modern and flexible regular expressions library"

test_relver '>=' 151051 && set_clangver

CONFIGURE_OPTS="--disable-static"

init
download_source $PROG $PROG $VER
prep_build
patch_source
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
