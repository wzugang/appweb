/*
    bit.h -- Build It Configuration Header for linux-x86

    This header is generated by Bit during configuration.
    You may edit this file, but Bit will overwrite it next
    time configuration is performed.
 */

/* Settings */
#define BIT__MINIMAL "doxygen,dsi,ejs,man,man2html,pmaker"
#define BIT_BUILD_NUMBER "0"
#define BIT_COMPANY "Embedthis"
#define BIT_DEPTH 1
#define BIT_EJS_ONE_MODULE 1
#define BIT_HAS_DOUBLE_BRACES 0
#define BIT_HAS_DYN_LOAD 1
#define BIT_HAS_LIB_EDIT 0
#define BIT_HAS_MMU 1
#define BIT_HAS_MTUNE 1
#define BIT_HAS_PAM 0
#define BIT_HAS_STACK_PROTECTOR 1
#define BIT_HAS_SYNC 1
#define BIT_HAS_SYNC_CAS 1
#define BIT_HAS_UNNAMED_UNIONS 1
#define BIT_HTTP_PORT 80
#define BIT_MANAGER "appman"
#define BIT_MDB 1
#define BIT_MINIMAL "doxygen,dsi,ejs,man,man2html,pmaker,ssl,ejscript,php,matrixssl,openssl"
#define BIT_OPTIONAL "cgi,dir,doxygen,dsi,ejs,ejscript,esp,man,man2html,openssl,matrixssl,pmaker,php,sqlite,ssl,utest,zip,zlib"
#define BIT_PACKS "bits/packs"
#define BIT_PAM 1
#define BIT_PLATFORMS "local"
#define BIT_PRODUCT "appweb"
#define BIT_REQUIRED "compiler,link,pcre"
#define BIT_SDB 0
#define BIT_SSL_PORT 443
#define BIT_SYNC "http,mpr,pcre,sqlite"
#define BIT_TITLE "Embedthis Appweb"
#define BIT_VERSION "4.1.0"
#define BIT_WARN64TO32 0
#define BIT_WARN_UNUSED 1

/* Prefixes */
#define BIT_CFG_PREFIX "/etc/appweb"
#define BIT_BIN_PREFIX "/usr/lib/appweb/4.1.0/bin"
#define BIT_INC_PREFIX "/usr/lib/appweb/4.1.0/inc"
#define BIT_LOG_PREFIX "/var/log/appweb"
#define BIT_PRD_PREFIX "/usr/lib/appweb"
#define BIT_SPL_PREFIX "/var/spool/appweb"
#define BIT_SRC_PREFIX "/usr/src/appweb-4.1.0"
#define BIT_VER_PREFIX "/usr/lib/appweb/4.1.0"
#define BIT_WEB_PREFIX "/var/www/appweb-default"

/* Suffixes */
#define BIT_EXE ""
#define BIT_SHLIB ".so"
#define BIT_SHOBJ ".so"
#define BIT_LIB ".a"
#define BIT_OBJ ".o"

/* Profile */
#define BIT_APPWEB_PRODUCT 1
#define BIT_PROFILE "debug"
#define BIT_CONFIG_CMD "bit -d -q -platform linux-x86 -without all -configure . -gen sh,make"

/* Miscellaneous */
#define BIT_MAJOR_VERSION 4
#define BIT_MINOR_VERSION 1
#define BIT_PATCH_VERSION 0
#define BIT_VNUM 400010000

/* Packs */
#define BIT_PACK_CGI 1
#define BIT_PACK_CC 1
#define BIT_PACK_DIR 1
#define BIT_PACK_DOXYGEN 0
#define BIT_PACK_DSI 0
#define BIT_PACK_EJS 0
#define BIT_PACK_EJSCRIPT 0
#define BIT_PACK_ESP 1
#define BIT_PACK_HTTP 1
#define BIT_PACK_LINK 1
#define BIT_PACK_MAN 0
#define BIT_PACK_MAN2HTML 0
#define BIT_PACK_MATRIXSSL 0
#define BIT_PACK_OPENSSL 0
#define BIT_PACK_PCRE 1
#define BIT_PACK_PHP 0
#define BIT_PACK_PMAKER 0
#define BIT_PACK_SQLITE 1
#define BIT_PACK_SSL 0
#define BIT_PACK_UTEST 1
#define BIT_PACK_ZIP 1
#define BIT_PACK_ZLIB 0
