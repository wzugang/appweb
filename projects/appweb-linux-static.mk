#
#   appweb-linux-static.mk -- Makefile to build Embedthis Appweb for linux
#

NAME                  := appweb
VERSION               := 5.4.1
PROFILE               ?= static
ARCH                  ?= $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
CC_ARCH               ?= $(shell echo $(ARCH) | sed 's/x86/i686/;s/x64/x86_64/')
OS                    ?= linux
CC                    ?= gcc
CONFIG                ?= $(OS)-$(ARCH)-$(PROFILE)
BUILD                 ?= build/$(CONFIG)
LBIN                  ?= $(BUILD)/bin
PATH                  := $(LBIN):$(PATH)

ME_COM_CGI            ?= 1
ME_COM_COMPILER       ?= 1
ME_COM_DIR            ?= 1
ME_COM_EJS            ?= 0
ME_COM_ESP            ?= 1
ME_COM_EST            ?= 0
ME_COM_HTTP           ?= 1
ME_COM_LIB            ?= 1
ME_COM_MATRIXSSL      ?= 0
ME_COM_MBEDTLS        ?= 0
ME_COM_MDB            ?= 1
ME_COM_MPR            ?= 1
ME_COM_NANOSSL        ?= 0
ME_COM_OPENSSL        ?= 1
ME_COM_OSDEP          ?= 1
ME_COM_PCRE           ?= 1
ME_COM_PHP            ?= 0
ME_COM_SQLITE         ?= 0
ME_COM_SSL            ?= 1
ME_COM_VXWORKS        ?= 0
ME_COM_WINSDK         ?= 1
ME_COM_ZLIB           ?= 0

ME_COM_OPENSSL_PATH   ?= "/usr/lib"

ifeq ($(ME_COM_EST),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_LIB),1)
    ME_COM_COMPILER := 1
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_MBEDTLS),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_NANOSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_OPENSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_ESP),1)
    ME_COM_MDB := 1
endif

CFLAGS                += -g -w
DFLAGS                +=  $(patsubst %,-D%,$(filter ME_%,$(MAKEFLAGS))) -DME_COM_CGI=$(ME_COM_CGI) -DME_COM_COMPILER=$(ME_COM_COMPILER) -DME_COM_DIR=$(ME_COM_DIR) -DME_COM_EJS=$(ME_COM_EJS) -DME_COM_ESP=$(ME_COM_ESP) -DME_COM_EST=$(ME_COM_EST) -DME_COM_HTTP=$(ME_COM_HTTP) -DME_COM_LIB=$(ME_COM_LIB) -DME_COM_MATRIXSSL=$(ME_COM_MATRIXSSL) -DME_COM_MBEDTLS=$(ME_COM_MBEDTLS) -DME_COM_MDB=$(ME_COM_MDB) -DME_COM_MPR=$(ME_COM_MPR) -DME_COM_NANOSSL=$(ME_COM_NANOSSL) -DME_COM_OPENSSL=$(ME_COM_OPENSSL) -DME_COM_OSDEP=$(ME_COM_OSDEP) -DME_COM_PCRE=$(ME_COM_PCRE) -DME_COM_PHP=$(ME_COM_PHP) -DME_COM_SQLITE=$(ME_COM_SQLITE) -DME_COM_SSL=$(ME_COM_SSL) -DME_COM_VXWORKS=$(ME_COM_VXWORKS) -DME_COM_WINSDK=$(ME_COM_WINSDK) -DME_COM_ZLIB=$(ME_COM_ZLIB) 
IFLAGS                += "-I$(BUILD)/inc"
LDFLAGS               += 
LIBPATHS              += -L$(BUILD)/bin
LIBS                  += -lrt -ldl -lpthread -lm

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

ME_ROOT_PREFIX        ?= 
ME_BASE_PREFIX        ?= $(ME_ROOT_PREFIX)/usr/local
ME_DATA_PREFIX        ?= $(ME_ROOT_PREFIX)/
ME_STATE_PREFIX       ?= $(ME_ROOT_PREFIX)/var
ME_APP_PREFIX         ?= $(ME_BASE_PREFIX)/lib/$(NAME)
ME_VAPP_PREFIX        ?= $(ME_APP_PREFIX)/$(VERSION)
ME_BIN_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/bin
ME_INC_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/include
ME_LIB_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/lib
ME_MAN_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/share/man
ME_SBIN_PREFIX        ?= $(ME_ROOT_PREFIX)/usr/local/sbin
ME_ETC_PREFIX         ?= $(ME_ROOT_PREFIX)/etc/$(NAME)
ME_WEB_PREFIX         ?= $(ME_ROOT_PREFIX)/var/www/$(NAME)
ME_LOG_PREFIX         ?= $(ME_ROOT_PREFIX)/var/log/$(NAME)
ME_SPOOL_PREFIX       ?= $(ME_ROOT_PREFIX)/var/spool/$(NAME)
ME_CACHE_PREFIX       ?= $(ME_ROOT_PREFIX)/var/spool/$(NAME)/cache
ME_SRC_PREFIX         ?= $(ME_ROOT_PREFIX)$(NAME)-$(VERSION)

WEB_USER              ?= $(shell egrep 'www-data|_www|nobody' /etc/passwd | sed 's/:.*$$$(ME_ROOT_PREFIX)/' |  tail -1)
WEB_GROUP             ?= $(shell egrep 'www-data|_www|nobody|nogroup' /etc/group | sed 's/:.*$$$(ME_ROOT_PREFIX)/' |  tail -1)

TARGETS               += init
TARGETS               += $(BUILD)/bin/appweb
TARGETS               += $(BUILD)/bin/authpass
ifeq ($(ME_COM_ESP),1)
    TARGETS           += $(BUILD)/bin/esp-compile.json
endif
ifeq ($(ME_COM_ESP),1)
    TARGETS           += $(BUILD)/bin/esp
endif
ifeq ($(ME_COM_HTTP),1)
    TARGETS           += $(BUILD)/bin/http
endif
ifeq ($(ME_COM_SSL),1)
    TARGETS           += $(BUILD)/bin
