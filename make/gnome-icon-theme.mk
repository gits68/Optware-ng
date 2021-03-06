###########################################################
#
# gnome-icon-theme
#
###########################################################

# You must replace "gnome-icon-theme" and "GNOME-ICON-THEME" with the lower case name and
# upper case name of your new package.  Some places below will say
# "Do not change this" - that does not include this global change,
# which must always be done to ensure we have unique names.

#
# GNOME-ICON-THEME_VERSION, GNOME-ICON-THEME_SITE and GNOME-ICON-THEME_SOURCE define
# the upstream location of the source code for the package.
# GNOME-ICON-THEME_DIR is the directory which is created when the source
# archive is unpacked.
# GNOME-ICON-THEME_UNZIP is the command used to unzip the source.
# It is usually "zcat" (for .gz) or "bzcat" (for .bz2)
#
# You should change all these variables to suit your package.
# Please make sure that you add a description, and that you
# list all your packages' dependencies, seperated by commas.
# 
# If you list yourself as MAINTAINER, please give a valid email
# address, and indicate your irc nick if it cannot be easily deduced
# from your name or email address.  If you leave MAINTAINER set to
# "NSLU2 Linux" other developers will feel free to edit.
#
GNOME-ICON-THEME_SITE=http://ftp.gnome.org/pub/GNOME/sources/gnome-icon-theme/3.12
GNOME-ICON-THEME_VERSION=3.12.0
GNOME-ICON-THEME_SOURCE=gnome-icon-theme-$(GNOME-ICON-THEME_VERSION).tar.xz
GNOME-ICON-THEME_DIR=gnome-icon-theme-$(GNOME-ICON-THEME_VERSION)
GNOME-ICON-THEME_UNZIP=xzcat
GNOME-ICON-THEME_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
GNOME-ICON-THEME_DESCRIPTION=GNOME icon theme.
GNOME-ICON-THEME_SECTION=misc
GNOME-ICON-THEME_PRIORITY=optional
GNOME-ICON-THEME_DEPENDS=
GNOME-ICON-THEME_SUGGESTS=
GNOME-ICON-THEME_CONFLICTS=

#
# GNOME-ICON-THEME_IPK_VERSION should be incremented when the ipk changes.
#
GNOME-ICON-THEME_IPK_VERSION=2

#
# GNOME-ICON-THEME_CONFFILES should be a list of user-editable files
#GNOME-ICON-THEME_CONFFILES=$(TARGET_PREFIX)/etc/gnome-icon-theme.conf $(TARGET_PREFIX)/etc/init.d/SXXgnome-icon-theme

#
# GNOME-ICON-THEME_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#GNOME-ICON-THEME_PATCHES=$(GNOME-ICON-THEME_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
GNOME-ICON-THEME_CPPFLAGS=
GNOME-ICON-THEME_LDFLAGS=

#
# GNOME-ICON-THEME_BUILD_DIR is the directory in which the build is done.
# GNOME-ICON-THEME_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# GNOME-ICON-THEME_IPK_DIR is the directory in which the ipk is built.
# GNOME-ICON-THEME_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
GNOME-ICON-THEME_BUILD_DIR=$(BUILD_DIR)/gnome-icon-theme
GNOME-ICON-THEME_SOURCE_DIR=$(SOURCE_DIR)/gnome-icon-theme
GNOME-ICON-THEME_IPK_DIR=$(BUILD_DIR)/gnome-icon-theme-$(GNOME-ICON-THEME_VERSION)-ipk
GNOME-ICON-THEME_IPK=$(BUILD_DIR)/gnome-icon-theme_$(GNOME-ICON-THEME_VERSION)-$(GNOME-ICON-THEME_IPK_VERSION)_$(TARGET_ARCH).ipk

