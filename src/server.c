/*
    server.c -- Manage a meta-server with one or more virtual hosts.

    A meta-server supports multiple endpoints and one or more (virtual) hosts.
    Meta Servers may be configured manually or via an "appweb.conf" configuration  file.

    Copyright (c) All Rights Reserved. See copyright notice at the bottom of the file.
 */

/********************************** Includes **********************************/

#include    "appweb.h"

/***************************** Forward Declarations ***************************/

static int appwebDestructor(MaAppweb *appweb);

/************************************ Code ************************************/
/*
    Create the top level appweb control object. This is typically a singleton.
 */
MaAppweb *maCreateAppweb(MprCtx ctx)
{
    MaAppweb    *appweb;
    Http        *http;

    appweb = mprAllocObjWithDestructorZeroed(ctx, MaAppweb, appwebDestructor);
    if (appweb == 0) {
        return 0;
    }
    appweb->servers = mprCreateList(appweb);
    appweb->http = http = httpCreate(appweb);
    httpSetContext(http, appweb);
    maGetUserGroup(appweb);
    maOpenDirHandler(http);
    maOpenEgiHandler(http);
    maOpenFileHandler(http);
    return appweb;
}


static int appwebDestructor(MaAppweb *appweb)
{
    /* TODO - should this call stop? */
    maUnloadStaticModules(appweb);
    return 0;
}


void maAddServer(MaAppweb *appweb, MaServer *server)
{
    mprAddItem(appweb->servers, server);
}


void maSetDefaultServer(MaAppweb *appweb, MaServer *server)
{
    appweb->defaultServer = server;
}


//  TODO - standardize on Find, Lookup, Get
MaServer *maLookupServer(MaAppweb *appweb, cchar *name)
{
    MaServer    *server;
    int         next;

    for (next = 0; (server = mprGetNextItem(appweb->servers, &next)) != 0; ) {
        if (strcmp(server->name, name) == 0) {
            return server;
        }
    }
    return 0;
}


int maStartAppweb(MaAppweb *appweb)
{
    MaServer    *server;
    Http        *http;
    char        *timeText;
    int         next;

    http = appweb->http;
    for (next = 0; (server = mprGetNextItem(appweb->servers, &next)) != 0; ) {
        maValidateConfiguration(server);
        if (maStartServer(server) < 0) {
            return MPR_ERR_CANT_INITIALIZE;
        }
    }
    timeText = mprFormatLocalTime(appweb, mprGetTime(appweb));
    mprLog(appweb, 1, "HTTP services Started at %s with max %d threads", timeText, mprGetMaxWorkers(appweb));
    mprFree(timeText);
    return 0;
}


int maStopAppweb(MaAppweb *appweb)
{
    MaServer    *server;
    int         next;

    for (next = 0; (server = mprGetNextItem(appweb->servers, &next)) != 0; ) {
        maStopServer(server);
    }
    return 0;
}


/*  
    Create a new meta-server. This may manage may virtual hosts. If ip and port are supplied,
    create a HttpServer now on that endpoint. Otherwise, call maConfigureServer later.
 */
MaServer *maCreateServer(MaAppweb *appweb, cchar *name, cchar *root, cchar *ip, int port)
{
    MaServer    *server;
    static int  staticModulesLoaded = 0;

    mprAssert(appweb);
    mprAssert(name && *name);

    server = mprAllocObjZeroed(appweb, MaServer);
    if (server == 0) {
        return 0;
    }
    server->hosts = mprCreateList(server);
    server->httpServers = mprCreateList(server);
    server->hostAddresses = mprCreateList(server);
    server->name = mprStrdup(server, name);
    server->appweb = appweb;
    server->http = appweb->http;

    maAddServer(appweb, server);
    maSetServerRoot(server, root);

    if (ip && port > 0) {
        maAddHttpServer(server, httpCreateServer(appweb->http, ip, port, NULL));
        maAddHostAddress(server, ip, port);
    }
    maSetDefaultServer(appweb, server);

    if (!staticModulesLoaded) {
        staticModulesLoaded = 1;
        maLoadStaticModules(appweb);
    }
    return server;
}


