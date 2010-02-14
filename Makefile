# This Makefile is part of build_stuff
# (C) 2010 Michael Pilgermann <kichkasch@gmx.de>

# for UBUNTU Launchpad upload of deb package
# Packager information
PGP_KEYID ="1B09FB51"
FULLNAME = "Michael Pilgermann"
EMAIL = "kichkasch@gmx.de"

############################################
# 1. pyrtm
# http://bitbucket.org/srid/pyrtm/overview/
#
PYRTM_PACKAGE_NAME = pyrtm
PYRTM_VERSION="0.2"
PYRTM_BUILD_VERSION="0ubuntu1"
PYRTM_SRC=pyrtm-$(PYRTM_VERSION).tar.gz
PYRTM_URL=http://pypi.python.org/packages/source/p/pyrtm/$(PYRTM_SRC)

pyrtm:
	$(call python_packager,$(PYRTM_PACKAGE_NAME),$(PYRTM_VERSION),$(PYRTM_BUILD_VERSION),$(PYRTM_SRC),$(PYRTM_URL))
#
# pyrtm
############################################


############################################
############################################
#
# GENERIC
#
python_packager = \
	mkdir tmp; \
	(cd tmp && $(call sdist,$(5))); \
	$(call sdist_ubuntu,$(1),$(2),$(3),$(4),$(5)); \
	$(call ppa_upload,$(1),$(2),$(3)); \
	$(call clean,$(1),$(2))

sdist = \
	wget $(1)

sdist_ubuntu = \
	export DEBFULLNAME=$(FULLNAME); \
	export DEBEMAIL=$(EMAIL); \
	mkdir build; \
	cp tmp/$(4) build/$(1)-$(2).orig.tar.gz; \
	(cd build && tar -xzf $(1)-$(2).orig.tar.gz); \
	cp -r $(1)/debian build/$(1)-$(2)/ ; \
	(cd build/$(1)-$(2)/ && dpkg-buildpackage -S -k$(PGP_KEYID))
	
ppa_upload = \
	(cd build/ && dput --config dput.config  kichkasch-thirdparty $(1)_$(2)-$(3)_source.changes)

clean = \
	echo "Cleaning up ..."; \
	rm -rf tmp/; \
	rm -rf build/$(1)-$(2)/