endif
TARGETS               += src/server/cache
TARGETS               += $(BUILD)/bin/appman

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
	@[ ! -x $(BUILD)/bin ] && mkdir -p $(BUILD)/bin; true
	@[ ! -x $(BUILD)/inc ] && mkdir -p $(BUILD)/inc; true
	@[ ! -x $(BUILD)/obj ] && mkdir -p $(BUILD)/obj; true
	@[ ! -f $(BUILD)/inc/me.h ] && cp projects/appweb-linux-static-me.h $(BUILD)/inc/me.h ; true
	@if ! diff $(BUILD)/inc/me.h projects/appweb-linux-static-me.h >/dev/null ; then\
		cp projects/appweb-linux-static-me.h $(BUILD)/inc/me.h  ; \
	fi; true
	@if [ -f "$(BUILD)/.makeflags" ] ; then \
		if [ "$(MAKEFLAGS)" != "`cat $(BUILD)/.makeflags`" ] ; then \
			echo "   [Warning] Make flags have changed since the last build" ; \
			echo "   [Warning] Previous build command: "`cat $(BUILD)/.makeflags`"" ; \
		fi ; \
	fi
	@echo "$(MAKEFLAGS)" >$(BUILD)/.makeflags

clean:
	rm -f "$(BUILD)/obj/appweb.o"
	rm -f "$(BUILD)/obj/authpass.o"
	rm -f "$(BUILD)/obj/cgiHandler.o"
	rm -f "$(BUILD)/obj/cgiProgram.o"
	rm -f "$(BUILD)/obj/config.o"
	rm -f "$(BUILD)/obj/convenience.o"
	rm -f "$(BUILD)/obj/esp.o"
	rm -f "$(BUILD)/obj/espHandler.o"
	rm -f "$(BUILD)/obj/espLib.o"
	rm -f "$(BUILD)/obj/est.o"
	rm -f "$(BUILD)/obj/estLib.o"
	rm -f "$(BUILD)/obj/http.o"
	rm -f "$(BUILD)/obj/httpLib.o"
	rm -f "$(BUILD)/obj/matrixssl.o"
	rm -f "$(BUILD)/obj/mbedtls.o"
	rm -f "$(BUILD)/obj/mprLib.o"
	rm -f "$(BUILD)/obj/nanossl.o"
	rm -f "$(BUILD)/obj/openssl.o"
	rm -f "$(BUILD)/obj/pcre.o"
	rm -f "$(BUILD)/obj/romFiles.o"
	rm -f "$(BUILD)/obj/watchdog.o"
	rm -f "$(BUILD)/bin/appweb"
	rm -f "$(BUILD)/bin/authpass"
	rm -f "$(BUILD)/bin/esp-compile.json"
	rm -f "$(BUILD)/bin/esp"
	rm -f "$(BUILD)/bin/http"
	rm -f "$(BUILD)/bin"
	rm -f "$(BUILD)/bin/libappweb.a"
	rm -f "$(BUILD)/bin/libesp.a"
	rm -f "$(BUILD)/bin/libhttp.a"
	rm -f "$(BUILD)/bin/libmpr.a"
	rm -f "$(BUILD)/bin/libpcre.a"
	rm -f "$(BUILD)/bin/libmpr-openssl.a"
	rm -f "$(BUILD)/bin/appman"

clobber: clean
	rm -fr ./$(BUILD)

#
#   init
#

init: $(DEPS_1)
	if [ ! -d /usr/include/openssl ] ; then echo ; \
	echo Install libssl-dev to get /usr/include/openssl ; \
	exit 255 ; \
	fi

#
#   me.h
#

$(BUILD)/inc/me.h: $(DEPS_2)

#
#   osdep.h
#
DEPS_3 += src/osdep/osdep.h
DEPS_3 += $(BUILD)/inc/me.h

$(BUILD)/inc/osdep.h: $(DEPS_3)
	@echo '      [Copy] $(BUILD)/inc/osdep.h'
	mkdir -p "$(BUILD)/inc"
	cp src/osdep/osdep.h $(BUILD)/inc/osdep.h

#
#   mpr.h
#
DEPS_4 += src/mpr/mpr.h
DEPS_4 += $(BUILD)/inc/me.h
DEPS_4 += $(BUILD)/inc/osdep.h

$(BUILD)/inc/mpr.h: $(DEPS_4)
	@echo '      [Copy] $(BUILD)/inc/mpr.h'
	mkdir -p "$(BUILD)/inc"
	cp src/mpr/mpr.h $(BUILD)/inc/mpr.h

#
#   http.h
#
DEPS_5 += src/http/http.h
DEPS_5 += $(BUILD)/inc/mpr.h

$(BUILD)/inc/http.h: $(DEPS_5)
	@echo '      [Copy] $(BUILD)/inc/http.h'
	mkdir -p "$(BUILD)/inc"
	cp src/http/http.h $(BUILD)/inc/http.h

#
#   customize.h
#

src/customize.h: $(DEPS_6)

#
#   appweb.h
#
DEPS_7 += src/appweb.h
DEPS_7 += $(BUILD)/inc/osdep.h
DEPS_7 += $(BUILD)/inc/mpr.h
DEPS_7 += $(BUILD)/inc/http.h
DEPS_7 += src/customize.h

$(BUILD)/inc/appweb.h: $(DEPS_7)
	@echo '      [Copy] $(BUILD)/inc/appweb.h'
	mkdir -p "$(BUILD)/inc"
	cp src/appweb.h $(BUILD)/inc/appweb.h

#
#   customize.h
#
DEPS_8 += src/customize.h

$(BUILD)/inc/customize.h: $(DEPS_8)
	@echo '      [Copy] $(BUILD)/inc/customize.h'
	mkdir -p "$(BUILD)/inc"
	cp src/customize.h $(BUILD)/inc/customize.h

#
#   esp.h
#
DEPS_9 += src/esp/esp.h
DEPS_9 += $(BUILD)/inc/me.h
DEPS_9 += $(BUILD)/inc/osdep.h
DEPS_9 += $(BUILD)/inc/http.h

$(BUILD)/inc/esp.h: $(DEPS_9)
	@echo '      [Copy] $(BUILD)/inc/esp.h'
	mkdir -p "$(BUILD)/inc"
	cp src/esp/esp.h $(BUILD)/inc/esp.h

#
#   est.h
#
DEPS_10 += src/est/est.h

$(BUILD)/inc/est.h: $(DEPS_10)
	@echo '      [Copy] $(BUILD)/inc/est.h'
	mkdir -p "$(BUILD)/inc"
	cp src/est/est.h $(BUILD)/inc/est.h

#
#   pcre.h
#
DEPS_11 += src/pcre/pcre.h

$(BUILD)/inc/pcre.h: $(DEPS_11)
	@echo '      [Copy] $(BUILD)/inc/pcre.h'
	mkdir -p "$(BUILD)/inc"
	cp src/pcre/pcre.h $(BUILD)/inc/pcre.h

