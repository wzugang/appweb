#
#   appweb-vxworks-default.mk -- Makefile to build Embedthis Appweb for vxworks
#

NAME                  := appweb
VERSION               := 4.6.3
PROFILE               ?= default
ARCH                  ?= $(shell echo $(WIND_HOST_TYPE) | sed 's/-.*//')
CPU                   ?= $(subst X86,PENTIUM,$(shell echo $(ARCH) | tr a-z A-Z))
OS                    ?= vxworks
CC                    ?= cc$(subst x86,pentium,$(ARCH))
LD                    ?= ld
CONFIG                ?= $(OS)-$(ARCH)-$(PROFILE)
BUILD                 ?= build/$(CONFIG)
LBIN                  ?= $(BUILD)/bin
PATH                  := $(LBIN):$(PATH)

ME_COM_CGI            ?= 1
ME_COM_DIR            ?= 1
ME_COM_EJS            ?= 0
ME_COM_ESP            ?= 1
ME_COM_EST            ?= 1
ME_COM_HTTP           ?= 1
ME_COM_MATRIXSSL      ?= 0
ME_COM_MDB            ?= 1
ME_COM_NANOSSL        ?= 0
ME_COM_OPENSSL        ?= 0
ME_COM_PCRE           ?= 1
ME_COM_PHP            ?= 0
ME_COM_SQLITE         ?= 0
ME_COM_SSL            ?= 1
ME_COM_WINSDK         ?= 1
ME_COM_ZLIB           ?= 0

ifeq ($(ME_COM_EST),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_NANOSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_OPENSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_EJS),1)
    ME_COM_ZLIB := 1
endif
ifeq ($(ME_COM_ESP),1)
    ME_COM_MDB := 1
endif

ME_COM_CGI_PATH       ?= src/modules/cgiHandler.c
ME_COM_COMPILER_PATH  ?= cc$(subst x86,pentium,$(ARCH))
ME_COM_DIR_PATH       ?= src/dirHandler.c
ME_COM_LIB_PATH       ?= ar
ME_COM_LINK_PATH      ?= ld
ME_COM_MATRIXSSL_PATH ?= /usr/src/matrixssl
ME_COM_NANOSSL_PATH   ?= /usr/src/nanossl
ME_COM_OPENSSL_PATH   ?= /usr/src/openssl
ME_COM_PHP_PATH       ?= /usr/src/php
ME_COM_VXWORKS_PATH   ?= $(WIND_BASE)

export WIND_HOME      ?= $(WIND_BASE)/..
export PATH           := $(WIND_GNU_PATH)/$(WIND_HOST_TYPE)/bin:$(PATH)

CFLAGS                += -fno-builtin -fno-defer-pop -fvolatile -w
DFLAGS                += -DVXWORKS -DRW_MULTI_THREAD -D_GNU_TOOL -DCPU=PENTIUM $(patsubst %,-D%,$(filter ME_%,$(MAKEFLAGS))) -DME_COM_CGI=$(ME_COM_CGI) -DME_COM_DIR=$(ME_COM_DIR) -DME_COM_EJS=$(ME_COM_EJS) -DME_COM_ESP=$(ME_COM_ESP) -DME_COM_EST=$(ME_COM_EST) -DME_COM_HTTP=$(ME_COM_HTTP) -DME_COM_MATRIXSSL=$(ME_COM_MATRIXSSL) -DME_COM_MDB=$(ME_COM_MDB) -DME_COM_NANOSSL=$(ME_COM_NANOSSL) -DME_COM_OPENSSL=$(ME_COM_OPENSSL) -DME_COM_PCRE=$(ME_COM_PCRE) -DME_COM_PHP=$(ME_COM_PHP) -DME_COM_SQLITE=$(ME_COM_SQLITE) -DME_COM_SSL=$(ME_COM_SSL) -DME_COM_WINSDK=$(ME_COM_WINSDK) -DME_COM_ZLIB=$(ME_COM_ZLIB) 
IFLAGS                += "-Ibuild/$(CONFIG)/inc -I$(WIND_BASE)/target/h -I$(WIND_BASE)/target/h/wrn/coreip"
LDFLAGS               += '-Wl,-r'
LIBPATHS              += -Lbuild/$(CONFIG)/bin
LIBS                  += -lgcc

DEBUG                 ?= debug
CFLAGS-debug          ?= -g
DFLAGS-debug          ?= -DME_DEBUG
LDFLAGS-debug         ?= -g
DFLAGS-release        ?= 
CFLAGS-release        ?= -O2
LDFLAGS-release       ?= 
CFLAGS                += $(CFLAGS-$(DEBUG))
DFLAGS                += $(DFLAGS-$(DEBUG))
LDFLAGS               += $(LDFLAGS-$(DEBUG))

ME_ROOT_PREFIX        ?= deploy
ME_BASE_PREFIX        ?= $(ME_ROOT_PREFIX)
ME_DATA_PREFIX        ?= $(ME_VAPP_PREFIX)
ME_STATE_PREFIX       ?= $(ME_VAPP_PREFIX)
ME_BIN_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_INC_PREFIX         ?= $(ME_VAPP_PREFIX)/inc
ME_LIB_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_MAN_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_SBIN_PREFIX        ?= $(ME_VAPP_PREFIX)
ME_ETC_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_WEB_PREFIX         ?= $(ME_VAPP_PREFIX)/web
ME_LOG_PREFIX         ?= $(ME_VAPP_PREFIX)
ME_SPOOL_PREFIX       ?= $(ME_VAPP_PREFIX)
ME_CACHE_PREFIX       ?= $(ME_VAPP_PREFIX)
ME_APP_PREFIX         ?= $(ME_BASE_PREFIX)
ME_VAPP_PREFIX        ?= $(ME_APP_PREFIX)
ME_SRC_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/src/$(NAME)-$(VERSION)


TARGETS               += build/$(CONFIG)/bin/appweb.out
TARGETS               += build/$(CONFIG)/bin/authpass.out
ifeq ($(ME_COM_CGI),1)
    TARGETS           += build/$(CONFIG)/bin/cgiProgram.out
endif
ifeq ($(ME_COM_EJS),1)
    TARGETS           += build/$(CONFIG)/bin/ejs.mod
endif
ifeq ($(ME_COM_EJS),1)
    TARGETS           += build/$(CONFIG)/bin/ejs.out
endif
ifeq ($(ME_COM_ESP),1)
    TARGETS           += build/$(CONFIG)/esp
endif
ifeq ($(ME_COM_ESP),1)
    TARGETS           += build/$(CONFIG)/bin/esp.conf
endif
ifeq ($(ME_COM_ESP),1)
    TARGETS           += build/$(CONFIG)/bin/esp.out
endif
TARGETS               += build/$(CONFIG)/bin/ca.crt
ifeq ($(ME_COM_HTTP),1)
    TARGETS           += build/$(CONFIG)/bin/http.out
endif
ifeq ($(ME_COM_EST),1)
    TARGETS           += build/$(CONFIG)/bin/libest.out
endif
ifeq ($(ME_COM_CGI),1)
    TARGETS           += build/$(CONFIG)/bin/libmod_cgi.out
endif
ifeq ($(ME_COM_EJS),1)
    TARGETS           += build/$(CONFIG)/bin/libmod_ejs.out
endif
ifeq ($(ME_COM_PHP),1)
    TARGETS           += build/$(CONFIG)/bin/libmod_php.out
endif
ifeq ($(ME_COM_SSL),1)
    TARGETS           += build/$(CONFIG)/bin/libmod_ssl.out
endif
ifeq ($(ME_COM_SQLITE),1)
    TARGETS           += build/$(CONFIG)/bin/libsql.out
endif
TARGETS               += build/$(CONFIG)/bin/appman.out
TARGETS               += src/server/cache
ifeq ($(ME_COM_SQLITE),1)
    TARGETS           += build/$(CONFIG)/bin/sqlite.out
endif
ifeq ($(ME_COM_CGI),1)
    TARGETS           += test/web/auth/basic/basic.cgi
endif
ifeq ($(ME_COM_CGI),1)
    TARGETS           += test/web/caching/cache.cgi
endif
ifeq ($(ME_COM_CGI),1)
    TARGETS           += test/cgi-bin/cgiProgram.out
endif
ifeq ($(ME_COM_CGI),1)
    TARGETS           += test/cgi-bin/testScript
endif

unexport CDPATH

ifndef SHOW
.SILENT:
endif

all build compile: prep $(TARGETS)

.PHONY: prep

prep:
	@echo "      [Info] Use "make SHOW=1" to trace executed commands."
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(ME_APP_PREFIX)" = "" ] ; then echo WARNING: ME_APP_PREFIX not set ; exit 255 ; fi
	@if [ "$(WIND_BASE)" = "" ] ; then echo WARNING: WIND_BASE not set. Run wrenv.sh. ; exit 255 ; fi
	@if [ "$(WIND_HOST_TYPE)" = "" ] ; then echo WARNING: WIND_HOST_TYPE not set. Run wrenv.sh. ; exit 255 ; fi
	@if [ "$(WIND_GNU_PATH)" = "" ] ; then echo WARNING: WIND_GNU_PATH not set. Run wrenv.sh. ; exit 255 ; fi
	@[ ! -x $(BUILD)/bin ] && mkdir -p $(BUILD)/bin; true
	@[ ! -x $(BUILD)/inc ] && mkdir -p $(BUILD)/inc; true
	@[ ! -x $(BUILD)/obj ] && mkdir -p $(BUILD)/obj; true
	@[ ! -f $(BUILD)/inc/me.h ] && cp projects/appweb-vxworks-default-me.h $(BUILD)/inc/me.h ; true
	@if ! diff $(BUILD)/inc/me.h projects/appweb-vxworks-default-me.h >/dev/null ; then\
		cp projects/appweb-vxworks-default-me.h $(BUILD)/inc/me.h  ; \
	fi; true
	@if [ -f "$(BUILD)/.makeflags" ] ; then \
		if [ "$(MAKEFLAGS)" != "`cat $(BUILD)/.makeflags`" ] ; then \
			echo "   [Warning] Make flags have changed since the last build: "`cat $(BUILD)/.makeflags`"" ; \
		fi ; \
	fi
	@echo $(MAKEFLAGS) >$(BUILD)/.makeflags

