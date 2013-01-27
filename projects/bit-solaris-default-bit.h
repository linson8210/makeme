/*
    bit.h -- Build It Configuration Header for solaris-x86-default

    This header is generated by Bit during configuration. To change settings, re-run
    configure or define variables in your Makefile to override these default values.
 */


/* Settings */
#ifndef BIT_BUILD_NUMBER
    #define BIT_BUILD_NUMBER "0"
#endif
#ifndef BIT_COMPANY
    #define BIT_COMPANY "Embedthis"
#endif
#ifndef BIT_DEBUG
    #define BIT_DEBUG 1
#endif
#ifndef BIT_DEPTH
    #define BIT_DEPTH 1
#endif
#ifndef BIT_DISCOVER
    #define BIT_DISCOVER "dsi,ejscript,est,man,man2html,pmaker"
#endif
#ifndef BIT_EJS_ONE_MODULE
    #define BIT_EJS_ONE_MODULE 1
#endif
#ifndef BIT_HAS_DOUBLE_BRACES
    #define BIT_HAS_DOUBLE_BRACES 1
#endif
#ifndef BIT_HAS_DYN_LOAD
    #define BIT_HAS_DYN_LOAD 1
#endif
#ifndef BIT_HAS_LIB_EDIT
    #define BIT_HAS_LIB_EDIT 0
#endif
#ifndef BIT_HAS_LIB_RT
    #define BIT_HAS_LIB_RT 0
#endif
#ifndef BIT_HAS_MMU
    #define BIT_HAS_MMU 1
#endif
#ifndef BIT_HAS_MTUNE
    #define BIT_HAS_MTUNE 1
#endif
#ifndef BIT_HAS_PAM
    #define BIT_HAS_PAM 0
#endif
#ifndef BIT_HAS_STACK_PROTECTOR
    #define BIT_HAS_STACK_PROTECTOR 1
#endif
#ifndef BIT_HAS_SYNC
    #define BIT_HAS_SYNC 0
#endif
#ifndef BIT_HAS_SYNC_CAS
    #define BIT_HAS_SYNC_CAS 0
#endif
#ifndef BIT_HAS_UNNAMED_UNIONS
    #define BIT_HAS_UNNAMED_UNIONS 1
#endif
#ifndef BIT_PACKS
    #define BIT_PACKS "bits/packs"
#endif
#ifndef BIT_PLATFORMS
    #define BIT_PLATFORMS "local"
#endif
#ifndef BIT_PRODUCT
    #define BIT_PRODUCT "bit"
#endif
#ifndef BIT_REQUIRED
    #define BIT_REQUIRED "compiler,lib,link,pcre,http,sqlite,ejscript"
#endif
#ifndef BIT_STATIC
    #define BIT_STATIC 0
#endif
#ifndef BIT_SYNC
    #define BIT_SYNC "bitos,est,mpr,pcre,http,ejs,sqlite"
#endif
#ifndef BIT_TITLE
    #define BIT_TITLE "Embedthis Bit"
#endif
#ifndef BIT_TUNE
    #define BIT_TUNE "size"
#endif
#ifndef BIT_VERSION
    #define BIT_VERSION "0.8.0"
#endif
#ifndef BIT_WARN64TO32
    #define BIT_WARN64TO32 0
#endif
#ifndef BIT_WARN_UNUSED
    #define BIT_WARN_UNUSED 0
#endif
#ifndef BIT_WITHOUT_ALL
    #define BIT_WITHOUT_ALL "dsi,est,man,man2html"
#endif
#ifndef BIT_WITHOUT_DEFAULT
    #define BIT_WITHOUT_DEFAULT "dsi,est,man,man2html"
#endif

/* Prefixes */
#ifndef BIT_CFG_PREFIX
    #define BIT_CFG_PREFIX "/etc/bit"
#endif
#ifndef BIT_BIN_PREFIX
    #define BIT_BIN_PREFIX "/usr/lib/bit/0.8.0/bin"
#endif
#ifndef BIT_INC_PREFIX
    #define BIT_INC_PREFIX "/usr/lib/bit/0.8.0/inc"
#endif
#ifndef BIT_LOG_PREFIX
    #define BIT_LOG_PREFIX "/var/log/bit"
#endif
#ifndef BIT_PRD_PREFIX
    #define BIT_PRD_PREFIX "/usr/lib/bit"
#endif
#ifndef BIT_SPL_PREFIX
    #define BIT_SPL_PREFIX "/var/spool/bit"
#endif
#ifndef BIT_SRC_PREFIX
    #define BIT_SRC_PREFIX "/usr/src/bit-0.8.0"