#
#   appweb.o
#
DEPS_12 += $(BUILD)/inc/appweb.h

$(BUILD)/obj/appweb.o: \
    src/server/appweb.c $(DEPS_12)
	@echo '   [Compile] $(BUILD)/obj/appweb.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/appweb.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/server/appweb.c

#
#   authpass.o
#
DEPS_13 += $(BUILD)/inc/appweb.h

$(BUILD)/obj/authpass.o: \
    src/utils/authpass.c $(DEPS_13)
	@echo '   [Compile] $(BUILD)/obj/authpass.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/authpass.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/utils/authpass.c

#
#   appweb.h
#

src/appweb.h: $(DEPS_14)

#
#   cgiHandler.o
#
DEPS_15 += src/appweb.h

$(BUILD)/obj/cgiHandler.o: \
    src/modules/cgiHandler.c $(DEPS_15)
	@echo '   [Compile] $(BUILD)/obj/cgiHandler.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/cgiHandler.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/modules/cgiHandler.c

#
#   cgiProgram.o
#

$(BUILD)/obj/cgiProgram.o: \
    test/cgiProgram.c $(DEPS_16)
	@echo '   [Compile] $(BUILD)/obj/cgiProgram.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/cgiProgram.o $(LDFLAGS) $(IFLAGS) test/cgiProgram.c

#
#   config.o
#
DEPS_17 += src/appweb.h
DEPS_17 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/config.o: \
    src/config.c $(DEPS_17)
	@echo '   [Compile] $(BUILD)/obj/config.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/config.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/config.c

#
#   convenience.o
#
DEPS_18 += src/appweb.h

$(BUILD)/obj/convenience.o: \
    src/convenience.c $(DEPS_18)
	@echo '   [Compile] $(BUILD)/obj/convenience.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/convenience.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/convenience.c

#
#   esp.h
#

src/esp/esp.h: $(DEPS_19)

#
#   esp.o
#
DEPS_20 += src/esp/esp.h

$(BUILD)/obj/esp.o: \
    src/esp/esp.c $(DEPS_20)
	@echo '   [Compile] $(BUILD)/obj/esp.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/esp.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/esp/esp.c

#
#   espHandler.o
#
DEPS_21 += src/appweb.h
DEPS_21 += $(BUILD)/inc/esp.h

$(BUILD)/obj/espHandler.o: \
    src/modules/espHandler.c $(DEPS_21)
	@echo '   [Compile] $(BUILD)/obj/espHandler.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/espHandler.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/modules/espHandler.c

#
#   espLib.o
#
DEPS_22 += src/esp/esp.h
DEPS_22 += $(BUILD)/inc/pcre.h
DEPS_22 += $(BUILD)/inc/http.h

$(BUILD)/obj/espLib.o: \
    src/esp/espLib.c $(DEPS_22)
	@echo '   [Compile] $(BUILD)/obj/espLib.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/espLib.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/esp/espLib.c

#
#   est.o
#
DEPS_23 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/est.o: \
    src/mpr-est/est.c $(DEPS_23)
	@echo '   [Compile] $(BUILD)/obj/est.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/est.o $(LDFLAGS) $(IFLAGS) src/mpr-est/est.c

#
#   est.h
#

src/est/est.h: $(DEPS_24)

#
#   estLib.o
#
DEPS_25 += src/est/est.h

$(BUILD)/obj/estLib.o: \
    src/est/estLib.c $(DEPS_25)
	@echo '   [Compile] $(BUILD)/obj/estLib.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/estLib.o $(LDFLAGS) $(IFLAGS) src/est/estLib.c

#
#   http.h
#

src/http/http.h: $(DEPS_26)

#
#   http.o
#
DEPS_27 += src/http/http.h

$(BUILD)/obj/http.o: \
    src/http/http.c $(DEPS_27)
	@echo '   [Compile] $(BUILD)/obj/http.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/http.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/http/http.c

#
#   httpLib.o
#
DEPS_28 += src/http/http.h
DEPS_28 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/httpLib.o: \
    src/http/httpLib.c $(DEPS_28)
	@echo '   [Compile] $(BUILD)/obj/httpLib.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/httpLib.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/http/httpLib.c

#
#   matrixssl.o
#
DEPS_29 += $(BUILD)/inc/me.h
DEPS_29 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/matrixssl.o: \
    src/mpr-matrixssl/matrixssl.c $(DEPS_29)
	@echo '   [Compile] $(BUILD)/obj/matrixssl.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/matrixssl.o $(LDFLAGS) "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" src/mpr-matrixssl/matrixssl.c

#
#   mbedtls.o
#
DEPS_30 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/mbedtls.o: \
    src/mpr-mbedtls/mbedtls.c $(DEPS_30)
	@echo '   [Compile] $(BUILD)/obj/mbedtls.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/mbedtls.o $(LDFLAGS) "-I$(ME_COM_MBEDTLS_PATH)/include" src/mpr-mbedtls/mbedtls.c

#
#   mpr.h
#

src/mpr/mpr.h: $(DEPS_31)

#
#   mprLib.o
#
DEPS_32 += src/mpr/mpr.h

$(BUILD)/obj/mprLib.o: \
    src/mpr/mprLib.c $(DEPS_32)
	@echo '   [Compile] $(BUILD)/obj/mprLib.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/mprLib.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/mpr/mprLib.c

#
#   nanossl.o
#
DEPS_33 += $(BUILD)/inc/me.h
DEPS_33 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/nanossl.o: \
    src/mpr-nanossl/nanossl.c $(DEPS_33)
	@echo '   [Compile] $(BUILD)/obj/nanossl.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/nanossl.o $(LDFLAGS) "-I$(ME_COM_NANOSSL_PATH)/src" src/mpr-nanossl/nanossl.c

#
#   openssl.o
#
DEPS_34 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/openssl.o: \
    src/mpr-openssl/openssl.c $(DEPS_34)
	@echo '   [Compile] $(BUILD)/obj/openssl.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/openssl.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/mpr-openssl/openssl.c

#
#   pcre.h
#

src/pcre/pcre.h: $(DEPS_35)

#
#   pcre.o
#
DEPS_36 += $(BUILD)/inc/me.h
DEPS_36 += src/pcre/pcre.h

$(BUILD)/obj/pcre.o: \
    src/pcre/pcre.c $(DEPS_36)
	@echo '   [Compile] $(BUILD)/obj/pcre.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/pcre.o $(LDFLAGS) $(IFLAGS) src/pcre/pcre.c

