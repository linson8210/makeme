#
#   makeme-freebsd-default.mk -- Makefile to build Embedthis MakeMe for freebsd
#

NAME                  := makeme
VERSION               := 0.9.1
PROFILE               ?= default
ARCH                  ?= $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
CC_ARCH               ?= $(shell echo $(ARCH) | sed 's/x86/i686/;s/x64/x86_64/')
OS                    ?= freebsd
CC                    ?= gcc
CONFIG                ?= $(OS)-$(ARCH)-$(PROFILE)
BUILD                 ?= build/$(CONFIG)
LBIN                  ?= $(BUILD)/bin
PATH                  := $(LBIN):$(PATH)

ME_COM_COMPILER       ?= 1
ME_COM_EJSCRIPT       ?= 1
ME_COM_HTTP           ?= 1
ME_COM_LIB            ?= 1
ME_COM_MATRIXSSL      ?= 0
ME_COM_MBEDTLS        ?= 1
ME_COM_MPR            ?= 1
ME_COM_NANOSSL        ?= 0
ME_COM_OPENSSL        ?= 0
ME_COM_OSDEP          ?= 1
ME_COM_PCRE           ?= 1
ME_COM_SSL            ?= 1
ME_COM_VXWORKS        ?= 0
ME_COM_WINSDK         ?= 1
ME_COM_ZLIB           ?= 1

ME_COM_OPENSSL_PATH   ?= "/usr/lib"

ifeq ($(ME_COM_LIB),1)
    ME_COM_COMPILER := 1
endif
ifeq ($(ME_COM_MBEDTLS),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_OPENSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_EJSCRIPT),1)
    ME_COM_ZLIB := 1
endif

CFLAGS                += -fPIC -w
DFLAGS                += -D_REENTRANT -DPIC $(patsubst %,-D%,$(filter ME_%,$(MAKEFLAGS))) -DME_COM_COMPILER=$(ME_COM_COMPILER) -DME_COM_EJSCRIPT=$(ME_COM_EJSCRIPT) -DME_COM_HTTP=$(ME_COM_HTTP) -DME_COM_LIB=$(ME_COM_LIB) -DME_COM_MATRIXSSL=$(ME_COM_MATRIXSSL) -DME_COM_MBEDTLS=$(ME_COM_MBEDTLS) -DME_COM_MPR=$(ME_COM_MPR) -DME_COM_NANOSSL=$(ME_COM_NANOSSL) -DME_COM_OPENSSL=$(ME_COM_OPENSSL) -DME_COM_OSDEP=$(ME_COM_OSDEP) -DME_COM_PCRE=$(ME_COM_PCRE) -DME_COM_SSL=$(ME_COM_SSL) -DME_COM_VXWORKS=$(ME_COM_VXWORKS) -DME_COM_WINSDK=$(ME_COM_WINSDK) -DME_COM_ZLIB=$(ME_COM_ZLIB) 
IFLAGS                += "-I$(BUILD)/inc"
LDFLAGS               += 
LIBPATHS              += -L$(BUILD)/bin
LIBS                  += -ldl -lpthread -lm

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


ifeq ($(ME_COM_EJSCRIPT),1)
    TARGETS           += $(BUILD)/bin/ejs.mod
endif
TARGETS               += $(BUILD)/bin/ejs.testme.es
TARGETS               += $(BUILD)/bin/ejs.testme.mod
ifeq ($(ME_COM_EJSCRIPT),1)
    TARGETS           += $(BUILD)/bin/makeme-ejs
endif
TARGETS               += $(BUILD)/.extras-modified
ifeq ($(ME_COM_HTTP),1)
    TARGETS           += $(BUILD)/bin/http
endif
TARGETS               += $(BUILD)/.install-certs-modified
TARGETS               += $(BUILD)/bin/libtestme.so
TARGETS               += $(BUILD)/bin/me
TARGETS               += $(BUILD)/bin/testme
TARGETS               += $(BUILD)/bin/testme.es

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
	@[ ! -f $(BUILD)/inc/me.h ] && cp projects/makeme-freebsd-default-me.h $(BUILD)/inc/me.h ; true
	@if ! diff $(BUILD)/inc/me.h projects/makeme-freebsd-default-me.h >/dev/null ; then\
		cp projects/makeme-freebsd-default-me.h $(BUILD)/inc/me.h  ; \
	fi; true
	@if [ -f "$(BUILD)/.makeflags" ] ; then \
		if [ "$(MAKEFLAGS)" != "`cat $(BUILD)/.makeflags`" ] ; then \
			echo "   [Warning] Make flags have changed since the last build" ; \
			echo "   [Warning] Previous build command: "`cat $(BUILD)/.makeflags`"" ; \
		fi ; \
	fi
	@echo "$(MAKEFLAGS)" >$(BUILD)/.makeflags

clean:
	rm -f "$(BUILD)/obj/ejs.o"
	rm -f "$(BUILD)/obj/ejsLib.o"
	rm -f "$(BUILD)/obj/ejsc.o"
	rm -f "$(BUILD)/obj/http.o"
	rm -f "$(BUILD)/obj/httpLib.o"
	rm -f "$(BUILD)/obj/libtestme.o"
	rm -f "$(BUILD)/obj/mbedtls.o"
	rm -f "$(BUILD)/obj/mbedtlsLib.o"
	rm -f "$(BUILD)/obj/me.o"
	rm -f "$(BUILD)/obj/mprLib.o"
	rm -f "$(BUILD)/obj/openssl.o"
	rm -f "$(BUILD)/obj/pcre.o"
	rm -f "$(BUILD)/obj/testme.o"
	rm -f "$(BUILD)/obj/zlib.o"
	rm -f "$(BUILD)/bin/ejs.testme.es"
	rm -f "$(BUILD)/bin/makeme-ejsc"
	rm -f "$(BUILD)/bin/makeme-ejs"
	rm -f "$(BUILD)/bin/http"
	rm -f "$(BUILD)/.install-certs-modified"
	rm -f "$(BUILD)/bin/libejs.so"
	rm -f "$(BUILD)/bin/libhttp.so"
	rm -f "$(BUILD)/bin/libmbedtls.a"
	rm -f "$(BUILD)/bin/libmpr.so"
	rm -f "$(BUILD)/bin/libpcre.so"
	rm -f "$(BUILD)/bin/libtestme.so"
	rm -f "$(BUILD)/bin/libzlib.so"
	rm -f "$(BUILD)/bin/libmpr-mbedtls.a"
	rm -f "$(BUILD)/bin/testme"
	rm -f "$(BUILD)/bin/testme.es"

clobber: clean
	rm -fr ./$(BUILD)

#
#   me.h
#

$(BUILD)/inc/me.h: $(DEPS_1)