int maStartServer(MaServer *server)
{
    MaHost      *host;
    HttpServer  *httpServer;
    int         next, nextHost, count, warned;

    for (next = 0; (host = mprGetNextItem(server->hosts, &next)) != 0; ) {
        if (maStartHost(host) < 0) {
            return MPR_ERR_CANT_INITIALIZE;
        }
    }

    /*  
        Start the Http servers and being listening for requests
     */
    warned = 0;
    count = 0;
    for (next = 0; (httpServer = mprGetNextItem(server->httpServers, &next)) != 0; ) {
        httpSetMetaServer(httpServer, server);
        /*
            Define a server notifier. This will be inherited by all accepted connections on the server
         */
        httpSetServerNotifier(httpServer, (HttpNotifier) maNotifyServerStateChange);
        if (httpStartServer(httpServer) < 0) {
            warned++;
            break;
        } else {
            count++;
        }
    }
    if (count == 0) {
        if (!warned) {
            mprError(server, "Server is not listening on any addresses");
        }
        return MPR_ERR_CANT_OPEN;
    }
    if (maApplyChangedGroup(server->appweb) < 0 || maApplyChangedUser(server->appweb) < 0) {
        return MPR_ERR_CANT_COMPLETE;
    }
    for (nextHost = 0; (host = mprGetNextItem(server->hosts, &nextHost)) != 0; ) {
        mprLog(server, 3, "Serving %s at \"%s\"", host->name, host->documentRoot);
    }
    return 0;
}


int maStopServer(MaServer *server)
{
    MaHost      *host;
    HttpServer  *httpServer;
    int         next;

    for (next = 0; (host = mprGetNextItem(server->hosts, &next)) != 0; ) {
        maStopHost(host);
    }
    for (next = 0; (httpServer = mprGetNextItem(server->httpServers, &next)) != 0; ) {
        httpStopServer(httpServer);
    }
    return 0;
}


void maAddHost(MaServer *server, MaHost *host)
{
    mprAddItem(server->hosts, host);
}


void maAddHttpServer(MaServer *server, HttpServer *httpServer)
{
    mprAddItem(server->httpServers, httpServer);
}


MaHost *maLookupHost(MaServer *server, cchar *name)
{
    MaHost  *host;
    int     next;

    for (next = 0; (host = mprGetNextItem(server->hosts, &next)) != 0; ) {
        if (strcmp(host->name, name) == 0) {
            return host;
        }
    }
    return 0;
}


MaHostAddress *maAddHostAddress(MaServer *server, cchar *ip, int port)
{
    MaHostAddress   *address;

    address = maCreateHostAddress(server, ip, port);
    mprAddItem(server->hostAddresses, address);
    return address;
}


/*  
    Lookup a host address. If ipAddr is null or port is -1, then those elements are wild.
 */
MaHostAddress *maLookupHostAddress(MaServer *server, cchar *ip, int port)
{
    MaHostAddress   *address;
    int             next;

    for (next = 0; (address = mprGetNextItem(server->hostAddresses, &next)) != 0; ) {
        if (address->port < 0 || port < 0 || address->port == port) {
            if (ip == 0 || address->ip == 0 || strcmp(address->ip, ip) == 0) {
                return address;
            }
        }
    }
    return 0;
}


MaHostAddress *maRemoveHostFromHostAddress(MaServer *server, cchar *ip, int port, MaHost *host)
{
    MaHostAddress   *address;
    MaHost          *hp;
    int             next, nextHost;

    for (next = 0; (address = mprGetNextItem(server->hostAddresses, &next)) != 0; ) {
        if (address->port < 0 || port < 0 || address->port == port) {
            if (ip == 0 || address->ip == 0 || strcmp(address->ip, ip) == 0) {
                for (nextHost = 0; (hp = mprGetNextItem(address->vhosts, &nextHost)) != 0; ) {
                    if (hp == host) {
                        mprRemoveItem(address->vhosts, hp);
                        nextHost--;
                    }
                }
            }
        }
    }
    return 0;
}


/*  
    Create the host addresses for a host. Called for hosts or for NameVirtualHost directives (host == 0).
 */
int maCreateHostAddresses(MaServer *server, MaHost *host, cchar *configValue)
{
    HttpServer      *httpServer;
    MaHostAddress   *address;
    char            *ipAddrPort, *ip, *value, *tok;
    char            addrBuf[MPR_MAX_IP_ADDR_PORT];
    int             next, port;

    address = 0;
    value = mprStrdup(server, configValue);
    ipAddrPort = mprStrTok(value, " \t", &tok);

    while (ipAddrPort) {
        if (mprStrcmpAnyCase(ipAddrPort, "_default_") == 0) {
            //  TODO is this used?
            mprAssert(0);
            ipAddrPort = "*:*";
        }

        if (mprParseIp(server, ipAddrPort, &ip, &port, -1) < 0) {
            mprError(server, "Can't parse ipAddr %s", ipAddrPort);
            continue;
        }
        mprAssert(ip && *ip);
        if (ip[0] == '*') {
            ip = mprStrdup(server, "");
        }

        /*  
            For each listening endpiont,
         */
        for (next = 0; (httpServer = mprGetNextItem(server->httpServers, &next)) != 0; ) {
            if (port > 0 && port != httpServer->port) {
                continue;
            }
            if (httpServer->ip[0] != '\0' && ip[0] != '\0' && strcmp(ip, httpServer->ip) != 0) {
                continue;
            }

            /*
                Find the matching host address or create a new one
             */
            if ((address = maLookupHostAddress(server, httpServer->ip, httpServer->port)) == 0) {
                address = maCreateHostAddress(server, httpServer->ip, httpServer->port);
                mprAddItem(server->hostAddresses, address);
            }

            /*
                If a host is specified
             */
            if (host == 0) {
                maSetNamedVirtualHostAddress(address);

            } else {
                maInsertVirtualHost(address, host);
                if (httpServer->ip[0] != '\0') {
                    mprSprintf(server, addrBuf, sizeof(addrBuf), "%s:%d", httpServer->ip, httpServer->port);
                } else {
                    mprSprintf(server, addrBuf, sizeof(addrBuf), "%s:%d", ip, httpServer->port);
                }
                maSetHostName(host, addrBuf);
            }
        }
        mprFree(ip);
        ipAddrPort = mprStrTok(0, " \t", &tok);
    }

    if (host) {
        if (address == 0) {
            mprError(server, "No valid IP address for host %s", host->name);
            mprFree(value);
            return MPR_ERR_CANT_INITIALIZE;
        }
        if (maIsNamedVirtualHostAddress(address)) {
            maSetNamedVirtualHost(host);
        }
    }
    mprFree(value);
    return 0;
}


