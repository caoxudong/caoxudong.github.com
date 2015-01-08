---
category:   pages
layout:     post
tag:        [memcache]
---



memcache中超时时间的设置
=====================



先贴一段memcache中的注释：

    #define REALTIME_MAXDELTA 60*60*24*30
    
    /*
     * given time value that's either unix time or delta from current unix time, return
     * unix time. Use the fact that delta can't exceed one month (and real time value can't
     * be that low).
     */
    static rel_time_t realtime(const time_t exptime) {
        /* no. of seconds in 30 days - largest possible delta exptime */
    
        if (exptime == 0) return 0; /* 0 means never expire */
    
        if (exptime > REALTIME_MAXDELTA) {
            /* if item expiration is at/before the server started, give it an
               expiration time of 1 second after the server started.
               (because 0 means don't expire).  without this, we'd
               underflow and wrap around to some large value way in the
               future, effectively making items expiring in the past
               really expiring never */
            if (exptime <= process_started)
                return (rel_time_t)1;
            return (rel_time_t)(exptime - process_started);
        } else {
            return (rel_time_t)(exptime + current_time);
        }
    }

注释里说了，

* 0 - 不过期
* 小于30天 - 作为自现在开始的超时偏移值处理
* 大于30天 - 转换为标准时间点处理
    * 如果时间点在程序启动之前 - 返回1
	* 如果时间点在程序启动之后 - 返回自程序启动之后的偏移值