#
#   osdep.h
#
DEPS_2 += src/osdep/osdep.h
DEPS_2 += $(BUILD)/inc/me.h

$(BUILD)/inc/osdep.h: $(DEPS_2)
	@echo '      [Copy] $(BUILD)/inc/osdep.h'
	mkdir -p "$(BUILD)/inc"
	cp src/osdep/osdep.h $(BUILD)/inc/osdep.h

#
#   mpr.h
#
DEPS_3 += src/mpr/mpr.h
DEPS_3 += $(BUILD)/inc/me.h
DEPS_3 += $(BUILD)/inc/osdep.h

$(BUILD)/inc/mpr.h: $(DEPS_3)
	@echo '      [Copy] $(BUILD)/inc/mpr.h'
	mkdir -p "$(BUILD)/inc"
	cp src/mpr/mpr.h $(BUILD)/inc/mpr.h

#
#   http.h
#
DEPS_4 += src/http/http.h
DEPS_4 += $(BUILD)/inc/mpr.h

$(BUILD)/inc/http.h: $(DEPS_4)
	@echo '      [Copy] $(BUILD)/inc/http.h'
	mkdir -p "$(BUILD)/inc"
	cp src/http/http.h $(BUILD)/inc/http.h

#
#   ejs.slots.h
#

src/ejscript/ejs.slots.h: $(DEPS_5)

#
#   pcre.h
#
DEPS_6 += src/pcre/pcre.h

$(BUILD)/inc/pcre.h: $(DEPS_6)
	@echo '      [Copy] $(BUILD)/inc/pcre.h'
	mkdir -p "$(BUILD)/inc"
	cp src/pcre/pcre.h $(BUILD)/inc/pcre.h

#
#   zlib.h
#
DEPS_7 += src/zlib/zlib.h
DEPS_7 += $(BUILD)/inc/me.h

$(BUILD)/inc/zlib.h: $(DEPS_7)
	@echo '      [Copy] $(BUILD)/inc/zlib.h'
	mkdir -p "$(BUILD)/inc"
	cp src/zlib/zlib.h $(BUILD)/inc/zlib.h

#
#   ejs.h
#
DEPS_8 += src/ejscript/ejs.h
DEPS_8 += $(BUILD)/inc/me.h
DEPS_8 += $(BUILD)/inc/osdep.h
DEPS_8 += $(BUILD)/inc/mpr.h
DEPS_8 += $(BUILD)/inc/http.h
DEPS_8 += src/ejscript/ejs.slots.h
DEPS_8 += $(BUILD)/inc/pcre.h
DEPS_8 += $(BUILD)/inc/zlib.h

$(BUILD)/inc/ejs.h: $(DEPS_8)
	@echo '      [Copy] $(BUILD)/inc/ejs.h'
	mkdir -p "$(BUILD)/inc"
	cp src/ejscript/ejs.h $(BUILD)/inc/ejs.h

#
#   ejs.slots.h
#
DEPS_9 += src/ejscript/ejs.slots.h

$(BUILD)/inc/ejs.slots.h: $(DEPS_9)
	@echo '      [Copy] $(BUILD)/inc/ejs.slots.h'
	mkdir -p "$(BUILD)/inc"
	cp src/ejscript/ejs.slots.h $(BUILD)/inc/ejs.slots.h

#
#   ejsByteGoto.h
#
DEPS_10 += src/ejscript/ejsByteGoto.h

$(BUILD)/inc/ejsByteGoto.h: $(DEPS_10)
	@echo '      [Copy] $(BUILD)/inc/ejsByteGoto.h'
	mkdir -p "$(BUILD)/inc"
	cp src/ejscript/ejsByteGoto.h $(BUILD)/inc/ejsByteGoto.h

#
#   mbedtls.h
#
DEPS_11 += src/mbedtls/mbedtls.h

$(BUILD)/inc/mbedtls.h: $(DEPS_11)
	@echo '      [Copy] $(BUILD)/inc/mbedtls.h'
	mkdir -p "$(BUILD)/inc"
	cp src/mbedtls/mbedtls.h $(BUILD)/inc/mbedtls.h

#
#   testme.h
#
DEPS_12 += src/tm/testme.h

$(BUILD)/inc/testme.h: $(DEPS_12)
	@echo '      [Copy] $(BUILD)/inc/testme.h'
	mkdir -p "$(BUILD)/inc"
	cp src/tm/testme.h $(BUILD)/inc/testme.h

#
#   ejs.h
#

src/ejscript/ejs.h: $(DEPS_13)

#
#   ejs.o
#
DEPS_14 += src/ejscript/ejs.h

$(BUILD)/obj/ejs.o: \
    src/ejscript/ejs.c $(DEPS_14)
	@echo '   [Compile] $(BUILD)/obj/ejs.o'
	$(CC) -c -o $(BUILD)/obj/ejs.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -D_FILE_OFFSET_BITS=64 $(IFLAGS) src/ejscript/ejs.c

#
#   ejsLib.o
#
DEPS_15 += src/ejscript/ejs.h
DEPS_15 += $(BUILD)/inc/mpr.h
DEPS_15 += $(BUILD)/inc/pcre.h
DEPS_15 += $(BUILD)/inc/me.h

$(BUILD)/obj/ejsLib.o: \
    src/ejscript/ejsLib.c $(DEPS_15)
	@echo '   [Compile] $(BUILD)/obj/ejsLib.o'
	$(CC) -c -o $(BUILD)/obj/ejsLib.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -D_FILE_OFFSET_BITS=64 $(IFLAGS) src/ejscript/ejsLib.c

#
#   ejsc.o
#
DEPS_16 += src/ejscript/ejs.h

$(BUILD)/obj/ejsc.o: \
    src/ejscript/ejsc.c $(DEPS_16)
	@echo '   [Compile] $(BUILD)/obj/ejsc.o'
	$(CC) -c -o $(BUILD)/obj/ejsc.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -D_FILE_OFFSET_BITS=64 $(IFLAGS) src/ejscript/ejsc.c

#
#   http.h
#

src/http/http.h: $(DEPS_17)

#
#   http.o
#
DEPS_18 += src/http/http.h

$(BUILD)/obj/http.o: \
    src/http/http.c $(DEPS_18)
	@echo '   [Compile] $(BUILD)/obj/http.o'
	$(CC) -c -o $(BUILD)/obj/http.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -D_FILE_OFFSET_BITS=64 $(IFLAGS) src/http/http.c

#
#   httpLib.o
#
DEPS_19 += src/http/http.h
DEPS_19 += $(BUILD)/inc/pcre.h

$(BUILD)/obj/httpLib.o: \
    src/http/httpLib.c $(DEPS_19)
	@echo '   [Compile] $(BUILD)/obj/httpLib.o'
	$(CC) -c -o $(BUILD)/obj/httpLib.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -D_FILE_OFFSET_BITS=64 $(IFLAGS) src/http/httpLib.c