#
#   romFiles.o
#
DEPS_37 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/romFiles.o: \
    src/romFiles.c $(DEPS_37)
	@echo '   [Compile] $(BUILD)/obj/romFiles.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/romFiles.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/romFiles.c

#
#   watchdog.o
#
DEPS_38 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/watchdog.o: \
    src/watchdog/watchdog.c $(DEPS_38)
	@echo '   [Compile] $(BUILD)/obj/watchdog.o'
	$(CC) -c $(DFLAGS) -o $(BUILD)/obj/watchdog.o $(LDFLAGS) -DME_COM_OPENSSL_PATH="$(ME_COM_OPENSSL_PATH)" $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/watchdog/watchdog.c

ifeq ($(ME_COM_SSL),1)
#
#   openssl
#
DEPS_39 += $(BUILD)/obj/openssl.o

$(BUILD)/bin/libmpr-openssl.a: $(DEPS_39)
	@echo '      [Link] $(BUILD)/bin/libmpr-openssl.a'
	ar -cr $(BUILD)/bin/libmpr-openssl.a "$(BUILD)/obj/openssl.o"
endif

ifeq ($(ME_COM_SSL),1)
#
#   mbedtls
#
DEPS_40 += $(BUILD)/obj/mbedtls.o

$(BUILD)/bin/libmpr-mbedtls.a: $(DEPS_40)
	@echo '      [Link] $(BUILD)/bin/libmpr-mbedtls.a'
	ar -cr $(BUILD)/bin/libmpr-mbedtls.a "$(BUILD)/obj/mbedtls.o"
endif

ifeq ($(ME_COM_EST),1)
#
#   libest
#
DEPS_41 += $(BUILD)/inc/osdep.h
DEPS_41 += $(BUILD)/inc/est.h
DEPS_41 += $(BUILD)/obj/estLib.o

$(BUILD)/bin/libest.a: $(DEPS_41)
	@echo '      [Link] $(BUILD)/bin/libest.a'
	ar -cr $(BUILD)/bin/libest.a "$(BUILD)/obj/estLib.o"
endif

ifeq ($(ME_COM_SSL),1)
#
#   est
#
ifeq ($(ME_COM_EST),1)
    DEPS_42 += $(BUILD)/bin/libest.a
endif
DEPS_42 += $(BUILD)/obj/est.o

$(BUILD)/bin/libmpr-estssl.a: $(DEPS_42)
	@echo '      [Link] $(BUILD)/bin/libmpr-estssl.a'
	ar -cr $(BUILD)/bin/libmpr-estssl.a "$(BUILD)/obj/est.o"
endif

ifeq ($(ME_COM_SSL),1)
#
#   matrixssl
#
DEPS_43 += $(BUILD)/obj/matrixssl.o

$(BUILD)/bin/libmpr_matrixssl.a: $(DEPS_43)
	@echo '      [Link] $(BUILD)/bin/libmpr_matrixssl.a'
	ar -cr $(BUILD)/bin/libmpr_matrixssl.a "$(BUILD)/obj/matrixssl.o"
endif

ifeq ($(ME_COM_SSL),1)
#
#   nanossl
#
DEPS_44 += $(BUILD)/obj/nanossl.o

$(BUILD)/bin/libmpr-nanossl.a: $(DEPS_44)
	@echo '      [Link] $(BUILD)/bin/libmpr-nanossl.a'
	ar -cr $(BUILD)/bin/libmpr-nanossl.a "$(BUILD)/obj/nanossl.o"
endif

#
#   libmpr
#
DEPS_45 += $(BUILD)/inc/osdep.h
ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_OPENSSL),1)
    DEPS_45 += $(BUILD)/bin/libmpr-openssl.a
endif
endif
ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_MBEDTLS),1)
    DEPS_45 += $(BUILD)/bin/libmpr-mbedtls.a
endif
endif
ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_EST),1)
    DEPS_45 += $(BUILD)/bin/libmpr-estssl.a
endif
endif
ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_MATRIXSSL),1)
    DEPS_45 += $(BUILD)/bin/libmpr_matrixssl.a
endif
endif
ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_NANOSSL),1)
    DEPS_45 += $(BUILD)/bin/libmpr-nanossl.a
endif
endif
DEPS_45 += $(BUILD)/inc/mpr.h
DEPS_45 += $(BUILD)/obj/mprLib.o

$(BUILD)/bin/libmpr.a: $(DEPS_45)
	@echo '      [Link] $(BUILD)/bin/libmpr.a'
	ar -cr $(BUILD)/bin/libmpr.a "$(BUILD)/obj/mprLib.o"

ifeq ($(ME_COM_PCRE),1)
#
#   libpcre
#
DEPS_46 += $(BUILD)/inc/pcre.h
DEPS_46 += $(BUILD)/obj/pcre.o

$(BUILD)/bin/libpcre.a: $(DEPS_46)
	@echo '      [Link] $(BUILD)/bin/libpcre.a'
	ar -cr $(BUILD)/bin/libpcre.a "$(BUILD)/obj/pcre.o"
endif

ifeq ($(ME_COM_HTTP),1)
#
#   libhttp
#
DEPS_47 += $(BUILD)/bin/libmpr.a
ifeq ($(ME_COM_PCRE),1)
    DEPS_47 += $(BUILD)/bin/libpcre.a
endif
DEPS_47 += $(BUILD)/inc/http.h
DEPS_47 += $(BUILD)/obj/httpLib.o

$(BUILD)/bin/libhttp.a: $(DEPS_47)
	@echo '      [Link] $(BUILD)/bin/libhttp.a'
	ar -cr $(BUILD)/bin/libhttp.a "$(BUILD)/obj/httpLib.o"
endif

ifeq ($(ME_COM_ESP),1)
#
#   libesp
#
ifeq ($(ME_COM_HTTP),1)
    DEPS_48 += $(BUILD)/bin/libhttp.a
endif
DEPS_48 += $(BUILD)/inc/esp.h
DEPS_48 += $(BUILD)/obj/espLib.o

$(BUILD)/bin/libesp.a: $(DEPS_48)
	@echo '      [Link] $(BUILD)/bin/libesp.a'
	ar -cr $(BUILD)/bin/libesp.a "$(BUILD)/obj/espLib.o"
endif

#
#   libappweb
#
ifeq ($(ME_COM_ESP),1)
    DEPS_49 += $(BUILD)/bin/libesp.a
endif
ifeq ($(ME_COM_HTTP),1)
    DEPS_49 += $(BUILD)/bin/libhttp.a
