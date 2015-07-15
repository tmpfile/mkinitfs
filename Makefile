
VERSION		:= 2.8.0

sysconfdir	?= /etc/mkinitfs
datarootdir	?= /usr/share
datadir		?= $(datarootdir)/mkinitfs

SBIN_FILES	:= mkinitfs bootchartd
SHARE_FILES	:= initramfs-init fstab passwd group
CONF_FILES	:= mkinitfs.conf \
		features.d/ata.modules \
		features.d/base.files \
		features.d/base.modules \
		features.d/bootchart.files \
		features.d/btrfs.modules \
		features.d/cdrom.modules \
		features.d/cramfs.modules \
		features.d/cryptsetup.files \
		features.d/cryptsetup.modules \
		features.d/ext2.modules \
		features.d/ext3.modules \
		features.d/ext4.modules \
		features.d/f2fs.modules \
		features.d/floppy.modules \
		features.d/gfs2.modules \
		features.d/jfs.modules \
		features.d/keymap.files \
		features.d/kms.files \
		features.d/kms.modules \
		features.d/lvm.files \
		features.d/lvm.modules \
		features.d/network.files \
		features.d/network.modules \
		features.d/ocfs2.modules \
		features.d/raid.modules \
		features.d/reiserfs.modules \
		features.d/scsi.modules \
		features.d/squashfs.modules \
		features.d/ubifs.modules \
		features.d/usb.modules \
		features.d/virtio.modules \
		features.d/xfs.modules

SCRIPTS		:= $(SBIN_FILES) initramfs-init
IN_FILES	:= $(addsuffix .in,$(SCRIPTS))

GIT_REV := $(shell test -d .git && git describe || echo exported)
ifneq ($(GIT_REV), exported)
FULL_VERSION    := $(patsubst $(PACKAGE)-%,%,$(GIT_REV))
FULL_VERSION    := $(patsubst v%,%,$(FULL_VERSION))
else
FULL_VERSION    := $(VERSION)
endif


DISTFILES	:= $(IN_FILES) $(CONF_FILES) Makefile

INSTALL		:= install
SED		:= sed
SED_REPLACE	:= -e 's:@VERSION@:$(FULL_VERSION):g' \
		-e 's:@sysconfdir@:$(sysconfdir):g' \
		-e 's:@datadir@:$(datadir):g'


all:	$(SCRIPTS)

clean:
	rm -f $(SCRIPTS)

help:
	@echo mkinitfs $(VERSION)
	@echo "usage: make install [DESTDIR=]"

.SUFFIXES:	.in
.in:
	${SED} ${SED_REPLACE} ${SED_EXTRA} $< > $@

install: $(SBIN_FILES) $(SHARE_FILES) $(CONF_FILES)
	for i in $(SBIN_FILES); do \
		$(INSTALL) -Dm755 $$i $(DESTDIR)/sbin/$$i;\
	done
	for i in $(CONF_FILES); do \
		$(INSTALL) -Dm644 $$i $(DESTDIR)/etc/mkinitfs/$$i;\
	done
	for i in $(SHARE_FILES); do \
		$(INSTALL) -D $$i $(DESTDIR)/usr/share/mkinitfs/$$i;\
	done