clean:
	rm -f "build/$(CONFIG)/obj/appweb.o"
	rm -f "build/$(CONFIG)/obj/authpass.o"
	rm -f "build/$(CONFIG)/obj/cgiHandler.o"
	rm -f "build/$(CONFIG)/obj/cgiProgram.o"
	rm -f "build/$(CONFIG)/obj/config.o"
	rm -f "build/$(CONFIG)/obj/convenience.o"
	rm -f "build/$(CONFIG)/obj/dirHandler.o"
	rm -f "build/$(CONFIG)/obj/ejs.o"
	rm -f "build/$(CONFIG)/obj/ejsHandler.o"
	rm -f "build/$(CONFIG)/obj/ejsLib.o"
	rm -f "build/$(CONFIG)/obj/ejsc.o"
	rm -f "build/$(CONFIG)/obj/esp.o"
	rm -f "build/$(CONFIG)/obj/espLib.o"
	rm -f "build/$(CONFIG)/obj/estLib.o"
	rm -f "build/$(CONFIG)/obj/fileHandler.o"
	rm -f "build/$(CONFIG)/obj/http.o"
	rm -f "build/$(CONFIG)/obj/httpLib.o"
	rm -f "build/$(CONFIG)/obj/log.o"
	rm -f "build/$(CONFIG)/obj/makerom.o"
	rm -f "build/$(CONFIG)/obj/manager.o"
	rm -f "build/$(CONFIG)/obj/mprLib.o"
	rm -f "build/$(CONFIG)/obj/mprSsl.o"
	rm -f "build/$(CONFIG)/obj/pcre.o"
	rm -f "build/$(CONFIG)/obj/phpHandler.o"
	rm -f "build/$(CONFIG)/obj/server.o"
	rm -f "build/$(CONFIG)/obj/slink.o"
	rm -f "build/$(CONFIG)/obj/sqlite.o"
	rm -f "build/$(CONFIG)/obj/sqlite3.o"
	rm -f "build/$(CONFIG)/obj/sslModule.o"
	rm -f "build/$(CONFIG)/obj/testAppweb.o"
	rm -f "build/$(CONFIG)/obj/testHttp.o"
	rm -f "build/$(CONFIG)/obj/zlib.o"
	rm -f "build/$(CONFIG)/bin/appweb.out"
	rm -f "build/$(CONFIG)/bin/authpass.out"
	rm -f "build/$(CONFIG)/bin/cgiProgram.out"
	rm -f "build/$(CONFIG)/bin/ejsc.out"
	rm -f "build/$(CONFIG)/bin/ejs.out"
	rm -f "build/$(CONFIG)/bin/esp.conf"
	rm -f "build/$(CONFIG)/bin/esp.out"
	rm -f "build/$(CONFIG)/bin/ca.crt"
	rm -f "build/$(CONFIG)/bin/http.out"
	rm -f "build/$(CONFIG)/bin/libappweb.out"
	rm -f "build/$(CONFIG)/bin/libejs.out"
	rm -f "build/$(CONFIG)/bin/libest.out"
	rm -f "build/$(CONFIG)/bin/libhttp.out"
	rm -f "build/$(CONFIG)/bin/libmod_cgi.out"
	rm -f "build/$(CONFIG)/bin/libmod_ejs.out"
	rm -f "build/$(CONFIG)/bin/libmod_esp.out"
	rm -f "build/$(CONFIG)/bin/libmod_php.out"
	rm -f "build/$(CONFIG)/bin/libmod_ssl.out"
	rm -f "build/$(CONFIG)/bin/libmpr.out"
	rm -f "build/$(CONFIG)/bin/libmprssl.out"
	rm -f "build/$(CONFIG)/bin/libpcre.out"
	rm -f "build/$(CONFIG)/bin/libslink.out"
	rm -f "build/$(CONFIG)/bin/libsql.out"
	rm -f "build/$(CONFIG)/bin/libzlib.out"
	rm -f "build/$(CONFIG)/bin/makerom.out"
	rm -f "build/$(CONFIG)/bin/appman.out"
	rm -f "build/$(CONFIG)/bin/sqlite.out"
	rm -f "build/$(CONFIG)/bin/testAppweb.out"

clobber: clean
	rm -fr ./$(BUILD)


#
#   mpr.h
#
build/$(CONFIG)/inc/mpr.h: $(DEPS_1)
	@echo '      [Copy] build/$(CONFIG)/inc/mpr.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/mpr/mpr.h build/$(CONFIG)/inc/mpr.h

#
#   me.h
#
build/$(CONFIG)/inc/me.h: $(DEPS_2)
	@echo '      [Copy] build/$(CONFIG)/inc/me.h'

#
#   osdep.h
#
build/$(CONFIG)/inc/osdep.h: $(DEPS_3)
	@echo '      [Copy] build/$(CONFIG)/inc/osdep.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/osdep/osdep.h build/$(CONFIG)/inc/osdep.h

#
#   mprLib.o
#
DEPS_4 += build/$(CONFIG)/inc/me.h
DEPS_4 += build/$(CONFIG)/inc/mpr.h
DEPS_4 += build/$(CONFIG)/inc/osdep.h

build/$(CONFIG)/obj/mprLib.o: \
    src/paks/mpr/mprLib.c $(DEPS_4)
	@echo '   [Compile] build/$(CONFIG)/obj/mprLib.o'
	$(CC) -c -o build/$(CONFIG)/obj/mprLib.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/mpr/mprLib.c

#
#   libmpr
#
DEPS_5 += build/$(CONFIG)/inc/mpr.h
DEPS_5 += build/$(CONFIG)/inc/me.h
DEPS_5 += build/$(CONFIG)/inc/osdep.h
DEPS_5 += build/$(CONFIG)/obj/mprLib.o

build/$(CONFIG)/bin/libmpr.out: $(DEPS_5)
	@echo '      [Link] build/$(CONFIG)/bin/libmpr.out'
	$(CC) -r -o build/$(CONFIG)/bin/libmpr.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/mprLib.o" $(LIBS) 

#
#   pcre.h
#
build/$(CONFIG)/inc/pcre.h: $(DEPS_6)
	@echo '      [Copy] build/$(CONFIG)/inc/pcre.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/pcre/pcre.h build/$(CONFIG)/inc/pcre.h

#
#   pcre.o
#
DEPS_7 += build/$(CONFIG)/inc/me.h
DEPS_7 += build/$(CONFIG)/inc/pcre.h

build/$(CONFIG)/obj/pcre.o: \
    src/paks/pcre/pcre.c $(DEPS_7)
	@echo '   [Compile] build/$(CONFIG)/obj/pcre.o'
	$(CC) -c -o build/$(CONFIG)/obj/pcre.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/pcre/pcre.c

ifeq ($(ME_COM_PCRE),1)
#
#   libpcre
#
DEPS_8 += build/$(CONFIG)/inc/pcre.h
DEPS_8 += build/$(CONFIG)/inc/me.h
DEPS_8 += build/$(CONFIG)/obj/pcre.o

build/$(CONFIG)/bin/libpcre.out: $(DEPS_8)
	@echo '      [Link] build/$(CONFIG)/bin/libpcre.out'
	$(CC) -r -o build/$(CONFIG)/bin/libpcre.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/pcre.o" $(LIBS) 
endif

#
#   http.h
#
build/$(CONFIG)/inc/http.h: $(DEPS_9)
	@echo '      [Copy] build/$(CONFIG)/inc/http.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/http/http.h build/$(CONFIG)/inc/http.h

#
#   httpLib.o
#
DEPS_10 += build/$(CONFIG)/inc/me.h
DEPS_10 += build/$(CONFIG)/inc/http.h
DEPS_10 += build/$(CONFIG)/inc/mpr.h

build/$(CONFIG)/obj/httpLib.o: \
    src/paks/http/httpLib.c $(DEPS_10)
	@echo '   [Compile] build/$(CONFIG)/obj/httpLib.o'
	$(CC) -c -o build/$(CONFIG)/obj/httpLib.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/http/httpLib.c

ifeq ($(ME_COM_HTTP),1)
#
#   libhttp
#
DEPS_11 += build/$(CONFIG)/inc/mpr.h
DEPS_11 += build/$(CONFIG)/inc/me.h
DEPS_11 += build/$(CONFIG)/inc/osdep.h
DEPS_11 += build/$(CONFIG)/obj/mprLib.o
DEPS_11 += build/$(CONFIG)/bin/libmpr.out
DEPS_11 += build/$(CONFIG)/inc/pcre.h
DEPS_11 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_11 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_11 += build/$(CONFIG)/inc/http.h
DEPS_11 += build/$(CONFIG)/obj/httpLib.o

build/$(CONFIG)/bin/libhttp.out: $(DEPS_11)
	@echo '      [Link] build/$(CONFIG)/bin/libhttp.out'
	$(CC) -r -o build/$(CONFIG)/bin/libhttp.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/httpLib.o" $(LIBS) 
endif

#
#   appweb.h
#
build/$(CONFIG)/inc/appweb.h: $(DEPS_12)
	@echo '      [Copy] build/$(CONFIG)/inc/appweb.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/appweb.h build/$(CONFIG)/inc/appweb.h

#
#   customize.h
#
build/$(CONFIG)/inc/customize.h: $(DEPS_13)
	@echo '      [Copy] build/$(CONFIG)/inc/customize.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/customize.h build/$(CONFIG)/inc/customize.h

#
#   config.o
#
DEPS_14 += build/$(CONFIG)/inc/me.h
DEPS_14 += build/$(CONFIG)/inc/appweb.h
DEPS_14 += build/$(CONFIG)/inc/pcre.h
DEPS_14 += build/$(CONFIG)/inc/mpr.h
DEPS_14 += build/$(CONFIG)/inc/http.h
DEPS_14 += build/$(CONFIG)/inc/customize.h

build/$(CONFIG)/obj/config.o: \
    src/config.c $(DEPS_14)
	@echo '   [Compile] build/$(CONFIG)/obj/config.o'
	$(CC) -c -o build/$(CONFIG)/obj/config.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/config.c

#
#   convenience.o
#
DEPS_15 += build/$(CONFIG)/inc/me.h
DEPS_15 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/convenience.o: \
    src/convenience.c $(DEPS_15)
	@echo '   [Compile] build/$(CONFIG)/obj/convenience.o'
	$(CC) -c -o build/$(CONFIG)/obj/convenience.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/convenience.c

#
#   dirHandler.o
#
DEPS_16 += build/$(CONFIG)/inc/me.h
DEPS_16 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/dirHandler.o: \
    src/dirHandler.c $(DEPS_16)
	@echo '   [Compile] build/$(CONFIG)/obj/dirHandler.o'
	$(CC) -c -o build/$(CONFIG)/obj/dirHandler.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/dirHandler.c