endif
DEPS_49 += $(BUILD)/bin/libmpr.a
DEPS_49 += $(BUILD)/inc/appweb.h
DEPS_49 += $(BUILD)/inc/customize.h
DEPS_49 += $(BUILD)/obj/config.o
DEPS_49 += $(BUILD)/obj/convenience.o
DEPS_49 += $(BUILD)/obj/romFiles.o
DEPS_49 += $(BUILD)/obj/cgiHandler.o
DEPS_49 += $(BUILD)/obj/espHandler.o

$(BUILD)/bin/libappweb.a: $(DEPS_49)
	@echo '      [Link] $(BUILD)/bin/libappweb.a'
	ar -cr $(BUILD)/bin/libappweb.a "$(BUILD)/obj/config.o" "$(BUILD)/obj/convenience.o" "$(BUILD)/obj/romFiles.o" "$(BUILD)/obj/cgiHandler.o" "$(BUILD)/obj/espHandler.o"

#
#   appweb
#
DEPS_50 += $(BUILD)/bin/libappweb.a
DEPS_50 += $(BUILD)/obj/appweb.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_50 += -lmpr-openssl
    LIBPATHS_50 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_50 += -lssl
    LIBPATHS_50 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_50 += -lcrypto
    LIBPATHS_50 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_50 += -lmpr-mbedtls
    LIBPATHS_50 += -L"$(ME_COM_MBEDTLS_PATH)/library"
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_50 += -lpolarssl
    LIBPATHS_50 += -L"$(ME_COM_MBEDTLS_PATH)/library"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_50 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_50 += -lmpr-estssl
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_50 += -lmpr_matrixssl
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_50 += -lcore_s
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_50 += -lcrypt_s
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_50 += -lssl_s
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_50 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_50 += -lmpr-nanossl
    LIBPATHS_50 += -L"$(ME_COM_NANOSSL_PATH)/bin"
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_50 += -lssls
    LIBPATHS_50 += -L"$(ME_COM_NANOSSL_PATH)/bin"
endif
LIBS_50 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_50 += -lmpr-openssl
    LIBPATHS_50 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_50 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_50 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_50 += -lpcre
endif
LIBS_50 += -lmpr
ifeq ($(ME_COM_ESP),1)
    LIBS_50 += -lesp
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_50 += -lhttp
endif
LIBS_50 += -lappweb
ifeq ($(ME_COM_ESP),1)
    LIBS_50 += -lesp
endif

$(BUILD)/bin/appweb: $(DEPS_50)
	@echo '      [Link] $(BUILD)/bin/appweb'
	$(CC) -o $(BUILD)/bin/appweb $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/appweb.o" $(LIBPATHS_50) $(LIBS_50) $(LIBS_50) $(LIBS) $(LIBS) 

#
#   authpass
#
DEPS_51 += $(BUILD)/bin/libappweb.a
DEPS_51 += $(BUILD)/obj/authpass.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_51 += -lmpr-openssl
    LIBPATHS_51 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_51 += -lssl
    LIBPATHS_51 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_51 += -lcrypto
    LIBPATHS_51 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_51 += -lmpr-mbedtls
    LIBPATHS_51 += -L"$(ME_COM_MBEDTLS_PATH)/library"
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_51 += -lpolarssl
    LIBPATHS_51 += -L"$(ME_COM_MBEDTLS_PATH)/library"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_51 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_51 += -lmpr-estssl
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_51 += -lmpr_matrixssl
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_51 += -lcore_s
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_51 += -lcrypt_s
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_51 += -lssl_s
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_51 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_51 += -lmpr-nanossl
    LIBPATHS_51 += -L"$(ME_COM_NANOSSL_PATH)/bin"
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_51 += -lssls
    LIBPATHS_51 += -L"$(ME_COM_NANOSSL_PATH)/bin"
endif
LIBS_51 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_51 += -lmpr-openssl
    LIBPATHS_51 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_51 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_51 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_51 += -lpcre
endif
LIBS_51 += -lmpr
ifeq ($(ME_COM_ESP),1)
    LIBS_51 += -lesp
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_51 += -lhttp
endif
LIBS_51 += -lappweb
ifeq ($(ME_COM_ESP),1)
    LIBS_51 += -lesp
endif

$(BUILD)/bin/authpass: $(DEPS_51)
	@echo '      [Link] $(BUILD)/bin/authpass'
	$(CC) -o $(BUILD)/bin/authpass $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/authpass.o" $(LIBPATHS_51) $(LIBS_51) $(LIBS_51) $(LIBS) $(LIBS) 

ifeq ($(ME_COM_ESP),1)
#
#   esp-compile.json
#
DEPS_52 += src/esp/esp-compile.json

$(BUILD)/bin/esp-compile.json: $(DEPS_52)
	@echo '      [Copy] $(BUILD)/bin/esp-compile.json'
	mkdir -p "$(BUILD)/bin"
	cp src/esp/esp-compile.json $(BUILD)/bin/esp-compile.json
endif

ifeq ($(ME_COM_ESP),1)
#
#   espcmd
#
DEPS_53 += $(BUILD)/bin/libesp.a
DEPS_53 += $(BUILD)/obj/esp.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_53 += -lmpr-openssl
    LIBPATHS_53 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_53 += -lssl
    LIBPATHS_53 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_53 += -lcrypto
    LIBPATHS_53 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_53 += -lmpr-mbedtls
    LIBPATHS_53 += -L"$(ME_COM_MBEDTLS_PATH)/library"
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_53 += -lpolarssl
    LIBPATHS_53 += -L"$(ME_COM_MBEDTLS_PATH)/library"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_53 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_53 += -lmpr-estssl
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_53 += -lmpr_matrixssl
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_53 += -lcore_s
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_53 += -lcrypt_s
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_53 += -lssl_s
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_53 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_53 += -lmpr-nanossl
    LIBPATHS_53 += -L"$(ME_COM_NANOSSL_PATH)/bin"
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_53 += -lssls
    LIBPATHS_53 += -L"$(ME_COM_NANOSSL_PATH)/bin"
endif
LIBS_53 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_53 += -lmpr-openssl
    LIBPATHS_53 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_53 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_53 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_53 += -lpcre
endif
LIBS_53 += -lmpr
LIBS_53 += -lesp
ifeq ($(ME_COM_HTTP),1)
    LIBS_53 += -lhttp
endif

$(BUILD)/bin/esp: $(DEPS_53)
	@echo '      [Link] $(BUILD)/bin/esp'
	$(CC) -o $(BUILD)/bin/esp $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/esp.o" $(LIBPATHS_53) $(LIBS_53) $(LIBS_53) $(LIBS) $(LIBS) 