#
#   testme.h
#

src/tm/testme.h: $(DEPS_20)

#
#   libtestme.o
#
DEPS_21 += src/tm/testme.h

$(BUILD)/obj/libtestme.o: \
    src/tm/libtestme.c $(DEPS_21)
	@echo '   [Compile] $(BUILD)/obj/libtestme.o'
	$(CC) -c -o $(BUILD)/obj/libtestme.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) $(IFLAGS) src/tm/libtestme.c

#
#   mbedtls.o
#
DEPS_22 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/mbedtls.o: \
    src/mpr-mbedtls/mbedtls.c $(DEPS_22)
	@echo '   [Compile] $(BUILD)/obj/mbedtls.o'
	$(CC) -c -o $(BUILD)/obj/mbedtls.o $(LDFLAGS) $(CFLAGS) -D_FILE_OFFSET_BITS=64 $(DFLAGS) $(IFLAGS) src/mpr-mbedtls/mbedtls.c

#
#   mbedtls.h
#

src/mbedtls/mbedtls.h: $(DEPS_23)

#
#   mbedtlsLib.o
#
DEPS_24 += src/mbedtls/mbedtls.h

$(BUILD)/obj/mbedtlsLib.o: \
    src/mbedtls/mbedtlsLib.c $(DEPS_24)
	@echo '   [Compile] $(BUILD)/obj/mbedtlsLib.o'
	$(CC) -c -o $(BUILD)/obj/mbedtlsLib.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) $(IFLAGS) src/mbedtls/mbedtlsLib.c

#
#   me.o
#
DEPS_25 += $(BUILD)/inc/ejs.h

$(BUILD)/obj/me.o: \
    src/me.c $(DEPS_25)
	@echo '   [Compile] $(BUILD)/obj/me.o'
	$(CC) -c -o $(BUILD)/obj/me.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -D_FILE_OFFSET_BITS=64 $(IFLAGS) src/me.c

#
#   mpr.h
#

src/mpr/mpr.h: $(DEPS_26)

#
#   mprLib.o
#
DEPS_27 += src/mpr/mpr.h

$(BUILD)/obj/mprLib.o: \
    src/mpr/mprLib.c $(DEPS_27)
	@echo '   [Compile] $(BUILD)/obj/mprLib.o'
	$(CC) -c -o $(BUILD)/obj/mprLib.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -D_FILE_OFFSET_BITS=64 $(IFLAGS) src/mpr/mprLib.c

#
#   openssl.o
#
DEPS_28 += $(BUILD)/inc/mpr.h

$(BUILD)/obj/openssl.o: \
    src/mpr-openssl/openssl.c $(DEPS_28)
	@echo '   [Compile] $(BUILD)/obj/openssl.o'
	$(CC) -c -o $(BUILD)/obj/openssl.o $(LDFLAGS) $(CFLAGS) -DME_COM_OPENSSL_PATH=$(ME_COM_OPENSSL_PATH) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" src/mpr-openssl/openssl.c

#
#   pcre.h
#

src/pcre/pcre.h: $(DEPS_29)

#
#   pcre.o
#
DEPS_30 += $(BUILD)/inc/me.h
DEPS_30 += src/pcre/pcre.h

$(BUILD)/obj/pcre.o: \
    src/pcre/pcre.c $(DEPS_30)
	@echo '   [Compile] $(BUILD)/obj/pcre.o'
	$(CC) -c -o $(BUILD)/obj/pcre.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) $(IFLAGS) src/pcre/pcre.c

#
#   testme.o
#
DEPS_31 += $(BUILD)/inc/ejs.h

$(BUILD)/obj/testme.o: \
    src/tm/testme.c $(DEPS_31)
	@echo '   [Compile] $(BUILD)/obj/testme.o'
	$(CC) -c -o $(BUILD)/obj/testme.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) -D_FILE_OFFSET_BITS=64 $(IFLAGS) src/tm/testme.c

#
#   zlib.h
#

src/zlib/zlib.h: $(DEPS_32)

#
#   zlib.o
#
DEPS_33 += $(BUILD)/inc/me.h
DEPS_33 += src/zlib/zlib.h

$(BUILD)/obj/zlib.o: \
    src/zlib/zlib.c $(DEPS_33)
	@echo '   [Compile] $(BUILD)/obj/zlib.o'
	$(CC) -c -o $(BUILD)/obj/zlib.o $(LDFLAGS) $(CFLAGS) $(DFLAGS) $(IFLAGS) src/zlib/zlib.c

ifeq ($(ME_COM_MBEDTLS),1)
#
#   libmbedtls
#
DEPS_34 += $(BUILD)/inc/osdep.h
DEPS_34 += $(BUILD)/inc/mbedtls.h
DEPS_34 += $(BUILD)/obj/mbedtlsLib.o

$(BUILD)/bin/libmbedtls.a: $(DEPS_34)
	@echo '      [Link] $(BUILD)/bin/libmbedtls.a'
	ar -cr $(BUILD)/bin/libmbedtls.a "$(BUILD)/obj/mbedtlsLib.o"
endif

ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_MBEDTLS),1)
#
#   mbedtls
#
ifeq ($(ME_COM_MBEDTLS),1)
    DEPS_35 += $(BUILD)/bin/libmbedtls.a
endif
DEPS_35 += $(BUILD)/obj/mbedtls.o

$(BUILD)/bin/libmpr-mbedtls.a: $(DEPS_35)
	@echo '      [Link] $(BUILD)/bin/libmpr-mbedtls.a'
	ar -cr $(BUILD)/bin/libmpr-mbedtls.a "$(BUILD)/obj/mbedtls.o"
endif
endif

ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_OPENSSL),1)
#
#   openssl
#
DEPS_36 += $(BUILD)/obj/openssl.o

$(BUILD)/bin/libmpr-openssl.a: $(DEPS_36)
	@echo '      [Link] $(BUILD)/bin/libmpr-openssl.a'
	ar -cr $(BUILD)/bin/libmpr-openssl.a "$(BUILD)/obj/openssl.o"
endif
endif

#
#   libmpr
#
DEPS_37 += $(BUILD)/inc/osdep.h
ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_MBEDTLS),1)
    DEPS_37 += $(BUILD)/bin/libmpr-mbedtls.a
endif
endif
ifeq ($(ME_COM_SSL),1)
ifeq ($(ME_COM_OPENSSL),1)
    DEPS_37 += $(BUILD)/bin/libmpr-openssl.a
endif
endif
DEPS_37 += $(BUILD)/inc/mpr.h
DEPS_37 += $(BUILD)/obj/mprLib.o

ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_37 += -lmbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_37 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_37 += -lmbedtls
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_37 += -lmpr-openssl
    LIBPATHS_37 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_37 += -lssl
    LIBPATHS_37 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_37 += -lcrypto
    LIBPATHS_37 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_37 += -lmpr-mbedtls