.PHONY: gnome-icon-theme-source gnome-icon-theme-unpack gnome-icon-theme gnome-icon-theme-stage gnome-icon-theme-ipk gnome-icon-theme-clean gnome-icon-theme-dirclean gnome-icon-theme-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(GNOME-ICON-THEME_SOURCE):
	$(WGET) -P $(@D) $(GNOME-ICON-THEME_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
gnome-icon-theme-source: $(DL_DIR)/$(GNOME-ICON-THEME_SOURCE) $(GNOME-ICON-THEME_PATCHES)

#
# This target unpacks the source code in the build directory.
# If the source archive is not .tar.gz or .tar.bz2, then you will need
# to change the commands here.  Patches to the source code are also
# applied in this target as required.
#
# This target also configures the build within the build directory.
# Flags such as LDFLAGS and CPPFLAGS should be passed into configure
# and NOT $(MAKE) below.  Passing it to configure causes configure to
# correctly BUILD the Makefile with the right paths, where passing it
# to Make causes it to override the default search paths of the compiler.
#
# If the compilation of the package requires other packages to be staged
# first, then do that first (e.g. "$(MAKE) <bar>-stage <baz>-stage").
#
# If the package uses  GNU libtool, you should invoke $(PATCH_LIBTOOL) as
# shown below to make various patches to it.
#
$(GNOME-ICON-THEME_BUILD_DIR)/.configured: $(DL_DIR)/$(GNOME-ICON-THEME_SOURCE) $(GNOME-ICON-THEME_PATCHES) make/gnome-icon-theme.mk
#	$(MAKE) <bar>-stage <baz>-stage
	rm -rf $(BUILD_DIR)/$(GNOME-ICON-THEME_DIR) $(@D)
	$(GNOME-ICON-THEME_UNZIP) $(DL_DIR)/$(GNOME-ICON-THEME_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	if test -n "$(GNOME-ICON-THEME_PATCHES)" ; \
		then cat $(GNOME-ICON-THEME_PATCHES) | \
		$(PATCH) -d $(BUILD_DIR)/$(GNOME-ICON-THEME_DIR) -p0 ; \
	fi
	if test "$(BUILD_DIR)/$(GNOME-ICON-THEME_DIR)" != "$(@D)" ; \
		then mv $(BUILD_DIR)/$(GNOME-ICON-THEME_DIR) $(@D) ; \
	fi
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(GNOME-ICON-THEME_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(GNOME-ICON-THEME_LDFLAGS)" \
		./configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--prefix=$(TARGET_PREFIX) \
		--disable-nls \
		--disable-static \
	)
#	$(PATCH_LIBTOOL) $(@D)/libtool
	touch $@

gnome-icon-theme-unpack: $(GNOME-ICON-THEME_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(GNOME-ICON-THEME_BUILD_DIR)/.built: $(GNOME-ICON-THEME_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D)
	touch $@

#
# This is the build convenience target.
#
gnome-icon-theme: $(GNOME-ICON-THEME_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(GNOME-ICON-THEME_BUILD_DIR)/.staged: $(GNOME-ICON-THEME_BUILD_DIR)/.built
	rm -f $@
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
	touch $@

gnome-icon-theme-stage: $(GNOME-ICON-THEME_BUILD_DIR)/.staged

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/gnome-icon-theme
#
$(GNOME-ICON-THEME_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: gnome-icon-theme" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(GNOME-ICON-THEME_PRIORITY)" >>$@
	@echo "Section: $(GNOME-ICON-THEME_SECTION)" >>$@
	@echo "Version: $(GNOME-ICON-THEME_VERSION)-$(GNOME-ICON-THEME_IPK_VERSION)" >>$@
	@echo "Maintainer: $(GNOME-ICON-THEME_MAINTAINER)" >>$@
	@echo "Source: $(GNOME-ICON-THEME_SITE)/$(GNOME-ICON-THEME_SOURCE)" >>$@
	@echo "Description: $(GNOME-ICON-THEME_DESCRIPTION)" >>$@
	@echo "Depends: $(GNOME-ICON-THEME_DEPENDS)" >>$@
	@echo "Suggests: $(GNOME-ICON-THEME_SUGGESTS)" >>$@
	@echo "Conflicts: $(GNOME-ICON-THEME_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(GNOME-ICON-THEME_IPK_DIR)$(TARGET_PREFIX)/sbin or $(GNOME-ICON-THEME_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(GNOME-ICON-THEME_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(GNOME-ICON-THEME_IPK_DIR)$(TARGET_PREFIX)/etc/gnome-icon-theme/...
# Documentation files should be installed in $(GNOME-ICON-THEME_IPK_DIR)$(TARGET_PREFIX)/doc/gnome-icon-theme/...
# Daemon startup scripts should be installed in $(GNOME-ICON-THEME_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??gnome-icon-theme
#
# You may need to patch your application to make it use these locations.
#
$(GNOME-ICON-THEME_IPK): $(GNOME-ICON-THEME_BUILD_DIR)/.built
	rm -rf $(GNOME-ICON-THEME_IPK_DIR) $(BUILD_DIR)/gnome-icon-theme_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(GNOME-ICON-THEME_BUILD_DIR) DESTDIR=$(GNOME-ICON-THEME_IPK_DIR) install
#	$(INSTALL) -d $(GNOME-ICON-THEME_IPK_DIR)$(TARGET_PREFIX)/etc/
#	$(INSTALL) -m 644 $(GNOME-ICON-THEME_SOURCE_DIR)/gnome-icon-theme.conf $(GNOME-ICON-THEME_IPK_DIR)$(TARGET_PREFIX)/etc/gnome-icon-theme.conf
#	$(INSTALL) -d $(GNOME-ICON-THEME_IPK_DIR)$(TARGET_PREFIX)/etc/init.d
#	$(INSTALL) -m 755 $(GNOME-ICON-THEME_SOURCE_DIR)/rc.gnome-icon-theme $(GNOME-ICON-THEME_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/SXXgnome-icon-theme
#	sed -i -e '/^#!/aOPTWARE_TARGET=${OPTWARE_TARGET}' $(GNOME-ICON-THEME_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/SXXgnome-icon-theme
	$(MAKE) $(GNOME-ICON-THEME_IPK_DIR)/CONTROL/control
	$(INSTALL) -m 755 $(GNOME-ICON-THEME_SOURCE_DIR)/postinst $(GNOME-ICON-THEME_IPK_DIR)/CONTROL/postinst
#	sed -i -e '/^#!/aOPTWARE_TARGET=${OPTWARE_TARGET}' $(GNOME-ICON-THEME_IPK_DIR)/CONTROL/postinst
	$(INSTALL) -m 755 $(GNOME-ICON-THEME_SOURCE_DIR)/prerm $(GNOME-ICON-THEME_IPK_DIR)/CONTROL/prerm
#	sed -i -e '/^#!/aOPTWARE_TARGET=${OPTWARE_TARGET}' $(GNOME-ICON-THEME_IPK_DIR)/CONTROL/prerm
#	if test -n "$(UPD-ALT_PREFIX)"; then \
		sed -i -e '/^[ 	]*update-alternatives /s|update-alternatives|$(UPD-ALT_PREFIX)/bin/&|' \
			$(GNOME-ICON-THEME_IPK_DIR)/CONTROL/postinst $(GNOME-ICON-THEME_IPK_DIR)/CONTROL/prerm; \
	fi
	echo $(GNOME-ICON-THEME_CONFFILES) | sed -e 's/ /\n/g' > $(GNOME-ICON-THEME_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(GNOME-ICON-THEME_IPK_DIR)
#	$(WHAT_TO_DO_WITH_IPK_DIR) $(GNOME-ICON-THEME_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
gnome-icon-theme-ipk: $(GNOME-ICON-THEME_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
gnome-icon-theme-clean:
	rm -f $(GNOME-ICON-THEME_BUILD_DIR)/.built
	-$(MAKE) -C $(GNOME-ICON-THEME_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
gnome-icon-theme-dirclean:
	rm -rf $(BUILD_DIR)/$(GNOME-ICON-THEME_DIR) $(GNOME-ICON-THEME_BUILD_DIR) $(GNOME-ICON-THEME_IPK_DIR) $(GNOME-ICON-THEME_IPK)
#
#
# Some sanity check for the package.
#
gnome-icon-theme-check: $(GNOME-ICON-THEME_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
