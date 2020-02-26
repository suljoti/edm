# Makefile for edm top level
TOP = .
ifdef EPICS_HOST_ARCH
 include $(TOP)/configure/CONFIG
 DIRS += util 
 DIRS += lib 
 DIRS += epicsPv
 DIRS += logPv
 DIRS += proxyPv
 DIRS += calcPv
 DIRS += locPv
 DIRS += baselib 
 DIRS += edmMain 
 DIRS += giflib 
 DIRS += pnglib 
 DIRS += pvFactory 
 DIRS += choiceButton
 DIRS += videowidget
 DIRS += triumflib
 DIRS += diamondlib
 DIRS += indicator
 DIRS += multiSegRampButton
 DIRS += slaclib
 include $(TOP)/configure/RULES_DIRS

else
    TOP = .
    ifneq ($(wildcard $(TOP)/config)x,x)
      # New Makefile.Host config file location
      include $(TOP)/config/CONFIG_EXTENSIONS
      DIRS = util lib epicsPv calcPv locPv baselib edmMain giflib pnglib pvFactory choiceButton
      include $(TOP)/config/RULES_DIRS
    else
      # Old Makefile.Unix config file location
      EPICS=../../..
      include $(EPICS)/config/CONFIG_EXTENSIONS
      DIRS = util lib epicsPv calcPv locPv baselib edmMain giflib pnglib pvFactory choiceButton
      include $(EPICS)/config/RULES_DIRS
    endif
endif
#----------------------------------------
#  ADD RULES AFTER THIS LINE

ifndef T_A

MYDIR:=$(shell readlink -e $(TOP))

install build rebuild buildInstall: make_script

make_script: $(TOP)/bin/$(EPICS_HOST_ARCH)/edm

# note: setup.sh does not only set environment variables but also creates files:

$(TOP)/bin/$(EPICS_HOST_ARCH)/edm:
	mkdir -p $(@D)
	rm -f $@
	(cd setup && . ./setup.sh >/dev/null && env | grep EDM | sed -e 's/^/export /') > $@
	echo "export LD_LIBRARY_PATH=$$EDM_LD_LIBRARY_PATH:$$LD_LIBRARY_PATH" >> $@
	chmod a+x $@
endif