endif

$(BUILD)/bin/libmpr.so: $(DEPS_37)
	@echo '      [Link] $(BUILD)/bin/libmpr.so'
	$(CC) -shared -o $(BUILD)/bin/libmpr.so $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/mprLib.o" $(LIBPATHS_37) $(LIBS_37) $(LIBS_37) $(LIBS) 

ifeq ($(ME_COM_PCRE),1)
#
#   libpcre
#
DEPS_38 += $(BUILD)/inc/pcre.h
DEPS_38 += $(BUILD)/obj/pcre.o

$(BUILD)/bin/libpcre.so: $(DEPS_38)
	@echo '      [Link] $(BUILD)/bin/libpcre.so'
	$(CC) -shared -o $(BUILD)/bin/libpcre.so $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/pcre.o" $(LIBS) 
endif

ifeq ($(ME_COM_HTTP),1)
#
#   libhttp
#
DEPS_39 += $(BUILD)/bin/libmpr.so
ifeq ($(ME_COM_PCRE),1)
    DEPS_39 += $(BUILD)/bin/libpcre.so
endif
DEPS_39 += $(BUILD)/inc/http.h
DEPS_39 += $(BUILD)/obj/httpLib.o

ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_39 += -lmbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_39 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_39 += -lmbedtls
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_39 += -lmpr-openssl
    LIBPATHS_39 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_39 += -lssl
    LIBPATHS_39 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_39 += -lcrypto
    LIBPATHS_39 += -L"$(ME_COM_OPENSSL_PATH)"
endif
LIBS_39 += -lmpr
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_39 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_39 += -lpcre
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_39 += -lpcre
endif
LIBS_39 += -lmpr

$(BUILD)/bin/libhttp.so: $(DEPS_39)
	@echo '      [Link] $(BUILD)/bin/libhttp.so'
	$(CC) -shared -o $(BUILD)/bin/libhttp.so $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/httpLib.o" $(LIBPATHS_39) $(LIBS_39) $(LIBS_39) $(LIBS) 
endif

ifeq ($(ME_COM_ZLIB),1)
#
#   libzlib
#
DEPS_40 += $(BUILD)/inc/zlib.h
DEPS_40 += $(BUILD)/obj/zlib.o

$(BUILD)/bin/libzlib.so: $(DEPS_40)
	@echo '      [Link] $(BUILD)/bin/libzlib.so'
	$(CC) -shared -o $(BUILD)/bin/libzlib.so $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/zlib.o" $(LIBS) 
endif

ifeq ($(ME_COM_EJSCRIPT),1)
#
#   libejs
#
ifeq ($(ME_COM_HTTP),1)
    DEPS_41 += $(BUILD)/bin/libhttp.so
endif
ifeq ($(ME_COM_PCRE),1)
    DEPS_41 += $(BUILD)/bin/libpcre.so
endif
DEPS_41 += $(BUILD)/bin/libmpr.so
ifeq ($(ME_COM_ZLIB),1)
    DEPS_41 += $(BUILD)/bin/libzlib.so
endif
DEPS_41 += $(BUILD)/inc/ejs.h
DEPS_41 += $(BUILD)/inc/ejs.slots.h
DEPS_41 += $(BUILD)/inc/ejsByteGoto.h
DEPS_41 += $(BUILD)/obj/ejsLib.o

ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_41 += -lmbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_41 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_41 += -lmbedtls
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_41 += -lmpr-openssl
    LIBPATHS_41 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_41 += -lssl
    LIBPATHS_41 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_41 += -lcrypto
    LIBPATHS_41 += -L"$(ME_COM_OPENSSL_PATH)"
endif
LIBS_41 += -lmpr
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_41 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_41 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_41 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_41 += -lpcre
endif
LIBS_41 += -lmpr
ifeq ($(ME_COM_ZLIB),1)
    LIBS_41 += -lzlib
endif
ifeq ($(ME_COM_ZLIB),1)
    LIBS_41 += -lzlib
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_41 += -lhttp
endif

$(BUILD)/bin/libejs.so: $(DEPS_41)
	@echo '      [Link] $(BUILD)/bin/libejs.so'
	$(CC) -shared -o $(BUILD)/bin/libejs.so $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/ejsLib.o" $(LIBPATHS_41) $(LIBS_41) $(LIBS_41) $(LIBS) 
endif

ifeq ($(ME_COM_EJSCRIPT),1)
#
#   ejsc
#
DEPS_42 += $(BUILD)/bin/libejs.so
DEPS_42 += $(BUILD)/obj/ejsc.o

ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_42 += -lmbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_42 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_42 += -lmbedtls
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_42 += -lmpr-openssl
    LIBPATHS_42 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_42 += -lssl
    LIBPATHS_42 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_42 += -lcrypto
    LIBPATHS_42 += -L"$(ME_COM_OPENSSL_PATH)"
endif
LIBS_42 += -lmpr
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_42 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_42 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_42 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_42 += -lpcre
endif
LIBS_42 += -lmpr
ifeq ($(ME_COM_ZLIB),1)
    LIBS_42 += -lzlib
endif
LIBS_42 += -lejs
ifeq ($(ME_COM_ZLIB),1)
    LIBS_42 += -lzlib
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_42 += -lhttp
endif

$(BUILD)/bin/makeme-ejsc: $(DEPS_42)
	@echo '      [Link] $(BUILD)/bin/makeme-ejsc'
	$(CC) -o $(BUILD)/bin/makeme-ejsc $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/ejsc.o" $(LIBPATHS_42) $(LIBS_42) $(LIBS_42) $(LIBS) $(LIBS) 
endif

ifeq ($(ME_COM_EJSCRIPT),1)
#
#   ejs.mod
#
DEPS_43 += src/ejscript/ejs.es
DEPS_43 += $(BUILD)/bin/makeme-ejsc

$(BUILD)/bin/ejs.mod: $(DEPS_43)
	( \
	cd src/ejscript; \
	echo '   [Compile] ejs.mod' ; \
	"../../$(BUILD)/bin/makeme-ejsc" --out "../../$(BUILD)/bin/ejs.mod" --optimize 9 --bind --require null ejs.es ; \
	)
endif

#
#   ejs.testme.es
#
DEPS_44 += src/tm/ejs.testme.es

$(BUILD)/bin/ejs.testme.es: $(DEPS_44)
	@echo '      [Copy] $(BUILD)/bin/ejs.testme.es'
	mkdir -p "$(BUILD)/bin"
	cp src/tm/ejs.testme.es $(BUILD)/bin/ejs.testme.es

#
#   ejs.testme.mod
#
DEPS_45 += src/tm/ejs.testme.es
ifeq ($(ME_COM_EJSCRIPT),1)
    DEPS_45 += $(BUILD)/bin/ejs.mod