#endif
#ifndef BIT_VER_PREFIX
    #define BIT_VER_PREFIX "/usr/lib/bit/0.8.0"
#endif
#ifndef BIT_WEB_PREFIX
    #define BIT_WEB_PREFIX "/var/www/bit-default"
#endif

/* Suffixes */
#ifndef BIT_EXE
    #define BIT_EXE ""
#endif
#ifndef BIT_SHLIB
    #define BIT_SHLIB ".so"
#endif
#ifndef BIT_SHOBJ
    #define BIT_SHOBJ ".so"
#endif
#ifndef BIT_LIB
    #define BIT_LIB ".a"
#endif
#ifndef BIT_OBJ
    #define BIT_OBJ ".o"
#endif

/* Profile */
#ifndef BIT_CONFIG_CMD
    #define BIT_CONFIG_CMD "bit -d -q -platform solaris-x86-default -without default -configure . -gen sh,make"
#endif
#ifndef BIT_BIT_PRODUCT
    #define BIT_BIT_PRODUCT 1
#endif
#ifndef BIT_PROFILE
    #define BIT_PROFILE "default"
#endif

/* Miscellaneous */
#ifndef BIT_MAJOR_VERSION
    #define BIT_MAJOR_VERSION 0
#endif
#ifndef BIT_MINOR_VERSION
    #define BIT_MINOR_VERSION 8
#endif
#ifndef BIT_PATCH_VERSION
    #define BIT_PATCH_VERSION 0
#endif
#ifndef BIT_VNUM
    #define BIT_VNUM 00
#endif

/* Packs */
#ifndef BIT_PACK__SQLITE
    #define BIT_PACK__SQLITE 0
#endif
#ifndef BIT_PACK_CC
    #define BIT_PACK_CC 1
#endif
#ifndef BIT_PACK_DEFAULT
    #define BIT_PACK_DEFAULT 0
#endif
#ifndef BIT_PACK_DSI
    #define BIT_PACK_DSI 0
#endif
#ifndef BIT_PACK_EJSCRIPT
    #define BIT_PACK_EJSCRIPT 1
#endif
#ifndef BIT_PACK_EST
    #define BIT_PACK_EST 0
#endif
#ifndef BIT_PACK_HTTP
    #define BIT_PACK_HTTP 1
#endif
#ifndef BIT_PACK_LIB
    #define BIT_PACK_LIB 1
#endif
#ifndef BIT_PACK_LINK
    #define BIT_PACK_LINK 1
#endif
#ifndef BIT_PACK_MAN
    #define BIT_PACK_MAN 0
#endif
#ifndef BIT_PACK_MAN2HTML
    #define BIT_PACK_MAN2HTML 0
#endif
#ifndef BIT_PACK_MATRIXSSL
    #define BIT_PACK_MATRIXSSL 0
#endif
#ifndef BIT_PACK_MOCANA
    #define BIT_PACK_MOCANA 0
#endif
#ifndef BIT_PACK_OPENSSL
    #define BIT_PACK_OPENSSL 0
#endif
#ifndef BIT_PACK_PCRE
    #define BIT_PACK_PCRE 1
#endif
#ifndef BIT_PACK_PMAKER
    #define BIT_PACK_PMAKER 1
#endif
#ifndef BIT_PACK_SQLITE
    #define BIT_PACK_SQLITE 1
#endif
#ifndef BIT_PACK_COMPILER_PATH
    #define BIT_PACK_COMPILER_PATH "/usr/bin/gcc"
#endif
#ifndef BIT_PACK_EJSCRIPT_PATH
    #define BIT_PACK_EJSCRIPT_PATH "/Users/mob/git/bit/src/deps/ejs"
#endif
#ifndef BIT_PACK_HTTP_PATH
    #define BIT_PACK_HTTP_PATH "/Users/mob/git/bit/macosx-x64-debug/bin/http"
#endif
#ifndef BIT_PACK_LIB_PATH
    #define BIT_PACK_LIB_PATH "/usr/bin/ar"
#endif
#ifndef BIT_PACK_LINK_PATH
    #define BIT_PACK_LINK_PATH "/usr/bin/ld"
#endif
#ifndef BIT_PACK_PCRE_PATH
    #define BIT_PACK_PCRE_PATH "/Users/mob/git/bit/src/deps/pcre"
#endif
#ifndef BIT_PACK_PMAKER_PATH
    #define BIT_PACK_PMAKER_PATH "undefined"
#endif
#ifndef BIT_PACK_SQLITE_PATH
    #define BIT_PACK_SQLITE_PATH "/Users/mob/git/bit/src/deps/sqlite"
#endif
