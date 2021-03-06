###########################################################
#
# rsnapshot
#
###########################################################

RSNAPSHOT_SITE=http://www.rsnapshot.org/downloads
RSNAPSHOT_VERSION=1.3.1
RSNAPSHOT_SOURCE=rsnapshot-$(RSNAPSHOT_VERSION).tar.gz
RSNAPSHOT_DIR=rsnapshot-$(RSNAPSHOT_VERSION)
RSNAPSHOT_UNZIP=zcat

RSNAPSHOT_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
RSNAPSHOT_DESCRIPTION=A filesystem snapshot utility based on rsync.
RSNAPSHOT_SECTION=util
RSNAPSHOT_PRIORITY=optional
RSNAPSHOT_DEPENDS=coreutils, perl, rsync, openssh

RSNAPSHOT_IPK_VERSION=1

RSNAPSHOT_CONFFILES=$(TARGET_PREFIX)/etc/rsnapshot.conf

RSNAPSHOT_PATCHES=

RSNAPSHOT_CPPFLAGS=
RSNAPSHOT_LDFLAGS=

RSNAPSHOT_BUILD_DIR=$(BUILD_DIR)/rsnapshot
RSNAPSHOT_SOURCE_DIR=$(SOURCE_DIR)/rsnapshot
RSNAPSHOT_IPK_DIR=$(BUILD_DIR)/rsnapshot-$(RSNAPSHOT_VERSION)-ipk
RSNAPSHOT_IPK=$(BUILD_DIR)/rsnapshot_$(RSNAPSHOT_VERSION)-$(RSNAPSHOT_IPK_VERSION)_$(TARGET_ARCH).ipk