endif

ifeq ($(ME_COM_HTTP),1)
#
#   httpcmd
#
DEPS_54 += $(BUILD)/bin/libhttp.a
DEPS_54 += $(BUILD)/obj/http.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_54 += -lmpr-openssl
    LIBPATHS_54 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_54 += -lssl
    LIBPATHS_54 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_54 += -lcrypto
    LIBPATHS_54 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_54 += -lmpr-mbedtls
    LIBPATHS_54 += -L"$(ME_COM_MBEDTLS_PATH)/library"
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_54 += -lpolarssl
    LIBPATHS_54 += -L"$(ME_COM_MBEDTLS_PATH)/library"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_54 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_54 += -lmpr-estssl
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_54 += -lmpr_matrixssl
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_54 += -lcore_s
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_54 += -lcrypt_s
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_54 += -lssl_s
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_54 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_54 += -lmpr-nanossl
    LIBPATHS_54 += -L"$(ME_COM_NANOSSL_PATH)/bin"
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_54 += -lssls
    LIBPATHS_54 += -L"$(ME_COM_NANOSSL_PATH)/bin"
endif
LIBS_54 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_54 += -lmpr-openssl
    LIBPATHS_54 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_54 += -lpcre
endif
LIBS_54 += -lhttp
ifeq ($(ME_COM_PCRE),1)
    LIBS_54 += -lpcre
endif
LIBS_54 += -lmpr

$(BUILD)/bin/http: $(DEPS_54)
	@echo '      [Link] $(BUILD)/bin/http'
	$(CC) -o $(BUILD)/bin/http $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/http.o" $(LIBPATHS_54) $(LIBS_54) $(LIBS_54) $(LIBS) $(LIBS) 
endif

ifeq ($(ME_COM_SSL),1)
#
#   install-certs
#
DEPS_55 += src/certs/samples/ca.crt
DEPS_55 += src/certs/samples/ca.key
DEPS_55 += src/certs/samples/dh.pem
DEPS_55 += src/certs/samples/ec.crt
DEPS_55 += src/certs/samples/ec.key
DEPS_55 += src/certs/samples/roots.crt
DEPS_55 += src/certs/samples/self.crt
DEPS_55 += src/certs/samples/self.key
DEPS_55 += src/certs/samples/test.crt
DEPS_55 += src/certs/samples/test.key

$(BUILD)/bin: $(DEPS_55)
	@echo '      [Copy] $(BUILD)/bin'
	mkdir -p "$(BUILD)/bin"
	cp src/certs/samples/ca.crt $(BUILD)/bin/ca.crt
	cp src/certs/samples/ca.key $(BUILD)/bin/ca.key
	cp src/certs/samples/dh.pem $(BUILD)/bin/dh.pem
	cp src/certs/samples/ec.crt $(BUILD)/bin/ec.crt
	cp src/certs/samples/ec.key $(BUILD)/bin/ec.key
	cp src/certs/samples/roots.crt $(BUILD)/bin/roots.crt
	cp src/certs/samples/self.crt $(BUILD)/bin/self.crt
	cp src/certs/samples/self.key $(BUILD)/bin/self.key
	cp src/certs/samples/test.crt $(BUILD)/bin/test.crt
	cp src/certs/samples/test.key $(BUILD)/bin/test.key
endif

#
#   server-cache
#

src/server/cache: $(DEPS_56)
	( \
	cd src/server; \
	mkdir -p "cache" ; \
	)

#
#   watchdog
#
DEPS_57 += $(BUILD)/bin/libmpr.a
DEPS_57 += $(BUILD)/obj/watchdog.o

ifeq ($(ME_COM_OPENSSL),1)
    LIBS_57 += -lmpr-openssl
    LIBPATHS_57 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_57 += -lssl
    LIBPATHS_57 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_57 += -lcrypto
    LIBPATHS_57 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_57 += -lmpr-mbedtls
    LIBPATHS_57 += -L"$(ME_COM_MBEDTLS_PATH)/library"
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_57 += -lpolarssl
    LIBPATHS_57 += -L"$(ME_COM_MBEDTLS_PATH)/library"
endif
ifeq ($(ME_COM_EST),1)
    LIBS_57 += -lest
endif
ifeq ($(ME_COM_EST),1)
    LIBS_57 += -lmpr-estssl
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_57 += -lmpr_matrixssl
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_57 += -lcore_s
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_57 += -lcrypt_s
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_57 += -lssl_s
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/matrixssl"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/core"
    LIBPATHS_57 += -L"$(ME_COM_MATRIXSSL_PATH)/crypto"
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_57 += -lmpr-nanossl
    LIBPATHS_57 += -L"$(ME_COM_NANOSSL_PATH)/bin"
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_57 += -lssls
    LIBPATHS_57 += -L"$(ME_COM_NANOSSL_PATH)/bin"
endif
LIBS_57 += -lmpr
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_57 += -lmpr-openssl
    LIBPATHS_57 += -L"$(ME_COM_OPENSSL_PATH)"
endif

$(BUILD)/bin/appman: $(DEPS_57)
	@echo '      [Link] $(BUILD)/bin/appman'
	$(CC) -o $(BUILD)/bin/appman $(LDFLAGS) $(LIBPATHS)  "$(BUILD)/obj/watchdog.o" $(LIBPATHS_57) $(LIBS_57) $(LIBS_57) $(LIBS) $(LIBS) 

#
#   stop
#

stop: $(DEPS_58)
	@./$(BUILD)/bin/appman stop disable uninstall >/dev/null 2>&1 ; true

#
#   installBinary
#

