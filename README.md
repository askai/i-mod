i_openwrt_mod
==============

Install
-------

Add this line to your feeds.conf.default.

    src-git imod git://github.com/askai/i-mod.git 

And run

    ./scripts/feeds update -a && ./scripts/feeds install -a && make menuconfig

安装
-------
在feeds.conf.default文件末尾添加：

    src-git imod git://github.com/askai/i-mod.git 
运行下面一行命令：

    ./scripts/feeds update -a && ./scripts/feeds install -a && make menuconfig
