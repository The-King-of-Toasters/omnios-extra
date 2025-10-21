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

. ../../../lib/build.sh

PROG=citus
PKG=ooce/database/postgresql-XX/citus
VER=13.1.0
SUMMARY="Citus PostgreSQL XX extension"
DESC="Transforms PostgreSQL XX into a distributed database"

. $SRCDIR/../common.sh

SKIP_LICENCES=AGPLv3

SKIP_RTIME_CHECK=1
NO_SONAME_EXPECTED=1

init
download_source $PROG v$VER
patch_source

for v in $PGVERSIONS; do
    # citus 13 is not compatible with postgres 14 and earlier
    ((v <= 14)) && continue
    PREFIX=$OPREFIX/pgsql-$v

    # pgsql 17 and future releases are built with clang from r55 on
    test_relver '>=' 151055 && ((v >= 17)) && set_clangver

    # Make sure the right pg_config is used.
    export PATH="$PREFIX/bin:$OPATH"

    prep_build
    build
    PKG=${PKG/XX/$v} \
        RUN_DEPENDS_IPS=${DEF_RUN_DEPENDS_IPS/XX/$v} \
        SUMMARY=${SUMMARY/XX/$v} \
        DESC=${DESC/XX/$v} \
        make_package
    clean_up
done

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
