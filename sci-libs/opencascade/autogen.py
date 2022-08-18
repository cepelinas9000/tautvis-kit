#!/usr/bin/env python3

from re import match

def get_latest_stable_version(releases):
	stable_versions = list(filter(lambda x: match(r"^V[7-9]_[0-9]+_+",x) , releases))
	# return version in opencascade format for exmaple "V7_6_3"
	return stable_versions[0]

async def generate(hub, **pkginfo):
	# maybe better to use from direct source (https://git.dev.opencascade.org/gitweb/?p=occt.git;a=summary)
	repo = "OCCT"
	user = 'Open-Cascade-SAS'
	releases_data = await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{user}/{repo}/tags", is_json=True
	)

	latest_release = get_latest_stable_version(list(map(lambda x: x["name"], releases_data)))
	if latest_release is None:
		raise hub.pkgtools.ebuild.BreezyError(f"Can't find a suitable release of {repo}")

	version = latest_release
	
	patches = []
	patches.append("opencascade-7.6.3-avoid-pre-stripping-binaries.patch")
	patches.append("opencascade-7.6.3-fixed-DESTDIR-v2.patch")
	
	if match(r"V7_6_3", version):
		patches.append("0001-0032697-Configuration-fix-compilation-errors-with-on.patch")
	
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version[1:].replace('_','.'),
		patches=patches,
		artifacts=[
			hub.pkgtools.ebuild.Artifact(
				url=f"https://github.com/{user}/{repo}/archive/{version}.tar.gz", final_name=f"{repo}-{version}.tar.gz"
			)
		],
	)
	ebuild.push()
