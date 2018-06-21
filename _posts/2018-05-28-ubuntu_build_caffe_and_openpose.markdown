---
title:      Ubuntu-16.04-LTS编译Caffe和OpenPose
layout:     post
category:   blog
tags:       [ubuntu, deeplearning, caffe, openpose]
---

>ubuntu版本，16.04-LTS
>
>参考文档，https://chunml.github.io/ChunML.github.io/project/Installing-Caffe-CPU-Only/
>
>知乎连接，https://zhuanlan.zhihu.com/p/37389382


单独安装 Caffe

1. 安装各种依赖包

        sudo apt-get install -y --no-install-recommends libboost-all-dev
        sudo apt-get install -y --no-install-recommends libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-serial-dev libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler libopenblas-dev libatlas-base-dev 

1. 下载caffe

        git clone https://github.com/BVLC/caffe
        cd caffe
        export CAFFE_HOME=${PWD}

1. 安装python依赖

        sudo apt-get install -y --no-install-recommends python-pip
        export LC_ALL=C
        sudo pip install scikit-image protobuf
        cd ${CAFFE_HOME}/python
        for req in $(cat requirements.txt); do sudo pip install $req; done

1. 修改caffe的Makefile文件

        cd ${CAFFE_HOME}
        vim Makefile.config

    几个需要调整的内容如下，其他地方按需调整

    1. 使用CPU还是GPU

                # CPU-only switch (uncomment to build without GPU support).
                CPU_ONLY := 1


    1. 设置OpenCV版本
    
                # Uncomment if you're using OpenCV 3
                OPENCV_VERSION := 3


    1. 设置anaconda目录

                # ANACONDA_HOME := $(HOME)/anaconda2
                # PYTHON_LIB := $(ANACONDA_HOME)/lib

1. 构建

        make all


遇到错误


1. 编译失败，缺少openlabs

    错误 

        In file included from ./include/caffe/util/math_functions.hpp:11:0,
                 from src/caffe/data_transformer.cpp:10:
        ./include/caffe/util/mkl_alternate.hpp:14:19: fatal error: cblas.h: No such file or directory
        compilation terminated.
        Makefile:581: recipe for target '.build_release/src/caffe/data_transformer.o' failed
        make: *** [.build_release/src/caffe/data_transformer.o] Error 1

    解决

        sudo apt-get install libopenblas-dev

1. 编译失败，找不到文件`hdf5.h`

    错误

        src/caffe/layers/hdf5_data_layer.cpp:13:18: fatal error: hdf5.h: No such file or directory
        compilation terminated.
        Makefile:581: recipe for target '.build_release/src/caffe/layers/hdf5_data_layer.o' failed
        make: *** [.build_release/src/caffe/layers/hdf5_data_layer.o] Error 1

    解决

        查找 hdf5.h 文件的位置，例如在 /usr/include/hdf5/serial/hdf5.h
        修改Makefile.config，修改属性 INCLUDE_PATH，添加属性值 /usr/include/hdf5/serial

1. 链接失败，找不到文件 `hdf5_hl` `hdf5` `cblas` `atlas`

    错误

        LD -o .build_release/lib/libcaffe.so.1.0.0
        /usr/bin/ld: cannot find -lhdf5_hl
        /usr/bin/ld: cannot find -lhdf5
        collect2: error: ld returned 1 exit status
        Makefile:572: recipe for target '.build_release/lib/libcaffe.so.1.0.0' failed
        make: *** [.build_release/lib/libcaffe.so.1.0.0] Error 1

    解决

        locate查找文件的文件，然后添加到 Makefile.config 文件中 LIBEARY_DIS 属性的值里
        

1. 链接失败，找不到文件`lcblas` `latlas`

    错误

        LD -o .build_release/lib/libcaffe.so.1.0.0
        /usr/bin/ld: cannot find -lcblas
        /usr/bin/ld: cannot find -latlas
        collect2: error: ld returned 1 exit status
        Makefile:572: recipe for target '.build_release/lib/libcaffe.so.1.0.0' failed
        make: *** [.build_release/lib/libcaffe.so.1.0.0] Error 1

    解决

        安装库 atlas-base-dev库，sudo apt-get install libatlas-base-dev