endif

$(BUILD)/bin/ejs.testme.mod: $(DEPS_45)
	( \
	cd src/tm; \
	echo '   [Compile] ejs.testme.mod' ; \
	"../../$(BUILD)/bin/makeme-ejsc" --optimize 9 --out "../../$(BUILD)/bin/ejs.testme.mod" --optimize 9 ejs.testme.es ; \
	)

ifeq ($(ME_COM_EJSCRIPT),1)
#
#   ejscmd
#
DEPS_46 += $(BUILD)/bin/libejs.so
DEPS_46 += $(BUILD)/obj/ejs.o

ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_46 += -lmbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_46 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_46 += -lmbedtls
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_46 += -lmpr-openssl
    LIBPATHS_46 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_46 += -lssl
    LIBPATHS_46 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_46 += -lcrypto
    LIBPATHS_46 += -L"$(ME_COM_OPENSSL_PATH)"
endif
LIBS_46 += -lmpr
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_46 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_46 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_46 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_46 += -lpcre
endif
LIBS_46 += -lmpr
ifeq ($(ME_COM_ZLIB),1)
    LIBS_46 += -lzlib
endif
LIBS_46 += -lejs
ifeq ($(ME_COM_ZLIB),1)
    LIBS_46 += -lzlib
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_46 += -lhttp
endif

$(BUILD)/bin/makeme-ejs: $(DEPS_46)
	@echo '      [Link] $(BUILD)/bin/makeme-ejs'
	$(CC) -o $(BUILD)/bin/makeme-ejs $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/ejs.o" $(LIBPATHS_46) $(LIBS_46) $(LIBS_46) $(LIBS) $(LIBS) 
endif

#
#   extras
#
DEPS_47 += src/Configure.es
DEPS_47 += src/Generate.es

$(BUILD)/.extras-modified: $(DEPS_47)
	@echo '      [Copy] $(BUILD)/bin'
	mkdir -p "$(BUILD)/bin"
	cp src/Configure.es $(BUILD)/bin/Configure.es
	cp src/Generate.es $(BUILD)/bin/Generate.es
	touch "$(BUILD)/.extras-modified"

ifeq ($(ME_COM_HTTP),1)
#
#   httpcmd
#
DEPS_48 += $(BUILD)/bin/libhttp.so
DEPS_48 += $(BUILD)/obj/http.o

ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_48 += -lmbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_48 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_48 += -lmbedtls
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_48 += -lmpr-openssl
    LIBPATHS_48 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_48 += -lssl
    LIBPATHS_48 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_48 += -lcrypto
    LIBPATHS_48 += -L"$(ME_COM_OPENSSL_PATH)"
endif
LIBS_48 += -lmpr
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_48 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_48 += -lpcre
endif
LIBS_48 += -lhttp
ifeq ($(ME_COM_PCRE),1)
    LIBS_48 += -lpcre
endif
LIBS_48 += -lmpr

$(BUILD)/bin/http: $(DEPS_48)
	@echo '      [Link] $(BUILD)/bin/http'
	$(CC) -o $(BUILD)/bin/http $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/http.o" $(LIBPATHS_48) $(LIBS_48) $(LIBS_48) $(LIBS) $(LIBS) 
endif

#
#   install-certs
#
DEPS_49 += src/certs/samples/ca.crt
DEPS_49 += src/certs/samples/ca.key
DEPS_49 += src/certs/samples/ec.crt
DEPS_49 += src/certs/samples/ec.key
DEPS_49 += src/certs/samples/roots.crt
DEPS_49 += src/certs/samples/self.crt
DEPS_49 += src/certs/samples/self.key
DEPS_49 += src/certs/samples/test.crt
DEPS_49 += src/certs/samples/test.key

$(BUILD)/.install-certs-modified: $(DEPS_49)
	@echo '      [Copy] $(BUILD)/bin'
	mkdir -p "$(BUILD)/bin"
	cp src/certs/samples/ca.crt $(BUILD)/bin/ca.crt
	cp src/certs/samples/ca.key $(BUILD)/bin/ca.key
	cp src/certs/samples/ec.crt $(BUILD)/bin/ec.crt
	cp src/certs/samples/ec.key $(BUILD)/bin/ec.key
	cp src/certs/samples/roots.crt $(BUILD)/bin/roots.crt
	cp src/certs/samples/self.crt $(BUILD)/bin/self.crt
	cp src/certs/samples/self.key $(BUILD)/bin/self.key
	cp src/certs/samples/test.crt $(BUILD)/bin/test.crt
	cp src/certs/samples/test.key $(BUILD)/bin/test.key
	touch "$(BUILD)/.install-certs-modified"

#
#   libtestme
#
DEPS_50 += $(BUILD)/inc/testme.h
DEPS_50 += $(BUILD)/obj/libtestme.o

$(BUILD)/bin/libtestme.so: $(DEPS_50)
	@echo '      [Link] $(BUILD)/bin/libtestme.so'
	$(CC) -shared -o $(BUILD)/bin/libtestme.so $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/libtestme.o" $(LIBS) 

#
#   me.mod
#
DEPS_51 += src/Builder.es
DEPS_51 += src/Loader.es
DEPS_51 += src/MakeMe.es
DEPS_51 += src/Me.es
DEPS_51 += src/Script.es
DEPS_51 += src/Target.es
DEPS_51 += paks/ejs-version/Version.es
ifeq ($(ME_COM_EJSCRIPT),1)
    DEPS_51 += $(BUILD)/bin/ejs.mod
endif

$(BUILD)/bin/me.mod: $(DEPS_51)
	echo '   [Compile] me.mod' ; \
	"./$(BUILD)/bin/makeme-ejsc" --optimize 9 --out "./$(BUILD)/bin/me.mod" --optimize 9 src/Builder.es src/Loader.es src/MakeMe.es src/Me.es src/Script.es src/Target.es paks/ejs-version/Version.es

#
#   pakrun
#
DEPS_52 += paks/me-components/appweb.me
DEPS_52 += paks/me-components/compiler.me
DEPS_52 += paks/me-components/components.me
DEPS_52 += paks/me-components/ejscript.me
DEPS_52 += paks/me-components/lib.me
DEPS_52 += paks/me-components/link.me
DEPS_52 += paks/me-components/rc.me
DEPS_52 += paks/me-components/testme.me
DEPS_52 += paks/me-components/vxworks.me
DEPS_52 += paks/me-components/winsdk.me
DEPS_52 += paks/me-installs/Installs.es
DEPS_52 += paks/me-installs/installs.me
DEPS_52 += paks/me-installs/manifest.me
DEPS_52 += paks/me-make/Make.es
DEPS_52 += paks/me-make/make.me
DEPS_52 += paks/me-os/freebsd.me
DEPS_52 += paks/me-os/gcc.me
DEPS_52 += paks/me-os/linux.me
DEPS_52 += paks/me-os/macosx.me
DEPS_52 += paks/me-os/os.me
DEPS_52 += paks/me-os/solaris.me
DEPS_52 += paks/me-os/unix.me
DEPS_52 += paks/me-os/vxworks.me
DEPS_52 += paks/me-os/windows.me
DEPS_52 += paks/me-vstudio/Vstudio.es
DEPS_52 += paks/me-vstudio/vstudio.me
DEPS_52 += paks/me-xcode/Xcode.es
DEPS_52 += paks/me-xcode/xcode.me

