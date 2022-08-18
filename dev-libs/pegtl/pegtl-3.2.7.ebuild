# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Header-only library for creating parsers according to Parsing Expression Grammar"
HOMEPAGE="https://github.com/taocpp/PEGTL"
SRC_URI="https://github.com/taocpp/PEGTL/tarball/cf639f7f4ee125f68e1ccfba8d99ebc0de57b9fe -> PEGTL-3.2.7-cf639f7.tar.gz"


LICENSE="BSL-1.0"
SLOT="0"
KEYWORDS="*"


post_src_unpack() {
    if [ ! -d "${S}" ]; then
	mv taocpp-PEGTL-* "${S}" || die
    fi
}