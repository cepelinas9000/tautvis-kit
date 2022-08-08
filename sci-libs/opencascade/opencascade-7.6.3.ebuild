# Copyright 1999-2019 Gentoo Authors
# Copyrirgt 2022 Funtoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs cmake-utils eapi7-ver

DESCRIPTION="Development platform for CAD/CAE, 3D surface/solid modeling and data exchange"
HOMEPAGE="https://www.opencascade.com/"
SRC_URI="https://github.com/Open-Cascade-SAS/OCCT/archive/V7_6_3.tar.gz -> OCCT-V7_6_3.tar.gz"

LICENSE="|| ( Open-CASCADE-LGPL-2.1-Exception-1.0 LGPL-2.1 )"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"

IUSE="debug doc opengl gles2 openvr rapidjson vtk"

RDEPEND="dev-lang/tcl:0=
	dev-lang/tk:0=
	dev-tcltk/itcl
	dev-tcltk/itk
	dev-tcltk/tix
	media-libs/freetype:2
	dev-cpp/tbb
	opengl? (virtual/glu)
	opengl? (virtual/opengl)
	gles2? (media-libs/mesa[gles2])
	rapidjson? (dev-libs/rapidjson)
	x11-libs/libXmu
	ffmpeg? ( virtual/ffmpeg )
	freeimage? ( media-libs/freeimage )
	vtk? ( sci-libs/vtk[rendering] )
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
"

CMAKE_BUILD_TYPE=Release

MY_PV="${PV//./_}"
S="${WORKDIR}/OCCT-${MY_PV}"

PATCHES=(
    "${FILESDIR}"/0001-0032697-Configuration-fix-compilation-errors-with-on.patch
)

pkg_setup() {
	check-reqs_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOC_Overview=$(usex doc)
		-DBUILD_WITH_DEBUG=$(usex debug)
		-DINSTALL_SAMPLES=$(usex examples)
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FREEIMAGE=$(usex freeimage)
		-DUSE_GLES2=$(usex gles2)
		-DUSE_TBB=Y
		-DUSE_VTK=$(usex vtk)
		-DUSE_OPENGL=$(usex opengl)
		-DUSE_RAPIDJSON=$(usex rapidjson)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	fperms go-w "/usr/$(get_libdir)/${P}/bin/draw.sh"

	if ! use examples; then
		rm -rf "${ED%/}/usr/$(get_libdir)/${P}/share/${PN}/samples" || die
	fi

	doins "${S}/${PV}"
}

