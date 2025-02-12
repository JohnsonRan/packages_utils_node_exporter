include $(TOPDIR)/rules.mk

PKG_NAME:=node_exporter
PKG_VERSION:=1.8.2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/prometheus/node_exporter/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=f615c70be816550498dd6a505391dbed1a896705eff842628de13a1fa7654e8f

PKG_MAINTAINER:=JohnsonRan <me@ihtw.moe>
PKG_LICENSE:=Apache-2.0

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/prometheus/node_exporter
GO_PKG_BUILD_PKG:=$(GO_PKG)
CGO_ENABLED:=0
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:=main.version=v$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/node_exporter
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Prometheus Node Exporter
  URL:=https://github.com/prometheus/node_exporter
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/node_exporter/description
  Prometheus exporter for hardware and OS metrics exposed by *NIX kernels
endef

define Package/node_exporter/install
	$(call GoPackage/Package/Install/Bin,$(1))
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(CURDIR)/files/node_exporter.init $(1)/etc/init.d/node_exporter
endef

define Package/node_exporter/postrm
#!/bin/sh
if [ -z $${IPKG_INSTROOT} ]; then
	service node_exporter stop > /dev/null 2>&1
	rm /etc/init.d/node_exporter > /dev/null 2>&1
	EOF
fi
endef

define Build/Prepare
	$(Build/Prepare/Default)
	$(RM) -r $(PKG_BUILD_DIR)/rules/logic_test
endef

$(eval $(call GoBinPackage,node_exporter))
$(eval $(call BuildPackage,node_exporter))