$(BUILD)/.pakrun-modified: $(DEPS_52)
	@echo '      [Copy] $(BUILD)/bin'
	mkdir -p "$(BUILD)/bin/paks/me-components"
	cp paks/me-components/appweb.me $(BUILD)/bin/paks/me-components/appweb.me
	cp paks/me-components/compiler.me $(BUILD)/bin/paks/me-components/compiler.me
	cp paks/me-components/components.me $(BUILD)/bin/paks/me-components/components.me
	cp paks/me-components/ejscript.me $(BUILD)/bin/paks/me-components/ejscript.me
	cp paks/me-components/lib.me $(BUILD)/bin/paks/me-components/lib.me
	cp paks/me-components/link.me $(BUILD)/bin/paks/me-components/link.me
	cp paks/me-components/rc.me $(BUILD)/bin/paks/me-components/rc.me
	cp paks/me-components/testme.me $(BUILD)/bin/paks/me-components/testme.me
	cp paks/me-components/vxworks.me $(BUILD)/bin/paks/me-components/vxworks.me
	cp paks/me-components/winsdk.me $(BUILD)/bin/paks/me-components/winsdk.me
	mkdir -p "$(BUILD)/bin/paks/me-installs"
	cp paks/me-installs/Installs.es $(BUILD)/bin/paks/me-installs/Installs.es
	cp paks/me-installs/installs.me $(BUILD)/bin/paks/me-installs/installs.me
	cp paks/me-installs/manifest.me $(BUILD)/bin/paks/me-installs/manifest.me
	mkdir -p "$(BUILD)/bin/paks/me-make"
	cp paks/me-make/Make.es $(BUILD)/bin/paks/me-make/Make.es
	cp paks/me-make/make.me $(BUILD)/bin/paks/me-make/make.me
	mkdir -p "$(BUILD)/bin/paks/me-os"
	cp paks/me-os/freebsd.me $(BUILD)/bin/paks/me-os/freebsd.me
	cp paks/me-os/gcc.me $(BUILD)/bin/paks/me-os/gcc.me
	cp paks/me-os/linux.me $(BUILD)/bin/paks/me-os/linux.me
	cp paks/me-os/macosx.me $(BUILD)/bin/paks/me-os/macosx.me
	cp paks/me-os/os.me $(BUILD)/bin/paks/me-os/os.me
	cp paks/me-os/solaris.me $(BUILD)/bin/paks/me-os/solaris.me
	cp paks/me-os/unix.me $(BUILD)/bin/paks/me-os/unix.me
	cp paks/me-os/vxworks.me $(BUILD)/bin/paks/me-os/vxworks.me
	cp paks/me-os/windows.me $(BUILD)/bin/paks/me-os/windows.me
	mkdir -p "$(BUILD)/bin/paks/me-vstudio"
	cp paks/me-vstudio/Vstudio.es $(BUILD)/bin/paks/me-vstudio/Vstudio.es
	cp paks/me-vstudio/vstudio.me $(BUILD)/bin/paks/me-vstudio/vstudio.me
	mkdir -p "$(BUILD)/bin/paks/me-xcode"
	cp paks/me-xcode/Xcode.es $(BUILD)/bin/paks/me-xcode/Xcode.es
	cp paks/me-xcode/xcode.me $(BUILD)/bin/paks/me-xcode/xcode.me
	touch "$(BUILD)/.pakrun-modified"

#
#   runtime
#
DEPS_53 += src/master-main.me
DEPS_53 += src/master-start.me
DEPS_53 += src/simple.me
DEPS_53 += src/standard.me
DEPS_53 += $(BUILD)/.pakrun-modified

$(BUILD)/.runtime-modified: $(DEPS_53)
	@echo '      [Copy] $(BUILD)/bin'
	mkdir -p "$(BUILD)/bin"
	cp src/master-main.me $(BUILD)/bin/master-main.me
	cp src/master-start.me $(BUILD)/bin/master-start.me
	cp src/simple.me $(BUILD)/bin/simple.me
	cp src/standard.me $(BUILD)/bin/standard.me
	touch "$(BUILD)/.runtime-modified"

#
#   me
#
DEPS_54 += $(BUILD)/bin/libmpr.so
ifeq ($(ME_COM_HTTP),1)
    DEPS_54 += $(BUILD)/bin/libhttp.so
endif
ifeq ($(ME_COM_EJSCRIPT),1)
    DEPS_54 += $(BUILD)/bin/libejs.so
endif
DEPS_54 += $(BUILD)/bin/me.mod
DEPS_54 += $(BUILD)/.runtime-modified
DEPS_54 += $(BUILD)/obj/me.o

ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_54 += -lmbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_54 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_54 += -lmbedtls
endif
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
LIBS_54 += -lmpr
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_54 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_54 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_54 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_54 += -lpcre
endif
LIBS_54 += -lmpr
ifeq ($(ME_COM_ZLIB),1)
    LIBS_54 += -lzlib
endif
ifeq ($(ME_COM_EJSCRIPT),1)
    LIBS_54 += -lejs
endif
ifeq ($(ME_COM_ZLIB),1)
    LIBS_54 += -lzlib
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_54 += -lhttp
endif

$(BUILD)/bin/me: $(DEPS_54)
	@echo '      [Link] $(BUILD)/bin/me'
	$(CC) -o $(BUILD)/bin/me $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/me.o" $(LIBPATHS_54) $(LIBS_54) $(LIBS_54) $(LIBS) $(LIBS) 

#
#   testme.mod
#
DEPS_55 += src/tm/testme.es
ifeq ($(ME_COM_EJSCRIPT),1)
    DEPS_55 += $(BUILD)/bin/ejs.mod
endif

$(BUILD)/bin/testme.mod: $(DEPS_55)
	( \
	cd src/tm; \
	echo '   [Compile] testme.mod' ; \
	"../../$(BUILD)/bin/makeme-ejsc" --optimize 9 --out "../../$(BUILD)/bin/testme.mod" --optimize 9 testme.es ; \
	)

#
#   testme
#
ifeq ($(ME_COM_EJSCRIPT),1)
    DEPS_56 += $(BUILD)/bin/libejs.so