installBinary: $(DEPS_59)
	mkdir -p "$(ME_APP_PREFIX)" ; \
	rm -f "$(ME_APP_PREFIX)/latest" ; \
	ln -s "$(VERSION)" "$(ME_APP_PREFIX)/latest" ; \
	mkdir -p "$(ME_LOG_PREFIX)" ; \
	chmod 755 "$(ME_LOG_PREFIX)" ; \
	[ `id -u` = 0 ] && chown $(WEB_USER):$(WEB_GROUP) "$(ME_LOG_PREFIX)"; true ; \
	mkdir -p "$(ME_CACHE_PREFIX)" ; \
	chmod 755 "$(ME_CACHE_PREFIX)" ; \
	[ `id -u` = 0 ] && chown $(WEB_USER):$(WEB_GROUP) "$(ME_CACHE_PREFIX)"; true ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/appweb $(ME_VAPP_PREFIX)/bin/appweb ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/appweb" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/appweb" "$(ME_BIN_PREFIX)/appweb" ; \
	if [ "$(ME_COM_SSL)" = 1 ]; then true ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/roots.crt $(ME_VAPP_PREFIX)/bin/roots.crt ; \
	fi ; \
	mkdir -p "$(ME_ETC_PREFIX)" ; \
	cp src/server/mime.types $(ME_ETC_PREFIX)/mime.types ; \
	mkdir -p "$(ME_ETC_PREFIX)" ; \
	cp src/server/appweb.conf $(ME_ETC_PREFIX)/appweb.conf ; \
	mkdir -p "$(ME_ETC_PREFIX)" ; \
	cp src/server/sample.conf $(ME_ETC_PREFIX)/sample.conf ; \
	echo 'set LOG_DIR "$(ME_LOG_PREFIX)"\nset CACHE_DIR "$(ME_CACHE_PREFIX)"\nDocuments "$(ME_WEB_PREFIX)\nListen 80\n<if SSL_MODULE>\nListenSecure 443\n</if>\n' >$(ME_ETC_PREFIX)/install.conf ; \
	mkdir -p "$(ME_WEB_PREFIX)" ; \
	mkdir -p "$(ME_WEB_PREFIX)/bench" ; \
	cp src/server/web/bench/1b.html $(ME_WEB_PREFIX)/bench/1b.html ; \
	cp src/server/web/bench/4k.html $(ME_WEB_PREFIX)/bench/4k.html ; \
	cp src/server/web/bench/64k.html $(ME_WEB_PREFIX)/bench/64k.html ; \
	cp src/server/web/favicon.ico $(ME_WEB_PREFIX)/favicon.ico ; \
	mkdir -p "$(ME_WEB_PREFIX)/icons" ; \
	cp src/server/web/icons/back.gif $(ME_WEB_PREFIX)/icons/back.gif ; \
	cp src/server/web/icons/blank.gif $(ME_WEB_PREFIX)/icons/blank.gif ; \
	cp src/server/web/icons/compressed.gif $(ME_WEB_PREFIX)/icons/compressed.gif ; \
	cp src/server/web/icons/folder.gif $(ME_WEB_PREFIX)/icons/folder.gif ; \
	cp src/server/web/icons/parent.gif $(ME_WEB_PREFIX)/icons/parent.gif ; \
	cp src/server/web/icons/space.gif $(ME_WEB_PREFIX)/icons/space.gif ; \
	cp src/server/web/icons/text.gif $(ME_WEB_PREFIX)/icons/text.gif ; \
	cp src/server/web/iehacks.css $(ME_WEB_PREFIX)/iehacks.css ; \
	mkdir -p "$(ME_WEB_PREFIX)/images" ; \
	cp src/server/web/images/banner.jpg $(ME_WEB_PREFIX)/images/banner.jpg ; \
	cp src/server/web/images/bottomShadow.jpg $(ME_WEB_PREFIX)/images/bottomShadow.jpg ; \
	cp src/server/web/images/shadow.jpg $(ME_WEB_PREFIX)/images/shadow.jpg ; \
	cp src/server/web/index.html $(ME_WEB_PREFIX)/index.html ; \
	cp src/server/web/min-index.html $(ME_WEB_PREFIX)/min-index.html ; \
	cp src/server/web/print.css $(ME_WEB_PREFIX)/print.css ; \
	cp src/server/web/screen.css $(ME_WEB_PREFIX)/screen.css ; \
	mkdir -p "$(ME_WEB_PREFIX)/test" ; \
	cp src/server/web/test/bench.html $(ME_WEB_PREFIX)/test/bench.html ; \
	cp src/server/web/test/test.cgi $(ME_WEB_PREFIX)/test/test.cgi ; \
	cp src/server/web/test/test.ejs $(ME_WEB_PREFIX)/test/test.ejs ; \
	cp src/server/web/test/test.esp $(ME_WEB_PREFIX)/test/test.esp ; \
	cp src/server/web/test/test.html $(ME_WEB_PREFIX)/test/test.html ; \
	cp src/server/web/test/test.php $(ME_WEB_PREFIX)/test/test.php ; \
	cp src/server/web/test/test.pl $(ME_WEB_PREFIX)/test/test.pl ; \
	cp src/server/web/test/test.py $(ME_WEB_PREFIX)/test/test.py ; \
	mkdir -p "$(ME_WEB_PREFIX)/test" ; \
	cp src/server/web/test/test.cgi $(ME_WEB_PREFIX)/test/test.cgi ; \
	chmod 755 "$(ME_WEB_PREFIX)/test/test.cgi" ; \
	cp src/server/web/test/test.pl $(ME_WEB_PREFIX)/test/test.pl ; \
	chmod 755 "$(ME_WEB_PREFIX)/test/test.pl" ; \
	cp src/server/web/test/test.py $(ME_WEB_PREFIX)/test/test.py ; \
	chmod 755 "$(ME_WEB_PREFIX)/test/test.py" ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/appman $(ME_VAPP_PREFIX)/bin/appman ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/appman" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/appman" "$(ME_BIN_PREFIX)/appman" ; \
	mkdir -p "$(ME_ROOT_PREFIX)/etc/init.d" ; \
	cp installs/linux/appweb.init $(ME_ROOT_PREFIX)/etc/init.d/appweb ; \
	chmod 755 "$(ME_ROOT_PREFIX)/etc/init.d/appweb" ; \
	if [ "$(ME_COM_ESP)" = 1 ]; then true ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/esp $(ME_VAPP_PREFIX)/bin/appesp ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/appesp" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/appesp" "$(ME_BIN_PREFIX)/appesp" ; \
	fi ; \
	if [ "$(ME_COM_ESP)" = 1 ]; then true ; \
	fi ; \
	if [ "$(ME_COM_ESP)" = 1 ]; then true ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/esp-compile.json $(ME_VAPP_PREFIX)/bin/esp-compile.json ; \
	fi ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/http $(ME_VAPP_PREFIX)/bin/http ; \
	mkdir -p "$(ME_VAPP_PREFIX)/inc" ; \
	cp $(BUILD)/inc/me.h $(ME_VAPP_PREFIX)/inc/me.h ; \
	mkdir -p "$(ME_INC_PREFIX)/appweb" ; \
	rm -f "$(ME_INC_PREFIX)/appweb/me.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/me.h" "$(ME_INC_PREFIX)/appweb/me.h" ; \
	cp src/osdep/osdep.h $(ME_VAPP_PREFIX)/inc/osdep.h ; \
	mkdir -p "$(ME_INC_PREFIX)/appweb" ; \
	rm -f "$(ME_INC_PREFIX)/appweb/osdep.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/osdep.h" "$(ME_INC_PREFIX)/appweb/osdep.h" ; \
	cp src/appweb.h $(ME_VAPP_PREFIX)/inc/appweb.h ; \
	mkdir -p "$(ME_INC_PREFIX)/appweb" ; \
	rm -f "$(ME_INC_PREFIX)/appweb/appweb.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/appweb.h" "$(ME_INC_PREFIX)/appweb/appweb.h" ; \
	cp src/customize.h $(ME_VAPP_PREFIX)/inc/customize.h ; \
	mkdir -p "$(ME_INC_PREFIX)/appweb" ; \
	rm -f "$(ME_INC_PREFIX)/appweb/customize.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/customize.h" "$(ME_INC_PREFIX)/appweb/customize.h" ; \
	cp src/est/est.h $(ME_VAPP_PREFIX)/inc/est.h ; \
	mkdir -p "$(ME_INC_PREFIX)/appweb" ; \
	rm -f "$(ME_INC_PREFIX)/appweb/est.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/est.h" "$(ME_INC_PREFIX)/appweb/est.h" ; \
	cp src/http/http.h $(ME_VAPP_PREFIX)/inc/http.h ; \
	mkdir -p "$(ME_INC_PREFIX)/appweb" ; \
	rm -f "$(ME_INC_PREFIX)/appweb/http.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/http.h" "$(ME_INC_PREFIX)/appweb/http.h" ; \
	cp src/mpr/mpr.h $(ME_VAPP_PREFIX)/inc/mpr.h ; \
	mkdir -p "$(ME_INC_PREFIX)/appweb" ; \
	rm -f "$(ME_INC_PREFIX)/appweb/mpr.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/mpr.h" "$(ME_INC_PREFIX)/appweb/mpr.h" ; \
	cp src/pcre/pcre.h $(ME_VAPP_PREFIX)/inc/pcre.h ; \
	mkdir -p "$(ME_INC_PREFIX)/appweb" ; \
	rm -f "$(ME_INC_PREFIX)/appweb/pcre.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/pcre.h" "$(ME_INC_PREFIX)/appweb/pcre.h" ; \
	if [ "$(ME_COM_ESP)" = 1 ]; then true ; \
	mkdir -p "$(ME_VAPP_PREFIX)/inc" ; \
	cp src/esp/esp.h $(ME_VAPP_PREFIX)/inc/esp.h ; \
	mkdir -p "$(ME_INC_PREFIX)/appweb" ; \
	rm -f "$(ME_INC_PREFIX)/appweb/esp.h" ; \
	ln -s "$(ME_VAPP_PREFIX)/inc/esp.h" "$(ME_INC_PREFIX)/appweb/esp.h" ; \
	fi ; \
	mkdir -p "$(ME_VAPP_PREFIX)/doc/man1" ; \
	cp doc/dist/man/appman.1 $(ME_VAPP_PREFIX)/doc/man1/appman.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/appman.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/appman.1" "$(ME_MAN_PREFIX)/man1/appman.1" ; \
	cp doc/dist/man/appweb.1 $(ME_VAPP_PREFIX)/doc/man1/appweb.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/appweb.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/appweb.1" "$(ME_MAN_PREFIX)/man1/appweb.1" ; \
	cp doc/dist/man/appwebMonitor.1 $(ME_VAPP_PREFIX)/doc/man1/appwebMonitor.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/appwebMonitor.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/appwebMonitor.1" "$(ME_MAN_PREFIX)/man1/appwebMonitor.1" ; \
	cp doc/dist/man/authpass.1 $(ME_VAPP_PREFIX)/doc/man1/authpass.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/authpass.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/authpass.1" "$(ME_MAN_PREFIX)/man1/authpass.1" ; \
	cp doc/dist/man/esp.1 $(ME_VAPP_PREFIX)/doc/man1/esp.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/esp.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/esp.1" "$(ME_MAN_PREFIX)/man1/esp.1" ; \
	cp doc/dist/man/http.1 $(ME_VAPP_PREFIX)/doc/man1/http.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/http.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man1/http.1" "$(ME_MAN_PREFIX)/man1/http.1"

