# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

MY_PV="${PV%_*}"
MY_P="${PN}-${MY_PV}"

S="${WORKDIR}/${MY_P}"

RESTRICT="mirror"

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="http://pipewire.org/"
SRC_URI="https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/${MY_PV}/pipewire-${MY_PV}.tar.bz2 -> ${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"

IUSE="docs examples ffmpeg gstreamer jack pulseaudio systemd"

RDEPEND="
	media-libs/alsa-lib
	media-libs/sbc
	media-video/ffmpeg:=
	jack? ( >=media-sound/jack2-1.9.10 )
	pulseaudio? ( >=media-sound/pulseaudio-11.1 )
	sys-apps/dbus
	virtual/libudev
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	systemd? ( sys-apps/systemd )
	media-libs/vulkan-loader
"
DEPEND="
	${RDEPEND}
	dev-util/vulkan-headers
	app-doc/xmltoman
	docs? ( app-doc/doxygen )
"

src_configure() {
	local emesonargs=(
		-Dman=enabled
		$(meson_feature docs)
		$(meson_feature examples)
		$(meson_feature ffmpeg)
		$(meson_feature gstreamer)
		$(meson_feature jack pipewire-jack)
		$(meson_feature jack)
		$(meson_feature pulseaudio pipewire-pulseaudio)
		$(meson_feature systemd)
	)

	meson_src_configure
}