endif
DEPS_56 += $(BUILD)/bin/testme.mod
DEPS_56 += $(BUILD)/bin/ejs.testme.mod
DEPS_56 += $(BUILD)/obj/testme.o

ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_56 += -lmbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_56 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_56 += -lmbedtls
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_56 += -lmpr-openssl
    LIBPATHS_56 += -L"$(ME_COM_OPENSSL_PATH)"
endif
ifeq ($(ME_COM_OPENSSL),1)
ifeq ($(ME_COM_SSL),1)
    LIBS_56 += -lssl
    LIBPATHS_56 += -L"$(ME_COM_OPENSSL_PATH)"
endif
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_56 += -lcrypto
    LIBPATHS_56 += -L"$(ME_COM_OPENSSL_PATH)"
endif
LIBS_56 += -lmpr
ifeq ($(ME_COM_MBEDTLS),1)
    LIBS_56 += -lmpr-mbedtls
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_56 += -lpcre
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_56 += -lhttp
endif
ifeq ($(ME_COM_PCRE),1)
    LIBS_56 += -lpcre
endif
LIBS_56 += -lmpr
ifeq ($(ME_COM_ZLIB),1)
    LIBS_56 += -lzlib
endif
ifeq ($(ME_COM_EJSCRIPT),1)
    LIBS_56 += -lejs
endif
ifeq ($(ME_COM_ZLIB),1)
    LIBS_56 += -lzlib
endif
ifeq ($(ME_COM_HTTP),1)
    LIBS_56 += -lhttp
endif

$(BUILD)/bin/testme: $(DEPS_56)
	@echo '      [Link] $(BUILD)/bin/testme'
	$(CC) -o $(BUILD)/bin/testme $(LDFLAGS) $(LIBPATHS) "$(BUILD)/obj/testme.o" $(LIBPATHS_56) $(LIBS_56) $(LIBS_56) $(LIBS) $(LIBS) 

#
#   testme.es
#
DEPS_57 += src/tm/testme.es

$(BUILD)/bin/testme.es: $(DEPS_57)
	@echo '      [Copy] $(BUILD)/bin/testme.es'
	mkdir -p "$(BUILD)/bin"
	cp src/tm/testme.es $(BUILD)/bin/testme.es

#
#   installPrep
#

installPrep: $(DEPS_58)
	if [ "`id -u`" != 0 ] ; \
	then echo "Must run as root. Rerun with "sudo"" ; \
	exit 255 ; \
	fi

#
#   stop
#

stop: $(DEPS_59)

#
#   installBinary
#