#
#   fileHandler.o
#
DEPS_17 += build/$(CONFIG)/inc/me.h
DEPS_17 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/fileHandler.o: \
    src/fileHandler.c $(DEPS_17)
	@echo '   [Compile] build/$(CONFIG)/obj/fileHandler.o'
	$(CC) -c -o build/$(CONFIG)/obj/fileHandler.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/fileHandler.c

#
#   log.o
#
DEPS_18 += build/$(CONFIG)/inc/me.h
DEPS_18 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/log.o: \
    src/log.c $(DEPS_18)
	@echo '   [Compile] build/$(CONFIG)/obj/log.o'
	$(CC) -c -o build/$(CONFIG)/obj/log.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/log.c

#
#   server.o
#
DEPS_19 += build/$(CONFIG)/inc/me.h
DEPS_19 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/server.o: \
    src/server.c $(DEPS_19)
	@echo '   [Compile] build/$(CONFIG)/obj/server.o'
	$(CC) -c -o build/$(CONFIG)/obj/server.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/server.c

#
#   libappweb
#
DEPS_20 += build/$(CONFIG)/inc/mpr.h
DEPS_20 += build/$(CONFIG)/inc/me.h
DEPS_20 += build/$(CONFIG)/inc/osdep.h
DEPS_20 += build/$(CONFIG)/obj/mprLib.o
DEPS_20 += build/$(CONFIG)/bin/libmpr.out
DEPS_20 += build/$(CONFIG)/inc/pcre.h
DEPS_20 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_20 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_20 += build/$(CONFIG)/inc/http.h
DEPS_20 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_20 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_20 += build/$(CONFIG)/inc/appweb.h
DEPS_20 += build/$(CONFIG)/inc/customize.h
DEPS_20 += build/$(CONFIG)/obj/config.o
DEPS_20 += build/$(CONFIG)/obj/convenience.o
DEPS_20 += build/$(CONFIG)/obj/dirHandler.o
DEPS_20 += build/$(CONFIG)/obj/fileHandler.o
DEPS_20 += build/$(CONFIG)/obj/log.o
DEPS_20 += build/$(CONFIG)/obj/server.o

build/$(CONFIG)/bin/libappweb.out: $(DEPS_20)
	@echo '      [Link] build/$(CONFIG)/bin/libappweb.out'
	$(CC) -r -o build/$(CONFIG)/bin/libappweb.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/config.o" "build/$(CONFIG)/obj/convenience.o" "build/$(CONFIG)/obj/dirHandler.o" "build/$(CONFIG)/obj/fileHandler.o" "build/$(CONFIG)/obj/log.o" "build/$(CONFIG)/obj/server.o" $(LIBS) 

#
#   slink.c
#
src/slink.c: $(DEPS_21)
	( \
	cd src; \
	[ ! -f slink.c ] && cp slink.empty slink.c ; true ; \
	)

#
#   esp.h
#
build/$(CONFIG)/inc/esp.h: $(DEPS_22)
	@echo '      [Copy] build/$(CONFIG)/inc/esp.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/esp/esp.h build/$(CONFIG)/inc/esp.h

#
#   slink.o
#
DEPS_23 += build/$(CONFIG)/inc/me.h
DEPS_23 += build/$(CONFIG)/inc/mpr.h
DEPS_23 += build/$(CONFIG)/inc/esp.h

build/$(CONFIG)/obj/slink.o: \
    src/slink.c $(DEPS_23)
	@echo '   [Compile] build/$(CONFIG)/obj/slink.o'
	$(CC) -c -o build/$(CONFIG)/obj/slink.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/slink.c

#
#   libslink
#
DEPS_24 += src/slink.c
DEPS_24 += build/$(CONFIG)/inc/me.h
DEPS_24 += build/$(CONFIG)/inc/mpr.h
DEPS_24 += build/$(CONFIG)/inc/esp.h
DEPS_24 += build/$(CONFIG)/obj/slink.o

build/$(CONFIG)/bin/libslink.out: $(DEPS_24)
	@echo '      [Link] build/$(CONFIG)/bin/libslink.out'
	$(CC) -r -o build/$(CONFIG)/bin/libslink.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/slink.o" $(LIBS) 

#
#   appweb.o
#
DEPS_25 += build/$(CONFIG)/inc/me.h
DEPS_25 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/appweb.o: \
    src/server/appweb.c $(DEPS_25)
	@echo '   [Compile] build/$(CONFIG)/obj/appweb.o'
	$(CC) -c -o build/$(CONFIG)/obj/appweb.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/server/appweb.c

#
#   appweb
#
DEPS_26 += build/$(CONFIG)/inc/mpr.h
DEPS_26 += build/$(CONFIG)/inc/me.h
DEPS_26 += build/$(CONFIG)/inc/osdep.h
DEPS_26 += build/$(CONFIG)/obj/mprLib.o
DEPS_26 += build/$(CONFIG)/bin/libmpr.out
DEPS_26 += build/$(CONFIG)/inc/pcre.h
DEPS_26 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_26 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_26 += build/$(CONFIG)/inc/http.h
DEPS_26 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_26 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_26 += build/$(CONFIG)/inc/appweb.h
DEPS_26 += build/$(CONFIG)/inc/customize.h
DEPS_26 += build/$(CONFIG)/obj/config.o
DEPS_26 += build/$(CONFIG)/obj/convenience.o
DEPS_26 += build/$(CONFIG)/obj/dirHandler.o
DEPS_26 += build/$(CONFIG)/obj/fileHandler.o
DEPS_26 += build/$(CONFIG)/obj/log.o
DEPS_26 += build/$(CONFIG)/obj/server.o
DEPS_26 += build/$(CONFIG)/bin/libappweb.out
DEPS_26 += src/slink.c
DEPS_26 += build/$(CONFIG)/inc/esp.h
DEPS_26 += build/$(CONFIG)/obj/slink.o
DEPS_26 += build/$(CONFIG)/bin/libslink.out
DEPS_26 += build/$(CONFIG)/obj/appweb.o

build/$(CONFIG)/bin/appweb.out: $(DEPS_26)
	@echo '      [Link] build/$(CONFIG)/bin/appweb.out'
	$(CC) -o build/$(CONFIG)/bin/appweb.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/appweb.o" $(LIBS) -Wl,-r 

#
#   authpass.o
#
DEPS_27 += build/$(CONFIG)/inc/me.h
DEPS_27 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/authpass.o: \
    src/utils/authpass.c $(DEPS_27)
	@echo '   [Compile] build/$(CONFIG)/obj/authpass.o'
	$(CC) -c -o build/$(CONFIG)/obj/authpass.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/utils/authpass.c

#
#   authpass
#
DEPS_28 += build/$(CONFIG)/inc/mpr.h
DEPS_28 += build/$(CONFIG)/inc/me.h
DEPS_28 += build/$(CONFIG)/inc/osdep.h
DEPS_28 += build/$(CONFIG)/obj/mprLib.o
DEPS_28 += build/$(CONFIG)/bin/libmpr.out
DEPS_28 += build/$(CONFIG)/inc/pcre.h
DEPS_28 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_28 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_28 += build/$(CONFIG)/inc/http.h
DEPS_28 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_28 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_28 += build/$(CONFIG)/inc/appweb.h
DEPS_28 += build/$(CONFIG)/inc/customize.h
DEPS_28 += build/$(CONFIG)/obj/config.o
DEPS_28 += build/$(CONFIG)/obj/convenience.o
DEPS_28 += build/$(CONFIG)/obj/dirHandler.o
DEPS_28 += build/$(CONFIG)/obj/fileHandler.o
DEPS_28 += build/$(CONFIG)/obj/log.o
DEPS_28 += build/$(CONFIG)/obj/server.o
DEPS_28 += build/$(CONFIG)/bin/libappweb.out
DEPS_28 += build/$(CONFIG)/obj/authpass.o

build/$(CONFIG)/bin/authpass.out: $(DEPS_28)
	@echo '      [Link] build/$(CONFIG)/bin/authpass.out'
	$(CC) -o build/$(CONFIG)/bin/authpass.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/authpass.o" $(LIBS) -Wl,-r 

#
#   cgiProgram.o
#
DEPS_29 += build/$(CONFIG)/inc/me.h

build/$(CONFIG)/obj/cgiProgram.o: \
    src/utils/cgiProgram.c $(DEPS_29)
	@echo '   [Compile] build/$(CONFIG)/obj/cgiProgram.o'
	$(CC) -c -o build/$(CONFIG)/obj/cgiProgram.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/utils/cgiProgram.c

ifeq ($(ME_COM_CGI),1)
#
#   cgiProgram
#
DEPS_30 += build/$(CONFIG)/inc/me.h
DEPS_30 += build/$(CONFIG)/obj/cgiProgram.o

build/$(CONFIG)/bin/cgiProgram.out: $(DEPS_30)
	@echo '      [Link] build/$(CONFIG)/bin/cgiProgram.out'
	$(CC) -o build/$(CONFIG)/bin/cgiProgram.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/cgiProgram.o" $(LIBS) -Wl,-r 
endif

#
#   zlib.h
#
build/$(CONFIG)/inc/zlib.h: $(DEPS_31)
	@echo '      [Copy] build/$(CONFIG)/inc/zlib.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/zlib/zlib.h build/$(CONFIG)/inc/zlib.h

#
#   zlib.o
#
DEPS_32 += build/$(CONFIG)/inc/me.h
DEPS_32 += build/$(CONFIG)/inc/zlib.h

build/$(CONFIG)/obj/zlib.o: \
    src/paks/zlib/zlib.c $(DEPS_32)
	@echo '   [Compile] build/$(CONFIG)/obj/zlib.o'
	$(CC) -c -o build/$(CONFIG)/obj/zlib.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/zlib/zlib.c

ifeq ($(ME_COM_ZLIB),1)
#
#   libzlib
#
DEPS_33 += build/$(CONFIG)/inc/zlib.h
DEPS_33 += build/$(CONFIG)/inc/me.h
DEPS_33 += build/$(CONFIG)/obj/zlib.o

build/$(CONFIG)/bin/libzlib.out: $(DEPS_33)
	@echo '      [Link] build/$(CONFIG)/bin/libzlib.out'
	$(CC) -r -o build/$(CONFIG)/bin/libzlib.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/zlib.o" $(LIBS) 
endif

#
#   ejs.h
#
build/$(CONFIG)/inc/ejs.h: $(DEPS_34)
	@echo '      [Copy] build/$(CONFIG)/inc/ejs.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/ejs/ejs.h build/$(CONFIG)/inc/ejs.h