1. 执行`make distribute`时找不到`arrayobject.h`文件


    错误

        CXX/LD -o python/caffe/_caffe.so python/caffe/_caffe.cpp
        python/caffe/_caffe.cpp:10:31: fatal error: numpy/arrayobject.h: No such file or directory
        compilation terminated.
        Makefile:507: recipe for target 'python/caffe/_caffe.so' failed
        make: *** [python/caffe/_caffe.so] Error 1
    
    解决

        sudo apt-get install python-numpy



安装openpose

其实OpenPose中自带了caffe的安装方法，并不需要再单独查询。

1. 下载openpose

        git clone git@github.com:CMU-Perceptual-Computing-Lab/openpose.git
        cd openpose
        export OPENPOSE_HOME=${PWD}

1. 编译CPU版本

    修改CMakeLists.txt文件
    
    * 注释掉`set(GPU_MODE CUDA CACHE STRING "Select the acceleration GPU library or CPU otherwise.")`
    * 添加`set(GPU_MODE CPU_ONLY CACHE STRING "No GPU, CPU ONLY")`        

1. 执行cmake

        mkdir build
        cd build
        cmake ..
        make -j`nproc`


遇到的错误

1. 找不到`mlsl.hpp`文件

错误

        In file included from /home/caoxudong/workspace/openpose/3rdparty/caffe/src/caffe/multinode/mlsl.cpp:42:0:
        /home/caoxudong/workspace/openpose/3rdparty/caffe/include/caffe/multinode/mlsl.hpp:43:20: fatal error: mlsl.hpp: No such file or directory
        compilation terminated.
        src/caffe/CMakeFiles/caffe.dir/build.make:86: recipe for target 'src/caffe/CMakeFiles/caffe.dir/multinode/mlsl.cpp.o' failed
        make[5]: *** [src/caffe/CMakeFiles/caffe.dir/multinode/mlsl.cpp.o] Error 1
        make[5]: *** Waiting for unfinished jobs....
        In file included from /home/caoxudong/workspace/openpose/3rdparty/caffe/include/caffe/syncedmem.hpp:51:0,
                        from /home/caoxudong/workspace/openpose/3rdparty/caffe/include/caffe/blob.hpp:47,
                        from /home/caoxudong/workspace/openpose/3rdparty/caffe/include/caffe/mkldnn_memory.hpp:45,
                        from /home/caoxudong/workspace/openpose/3rdparty/caffe/src/caffe/mkldnn_base.cpp:39:
        /home/caoxudong/workspace/openpose/3rdparty/caffe/include/caffe/multinode/mlsl.hpp:43:20: fatal error: mlsl.hpp: No such file or directory
        compilation terminated.
        src/caffe/CMakeFiles/caffe.dir/build.make:62: recipe for target 'src/caffe/CMakeFiles/caffe.dir/mkldnn_base.cpp.o' failed
        make[5]: *** [src/caffe/CMakeFiles/caffe.dir/mkldnn_base.cpp.o] Error 1
        CMakeFiles/Makefile2:340: recipe for target 'src/caffe/CMakeFiles/caffe.dir/all' failed
        make[4]: *** [src/caffe/CMakeFiles/caffe.dir/all] Error 2
        Makefile:127: recipe for target 'all' failed
        make[3]: *** [all] Error 2
        CMakeFiles/openpose_caffe.dir/build.make:110: recipe for target 'caffe/src/openpose_caffe-stamp/openpose_caffe-build' failed
        make[2]: *** [caffe/src/openpose_caffe-stamp/openpose_caffe-build] Error 2
        CMakeFiles/Makefile2:67: recipe for target 'CMakeFiles/openpose_caffe.dir/all' failed
        make[1]: *** [CMakeFiles/openpose_caffe.dir/all] Error 2
        Makefile:83: recipe for target 'all' failed
        make: *** [all] Error 2

解决

        查看文件夹"/home/caoxudong/workspace/openpose/3rdparty/caffe/external/mkl"中的压缩包是否正常，是否解压了。
        若文件不正常，删除重新下载压缩包" mklml_lnx"，再重新编译