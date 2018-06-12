---
title:      OpenPose命令行参数记录
layout:     post
category:   blog
tags:       [deeplearning, openpose]
---

# Flags from /home/vagrant/software/openpose/examples/openpose/openpose.cpp:

* `-3d`

        -3d (Running OpenPose 3-D reconstruction demo: 1) Reading from a stereo camera system. 2) Performing 3-D reconstruction from the multiple views. 3) Displaying 3-D reconstruction results. Note that it will only display 1 person. If multiple people is present, it will fail.) type: bool default: false

类型为`bool`，默认值为`false`

指定该参数后，openpose会执行一下动作

1. 从摄像头中读取数据
1. 从多视图中执行3D重构
1. 展示3D重构结果

需要注意的是，这里只能展示1个人，如果有多个的话，会执行失败。

* `-3d_min_views`

        -3d_min_views (Minimum number of views required to reconstruct each keypoint. By default (-1), it will require all the cameras to see the keypoint in order to reconstruct it.) type: int32 default: -1

类型为`int32`，默认值为`-1`

该参数用于指定重构关键点(keypoint)是所用的视图的最小数量。默认值为-1，表示使用所有的摄像头。

* `-3d_views`

        -3d_views (Complementary option to `--image_dir` or `--video`. OpenPose will read as many images per iteration, allowing tasks such as stereo camera processing (`--3d`). Note that `--camera_parameters_folder` must be set. OpenPose must find as many `xml` files in the parameter folder as this number indicates.) type: int32 default: 1

类型为`int32`，默认值为`1`

该参数与参数`--image_dir`或`--video`共同使用。该参数用于指定openpose在每次迭代时所读取的图片的数量。注意，使用参数时，必须同时使用参数`--camera_parameters_folder`，并且在该文件家中，openpose必须能否读取到足够多的`xml`文件，文件的数量由`-3d_views`指定。

* `-alpha_heatmap`

        -alpha_heatmap (Blending factor (range 0-1) between heatmap and original frame. 1 will only show the heatmap, 0 will only show the frame. Only valid for GPU rendering.) type: double default: 0.69999999999999996

类型为`double`，默认值为`0.69999999999999996`

该参数指定热点图(heatmap)和原始图的混合度。若参数值为`1`，则只显示热点图，若参数值为`0`，则只显示原始图。该参数仅对GPU渲染有效。

* `-alpha_pose`

        -alpha_pose (Blending factor (range 0-1) for the body part rendering. 1 will show it completely, 0 will hide it. Only valid for GPU rendering.) type: double default: 0.59999999999999998

类型为`double`，默认值为`0.59999999999999998`

该参数用于指定身体渲染的混合度。若参数之为`1`，则完全渲染，若参数值为`0`，则隐藏身体渲染。该参数仅对GPU渲染有效。

* `-body_disable`

        -body_disable (Disable body keypoint detection. Option only possible for faster (but less accurate) face keypoint detection.) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于禁用身体关键点(keypoint)检测。一般情况下，使用该参数是为了加快面部关键点检测（但会有精度损失）。

* `-camera`

        -camera (The camera index for cv::VideoCapture. Integer in the range [0,9]. Select a negative number (by default), to auto-detect and open the first available camera.) type: int32 default: -1

类型为`int32`，默认值为`-1`

该参数用于指定`cv::VideoCapture`的摄像头索引值，索引值的有效范围是`[0,9]`。若参数值为负数，则会自动检测并打开第一个可用的摄像头。

* `-camera_fps`

        -camera_fps (Frame rate for the webcam (also used when saving video). Set this value to the minimum value between the OpenPose displayed speed and the webcam real frame rate.) type: double default: 30

类型为`double`，默认值为`30`

该参数用于指定摄像头的帧率，在保存视频的时候也会用到该参数。应该将该参数值设置为openpose展示速度和摄像头真实帧率两者间较小的一个。

* `-camera_parameter_folder`
        
        -camera_parameter_folder (String with the folder where the camera parameters are located.) type: string default: "models/cameraParameters/flir/"        

类型为`string`，默认值为`models/cameraParameters/flir/`

该参数用与指定摄像头参数文件所在的文件夹路径。

* `-camera_resolution`

        -camera_resolution (Set the camera resolution (either `--camera` or `--flir_camera`). `-1x-1` will use the default 1280x720 for `--camera`, or the maximum flir camera resolution available for `--flir_camera`) type: string default: "-1x-1"

类型为`string`，默认值为`-1x-1`

该参数用与指定摄像头分辨率(也可以通过参数`--camera`或`--flir_camera`指定)。参数值`-1x-1`表示使用默认分辨率`1280x720`，莫否会使用参数`--flir_camera`可使用的最大FLIR摄像头分辨率。

* `-disable_blending`

        -disable_blending (If enabled, it will render the results (keypoint skeletons or heatmaps) on a black background, instead of being rendered into the original image. Related: `part_to_show`, `alpha_pose`, and `alpha_pose`.) type: bool default: false

类型为`bool`，默认值为`false`

指定该参数用后，openpose会在黑色背景中渲染结果(关键点或热点图)，而不会在原始图上渲染。相关参数`part_to_show`，`alpha_pose`。

* `-disable_multi_thread`

        -disable_multi_thread (It would slightly reduce the frame rate in order to highly reduce the lag. Mainly useful for 1) Cases where it is needed a low latency (e.g. webcam in real-time scenarios with low-range GPU devices); and 2) Debugging OpenPose when it is crashing to locate the error.) type: bool default: false

类型为`bool`，默认值为`false`

使用该参数后会降低延迟，但同时也会降低帧率。

该参数的主要应用场景

1. 带有低延迟GPU设备的实时摄像场景
1. 调试openpose

* `-display`

        -display (Display mode: -1 for automatic selection; 0 for no display (useful if there is no X server and/or to slightly speed up the processing if visual output is not required); 2 for 2-D display; 3 for 3-D display (if `--3d` enabled); and 1 for both 2-D and 3-D display.) type: int32 default: -1

类型为`int32`，默认值为`-1`

该参数用于指定展示模式

        -1: 自动选择
         0: 不展示，用于没有图形界面的服务器，或者不需要图形展示时来加速处理
         1: 同时展示2D和3D
         2: 2D展示
         3: 3D展示，如果指定了参数 --3d 的话

* `-face`

        -face (Enables face keypoint detection. It will share some parameters from the body pose, e.g. `model_folder`. Note that this will considerable slow down the performance and increse the required GPU memory. In addition, the greater number of people on the image, the slower OpenPose will be.) type: bool default: false

类型为`bool`，默认值为`false`

该参数用指定是否进行面部关键点检测。面部关键点检测与身体关键点检测会共享一个参数，例如`model_folder`。注意，使用启用面部挂件点检测会降低整体性能，消耗更多的GPU内存。此外，图片中的人越多，openpose处理越慢。