#
#   ejs.slots.h
#
build/$(CONFIG)/inc/ejs.slots.h: $(DEPS_35)
	@echo '      [Copy] build/$(CONFIG)/inc/ejs.slots.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/ejs/ejs.slots.h build/$(CONFIG)/inc/ejs.slots.h

#
#   ejsByteGoto.h
#
build/$(CONFIG)/inc/ejsByteGoto.h: $(DEPS_36)
	@echo '      [Copy] build/$(CONFIG)/inc/ejsByteGoto.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/ejs/ejsByteGoto.h build/$(CONFIG)/inc/ejsByteGoto.h

#
#   ejsLib.o
#
DEPS_37 += build/$(CONFIG)/inc/me.h
DEPS_37 += build/$(CONFIG)/inc/ejs.h
DEPS_37 += build/$(CONFIG)/inc/mpr.h
DEPS_37 += build/$(CONFIG)/inc/pcre.h
DEPS_37 += build/$(CONFIG)/inc/osdep.h
DEPS_37 += build/$(CONFIG)/inc/http.h
DEPS_37 += build/$(CONFIG)/inc/ejs.slots.h

build/$(CONFIG)/obj/ejsLib.o: \
    src/paks/ejs/ejsLib.c $(DEPS_37)
	@echo '   [Compile] build/$(CONFIG)/obj/ejsLib.o'
	$(CC) -c -o build/$(CONFIG)/obj/ejsLib.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/ejs/ejsLib.c

ifeq ($(ME_COM_EJS),1)
#
#   libejs
#
DEPS_38 += build/$(CONFIG)/inc/mpr.h
DEPS_38 += build/$(CONFIG)/inc/me.h
DEPS_38 += build/$(CONFIG)/inc/osdep.h
DEPS_38 += build/$(CONFIG)/obj/mprLib.o
DEPS_38 += build/$(CONFIG)/bin/libmpr.out
DEPS_38 += build/$(CONFIG)/inc/pcre.h
DEPS_38 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_38 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_38 += build/$(CONFIG)/inc/http.h
DEPS_38 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_38 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_38 += build/$(CONFIG)/inc/zlib.h
DEPS_38 += build/$(CONFIG)/obj/zlib.o
ifeq ($(ME_COM_ZLIB),1)
    DEPS_38 += build/$(CONFIG)/bin/libzlib.out
endif
DEPS_38 += build/$(CONFIG)/inc/ejs.h
DEPS_38 += build/$(CONFIG)/inc/ejs.slots.h
DEPS_38 += build/$(CONFIG)/inc/ejsByteGoto.h
DEPS_38 += build/$(CONFIG)/obj/ejsLib.o

build/$(CONFIG)/bin/libejs.out: $(DEPS_38)
	@echo '      [Link] build/$(CONFIG)/bin/libejs.out'
	$(CC) -r -o build/$(CONFIG)/bin/libejs.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/ejsLib.o" $(LIBS) 
endif

#
#   ejsc.o
#
DEPS_39 += build/$(CONFIG)/inc/me.h
DEPS_39 += build/$(CONFIG)/inc/ejs.h

build/$(CONFIG)/obj/ejsc.o: \
    src/paks/ejs/ejsc.c $(DEPS_39)
	@echo '   [Compile] build/$(CONFIG)/obj/ejsc.o'
	$(CC) -c -o build/$(CONFIG)/obj/ejsc.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/ejs/ejsc.c

ifeq ($(ME_COM_EJS),1)
#
#   ejsc
#
DEPS_40 += build/$(CONFIG)/inc/mpr.h
DEPS_40 += build/$(CONFIG)/inc/me.h
DEPS_40 += build/$(CONFIG)/inc/osdep.h
DEPS_40 += build/$(CONFIG)/obj/mprLib.o
DEPS_40 += build/$(CONFIG)/bin/libmpr.out
DEPS_40 += build/$(CONFIG)/inc/pcre.h
DEPS_40 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_40 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_40 += build/$(CONFIG)/inc/http.h
DEPS_40 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_40 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_40 += build/$(CONFIG)/inc/zlib.h
DEPS_40 += build/$(CONFIG)/obj/zlib.o
ifeq ($(ME_COM_ZLIB),1)
    DEPS_40 += build/$(CONFIG)/bin/libzlib.out
endif
DEPS_40 += build/$(CONFIG)/inc/ejs.h
DEPS_40 += build/$(CONFIG)/inc/ejs.slots.h
DEPS_40 += build/$(CONFIG)/inc/ejsByteGoto.h
DEPS_40 += build/$(CONFIG)/obj/ejsLib.o
DEPS_40 += build/$(CONFIG)/bin/libejs.out
DEPS_40 += build/$(CONFIG)/obj/ejsc.o

build/$(CONFIG)/bin/ejsc.out: $(DEPS_40)
	@echo '      [Link] build/$(CONFIG)/bin/ejsc.out'
	$(CC) -o build/$(CONFIG)/bin/ejsc.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/ejsc.o" $(LIBS) -Wl,-r 
endif

ifeq ($(ME_COM_EJS),1)
#
#   ejs.mod
#
DEPS_41 += src/paks/ejs/ejs.es
DEPS_41 += build/$(CONFIG)/inc/mpr.h
DEPS_41 += build/$(CONFIG)/inc/me.h
DEPS_41 += build/$(CONFIG)/inc/osdep.h
DEPS_41 += build/$(CONFIG)/obj/mprLib.o
DEPS_41 += build/$(CONFIG)/bin/libmpr.out
DEPS_41 += build/$(CONFIG)/inc/pcre.h
DEPS_41 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_41 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_41 += build/$(CONFIG)/inc/http.h
DEPS_41 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_41 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_41 += build/$(CONFIG)/inc/zlib.h
DEPS_41 += build/$(CONFIG)/obj/zlib.o
ifeq ($(ME_COM_ZLIB),1)
    DEPS_41 += build/$(CONFIG)/bin/libzlib.out
endif
DEPS_41 += build/$(CONFIG)/inc/ejs.h
DEPS_41 += build/$(CONFIG)/inc/ejs.slots.h
DEPS_41 += build/$(CONFIG)/inc/ejsByteGoto.h
DEPS_41 += build/$(CONFIG)/obj/ejsLib.o
DEPS_41 += build/$(CONFIG)/bin/libejs.out
DEPS_41 += build/$(CONFIG)/obj/ejsc.o
DEPS_41 += build/$(CONFIG)/bin/ejsc.out

build/$(CONFIG)/bin/ejs.mod: $(DEPS_41)
	( \
	cd src/paks/ejs; \
	../../../$(LBIN)/ejsc --out ../../../build/$(CONFIG)/bin/ejs.mod --optimize 9 --bind --require null ejs.es ; \
	)
endif

#
#   ejs.o
#
DEPS_42 += build/$(CONFIG)/inc/me.h
DEPS_42 += build/$(CONFIG)/inc/ejs.h

build/$(CONFIG)/obj/ejs.o: \
    src/paks/ejs/ejs.c $(DEPS_42)
	@echo '   [Compile] build/$(CONFIG)/obj/ejs.o'
	$(CC) -c -o build/$(CONFIG)/obj/ejs.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/ejs/ejs.c

ifeq ($(ME_COM_EJS),1)
#
#   ejscmd
#
DEPS_43 += build/$(CONFIG)/inc/mpr.h
DEPS_43 += build/$(CONFIG)/inc/me.h
DEPS_43 += build/$(CONFIG)/inc/osdep.h
DEPS_43 += build/$(CONFIG)/obj/mprLib.o
DEPS_43 += build/$(CONFIG)/bin/libmpr.out
DEPS_43 += build/$(CONFIG)/inc/pcre.h
DEPS_43 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_43 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_43 += build/$(CONFIG)/inc/http.h
DEPS_43 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_43 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_43 += build/$(CONFIG)/inc/zlib.h
DEPS_43 += build/$(CONFIG)/obj/zlib.o
ifeq ($(ME_COM_ZLIB),1)
    DEPS_43 += build/$(CONFIG)/bin/libzlib.out
endif
DEPS_43 += build/$(CONFIG)/inc/ejs.h
DEPS_43 += build/$(CONFIG)/inc/ejs.slots.h
DEPS_43 += build/$(CONFIG)/inc/ejsByteGoto.h
DEPS_43 += build/$(CONFIG)/obj/ejsLib.o
DEPS_43 += build/$(CONFIG)/bin/libejs.out
DEPS_43 += build/$(CONFIG)/obj/ejs.o

build/$(CONFIG)/bin/ejs.out: $(DEPS_43)
	@echo '      [Link] build/$(CONFIG)/bin/ejs.out'
	$(CC) -o build/$(CONFIG)/bin/ejs.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/ejs.o" $(LIBS) -Wl,-r 
endif