/*  
    Set the Server Root directory. We convert path into an absolute path.
 */
void maSetServerRoot(MaServer *server, cchar *path)
{
    if (path == 0 || BLD_FEATURE_ROMFS) {
        path = ".";
    }
#if !VXWORKS
    /*
        VxWorks stat() is broken if using a network FTP server.
     */
    if (! mprPathExists(server, path, R_OK)) {
        mprError(server, "Can't access ServerRoot directory %s", path);
        return;
    }
#endif
    mprFree(server->serverRoot);
    server->serverRoot = mprGetAbsPath(server, path);
}


/*
    Set the document root for the default server (only)
 */
void maSetDocumentRoot(MaServer *server, cchar *path)
{
    HttpServer  *httpServer;
    MaHost      *host;
    int         next;

    maSetHostDirs(server->defaultHost, path);
    for (next = 0; ((httpServer = mprGetNextItem(server->httpServers, &next)) != 0); ) {
        httpSetDocumentRoot(httpServer, path);
    }
    for (next = 0; (host = mprGetNextItem(server->hosts, &next)) != 0; ) {
        maSetHostDocumentRoot(host, path);
    }
}


/*
    Set the document root for the default server (only)
 */
void maSetIpAddr(MaServer *server, cchar *ip, int port)
{
    HttpServer  *httpServer;
    char        ipAddrPort[MPR_MAX_IP_ADDR_PORT];
    int         next;

    mprSprintf(server, ipAddrPort, sizeof(ipAddrPort), "%s:%d", ip ? ip : "*", port > 0 ? port : HTTP_DEFAULT_PORT);

    for (next = 0; ((httpServer = mprGetNextItem(server->httpServers, &next)) != 0); ) {
        httpSetIpAddr(httpServer, ip, port);
        maSetHostIpAddrPort(server->defaultHost, ipAddrPort);
    }
}


void maSetDefaultHost(MaServer *server, MaHost *host)
{
    server->defaultHost = host;
}


#if UNUSED
void maSetKeepAliveTimeout(MaAppweb *appweb, int timeout)
{
    //  MOB -- API needed
    appweb->http->limits->inactivityTimeout = timeout;
}


//  MOB -- is this used?
void maSetMaxKeepAlive(MaAppweb *appweb, int timeout)
{
    //  MOB -- API needed
    appweb->http->limits->keepAliveCount = timeout;
}


/*  
    Set the default request timeout. This is the maximum time a request can run.
    Not to be confused with the session timeout or the keep alive timeout.
 */
void maSetTimeout(MaAppweb *appweb, int timeout)
{
    //  MOB -- API needed
    appweb->http->limits->requestTimeout = timeout * MPR_TICKS_PER_SEC;
}
#endif


/*
    @copy   default

    Copyright (c) Embedthis Software LLC, 2003-2010. All Rights Reserved.
    Copyright (c) Michael O'Brien, 1993-2010. All Rights Reserved.

    This software is distributed under commercial and open source licenses.
    You may use the GPL open source license described below or you may acquire
    a commercial license from Embedthis Software. You agree to be fully bound
    by the terms of either license. Consult the LICENSE.TXT distributed with
    this software for full details.

    This software is open source; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the
    Free Software Foundation; either version 2 of the License, or (at your
    option) any later version. See the GNU General Public License for more
    details at: http://www.embedthis.com/downloads/gplLicense.html

    This program is distributed WITHOUT ANY WARRANTY; without even the
    implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    This GPL license does NOT permit incorporating this software into
    proprietary programs. If you are unable to comply with the GPL, you must
    acquire a commercial license to use this software. Commercial licenses
    for this software and support services are available from Embedthis
    Software at http://www.embedthis.com

    @end
 */
