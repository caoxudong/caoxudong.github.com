---
category:   pages
layout:     post
tag:        [java, network]
---


获取本机ip信息
==================


今天同事说道，使用`InetAddress`类无法在mac上获取到本机ip和主机名，而在服务器linux上就可以。

下面以`jdk_1.7.0_25`加以说明。

首先，对于主机名的问题，linux服务器上在`/etc/hostname`文件中做了设置，所以能查出；而在mac上，作为开发机，并没有做相关配置，所以查不到。

然后，在`InetAddress.getLocalHost`方法中，会根据主机名做判断，如果是`localhost`就返回ip为`127.0.0.1`的接口对象，否则会通过名字服务器来查找本地的ip，并返回相关对象。如下所示：

    public static InetAddress getLocalHost() throws UnknownHostException {

        SecurityManager security = System.getSecurityManager();
        try {
            String local = impl.getLocalHostName();

            if (security != null) {
                security.checkConnect(local, -1);
            }

            if (local.equals("localhost")) {
                return impl.loopbackAddress();
            }

            InetAddress ret = null;
            synchronized (cacheLock) {
                long now = System.currentTimeMillis();
                if (cachedLocalHost != null) {
                    if ((now - cacheTime) < maxCacheTime) // Less than 5s old?
                        ret = cachedLocalHost;
                    else
                        cachedLocalHost = null;
                }

                // we are calling getAddressesFromNameService directly
                // to avoid getting localHost from cache
                if (ret == null) {
                    InetAddress[] localAddrs;
                    try {
                        localAddrs =
                            InetAddress.getAddressesFromNameService(local, null);
                    } catch (UnknownHostException uhe) {
                        // Rethrow with a more informative error message.
                        UnknownHostException uhe2 =
                            new UnknownHostException(local + ": " +
                                                     uhe.getMessage());
                        uhe2.initCause(uhe);
                        throw uhe2;
                    }
                    cachedLocalHost = localAddrs[0];
                    cacheTime = now;
                    ret = localAddrs[0];
                }
            }
            return ret;
        } catch (java.lang.SecurityException e) {
            return impl.loopbackAddress();
        }
    }

针对上面的问题，可以使用NetworkInterface类来处理，该类用于获取本机网络接口信息，可以正确的拿到ip和主机名信息。

NetworkInterface类的getAll方法中会获取本地所有网络接口，是一个本地方法，其在bsd上的实现[NetworkInterface.c][1]是：

	/*
     * Class:     java_net_NetworkInterface
     * Method:    getAll
     * Signature: ()[Ljava/net/NetworkInterface;
     */
    JNIEXPORT jobjectArray JNICALL Java_java_net_NetworkInterface_getAll(JNIEnv *env, jclass cls) {
    
        netif *ifs, *curr;
        jobjectArray netIFArr;
        jint arr_index, ifCount;
    
        ifs = enumInterfaces(env);
        if (ifs == NULL) {
            return NULL;
        }
    
        /* count the interface */
        ifCount = 0;
        curr = ifs;
        while (curr != NULL) {
            ifCount++;
            curr = curr->next;
        }
    
        /* allocate a NetworkInterface array */
        netIFArr = (*env)->NewObjectArray(env, ifCount, cls, NULL);
        if (netIFArr == NULL) {
            freeif(ifs);
            return NULL;
        }
    
        /*
         * Iterate through the interfaces, create a NetworkInterface instance
         * for each array element and populate the object.
         */
        curr = ifs;
        arr_index = 0;
        while (curr != NULL) {
            jobject netifObj;
    
            netifObj = createNetworkInterface(env, curr);
            if (netifObj == NULL) {
                freeif(ifs);
                return NULL;
            }
    
            /* put the NetworkInterface into the array */
            (*env)->SetObjectArrayElement(env, netIFArr, arr_index++, netifObj);
    
            curr = curr->next;
        }
    
        freeif(ifs);
        return netIFArr;
    }

相关的主要方法是`enumIPv4Interfaces`，该方法会在`enumInterfaces`方法中被调用。`enumIPv4Interfaces`方法的主要功能是遍历所有IPv4网络接口，创建相关对象并返回，其具体实现为：
    
    /*
     * Enumerates and returns all IPv4 interfaces
     */
    static netif *enumIPv4Interfaces(JNIEnv *env, int sock, netif *ifs) {
        struct ifaddrs *ifa, *origifa;
    
        if (getifaddrs(&origifa) != 0) {
            NET_ThrowByNameWithLastError(env , JNU_JAVANETPKG "SocketException",
                         "getifaddrs() function failed");
            return ifs;
        }
    
        for (ifa = origifa; ifa != NULL; ifa = ifa->ifa_next) {
    
            /*
             * Skip non-AF_INET entries.
             */
            if (ifa->ifa_addr == NULL || ifa->ifa_addr->sa_family != AF_INET)
                continue;
    
            /*
             * Add to the list.
             */
            ifs = addif(env, sock, ifa->ifa_name, ifs, ifa->ifa_addr, AF_INET, 0);
    
            /*
             * If an exception occurred then free the list.
             */
            if ((*env)->ExceptionOccurred(env)) {
                freeifaddrs(origifa);
                freeif(ifs);
                return NULL;
            }
        }
    
        /*
         * Free socket and buffer
         */
        freeifaddrs(origifa);
        return ifs;
    }




[1]:    http://hg.openjdk.java.net/jdk7u/jdk7u/jdk/file/861e489158ef/src/solaris/native/java/net/NetworkInterface.c
