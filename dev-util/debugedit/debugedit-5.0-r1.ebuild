# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Create debuginfo and source file distributions"
HOMEPAGE="https://sourceware.org/debugedit/"
SRC_URI="
	https://sourceware.org/ftp/debugedit/${PV}/${P}.tar.xz
	https://sourceware.org/ftp/debugedit/${PV}/${P}.tar.xz.sig
"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-libs/elfutils-0.176-r1
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig
"


PATCHES=(
	"${FILESDIR}"/${P}-readelf.patch
	"${FILESDIR}"/${P}-zero-dir-entry.patch
	"${FILESDIR}"/${P}-hppa.patch
	"${FILESDIR}"/${P}-musl-error.h-fix.patch
)

src_prepare() {
	default
	eautoreconf
}