ifeq ($(ME_COM_ESP),1)
#
#   esp-paks
#
DEPS_44 += src/paks/esp-html-mvc
DEPS_44 += src/paks/esp-html-mvc/client
DEPS_44 += src/paks/esp-html-mvc/client/assets
DEPS_44 += src/paks/esp-html-mvc/client/assets/favicon.ico
DEPS_44 += src/paks/esp-html-mvc/client/css
DEPS_44 += src/paks/esp-html-mvc/client/css/all.css
DEPS_44 += src/paks/esp-html-mvc/client/css/all.less
DEPS_44 += src/paks/esp-html-mvc/client/index.esp
DEPS_44 += src/paks/esp-html-mvc/css
DEPS_44 += src/paks/esp-html-mvc/css/app.less
DEPS_44 += src/paks/esp-html-mvc/css/theme.less
DEPS_44 += src/paks/esp-html-mvc/generate
DEPS_44 += src/paks/esp-html-mvc/generate/appweb.conf
DEPS_44 += src/paks/esp-html-mvc/generate/controller.c
DEPS_44 += src/paks/esp-html-mvc/generate/controllerSingleton.c
DEPS_44 += src/paks/esp-html-mvc/generate/edit.esp
DEPS_44 += src/paks/esp-html-mvc/generate/list.esp
DEPS_44 += src/paks/esp-html-mvc/layouts
DEPS_44 += src/paks/esp-html-mvc/layouts/default.esp
DEPS_44 += src/paks/esp-html-mvc/package.json
DEPS_44 += src/paks/esp-legacy-mvc
DEPS_44 += src/paks/esp-legacy-mvc/generate
DEPS_44 += src/paks/esp-legacy-mvc/generate/appweb.conf
DEPS_44 += src/paks/esp-legacy-mvc/generate/controller.c
DEPS_44 += src/paks/esp-legacy-mvc/generate/edit.esp
DEPS_44 += src/paks/esp-legacy-mvc/generate/list.esp
DEPS_44 += src/paks/esp-legacy-mvc/generate/migration.c
DEPS_44 += src/paks/esp-legacy-mvc/generate/src
DEPS_44 += src/paks/esp-legacy-mvc/generate/src/app.c
DEPS_44 += src/paks/esp-legacy-mvc/layouts
DEPS_44 += src/paks/esp-legacy-mvc/layouts/default.esp
DEPS_44 += src/paks/esp-legacy-mvc/package.json
DEPS_44 += src/paks/esp-legacy-mvc/static
DEPS_44 += src/paks/esp-legacy-mvc/static/css
DEPS_44 += src/paks/esp-legacy-mvc/static/css/all.css
DEPS_44 += src/paks/esp-legacy-mvc/static/images
DEPS_44 += src/paks/esp-legacy-mvc/static/images/banner.jpg
DEPS_44 += src/paks/esp-legacy-mvc/static/images/favicon.ico
DEPS_44 += src/paks/esp-legacy-mvc/static/images/splash.jpg
DEPS_44 += src/paks/esp-legacy-mvc/static/index.esp
DEPS_44 += src/paks/esp-legacy-mvc/static/js
DEPS_44 += src/paks/esp-legacy-mvc/static/js/jquery.esp.js
DEPS_44 += src/paks/esp-legacy-mvc/static/js/jquery.js
DEPS_44 += src/paks/esp-mvc
DEPS_44 += src/paks/esp-mvc/generate
DEPS_44 += src/paks/esp-mvc/generate/appweb.conf
DEPS_44 += src/paks/esp-mvc/generate/controller.c
DEPS_44 += src/paks/esp-mvc/generate/migration.c
DEPS_44 += src/paks/esp-mvc/generate/src
DEPS_44 += src/paks/esp-mvc/generate/src/app.c
DEPS_44 += src/paks/esp-mvc/LICENSE.md
DEPS_44 += src/paks/esp-mvc/package.json
DEPS_44 += src/paks/esp-mvc/README.md
DEPS_44 += src/paks/esp-server
DEPS_44 += src/paks/esp-server/generate
DEPS_44 += src/paks/esp-server/generate/appweb.conf
DEPS_44 += src/paks/esp-server/package.json