#
#   start
#
DEPS_60 += stop

start: $(DEPS_60)
	./$(BUILD)/bin/appman install enable start

#
#   install
#
DEPS_61 += stop
DEPS_61 += installBinary
DEPS_61 += start

install: $(DEPS_61)

#
#   installPrep
#

installPrep: $(DEPS_62)
	if [ "`id -u`" != 0 ] ; \
	then echo "Must run as root. Rerun with "sudo"" ; \
	exit 255 ; \
	fi

#
#   run
#

run: $(DEPS_63)
	( \
	cd src/server; \
	../../$(BUILD)/bin/appweb --log stdout:2 ; \
	)

#
#   uninstall
#
DEPS_64 += stop

uninstall: $(DEPS_64)
	( \
	cd installs; \
	rm -fr "$(ME_WEB_PREFIX)" ; \
	rm -fr "$(ME_SPOOL_PREFIX)" ; \
	rm -fr "$(ME_CACHE_PREFIX)" ; \
	rm -fr "$(ME_LOG_PREFIX)" ; \
	rm -fr "$(ME_VAPP_PREFIX)" ; \
	rmdir -p "$(ME_ETC_PREFIX)" 2>/dev/null ; true ; \
	rmdir -p "$(ME_WEB_PREFIX)" 2>/dev/null ; true ; \
	rmdir -p "$(ME_LOG_PREFIX)" 2>/dev/null ; true ; \
	rmdir -p "$(ME_SPOOL_PREFIX)" 2>/dev/null ; true ; \
	rmdir -p "$(ME_CACHE_PREFIX)" 2>/dev/null ; true ; \
	rm -f "$(ME_APP_PREFIX)/latest" ; \
	rmdir -p "$(ME_APP_PREFIX)" 2>/dev/null ; true ; \
	rm -f "$(ME_ETC_PREFIX)/appweb.conf" ; \
	rm -f "$(ME_ETC_PREFIX)/esp.conf" ; \
	rm -f "$(ME_ETC_PREFIX)/mine.types" ; \
	rm -f "$(ME_ETC_PREFIX)/install.conf" ; \
	rm -fr "$(ME_INC_PREFIX)/appweb" ; \
	)

#
#   version
#

version: $(DEPS_65)
	echo $(VERSION)