$(RSNAPSHOT_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: rsnapshot" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(RSNAPSHOT_PRIORITY)" >>$@
	@echo "Section: $(RSNAPSHOT_SECTION)" >>$@
	@echo "Version: $(RSNAPSHOT_VERSION)-$(RSNAPSHOT_IPK_VERSION)" >>$@
	@echo "Maintainer: $(RSNAPSHOT_MAINTAINER)" >>$@
	@echo "Source: $(RSNAPSHOT_SITE)/$(RSNAPSHOT_SOURCE)" >>$@
	@echo "Description: $(RSNAPSHOT_DESCRIPTION)" >>$@
	@echo "Depends: $(RSNAPSHOT_DEPENDS)" >>$@

$(DL_DIR)/$(RSNAPSHOT_SOURCE):
	$(WGET) -P $(@D) $(RSNAPSHOT_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

rsnapshot-source: $(DL_DIR)/$(RSNAPSHOT_SOURCE) $(RSNAPSHOT_PATCHES)

$(RSNAPSHOT_BUILD_DIR)/.configured: $(DL_DIR)/$(RSNAPSHOT_SOURCE) $(RSNAPSHOT_PATCHES) make/rsnapshot.mk
#	$(MAKE) rsync-stage
	rm -rf $(BUILD_DIR)/$(RSNAPSHOT_DIR) $(@D)
	$(RSNAPSHOT_UNZIP) $(DL_DIR)/$(RSNAPSHOT_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(RSNAPSHOT_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(RSNAPSHOT_DIR) -p1
	mv $(BUILD_DIR)/$(RSNAPSHOT_DIR) $(@D)
	sed -i 's#/usr/bin/pod2man#pod2man#' $(@D)/Makefile.in
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(RSNAPSHOT_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(RSNAPSHOT_LDFLAGS)" \
		ac_cv_path_PERL=$(TARGET_PREFIX)/bin/perl \
		ac_cv_path_RSYNC=$(TARGET_PREFIX)/bin/rsync \
		ac_cv_path_SSH=$(TARGET_PREFIX)/bin/ssh \
		ac_cv_path_CP=$(TARGET_PREFIX)/bin/cp \
		ac_cv_path_RM=$(TARGET_PREFIX)/bin/rm \
		ac_cv_path_DU=$(TARGET_PREFIX)/bin/du \
		./configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--prefix=$(TARGET_PREFIX) \
		--disable-nls \
		--without-logger \
	)
	touch $@

rsnapshot-unpack: $(RSNAPSHOT_BUILD_DIR)/.configured

$(RSNAPSHOT_BUILD_DIR)/.built: $(RSNAPSHOT_BUILD_DIR)/.configured
	rm -f $@
#	$(MAKE) -C $(RSNAPSHOT_BUILD_DIR)
	touch $@

rsnapshot: $(RSNAPSHOT_BUILD_DIR)/.built

#$(RSNAPSHOT_BUILD_DIR)/.staged: $(RSNAPSHOT_BUILD_DIR)/.built
#	rm -f $@
#	$(MAKE) -C $(RSNAPSHOT_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
#	touch $@
#
#rsnapshot-stage: $(RSNAPSHOT_BUILD_DIR)/.staged

$(RSNAPSHOT_IPK): $(RSNAPSHOT_BUILD_DIR)/.built
	rm -rf $(RSNAPSHOT_IPK_DIR) $(BUILD_DIR)/rsnapshot_*_$(TARGET_ARCH).ipk
	-$(MAKE) -C $(RSNAPSHOT_BUILD_DIR) DESTDIR=$(RSNAPSHOT_IPK_DIR) install
	sed -i '/^=head1 USAGE$$/s/^/=back\n\n/' $(RSNAPSHOT_BUILD_DIR)/rsnapshot
	$(MAKE) -C $(RSNAPSHOT_BUILD_DIR) DESTDIR=$(RSNAPSHOT_IPK_DIR) install
	sed -i -e '/\/usr\/bin\/perl -w/d' -e 's|/usr/local/|$(TARGET_PREFIX)/|g' $(RSNAPSHOT_IPK_DIR)$(TARGET_PREFIX)/bin/*
	find $(RSNAPSHOT_IPK_DIR)$(TARGET_PREFIX) -type d -exec chmod go+rx {} \;
	$(INSTALL) -m 644 $(RSNAPSHOT_SOURCE_DIR)/rsnapshot.conf $(RSNAPSHOT_IPK_DIR)$(TARGET_PREFIX)/etc/rsnapshot.conf
	$(INSTALL) -d $(RSNAPSHOT_IPK_DIR)$(TARGET_PREFIX)/var/rsnapshot/
	$(INSTALL) -d $(RSNAPSHOT_IPK_DIR)$(TARGET_PREFIX)/var/run/
	$(INSTALL) -d $(RSNAPSHOT_IPK_DIR)$(TARGET_PREFIX)/var/log/
	$(MAKE) $(RSNAPSHOT_IPK_DIR)/CONTROL/control
#	$(INSTALL) -m 755 $(RSNAPSHOT_SOURCE_DIR)/postinst $(RSNAPSHOT_IPK_DIR)/CONTROL/postinst
#	$(INSTALL) -m 755 $(RSNAPSHOT_SOURCE_DIR)/prerm $(RSNAPSHOT_IPK_DIR)/CONTROL/prerm
	echo $(RSNAPSHOT_CONFFILES) | sed -e 's/ /\n/g' > $(RSNAPSHOT_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(RSNAPSHOT_IPK_DIR)

rsnapshot-ipk: $(RSNAPSHOT_IPK)

rsnapshot-clean:
	-$(MAKE) -C $(RSNAPSHOT_BUILD_DIR) clean

rsnapshot-dirclean:
	rm -rf $(BUILD_DIR)/$(RSNAPSHOT_DIR) $(RSNAPSHOT_BUILD_DIR) $(RSNAPSHOT_IPK_DIR) $(RSNAPSHOT_IPK)

rsnapshot-check: $(RSNAPSHOT_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $(RSNAPSHOT_IPK)