installBinary: $(DEPS_60)
	mkdir -p "$(ME_APP_PREFIX)" ; \
	rm -f "$(ME_APP_PREFIX)/latest" ; \
	ln -s "$(VERSION)" "$(ME_APP_PREFIX)/latest" ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/me $(ME_VAPP_PREFIX)/bin/me ; \
	chmod 755 "$(ME_VAPP_PREFIX)/bin/me" ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	chmod 755 "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/me" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/me" "$(ME_BIN_PREFIX)/me" ; \
	cp $(BUILD)/bin/testme $(ME_VAPP_PREFIX)/bin/testme ; \
	chmod 755 "$(ME_VAPP_PREFIX)/bin/testme" ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	chmod 755 "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/testme" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/testme" "$(ME_BIN_PREFIX)/testme" ; \
	cp $(BUILD)/bin/makeme-ejs $(ME_VAPP_PREFIX)/bin/makeme-ejs ; \
	chmod 755 "$(ME_VAPP_PREFIX)/bin/makeme-ejs" ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	chmod 755 "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/makeme-ejs" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/makeme-ejs" "$(ME_BIN_PREFIX)/makeme-ejs" ; \
	cp $(BUILD)/bin/makeme-ejsc $(ME_VAPP_PREFIX)/bin/makeme-ejsc ; \
	chmod 755 "$(ME_VAPP_PREFIX)/bin/makeme-ejsc" ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	chmod 755 "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/makeme-ejsc" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/makeme-ejsc" "$(ME_BIN_PREFIX)/makeme-ejsc" ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/http $(ME_VAPP_PREFIX)/bin/http ; \
	chmod 755 "$(ME_VAPP_PREFIX)/bin/http" ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	chmod 755 "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/http" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/http" "$(ME_BIN_PREFIX)/http" ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/libejs.so $(ME_VAPP_PREFIX)/bin/libejs.so ; \
	cp $(BUILD)/bin/libhttp.so $(ME_VAPP_PREFIX)/bin/libhttp.so ; \
	cp $(BUILD)/bin/libmpr.so $(ME_VAPP_PREFIX)/bin/libmpr.so ; \
	cp $(BUILD)/bin/libpcre.so $(ME_VAPP_PREFIX)/bin/libpcre.so ; \
	cp $(BUILD)/bin/libzlib.so $(ME_VAPP_PREFIX)/bin/libzlib.so ; \
	cp $(BUILD)/bin/libtestme.so $(ME_VAPP_PREFIX)/bin/libtestme.so ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp $(BUILD)/bin/roots.crt $(ME_VAPP_PREFIX)/bin/roots.crt ; \
	cp $(BUILD)/bin/ejs.mod $(ME_VAPP_PREFIX)/bin/ejs.mod ; \
	cp $(BUILD)/bin/me.mod $(ME_VAPP_PREFIX)/bin/me.mod ; \
	cp $(BUILD)/bin/testme.mod $(ME_VAPP_PREFIX)/bin/testme.mod ; \
	cp $(BUILD)/bin/ejs.testme.mod $(ME_VAPP_PREFIX)/bin/ejs.testme.mod ; \
	mkdir -p "$(ME_VAPP_PREFIX)/inc" ; \
	cp src/tm/testme.h $(ME_VAPP_PREFIX)/inc/testme.h ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp src/master-main.me $(ME_VAPP_PREFIX)/bin/master-main.me ; \
	cp src/master-start.me $(ME_VAPP_PREFIX)/bin/master-start.me ; \
	cp src/simple.me $(ME_VAPP_PREFIX)/bin/simple.me ; \
	cp src/standard.me $(ME_VAPP_PREFIX)/bin/standard.me ; \
	cp src/Configure.es $(ME_VAPP_PREFIX)/bin/Configure.es ; \
	cp src/Generate.es $(ME_VAPP_PREFIX)/bin/Generate.es ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin/paks/me-components" ; \
	cp paks/me-components/appweb.me $(ME_VAPP_PREFIX)/bin/paks/me-components/appweb.me ; \
	cp paks/me-components/compiler.me $(ME_VAPP_PREFIX)/bin/paks/me-components/compiler.me ; \
	cp paks/me-components/components.me $(ME_VAPP_PREFIX)/bin/paks/me-components/components.me ; \
	cp paks/me-components/ejscript.me $(ME_VAPP_PREFIX)/bin/paks/me-components/ejscript.me ; \
	cp paks/me-components/lib.me $(ME_VAPP_PREFIX)/bin/paks/me-components/lib.me ; \
	cp paks/me-components/LICENSE.md $(ME_VAPP_PREFIX)/bin/paks/me-components/LICENSE.md ; \
	cp paks/me-components/link.me $(ME_VAPP_PREFIX)/bin/paks/me-components/link.me ; \
	cp paks/me-components/package.json $(ME_VAPP_PREFIX)/bin/paks/me-components/package.json ; \
	cp paks/me-components/rc.me $(ME_VAPP_PREFIX)/bin/paks/me-components/rc.me ; \
	cp paks/me-components/README.md $(ME_VAPP_PREFIX)/bin/paks/me-components/README.md ; \
	cp paks/me-components/testme.me $(ME_VAPP_PREFIX)/bin/paks/me-components/testme.me ; \
	cp paks/me-components/vxworks.me $(ME_VAPP_PREFIX)/bin/paks/me-components/vxworks.me ; \
	cp paks/me-components/winsdk.me $(ME_VAPP_PREFIX)/bin/paks/me-components/winsdk.me ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin/paks/me-installs" ; \
	cp paks/me-installs/Installs.es $(ME_VAPP_PREFIX)/bin/paks/me-installs/Installs.es ; \
	cp paks/me-installs/installs.me $(ME_VAPP_PREFIX)/bin/paks/me-installs/installs.me ; \
	cp paks/me-installs/LICENSE.md $(ME_VAPP_PREFIX)/bin/paks/me-installs/LICENSE.md ; \
	cp paks/me-installs/manifest.me $(ME_VAPP_PREFIX)/bin/paks/me-installs/manifest.me ; \
	cp paks/me-installs/package.json $(ME_VAPP_PREFIX)/bin/paks/me-installs/package.json ; \
	cp paks/me-installs/README.md $(ME_VAPP_PREFIX)/bin/paks/me-installs/README.md ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin/paks/me-make" ; \
	cp paks/me-make/LICENSE.md $(ME_VAPP_PREFIX)/bin/paks/me-make/LICENSE.md ; \
	cp paks/me-make/Make.es $(ME_VAPP_PREFIX)/bin/paks/me-make/Make.es ; \
	cp paks/me-make/make.me $(ME_VAPP_PREFIX)/bin/paks/me-make/make.me ; \
	cp paks/me-make/package.json $(ME_VAPP_PREFIX)/bin/paks/me-make/package.json ; \
	cp paks/me-make/README.md $(ME_VAPP_PREFIX)/bin/paks/me-make/README.md ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin/paks/me-os" ; \
	cp paks/me-os/freebsd.me $(ME_VAPP_PREFIX)/bin/paks/me-os/freebsd.me ; \
	cp paks/me-os/gcc.me $(ME_VAPP_PREFIX)/bin/paks/me-os/gcc.me ; \
	cp paks/me-os/LICENSE.md $(ME_VAPP_PREFIX)/bin/paks/me-os/LICENSE.md ; \
	cp paks/me-os/linux.me $(ME_VAPP_PREFIX)/bin/paks/me-os/linux.me ; \
	cp paks/me-os/macosx.me $(ME_VAPP_PREFIX)/bin/paks/me-os/macosx.me ; \
	cp paks/me-os/os.me $(ME_VAPP_PREFIX)/bin/paks/me-os/os.me ; \
	cp paks/me-os/package.json $(ME_VAPP_PREFIX)/bin/paks/me-os/package.json ; \
	cp paks/me-os/README.md $(ME_VAPP_PREFIX)/bin/paks/me-os/README.md ; \
	cp paks/me-os/solaris.me $(ME_VAPP_PREFIX)/bin/paks/me-os/solaris.me ; \
	cp paks/me-os/unix.me $(ME_VAPP_PREFIX)/bin/paks/me-os/unix.me ; \
	cp paks/me-os/vxworks.me $(ME_VAPP_PREFIX)/bin/paks/me-os/vxworks.me ; \
	cp paks/me-os/windows.me $(ME_VAPP_PREFIX)/bin/paks/me-os/windows.me ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin/paks/me-vstudio" ; \
	cp paks/me-vstudio/LICENSE.md $(ME_VAPP_PREFIX)/bin/paks/me-vstudio/LICENSE.md ; \
	cp paks/me-vstudio/package.json $(ME_VAPP_PREFIX)/bin/paks/me-vstudio/package.json ; \
	cp paks/me-vstudio/README.md $(ME_VAPP_PREFIX)/bin/paks/me-vstudio/README.md ; \
	cp paks/me-vstudio/Vstudio.es $(ME_VAPP_PREFIX)/bin/paks/me-vstudio/Vstudio.es ; \
	cp paks/me-vstudio/vstudio.me $(ME_VAPP_PREFIX)/bin/paks/me-vstudio/vstudio.me ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin/paks/me-xcode" ; \
	cp paks/me-xcode/LICENSE.md $(ME_VAPP_PREFIX)/bin/paks/me-xcode/LICENSE.md ; \
	cp paks/me-xcode/package.json $(ME_VAPP_PREFIX)/bin/paks/me-xcode/package.json ; \
	cp paks/me-xcode/README.md $(ME_VAPP_PREFIX)/bin/paks/me-xcode/README.md ; \
	cp paks/me-xcode/Xcode.es $(ME_VAPP_PREFIX)/bin/paks/me-xcode/Xcode.es ; \
	cp paks/me-xcode/xcode.me $(ME_VAPP_PREFIX)/bin/paks/me-xcode/xcode.me ; \
	mkdir -p "$(ME_VAPP_PREFIX)/doc/man/man1" ; \
	cp doc/dist/man/me.1 $(ME_VAPP_PREFIX)/doc/man/man1/me.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/me.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man/man1/me.1" "$(ME_MAN_PREFIX)/man1/me.1" ; \
	cp doc/dist/man/testme.1 $(ME_VAPP_PREFIX)/doc/man/man1/testme.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/testme.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man/man1/testme.1" "$(ME_MAN_PREFIX)/man1/testme.1"

#
#   start
#

start: $(DEPS_61)

#
#   install
#
DEPS_62 += installPrep
DEPS_62 += stop
DEPS_62 += installBinary
DEPS_62 += start

install: $(DEPS_62)

#
#   uninstall
#
DEPS_63 += stop

uninstall: $(DEPS_63)
	rm -fr "$(ME_VAPP_PREFIX)" ; \
	rm -f "$(ME_APP_PREFIX)/latest" ; \
	rmdir -p "$(ME_APP_PREFIX)" 2>/dev/null ; true

#
#   version
#

version: $(DEPS_64)
	echo $(VERSION)