build/$(CONFIG)/esp: $(DEPS_44)
	( \
	cd src/paks; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3" ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/client" ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/client/assets" ; \
	cp esp-html-mvc/client/assets/favicon.ico ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/client/assets/favicon.ico ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/client/css" ; \
	cp esp-html-mvc/client/css/all.css ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/client/css/all.css ; \
	cp esp-html-mvc/client/css/all.less ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/client/css/all.less ; \
	cp esp-html-mvc/client/index.esp ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/client/index.esp ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/css" ; \
	cp esp-html-mvc/css/app.less ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/css/app.less ; \
	cp esp-html-mvc/css/theme.less ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/css/theme.less ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/generate" ; \
	cp esp-html-mvc/generate/appweb.conf ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/generate/appweb.conf ; \
	cp esp-html-mvc/generate/controller.c ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/generate/controller.c ; \
	cp esp-html-mvc/generate/controllerSingleton.c ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/generate/controllerSingleton.c ; \
	cp esp-html-mvc/generate/edit.esp ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/generate/edit.esp ; \
	cp esp-html-mvc/generate/list.esp ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/generate/list.esp ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/layouts" ; \
	cp esp-html-mvc/layouts/default.esp ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/layouts/default.esp ; \
	cp esp-html-mvc/package.json ../../build/$(CONFIG)/esp/esp-html-mvc/4.6.3/package.json ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3" ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/generate" ; \
	cp esp-legacy-mvc/generate/appweb.conf ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/generate/appweb.conf ; \
	cp esp-legacy-mvc/generate/controller.c ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/generate/controller.c ; \
	cp esp-legacy-mvc/generate/edit.esp ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/generate/edit.esp ; \
	cp esp-legacy-mvc/generate/list.esp ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/generate/list.esp ; \
	cp esp-legacy-mvc/generate/migration.c ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/generate/migration.c ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/generate/src" ; \
	cp esp-legacy-mvc/generate/src/app.c ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/generate/src/app.c ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/layouts" ; \
	cp esp-legacy-mvc/layouts/default.esp ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/layouts/default.esp ; \
	cp esp-legacy-mvc/package.json ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/package.json ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/static" ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/static/css" ; \
	cp esp-legacy-mvc/static/css/all.css ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/static/css/all.css ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/static/images" ; \
	cp esp-legacy-mvc/static/images/banner.jpg ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/static/images/banner.jpg ; \
	cp esp-legacy-mvc/static/images/favicon.ico ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/static/images/favicon.ico ; \
	cp esp-legacy-mvc/static/images/splash.jpg ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/static/images/splash.jpg ; \
	cp esp-legacy-mvc/static/index.esp ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/static/index.esp ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/static/js" ; \
	cp esp-legacy-mvc/static/js/jquery.esp.js ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/static/js/jquery.esp.js ; \
	cp esp-legacy-mvc/static/js/jquery.js ../../build/$(CONFIG)/esp/esp-legacy-mvc/4.6.3/static/js/jquery.js ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-mvc/4.6.3" ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-mvc/4.6.3/generate" ; \
	cp esp-mvc/generate/appweb.conf ../../build/$(CONFIG)/esp/esp-mvc/4.6.3/generate/appweb.conf ; \
	cp esp-mvc/generate/controller.c ../../build/$(CONFIG)/esp/esp-mvc/4.6.3/generate/controller.c ; \
	cp esp-mvc/generate/migration.c ../../build/$(CONFIG)/esp/esp-mvc/4.6.3/generate/migration.c ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-mvc/4.6.3/generate/src" ; \
	cp esp-mvc/generate/src/app.c ../../build/$(CONFIG)/esp/esp-mvc/4.6.3/generate/src/app.c ; \
	cp esp-mvc/LICENSE.md ../../build/$(CONFIG)/esp/esp-mvc/4.6.3/LICENSE.md ; \
	cp esp-mvc/package.json ../../build/$(CONFIG)/esp/esp-mvc/4.6.3/package.json ; \
	cp esp-mvc/README.md ../../build/$(CONFIG)/esp/esp-mvc/4.6.3/README.md ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-server/4.6.3" ; \
	mkdir -p "../../build/$(CONFIG)/esp/esp-server/4.6.3/generate" ; \
	cp esp-server/generate/appweb.conf ../../build/$(CONFIG)/esp/esp-server/4.6.3/generate/appweb.conf ; \
	cp esp-server/package.json ../../build/$(CONFIG)/esp/esp-server/4.6.3/package.json ; \
	)
endif

ifeq ($(ME_COM_ESP),1)
#
#   esp.conf
#
DEPS_45 += src/paks/esp/esp.conf

build/$(CONFIG)/bin/esp.conf: $(DEPS_45)
	@echo '      [Copy] build/$(CONFIG)/bin/esp.conf'
	mkdir -p "build/$(CONFIG)/bin"
	cp src/paks/esp/esp.conf build/$(CONFIG)/bin/esp.conf
endif

#
#   espLib.o
#
DEPS_46 += build/$(CONFIG)/inc/me.h
DEPS_46 += build/$(CONFIG)/inc/esp.h
DEPS_46 += build/$(CONFIG)/inc/pcre.h
DEPS_46 += build/$(CONFIG)/inc/osdep.h
DEPS_46 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/espLib.o: \
    src/paks/esp/espLib.c $(DEPS_46)
	@echo '   [Compile] build/$(CONFIG)/obj/espLib.o'
	$(CC) -c -o build/$(CONFIG)/obj/espLib.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/esp/espLib.c

ifeq ($(ME_COM_ESP),1)
#
#   libmod_esp
#
DEPS_47 += build/$(CONFIG)/inc/mpr.h
DEPS_47 += build/$(CONFIG)/inc/me.h
DEPS_47 += build/$(CONFIG)/inc/osdep.h
DEPS_47 += build/$(CONFIG)/obj/mprLib.o
DEPS_47 += build/$(CONFIG)/bin/libmpr.out
DEPS_47 += build/$(CONFIG)/inc/pcre.h
DEPS_47 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_47 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_47 += build/$(CONFIG)/inc/http.h
DEPS_47 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_47 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_47 += build/$(CONFIG)/inc/appweb.h
DEPS_47 += build/$(CONFIG)/inc/customize.h
DEPS_47 += build/$(CONFIG)/obj/config.o
DEPS_47 += build/$(CONFIG)/obj/convenience.o
DEPS_47 += build/$(CONFIG)/obj/dirHandler.o
DEPS_47 += build/$(CONFIG)/obj/fileHandler.o
DEPS_47 += build/$(CONFIG)/obj/log.o
DEPS_47 += build/$(CONFIG)/obj/server.o
DEPS_47 += build/$(CONFIG)/bin/libappweb.out
DEPS_47 += build/$(CONFIG)/inc/esp.h
DEPS_47 += build/$(CONFIG)/obj/espLib.o

build/$(CONFIG)/bin/libmod_esp.out: $(DEPS_47)
	@echo '      [Link] build/$(CONFIG)/bin/libmod_esp.out'
	$(CC) -r -o build/$(CONFIG)/bin/libmod_esp.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/espLib.o" $(LIBS) 
endif

#
#   esp.o
#
DEPS_48 += build/$(CONFIG)/inc/me.h
DEPS_48 += build/$(CONFIG)/inc/esp.h

build/$(CONFIG)/obj/esp.o: \
    src/paks/esp/esp.c $(DEPS_48)
	@echo '   [Compile] build/$(CONFIG)/obj/esp.o'
	$(CC) -c -o build/$(CONFIG)/obj/esp.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/esp/esp.c

ifeq ($(ME_COM_ESP),1)
#
#   espcmd
#
DEPS_49 += build/$(CONFIG)/inc/mpr.h
DEPS_49 += build/$(CONFIG)/inc/me.h
DEPS_49 += build/$(CONFIG)/inc/osdep.h
DEPS_49 += build/$(CONFIG)/obj/mprLib.o
DEPS_49 += build/$(CONFIG)/bin/libmpr.out
DEPS_49 += build/$(CONFIG)/inc/pcre.h
DEPS_49 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_49 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_49 += build/$(CONFIG)/inc/http.h
DEPS_49 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_49 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_49 += build/$(CONFIG)/inc/appweb.h
DEPS_49 += build/$(CONFIG)/inc/customize.h
DEPS_49 += build/$(CONFIG)/obj/config.o
DEPS_49 += build/$(CONFIG)/obj/convenience.o
DEPS_49 += build/$(CONFIG)/obj/dirHandler.o
DEPS_49 += build/$(CONFIG)/obj/fileHandler.o
DEPS_49 += build/$(CONFIG)/obj/log.o
DEPS_49 += build/$(CONFIG)/obj/server.o
DEPS_49 += build/$(CONFIG)/bin/libappweb.out
DEPS_49 += build/$(CONFIG)/inc/esp.h
DEPS_49 += build/$(CONFIG)/obj/espLib.o
DEPS_49 += build/$(CONFIG)/bin/libmod_esp.out
DEPS_49 += build/$(CONFIG)/obj/esp.o

build/$(CONFIG)/bin/esp.out: $(DEPS_49)
	@echo '      [Link] build/$(CONFIG)/bin/esp.out'
	$(CC) -o build/$(CONFIG)/bin/esp.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/esp.o" $(LIBS) -Wl,-r 
endif


#
#   genslink
#
genslink: $(DEPS_50)
	( \
	cd src; \
	esp --static --genlink slink.c compile ; \
	)

#
#   http-ca-crt
#
DEPS_51 += src/paks/http/ca.crt

build/$(CONFIG)/bin/ca.crt: $(DEPS_51)
	@echo '      [Copy] build/$(CONFIG)/bin/ca.crt'
	mkdir -p "build/$(CONFIG)/bin"
	cp src/paks/http/ca.crt build/$(CONFIG)/bin/ca.crt

#
#   http.o
#
DEPS_52 += build/$(CONFIG)/inc/me.h
DEPS_52 += build/$(CONFIG)/inc/http.h

build/$(CONFIG)/obj/http.o: \
    src/paks/http/http.c $(DEPS_52)
	@echo '   [Compile] build/$(CONFIG)/obj/http.o'
	$(CC) -c -o build/$(CONFIG)/obj/http.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/http/http.c

ifeq ($(ME_COM_HTTP),1)
#
#   httpcmd
#
DEPS_53 += build/$(CONFIG)/inc/mpr.h
DEPS_53 += build/$(CONFIG)/inc/me.h
DEPS_53 += build/$(CONFIG)/inc/osdep.h
DEPS_53 += build/$(CONFIG)/obj/mprLib.o
DEPS_53 += build/$(CONFIG)/bin/libmpr.out
DEPS_53 += build/$(CONFIG)/inc/pcre.h
DEPS_53 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_53 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_53 += build/$(CONFIG)/inc/http.h
DEPS_53 += build/$(CONFIG)/obj/httpLib.o
DEPS_53 += build/$(CONFIG)/bin/libhttp.out
DEPS_53 += build/$(CONFIG)/obj/http.o

build/$(CONFIG)/bin/http.out: $(DEPS_53)
	@echo '      [Link] build/$(CONFIG)/bin/http.out'
	$(CC) -o build/$(CONFIG)/bin/http.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/http.o" $(LIBS) -Wl,-r 
endif

#
#   est.h
#
build/$(CONFIG)/inc/est.h: $(DEPS_54)
	@echo '      [Copy] build/$(CONFIG)/inc/est.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/est/est.h build/$(CONFIG)/inc/est.h

#
#   estLib.o
#
DEPS_55 += build/$(CONFIG)/inc/me.h
DEPS_55 += build/$(CONFIG)/inc/est.h
DEPS_55 += build/$(CONFIG)/inc/osdep.h

build/$(CONFIG)/obj/estLib.o: \
    src/paks/est/estLib.c $(DEPS_55)
	@echo '   [Compile] build/$(CONFIG)/obj/estLib.o'
	$(CC) -c -o build/$(CONFIG)/obj/estLib.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/est/estLib.c

ifeq ($(ME_COM_EST),1)
#
#   libest
#
DEPS_56 += build/$(CONFIG)/inc/est.h
DEPS_56 += build/$(CONFIG)/inc/me.h
DEPS_56 += build/$(CONFIG)/inc/osdep.h
DEPS_56 += build/$(CONFIG)/obj/estLib.o

build/$(CONFIG)/bin/libest.out: $(DEPS_56)
	@echo '      [Link] build/$(CONFIG)/bin/libest.out'
	$(CC) -r -o build/$(CONFIG)/bin/libest.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/estLib.o" $(LIBS) 
endif

#
#   cgiHandler.o
#
DEPS_57 += build/$(CONFIG)/inc/me.h
DEPS_57 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/cgiHandler.o: \
    src/modules/cgiHandler.c $(DEPS_57)
	@echo '   [Compile] build/$(CONFIG)/obj/cgiHandler.o'
	$(CC) -c -o build/$(CONFIG)/obj/cgiHandler.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/modules/cgiHandler.c

ifeq ($(ME_COM_CGI),1)
#
#   libmod_cgi
#
DEPS_58 += build/$(CONFIG)/inc/mpr.h
DEPS_58 += build/$(CONFIG)/inc/me.h
DEPS_58 += build/$(CONFIG)/inc/osdep.h
DEPS_58 += build/$(CONFIG)/obj/mprLib.o
DEPS_58 += build/$(CONFIG)/bin/libmpr.out
DEPS_58 += build/$(CONFIG)/inc/pcre.h
DEPS_58 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_58 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_58 += build/$(CONFIG)/inc/http.h
DEPS_58 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_58 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_58 += build/$(CONFIG)/inc/appweb.h
DEPS_58 += build/$(CONFIG)/inc/customize.h
DEPS_58 += build/$(CONFIG)/obj/config.o
DEPS_58 += build/$(CONFIG)/obj/convenience.o
DEPS_58 += build/$(CONFIG)/obj/dirHandler.o
DEPS_58 += build/$(CONFIG)/obj/fileHandler.o
DEPS_58 += build/$(CONFIG)/obj/log.o
DEPS_58 += build/$(CONFIG)/obj/server.o
DEPS_58 += build/$(CONFIG)/bin/libappweb.out
DEPS_58 += build/$(CONFIG)/obj/cgiHandler.o

build/$(CONFIG)/bin/libmod_cgi.out: $(DEPS_58)
	@echo '      [Link] build/$(CONFIG)/bin/libmod_cgi.out'
	$(CC) -r -o build/$(CONFIG)/bin/libmod_cgi.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/cgiHandler.o" $(LIBS) 
endif

#
#   ejsHandler.o
#
DEPS_59 += build/$(CONFIG)/inc/me.h
DEPS_59 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/ejsHandler.o: \
    src/modules/ejsHandler.c $(DEPS_59)
	@echo '   [Compile] build/$(CONFIG)/obj/ejsHandler.o'
	$(CC) -c -o build/$(CONFIG)/obj/ejsHandler.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/modules/ejsHandler.c

ifeq ($(ME_COM_EJS),1)
#
#   libmod_ejs
#
DEPS_60 += build/$(CONFIG)/inc/mpr.h
DEPS_60 += build/$(CONFIG)/inc/me.h
DEPS_60 += build/$(CONFIG)/inc/osdep.h
DEPS_60 += build/$(CONFIG)/obj/mprLib.o
DEPS_60 += build/$(CONFIG)/bin/libmpr.out
DEPS_60 += build/$(CONFIG)/inc/pcre.h
DEPS_60 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_60 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_60 += build/$(CONFIG)/inc/http.h
DEPS_60 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_60 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_60 += build/$(CONFIG)/inc/appweb.h
DEPS_60 += build/$(CONFIG)/inc/customize.h
DEPS_60 += build/$(CONFIG)/obj/config.o
DEPS_60 += build/$(CONFIG)/obj/convenience.o
DEPS_60 += build/$(CONFIG)/obj/dirHandler.o
DEPS_60 += build/$(CONFIG)/obj/fileHandler.o
DEPS_60 += build/$(CONFIG)/obj/log.o
DEPS_60 += build/$(CONFIG)/obj/server.o
DEPS_60 += build/$(CONFIG)/bin/libappweb.out
DEPS_60 += build/$(CONFIG)/inc/zlib.h
DEPS_60 += build/$(CONFIG)/obj/zlib.o
ifeq ($(ME_COM_ZLIB),1)
    DEPS_60 += build/$(CONFIG)/bin/libzlib.out
endif
DEPS_60 += build/$(CONFIG)/inc/ejs.h
DEPS_60 += build/$(CONFIG)/inc/ejs.slots.h
DEPS_60 += build/$(CONFIG)/inc/ejsByteGoto.h
DEPS_60 += build/$(CONFIG)/obj/ejsLib.o
DEPS_60 += build/$(CONFIG)/bin/libejs.out
DEPS_60 += build/$(CONFIG)/obj/ejsHandler.o

build/$(CONFIG)/bin/libmod_ejs.out: $(DEPS_60)
	@echo '      [Link] build/$(CONFIG)/bin/libmod_ejs.out'
	$(CC) -r -o build/$(CONFIG)/bin/libmod_ejs.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/ejsHandler.o" $(LIBS) 
endif

#
#   phpHandler.o
#
DEPS_61 += build/$(CONFIG)/inc/me.h
DEPS_61 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/phpHandler.o: \
    src/modules/phpHandler.c $(DEPS_61)
	@echo '   [Compile] build/$(CONFIG)/obj/phpHandler.o'
	$(CC) -c -o build/$(CONFIG)/obj/phpHandler.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" "-I$(ME_COM_PHP_PATH)" "-I$(ME_COM_PHP_PATH)/main" "-I$(ME_COM_PHP_PATH)/Zend" "-I$(ME_COM_PHP_PATH)/TSRM" src/modules/phpHandler.c

ifeq ($(ME_COM_PHP),1)
#
#   libmod_php
#
DEPS_62 += build/$(CONFIG)/inc/mpr.h
DEPS_62 += build/$(CONFIG)/inc/me.h
DEPS_62 += build/$(CONFIG)/inc/osdep.h
DEPS_62 += build/$(CONFIG)/obj/mprLib.o
DEPS_62 += build/$(CONFIG)/bin/libmpr.out
DEPS_62 += build/$(CONFIG)/inc/pcre.h
DEPS_62 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_62 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_62 += build/$(CONFIG)/inc/http.h
DEPS_62 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_62 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_62 += build/$(CONFIG)/inc/appweb.h
DEPS_62 += build/$(CONFIG)/inc/customize.h
DEPS_62 += build/$(CONFIG)/obj/config.o
DEPS_62 += build/$(CONFIG)/obj/convenience.o
DEPS_62 += build/$(CONFIG)/obj/dirHandler.o
DEPS_62 += build/$(CONFIG)/obj/fileHandler.o
DEPS_62 += build/$(CONFIG)/obj/log.o
DEPS_62 += build/$(CONFIG)/obj/server.o
DEPS_62 += build/$(CONFIG)/bin/libappweb.out
DEPS_62 += build/$(CONFIG)/obj/phpHandler.o

LIBS_62 += -lphp5
LIBPATHS_62 += -L$(ME_COM_PHP_PATH)/libs

build/$(CONFIG)/bin/libmod_php.out: $(DEPS_62)
	@echo '      [Link] build/$(CONFIG)/bin/libmod_php.out'
	$(CC) -r -o build/$(CONFIG)/bin/libmod_php.out $(LDFLAGS) $(LIBPATHS)  "build/$(CONFIG)/obj/phpHandler.o" $(LIBPATHS_62) $(LIBS_62) $(LIBS_62) $(LIBS) 
endif

#
#   mprSsl.o
#
DEPS_63 += build/$(CONFIG)/inc/me.h
DEPS_63 += build/$(CONFIG)/inc/mpr.h
DEPS_63 += build/$(CONFIG)/inc/est.h

build/$(CONFIG)/obj/mprSsl.o: \
    src/paks/mpr/mprSsl.c $(DEPS_63)
	@echo '   [Compile] build/$(CONFIG)/obj/mprSsl.o'
	$(CC) -c -o build/$(CONFIG)/obj/mprSsl.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/paks/mpr/mprSsl.c

#
#   libmprssl
#
DEPS_64 += build/$(CONFIG)/inc/mpr.h
DEPS_64 += build/$(CONFIG)/inc/me.h
DEPS_64 += build/$(CONFIG)/inc/osdep.h
DEPS_64 += build/$(CONFIG)/obj/mprLib.o
DEPS_64 += build/$(CONFIG)/bin/libmpr.out
DEPS_64 += build/$(CONFIG)/inc/est.h
DEPS_64 += build/$(CONFIG)/obj/estLib.o
ifeq ($(ME_COM_EST),1)
    DEPS_64 += build/$(CONFIG)/bin/libest.out
endif
DEPS_64 += build/$(CONFIG)/obj/mprSsl.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_64 += -lssl
    LIBPATHS_64 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_64 += -lcrypto
    LIBPATHS_64 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_64 += -lmatrixssl
    LIBPATHS_64 += -L$(ME_COM_MATRIXSSL_PATH)
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_64 += -lssls
    LIBPATHS_64 += -L$(ME_COM_NANOSSL_PATH)/bin
endif

build/$(CONFIG)/bin/libmprssl.out: $(DEPS_64)
	@echo '      [Link] build/$(CONFIG)/bin/libmprssl.out'
	$(CC) -r -o build/$(CONFIG)/bin/libmprssl.out $(LDFLAGS) $(LIBPATHS)    "build/$(CONFIG)/obj/mprSsl.o" $(LIBPATHS_64) $(LIBS_64) $(LIBS_64) $(LIBS) 

#
#   sslModule.o
#
DEPS_65 += build/$(CONFIG)/inc/me.h
DEPS_65 += build/$(CONFIG)/inc/appweb.h

build/$(CONFIG)/obj/sslModule.o: \
    src/modules/sslModule.c $(DEPS_65)
	@echo '   [Compile] build/$(CONFIG)/obj/sslModule.o'
	$(CC) -c -o build/$(CONFIG)/obj/sslModule.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/modules/sslModule.c

ifeq ($(ME_COM_SSL),1)
#
#   libmod_ssl
#
DEPS_66 += build/$(CONFIG)/inc/mpr.h
DEPS_66 += build/$(CONFIG)/inc/me.h
DEPS_66 += build/$(CONFIG)/inc/osdep.h
DEPS_66 += build/$(CONFIG)/obj/mprLib.o
DEPS_66 += build/$(CONFIG)/bin/libmpr.out
DEPS_66 += build/$(CONFIG)/inc/pcre.h
DEPS_66 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_66 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_66 += build/$(CONFIG)/inc/http.h
DEPS_66 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_66 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_66 += build/$(CONFIG)/inc/appweb.h
DEPS_66 += build/$(CONFIG)/inc/customize.h
DEPS_66 += build/$(CONFIG)/obj/config.o
DEPS_66 += build/$(CONFIG)/obj/convenience.o
DEPS_66 += build/$(CONFIG)/obj/dirHandler.o
DEPS_66 += build/$(CONFIG)/obj/fileHandler.o
DEPS_66 += build/$(CONFIG)/obj/log.o
DEPS_66 += build/$(CONFIG)/obj/server.o
DEPS_66 += build/$(CONFIG)/bin/libappweb.out
DEPS_66 += build/$(CONFIG)/inc/est.h
DEPS_66 += build/$(CONFIG)/obj/estLib.o
ifeq ($(ME_COM_EST),1)
    DEPS_66 += build/$(CONFIG)/bin/libest.out
endif
DEPS_66 += build/$(CONFIG)/obj/mprSsl.o
DEPS_66 += build/$(CONFIG)/bin/libmprssl.out
DEPS_66 += build/$(CONFIG)/obj/sslModule.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_66 += -lssl
    LIBPATHS_66 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_66 += -lcrypto
    LIBPATHS_66 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_66 += -lmatrixssl
    LIBPATHS_66 += -L$(ME_COM_MATRIXSSL_PATH)
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_66 += -lssls
    LIBPATHS_66 += -L$(ME_COM_NANOSSL_PATH)/bin
endif

build/$(CONFIG)/bin/libmod_ssl.out: $(DEPS_66)
	@echo '      [Link] build/$(CONFIG)/bin/libmod_ssl.out'
	$(CC) -r -o build/$(CONFIG)/bin/libmod_ssl.out $(LDFLAGS) $(LIBPATHS)    "build/$(CONFIG)/obj/sslModule.o" $(LIBPATHS_66) $(LIBS_66) $(LIBS_66) $(LIBS) 
endif

#
#   sqlite3.h
#
build/$(CONFIG)/inc/sqlite3.h: $(DEPS_67)
	@echo '      [Copy] build/$(CONFIG)/inc/sqlite3.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/sqlite/sqlite3.h build/$(CONFIG)/inc/sqlite3.h

#
#   sqlite3.o
#
DEPS_68 += build/$(CONFIG)/inc/me.h
DEPS_68 += build/$(CONFIG)/inc/sqlite3.h

build/$(CONFIG)/obj/sqlite3.o: \
    src/paks/sqlite/sqlite3.c $(DEPS_68)
	@echo '   [Compile] build/$(CONFIG)/obj/sqlite3.o'
	$(CC) -c -o build/$(CONFIG)/obj/sqlite3.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/sqlite/sqlite3.c

ifeq ($(ME_COM_SQLITE),1)
#
#   libsql
#
DEPS_69 += build/$(CONFIG)/inc/sqlite3.h
DEPS_69 += build/$(CONFIG)/inc/me.h
DEPS_69 += build/$(CONFIG)/obj/sqlite3.o

build/$(CONFIG)/bin/libsql.out: $(DEPS_69)
	@echo '      [Link] build/$(CONFIG)/bin/libsql.out'
	$(CC) -r -o build/$(CONFIG)/bin/libsql.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/sqlite3.o" $(LIBS) 
endif

#
#   manager.o
#
DEPS_70 += build/$(CONFIG)/inc/me.h
DEPS_70 += build/$(CONFIG)/inc/mpr.h

build/$(CONFIG)/obj/manager.o: \
    src/paks/mpr/manager.c $(DEPS_70)
	@echo '   [Compile] build/$(CONFIG)/obj/manager.o'
	$(CC) -c -o build/$(CONFIG)/obj/manager.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/mpr/manager.c

#
#   manager
#
DEPS_71 += build/$(CONFIG)/inc/mpr.h
DEPS_71 += build/$(CONFIG)/inc/me.h
DEPS_71 += build/$(CONFIG)/inc/osdep.h
DEPS_71 += build/$(CONFIG)/obj/mprLib.o
DEPS_71 += build/$(CONFIG)/bin/libmpr.out
DEPS_71 += build/$(CONFIG)/obj/manager.o

build/$(CONFIG)/bin/appman.out: $(DEPS_71)
	@echo '      [Link] build/$(CONFIG)/bin/appman.out'
	$(CC) -o build/$(CONFIG)/bin/appman.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/manager.o" $(LIBS) -Wl,-r 

#
#   server-cache
#
src/server/cache: $(DEPS_72)
	( \
	cd src/server; \
	mkdir -p cache ; \
	)

#
#   sqlite.o
#
DEPS_73 += build/$(CONFIG)/inc/me.h
DEPS_73 += build/$(CONFIG)/inc/sqlite3.h

build/$(CONFIG)/obj/sqlite.o: \
    src/paks/sqlite/sqlite.c $(DEPS_73)
	@echo '   [Compile] build/$(CONFIG)/obj/sqlite.o'
	$(CC) -c -o build/$(CONFIG)/obj/sqlite.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" src/paks/sqlite/sqlite.c

ifeq ($(ME_COM_SQLITE),1)
#
#   sqliteshell
#
DEPS_74 += build/$(CONFIG)/inc/sqlite3.h
DEPS_74 += build/$(CONFIG)/inc/me.h
DEPS_74 += build/$(CONFIG)/obj/sqlite3.o
DEPS_74 += build/$(CONFIG)/bin/libsql.out
DEPS_74 += build/$(CONFIG)/obj/sqlite.o

build/$(CONFIG)/bin/sqlite.out: $(DEPS_74)
	@echo '      [Link] build/$(CONFIG)/bin/sqlite.out'
	$(CC) -o build/$(CONFIG)/bin/sqlite.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/sqlite.o" $(LIBS) -Wl,-r 
endif

#
#   testAppweb.h
#
build/$(CONFIG)/inc/testAppweb.h: $(DEPS_75)
	@echo '      [Copy] build/$(CONFIG)/inc/testAppweb.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp test/src/testAppweb.h build/$(CONFIG)/inc/testAppweb.h

#
#   testAppweb.o
#
DEPS_76 += build/$(CONFIG)/inc/me.h
DEPS_76 += build/$(CONFIG)/inc/testAppweb.h
DEPS_76 += build/$(CONFIG)/inc/mpr.h
DEPS_76 += build/$(CONFIG)/inc/http.h

build/$(CONFIG)/obj/testAppweb.o: \
    test/src/testAppweb.c $(DEPS_76)
	@echo '   [Compile] build/$(CONFIG)/obj/testAppweb.o'
	$(CC) -c -o build/$(CONFIG)/obj/testAppweb.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" test/src/testAppweb.c

#
#   testHttp.o
#
DEPS_77 += build/$(CONFIG)/inc/me.h
DEPS_77 += build/$(CONFIG)/inc/testAppweb.h

build/$(CONFIG)/obj/testHttp.o: \
    test/src/testHttp.c $(DEPS_77)
	@echo '   [Compile] build/$(CONFIG)/obj/testHttp.o'
	$(CC) -c -o build/$(CONFIG)/obj/testHttp.o $(CFLAGS) $(DFLAGS) "-Ibuild/$(CONFIG)/inc" "-I$(WIND_BASE)/target/h" "-I$(WIND_BASE)/target/h/wrn/coreip" test/src/testHttp.c

#
#   testAppweb
#
DEPS_78 += build/$(CONFIG)/inc/mpr.h
DEPS_78 += build/$(CONFIG)/inc/me.h
DEPS_78 += build/$(CONFIG)/inc/osdep.h
DEPS_78 += build/$(CONFIG)/obj/mprLib.o
DEPS_78 += build/$(CONFIG)/bin/libmpr.out
DEPS_78 += build/$(CONFIG)/inc/pcre.h
DEPS_78 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_78 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_78 += build/$(CONFIG)/inc/http.h
DEPS_78 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_78 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_78 += build/$(CONFIG)/inc/appweb.h
DEPS_78 += build/$(CONFIG)/inc/customize.h
DEPS_78 += build/$(CONFIG)/obj/config.o
DEPS_78 += build/$(CONFIG)/obj/convenience.o
DEPS_78 += build/$(CONFIG)/obj/dirHandler.o
DEPS_78 += build/$(CONFIG)/obj/fileHandler.o
DEPS_78 += build/$(CONFIG)/obj/log.o
DEPS_78 += build/$(CONFIG)/obj/server.o
DEPS_78 += build/$(CONFIG)/bin/libappweb.out
DEPS_78 += build/$(CONFIG)/inc/testAppweb.h
DEPS_78 += build/$(CONFIG)/obj/testAppweb.o
DEPS_78 += build/$(CONFIG)/obj/testHttp.o

build/$(CONFIG)/bin/testAppweb.out: $(DEPS_78)
	@echo '      [Link] build/$(CONFIG)/bin/testAppweb.out'
	$(CC) -o build/$(CONFIG)/bin/testAppweb.out $(LDFLAGS) $(LIBPATHS) "build/$(CONFIG)/obj/testAppweb.o" "build/$(CONFIG)/obj/testHttp.o" $(LIBS) -Wl,-r 

ifeq ($(ME_COM_CGI),1)
#
#   test-basic.cgi
#
DEPS_79 += build/$(CONFIG)/inc/mpr.h
DEPS_79 += build/$(CONFIG)/inc/me.h
DEPS_79 += build/$(CONFIG)/inc/osdep.h
DEPS_79 += build/$(CONFIG)/obj/mprLib.o
DEPS_79 += build/$(CONFIG)/bin/libmpr.out
DEPS_79 += build/$(CONFIG)/inc/pcre.h
DEPS_79 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_79 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_79 += build/$(CONFIG)/inc/http.h
DEPS_79 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_79 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_79 += build/$(CONFIG)/inc/appweb.h
DEPS_79 += build/$(CONFIG)/inc/customize.h
DEPS_79 += build/$(CONFIG)/obj/config.o
DEPS_79 += build/$(CONFIG)/obj/convenience.o
DEPS_79 += build/$(CONFIG)/obj/dirHandler.o
DEPS_79 += build/$(CONFIG)/obj/fileHandler.o
DEPS_79 += build/$(CONFIG)/obj/log.o
DEPS_79 += build/$(CONFIG)/obj/server.o
DEPS_79 += build/$(CONFIG)/bin/libappweb.out
DEPS_79 += build/$(CONFIG)/inc/testAppweb.h
DEPS_79 += build/$(CONFIG)/obj/testAppweb.o
DEPS_79 += build/$(CONFIG)/obj/testHttp.o
DEPS_79 += build/$(CONFIG)/bin/testAppweb.out

test/web/auth/basic/basic.cgi: $(DEPS_79)
	( \
	cd test; \
	echo "#!`type -p ejs`" >web/auth/basic/basic.cgi ; \
	echo 'print("HTTP/1.0 200 OK\nContent-Type: text/plain\n\n" + serialize(App.env, {pretty: true}) + "\n")' >>web/auth/basic/basic.cgi ; \
	chmod +x web/auth/basic/basic.cgi ; \
	)
endif

ifeq ($(ME_COM_CGI),1)
#
#   test-cache.cgi
#
DEPS_80 += build/$(CONFIG)/inc/mpr.h
DEPS_80 += build/$(CONFIG)/inc/me.h
DEPS_80 += build/$(CONFIG)/inc/osdep.h
DEPS_80 += build/$(CONFIG)/obj/mprLib.o
DEPS_80 += build/$(CONFIG)/bin/libmpr.out
DEPS_80 += build/$(CONFIG)/inc/pcre.h
DEPS_80 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_80 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_80 += build/$(CONFIG)/inc/http.h
DEPS_80 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_80 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_80 += build/$(CONFIG)/inc/appweb.h
DEPS_80 += build/$(CONFIG)/inc/customize.h
DEPS_80 += build/$(CONFIG)/obj/config.o
DEPS_80 += build/$(CONFIG)/obj/convenience.o
DEPS_80 += build/$(CONFIG)/obj/dirHandler.o
DEPS_80 += build/$(CONFIG)/obj/fileHandler.o
DEPS_80 += build/$(CONFIG)/obj/log.o
DEPS_80 += build/$(CONFIG)/obj/server.o
DEPS_80 += build/$(CONFIG)/bin/libappweb.out
DEPS_80 += build/$(CONFIG)/inc/testAppweb.h
DEPS_80 += build/$(CONFIG)/obj/testAppweb.o
DEPS_80 += build/$(CONFIG)/obj/testHttp.o
DEPS_80 += build/$(CONFIG)/bin/testAppweb.out

test/web/caching/cache.cgi: $(DEPS_80)
	( \
	cd test; \
	echo "#!`type -p ejs`" >web/caching/cache.cgi ; \
	echo 'print("HTTP/1.0 200 OK\nContent-Type: text/plain\n\n{number:" + Date().now() + "}\n")' >>web/caching/cache.cgi ; \
	chmod +x web/caching/cache.cgi ; \
	)
endif

ifeq ($(ME_COM_CGI),1)
#
#   test-cgiProgram
#
DEPS_81 += build/$(CONFIG)/inc/me.h
DEPS_81 += build/$(CONFIG)/obj/cgiProgram.o
DEPS_81 += build/$(CONFIG)/bin/cgiProgram.out

test/cgi-bin/cgiProgram.out: $(DEPS_81)
	( \
	cd test; \
	cp ../build/$(CONFIG)/bin/cgiProgram.out cgi-bin/cgiProgram.out ; \
	cp ../build/$(CONFIG)/bin/cgiProgram.out cgi-bin/nph-cgiProgram.out ; \
	cp ../build/$(CONFIG)/bin/cgiProgram.out 'cgi-bin/cgi Program.out' ; \
	cp ../build/$(CONFIG)/bin/cgiProgram.out web/cgiProgram.cgi ; \
	chmod +x cgi-bin/* web/cgiProgram.cgi ; \
	)
endif

ifeq ($(ME_COM_CGI),1)
#
#   test-testScript
#
DEPS_82 += build/$(CONFIG)/inc/mpr.h
DEPS_82 += build/$(CONFIG)/inc/me.h
DEPS_82 += build/$(CONFIG)/inc/osdep.h
DEPS_82 += build/$(CONFIG)/obj/mprLib.o
DEPS_82 += build/$(CONFIG)/bin/libmpr.out
DEPS_82 += build/$(CONFIG)/inc/pcre.h
DEPS_82 += build/$(CONFIG)/obj/pcre.o
ifeq ($(ME_COM_PCRE),1)
    DEPS_82 += build/$(CONFIG)/bin/libpcre.out
endif
DEPS_82 += build/$(CONFIG)/inc/http.h
DEPS_82 += build/$(CONFIG)/obj/httpLib.o
ifeq ($(ME_COM_HTTP),1)
    DEPS_82 += build/$(CONFIG)/bin/libhttp.out
endif
DEPS_82 += build/$(CONFIG)/inc/appweb.h
DEPS_82 += build/$(CONFIG)/inc/customize.h
DEPS_82 += build/$(CONFIG)/obj/config.o
DEPS_82 += build/$(CONFIG)/obj/convenience.o
DEPS_82 += build/$(CONFIG)/obj/dirHandler.o
DEPS_82 += build/$(CONFIG)/obj/fileHandler.o
DEPS_82 += build/$(CONFIG)/obj/log.o
DEPS_82 += build/$(CONFIG)/obj/server.o
DEPS_82 += build/$(CONFIG)/bin/libappweb.out
DEPS_82 += build/$(CONFIG)/inc/testAppweb.h
DEPS_82 += build/$(CONFIG)/obj/testAppweb.o
DEPS_82 += build/$(CONFIG)/obj/testHttp.o
DEPS_82 += build/$(CONFIG)/bin/testAppweb.out

test/cgi-bin/testScript: $(DEPS_82)
	( \
	cd test; \
	echo '#!../build/$(CONFIG)/bin/cgiProgram.out' >cgi-bin/testScript ; chmod +x cgi-bin/testScript ; \
	)
endif

#
#   installBinary
#
installBinary: $(DEPS_83)

#
#   install
#
DEPS_84 += installBinary

install: $(DEPS_84)


#
#   run
#
DEPS_85 += compile

run: $(DEPS_85)
	( \
	cd src/server; \
	sudo ../../build/$(CONFIG)/bin/appweb -v ; \
	)


#
#   uninstall
#
DEPS_86 += build

uninstall: $(DEPS_86)
	( \
	cd package; \
	rm -f "$(ME_VAPP_PREFIX)/appweb.conf" ; \
	rm -f "$(ME_VAPP_PREFIX)/esp.conf" ; \
	rm -f "$(ME_VAPP_PREFIX)/mine.types" ; \
	rm -f "$(ME_VAPP_PREFIX)/install.conf" ; \
	rm -fr "$(ME_VAPP_PREFIX)/inc/appweb" ; \
	)

#
#   version
#
version: $(DEPS_87)
	echo 4.6.3

