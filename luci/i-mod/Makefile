include $(TOPDIR)/rules.mk

LUCI_TOPDIR=..

PKG_NAME:=i-mod
PKG_RELEASE:=1

PKG_BUILD_PARALLEL:=0

PKG_VERSION:=$(shell $(LUCI_TOPDIR)/build/mkrevision.sh 2>/dev/null || echo unknown)

PKG_BUILD_DEPENDS:=$(if $(STAGING_DIR_ROOT),lua/host)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/ipkg-install
PKG_USE_MIPS16:=0

LUA_TARGET:=compile
LUCI_CFLAGS:=
LUCI_BUILD_PACKAGES:=
LUCI_SELECTED_MODULES:=

ifeq ($(BOARD),brcm-2.4)
  MAKE_FLAGS += CRAP="1"
endif

### Templates ###
define Package/luci/install/template
	$(CP) -a $(PKG_BUILD_DIR)/$(2)/dist/* $(1)/ -R
	$(CP) -a $(PKG_BUILD_DIR)/$(2)/ipkg/* $(1)/CONTROL/ 2>/dev/null || true
endef

### Protocols ###
define protocol
  define Package/luci-proto-$(1)
    SECTION:=luci
    CATEGORY:=I-MOD
    TITLE:=LuCI - I-MOD
    URL:=https://github.com/askai/i-mod
    SUBMENU:=2. LuCI Protocols
    TITLE:=$(if $(2),$(2),LuCI $(1) protocol support)
    DEPENDS:=$(3)
  endef

  define Package/luci-proto-$(1)/install
	$(call Package/luci/install/template,$$(1),protocols/$(1))
  endef

  ifneq ($(CONFIG_PACKAGE_luci-proto-$(1)),)
    LUCI_SELECTED_MODULES+=protocols/$(1)
  endif

  LUCI_BUILD_PACKAGES += luci-proto-$(1)
endef

### Applications ###
define application
  define Package/luci-app-$(1)
    SECTION:=luci
    CATEGORY:=I-MOD
    TITLE:=LuCI - I-MOD
    URL:=https://github.com/askai/i-mod
    SUBMENU:=1. LuCI Applications
    TITLE:=$(if $(2),$(2),LuCI $(1) application)
	DEPENDS:=$(3)
  endef

  define Package/luci-app-$(1)/install
	$(call Package/luci/install/template,$$(1),applications/luci-$(1))
  endef

  ifneq ($(CONFIG_PACKAGE_luci-app-$(1)),)
    LUCI_SELECTED_MODULES+=applications/luci-$(1)
  endif

  LUCI_BUILD_PACKAGES += luci-app-$(1)
endef

$(eval $(call application,adbyby,LuCI Support for adbyby,\
    +PACKAGE_luci-app-adbyby:libpthread \
    +PACKAGE_luci-app-adbyby:libstdcpp))

$(eval $(call application,aria2,LuCI Support for aria2,\
	+PACKAGE_luci-app-aria2:aria2 \
	+PACKAGE_luci-app-aria2:curl \
	+PACKAGE_luci-app-aria2:wget \
	+PACKAGE_luci-app-aria2:openssl-util))

$(eval $(call application,chinadns,LuCI Support for ChinaDNS,\
	+PACKAGE_luci-app-chinadns:ChinaDNS))

$(eval $(call application,cpulimit,LuCI Support for cpulimit,\
	+PACKAGE_luci-app-cpulimit:cpulimit))

$(eval $(call application,dns2socks,LuCI Support for dns2socks,\
	+PACKAGE_luci-app-dns2socks:dns2socks))

$(eval $(call application,macvlan,LuCI Support for macvlan,\
    +PACKAGE_luci-app-macvlan:kmod-macvlan \
    +PACKAGE_luci-app-macvlan:luci-app-mwan3))

$(eval $(call application,mjpg-streamer,LuCI Support for mjpg-streamer,\
    +PACKAGE_luci-app-mjpg-streamer:mjpg-streamer))

$(eval $(call application,n2n_v2,LuCI Support for n2n_v2,\
    +PACKAGE_luci-app-n2n_v2:n2n_v2))

$(eval $(call application,qos-gargoyle,LuCI Support for qos-gargoyle,\
    +PACKAGE_luci-app-qos-gargoyle:qos-gargoyle))

$(eval $(call application,redsocks2,LuCI Support for redsocks2,\
	+PACKAGE_luci-app-redsocks2:redsocks2 \
	+PACKAGE_luci-app-redsocks2:kmod-ipt-nat \
	+PACKAGE_luci-app-redsocks2:kmod-ipt-nat-extra \
	+PACKAGE_luci-app-redsocks2:kmod-ipt-ipset \
	+PACKAGE_luci-app-redsocks2:ipset \
	+PACKAGE_luci-app-shadowsocks:resolveip))

$(eval $(call application,shadowsocks,LuCI Support for shadowsocks,\
    +PACKAGE_luci-app-shadowsocks:shadowsocks-libev))

$(eval $(call application,usb-printer,LuCI Support for usb-printer,\
    +PACKAGE_luci-app-usb-printer:p910nd))

$(eval $(call application,vsftpd,LuCI Support for vsftpd,\
    +PACKAGE_luci-app-vsftpd:vsftpd-pam))

$(eval $(call application,xunlei,LuCI Support for Xware downloading app,\
    +PACKAGE_luci-app-xunlei:wget))

### Compile ###
PKG_CONFIG_DEPENDS=$(patsubst %,CONFIG_PACKAGE_%,$(LUCI_BUILD_PACKAGES))

include $(INCLUDE_DIR)/package.mk

define Build/Prepare
	@if [ ! -x $(LUCI_TOPDIR)/build/mkrevision.sh ]; then \
		echo "*** Repository layout changed!" >&2; \
		echo "*** Please change the LuCI url in feeds.conf to http://svn.luci.subsignal.org/luci/trunk and reinstall the feed with" >&2; \
		echo "*** ./scripts/feeds update luci; ./scripts/feeds install -a -p luci" >&2; \
		exit 1; \
	fi
	mkdir -p $(PKG_BUILD_DIR)
	$(TAR) c -C $(LUCI_TOPDIR) . \
		--exclude=.pc --exclude=.svn --exclude=.git \
		--exclude='boa-0*' --exclude='*.o' --exclude='*.so' \
		--exclude=dist | \
			tar x -C $(PKG_BUILD_DIR)/
	$(call Build/Prepare/Default)
endef

define Build/Configure
endef

MAKE_FLAGS += \
	MODULES="$(LUCI_SELECTED_MODULES)" \
	LUA_TARGET="$(LUA_TARGET)" \
	LUA_SHLIBS="-llua -lm -ldl -lcrypt" \
	CFLAGS="$(TARGET_CFLAGS) $(LUCI_CFLAGS) -I$(STAGING_DIR)/usr/include" \
	LDFLAGS="$(TARGET_LDFLAGS) -L$(STAGING_DIR)/usr/lib" \
	NIXIO_TLS="$(NIXIO_TLS)" OS="Linux"


$(foreach b,$(LUCI_BUILD_PACKAGES),$(eval $(call BuildPackage,$(b))))
