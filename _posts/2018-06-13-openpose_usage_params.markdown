---
title:      OpenPose命令行参数记录
layout:     post
category:   blog
tags:       [deeplearning, openpose]
---

>openpose version v1.3.0

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

该参数用于指定摄像头参数文件所在的文件夹路径。

* `-camera_resolution`

        -camera_resolution (Set the camera resolution (either `--camera` or `--flir_camera`). `-1x-1` will use the default 1280x720 for `--camera`, or the maximum flir camera resolution available for `--flir_camera`) type: string default: "-1x-1"

类型为`string`，默认值为`-1x-1`

该参数用于指定摄像头分辨率(也可以通过参数`--camera`或`--flir_camera`指定)。参数值`-1x-1`表示使用默认分辨率`1280x720`，莫否会使用参数`--flir_camera`可使用的最大FLIR摄像头分辨率。

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

* `-face_alpha_heatmap`

        -face_alpha_heatmap (Analogous to `alpha_heatmap` but applied to face.) type: double default: 0.69999999999999996

类型为`double`，默认值为`0.69999999999999996`。

与参数`alpha_heatmap`类似，但只应用于面部。

* `-face_alpha_pose`

        -face_alpha_pose (Analogous to `alpha_pose` but applied to face.) type: double default: 0.59999999999999998

类型为`double`，默认值为`0.59999999999999998`

与参数`alpha_pose`类似，但只应用于面部。

* `-face_net_resolution`

        -face_net_resolution (Multiples of 16 and squared. Analogous to `net_resolution` but applied to the face keypoint detector. 320x320 usually works fine while giving a substantial speed up when multiple faces on the image.) type: string default: "368x368"

类型为`string`，默认值为`368x368`。

该参数的值必须为16的配置，且可以开平方，具体含义与`net_resolution`类似，只不过只应用于面部关键点检测。一般来说，当图片中有多张脸时，使用`320x320`稍稍加速处理过程。

* `-face_render`

        -face_render (Analogous to `render_pose` but applied to the face. Extra option: -1 to use the same configuration that `render_pose` is using.) type: int32 default: -1

类型为`int32`，默认值为`-1`。

与参数`render_pose`类似，但只应用于面部。

* `-face_render_threshold`

        -face_render_threshold (Analogous to `render_threshold`, but applied to the face keypoints.) type: double default: 0.40000000000000002

类型为`double`，默认值为`0.40000000000000002`

与参数`render_threshold`类似，但只应用于面部关键点。

* `-flir_camera`

        -flir_camera (Whether to use FLIR (Point-Grey) stereo camera.) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于指定是否使用FLIR摄像头。

* `-flir_camera_index`

        -flir_camera_index (Select -1 (default) to run on all detected flir cameras at once. Otherwise, select the flir camera index to run, where 0 corresponds to the detected flir camera with the lowest serial number, and `n` to the `n`-th lowest serial number camera.) type: int32 default: -1

类型为`int32`，默认值为`-1`

该参数用于指定要运行的FLIR摄像头的索引值。若参数值为`-1`，则会在所有检测到的FLIR摄像头上运行。索引值表示的是所有检测到的FLIR摄像头的序列号进行有小到大进行排序之后的索引值。`0`表示最小的，`n`表示第`n`小的。

* `-frame_first`

        -frame_first (Start on desired frame number. Indexes are 0-based, i.e. the first frame has index 0.) type: uint64 default: 0

类型为`unit64`，默认值为`0`

该参数用于指定起始帧的索引值，索引值从`0`开始。

* `-frame_flip`

        -frame_flip (Flip/mirror each frame (e.g. for real time webcam demonstrations).) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于指定是否对每一帧启用`Flip/mirror`，例如实时摄像头展示的场景。

* `-frame_keep_distortion`

        -frame_keep_distortion (If false (default), it will undistortionate the image based on the `camera_parameter_folder` camera parameters; if true, it will not undistortionate, i.e., it will leave it as it is.) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于指定是否基于摄像头参数对图像做变形操作，摄像头参数文件由参数`camera_parameter_folder`指定。

* `-frame_last`

        -frame_last (Finish on desired frame number. Select -1 to disable. Indexes are 0-based, e.g. if set to 10, it will process 11 frames (0-10).) type: uint64 default: 18446744073709551615

类型为`unit64`，默认值为`18446744073709551615`

该参数用于指定在哪一帧结束操作，索引值从`0`开始。若参数值为`-1`，表示禁用；若参数值为`10`，则openpose会处理`11`帧，即`0-10`。

* `-frame_rotate`

        -frame_rotate (Rotate each frame, 4 possible values: 0, 90, 180, 270.) type: int32 default: 0

类型为`int32`，默认值为`0`

该参数用于指定帧的旋转值，可选参数值包括`0` `90` `180` `270`。

* `-frames_repeat`

        -frames_repeat (Repeat frames when finished.) type: bool default: false

类型为`bool`，默认值为`false`

该参数值用于指定在处理结束后，是否重新处理。

* `-fullscreen`

        -fullscreen (Run in full-screen mode (press f during runtime to toggle).) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于指定openpose是否已全屏方式运行。在运行过程中，可以按`f`来切换。

* `-hand`

        -hand (Enables hand keypoint detection. It will share some parameters from the body pose, e.g. `model_folder`. Analogously to `--face`, it will also slow down the performance, increase the required GPU memory and its speed depends on the number of people.) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于指定是否启用手部关键点检测。手部关键点检测与身体关键点检测共享一些参数，例如`model_folder`。该参数与`--face`类似，会降低整体性能，增加GPU的内存消耗，具体影响程度取决于场景中人的数量。

* `-hand_alpha_heatmap`

        -hand_alpha_heatmap (Analogous to `alpha_heatmap` but applied to hand.) type: double default: 0.69999999999999996

类型为`double`，默认值为`0.69999999999999996`

与参数`alpah_heatmap`类似，但只应用于手部。

* `-hand_alpha_pose`

        -hand_alpha_pose (Analogous to `alpha_pose` but applied to hand.) type: double default: 0.59999999999999998

类型为`double`，默认值为`0.59999999999999998`

该参数与`alpha_pose`类似，但只应用于手部。

* `-hand_net_resolution`

        -hand_net_resolution (Multiples of 16 and squared. Analogous to `net_resolution` but applied to the hand keypoint detector.) type: string default: "368x368"

类型为`string`，默认值为`368x368`

该参数的值必须为16的倍数，且可以开平方。该参数与`net_resolution`类似，但只应用于手部关键点检测。

* `-hand_render`

        -hand_render (Analogous to `render_pose` but applied to the hand. Extra option: -1 to use the same configuration that `render_pose` is using.) type: int32 default: -1

类型为`int32`，默认值为`-1`

该参数与`render_pose`类似，但只应用于手部。

* `-hand_render_threshold`

        -hand_render_threshold (Analogous to `render_threshold`, but applied to the hand keypoints.) type: double default: 0.20000000000000001

类型为`double`，默认值为`0.20000000000000001`

该参数与`render_threshold`类型，但只应用于手部关键点。

* `-hand_scale_number`

        -hand_scale_number (Analogous to `scale_number` but applied to the hand keypoint detector. Our best results were found with `hand_scale_number` = 6 and `hand_scale_range` = 0.4.) type: int32 default: 1

类型为`int32`，默认值为`1`

该参数与`scale_number`类型，但只应用于手部关键点检测。目前最佳测试结果是`hand_scale_numer=6; hand_scale_range = 0.4`

* `-hand_scale_range`

        -hand_scale_range (Analogous purpose than `scale_gap` but applied to the hand keypoint detector. Total range between smallest and biggest scale. The scales will be centered in ratio 1. E.g. if scaleRange = 0.4 and scalesNumber = 2, then there will be 2 scales, 0.8 and 1.2.) type: double default: 0.40000000000000002

类型为`double`，默认值为`0.40000000000000002`

该参数与`scale_range`类似，但只应用于手部关键点检测。全部变动范围以`1`为中心，例如若设置`scaleRange = 0.4; scalesNumber = 2`，则会有scale，分别为`0.8`和`1.2`。

* `-hand_tracking`

        -hand_tracking (Adding hand tracking might improve hand keypoints detection for webcam (if the frame rate is high enough, i.e. >7 FPS per GPU) and video. This is not person ID tracking, it simply looks for hands in positions at which hands were located in previous frames, but it does not guarantee the same person ID among frames.) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于指定是否启用手部跟踪。启用手部跟踪可以增强网络摄像头和视频的手部关键点检测。这里的跟踪并非是针对某个人的手来跟踪，仅仅是跟踪帧中手的位置变化，并不能保证是同一个人的手。

* `-heatmaps_add_PAFs`

        -heatmaps_add_PAFs (Same functionality as `add_heatmaps_parts`, but adding the PAFs.) type: bool default: false

类型为`bool`，默认值为`false`

该参数与`add_heatmaps_parts`功能相同，但增加了**PAFs**.

* `-heatmaps_add_bkg`

        -heatmaps_add_bkg (Same functionality as `add_heatmaps_parts`, but adding the heatmap corresponding to background.) type: bool default: false

类型为`bool`，默认值为`false`

该参数与`add_heatmaps_parts`功能相同，但会在相关联的背景上添加热力图。

* `-heatmaps_add_parts`

        -heatmaps_add_parts (If true, it will fill op::Datum::poseHeatMaps array with the body part heatmaps, and analogously face & hand heatmaps to op::Datum::faceHeatMaps & op::Datum::handHeatMaps. If more than one `add_heatmaps_X` flag is enabled, it will place then in sequential memory order: body parts + bkg + PAFs. It will follow the order on POSE_BODY_PART_MAPPING in `src/openpose/pose/poseParameters.cpp`. Program speed will considerably decrease. Not required for OpenPose, enable it only if you intend to explicitly use this information later.) type: bool default: false

类型为`bool`，默认值为`false`

该参数指定是否填充热力图数据，身体热力图数据填充于`op::Datum::poseHeatMaps`，面部热力图数据填充于`op::Datum::faceHeatMaps`，手部热力图数据填充于`op::Datum::handHeatMaps`。若指定了多个`add_heatmaps_X`标志，则会按以下顺序放置热力图，`body parts + bkg + PAFs`，数据内容的放置顺序由文件`src/openpose/pose/poseParameters.cpp`中的`POSE_BODY_PART_MAPPING`指定。使用该参数后，程序速度会大幅下降。这个参数并非是openpose必须的，除非是你真的是想展示这些数据，否则别用这个参数。

* `-heatmaps_scale`

        -heatmaps_scale (Set 0 to scale op::Datum::poseHeatMaps in the range [-1,1], 1 for [0,1]; 2 for integer rounded [0,255]; and 3 for no scaling.) type: int32 default: 2

类型为`int32`，默认值为`2`

若参数值为`0`，则`op::Datum::poseHeatMaps`的范围是`[-1, 1]`；若参数值为`1`，则范围是`[0, 1]`，若参数值为`2`，则范围为`[0, 255]`，若参数值为`3`，表示无意义。

* `-identification`

        -identification (Not available yet, coming soon. Whether to enable people identification across frames.) type: bool default: false

类型为`bool`，默认值为`false`

目前还不支持该参数，后续会加上。

该参数用于指定是否启用人员的跨帧标识。

* `-image_dir`

        -image_dir (Process a directory of images. Use `examples/media/` for our default example folder with 20 images. Read all standard formats (jpg, png, bmp, etc.).) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定要处理的图片的文件夹，例如`examples/media/`，支持所有标准图片格式，例如`jpg` `png` `bmp`等。

* `-ip_camera`

        -ip_camera (String with the IP camera URL. It supports protocols like RTSP and HTTP.) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定摄像头的URL，支持`RTSP`协议和`HTTP`协议。

* `-keypoint_scale`

        -keypoint_scale (Scaling of the (x,y) coordinates of the final pose data array, i.e. the scale of the (x,y) coordinates that will be saved with the `write_keypoint` & `write_keypoint_json` flags. Select `0` to scale it to the original source resolution; `1`to scale it to the net output size (set with `net_resolution`); `2` to scale it to the final output size (set with `resolution`); `3` to scale it in the range [0,1], where (0,0) would be the top-left corner of the image, and (1,1) the bottom-right one; and 4 for range [-1,1], where (-1,-1) would be the top-left corner of the image, and (1,1) the bottom-right one. Non related with `scale_number` and `scale_gap`.) type: int32 default: 0

类型为`int32`，默认值为`0`

该参数用于控制最终姿态数据的坐标缩放范围，使用参数`write_keypoint`和`write_keypoint_json`时会保存坐标`(x,y)`。若参数值为`0`，则会使用原始分辨率；若参数值为`1`，则会按照网络输出大小来缩放(使用`net_resolution`来设置)；若参数为`2`，则会按照最终输出大小来设置(使用`resolution`来设置)；若参数值为`3`，则会将缩放范围设置为`[0,1]`之间，其中`(0,0)`表示图像左上角，`(1,1)`表示右下角；若参数值为`4`，则缩放范围为`[-1,1]`，其中`(-1,-1)`表示图像左上角，`(1,1)`表示右下角。该参数的值与`scale_number`和`scale_gap`无关。

* `-logging_level`

        -logging_level (The logging level. Integer in the range [0, 255]. 0 will output any log() message, while 255 will not output any. Current OpenPose library messages are in the range 0-4: 1 for low priority messages and 4 for important ones.) type: int32 default: 3

类型为`int32`，默认值为`3`

该参数用于控制日志级别，参数值的范围是`[0, 255]`。若参数值为`0`，则会输出所有日志；若参数值为`255`，则不会输出任何日志。目前openpose所使用的参数范围是`0-4`，其中`1`表示低优先级日志，`4`表示重要日志。

* `-model_folder`

        -model_folder (Folder path (absolute or relative) where the models (pose, face, ...) are located.) type: string default: "models/"

类型为`string`，默认值为`"models/"`

该参数用于指定模型数据(姿态、面部等)的位置，相对目录或绝对目录都可以。

* `-model_pose`

        -model_pose (Model to be used. E.g. `COCO` (18 keypoints), `MPI` (15 keypoints, ~10% faster), `MPI_4_layers` (15 keypoints, even faster but less accurate).) type: string default: "COCO"

类型为`string`，默认值为`"COCO/"`

该参数用于指定要使用的模型，例如`COCO`（基于18个关键点） `MPI`(基于15个关键点，速度提升约10%) `MPI_4_layer`（基于15个关键点，速度更快，但准度下降）

* `-net_resolution`

        -net_resolution (Multiples of 16. If it is increased, the accuracy potentially increases. If it is decreased, the speed increases. For maximum speed-accuracy balance, it should keep the closest aspect ratio possible to the images or videos to be processed. Using `-1` in any of the dimensions, OP will choose the optimal aspect ratio depending on the user's input value. E.g. the default `-1x368` is equivalent to `656x368` in 16:9 resolutions, e.g. full HD (1980x1080) and HD (1280x720) resolutions.) type: string default: "-1x368"

类型为`string`，默认值为`"-1x386"`

该参数的值必须为16的整数倍。提升该参数会增强准度，降低该参数可提升处理速度。为了尽可能平衡速度和准度，应尽可能与输入的图片或视频的长宽比保持一致。参数值中任意维度的值为`-1`，则openpose会根据用户输入内容自动选择合适的长宽比，例如若分辨率为`16:9`，则参数值`-1x368`会扩展为`656x368` `1980x1080`或`1280x720`。

* `-no_gui_verbose`      

        -no_gui_verbose (Do not write text on output images on GUI (e.g. number of current frame and people). It does not affect the pose rendering.) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于控制是否在GUI上将文本写到输出图片中，例如当前帧和人的数量。该参数并不会影响姿态渲染。

* `-num_gpu`

        -num_gpu (The number of GPU devices to use. If negative, it will use all the available GPUs in your machine.) type: int32 default: -1

类型为`int32`，默认值为`-1`

该参数用于指定要使用的GPU设备的数量。若参数值为负数，则会使用当前机器上所有可用的GPU。

* `-num_gpu_start`

        -num_gpu_start (GPU device start number.) type: int32 default: 0

类型为`int32`，默认值为`0`

该参数用于指定GPU设备的起始编号。

* `-number_people_max`

        -number_people_max (This parameter will limit the maximum number of people detected, by keeping the people with top scores. The score is based in person area over the image, body part score, as well as joint score (between each pair of connected body parts). Useful if you know the exact number of people in the scene, so it can remove false positives (if all the people have been detected. However, it might also include false negatives by removing very small or highly occluded people. -1 will keep them all.) type: int32 default: -1

类型为`int32`，默认值为`-1`

该参数用限制要处理的人员的数量最大值，具体方式是记录人员的最高得分。该分数是基于图像中人员区域、身体区域的分数，以及连接点的分数。若你清楚的指导场景中人员的数量，那么合理设置人员上限，可以有效降低错误识别(false positive)，若场景中所有的人员都已检测出的话。但该参数可能会提升识别遗漏(false negative)的概率，openpose会移除掉非常小或非常高的封闭人像。将参数设置为`-1`的话，会将这两者都保留下来。

* `-output_resolution`

        -output_resolution (The image resolution (display and output). Use "-1x-1" to force the program to use the input image resolution.) type: string default: "-1x-1"

类型为`string`，默认值为`-1x-1`

该参数用于控制输出图片的分辨率。若参数值为`-1x-1`，则输出分辨率与输入分辨率相同。

* `-part_candidates`

        -part_candidates (Also enable `write_json` in order to save this information. If true, it will fill the op::Datum::poseCandidates array with the body part candidates. Candidates refer to all the detected body parts, before being assembled into people. Note that the number of candidates is equal or higher than the number of final body parts (i.e. after being assembled into people). The empty body parts are filled with 0s. Program speed will slightly decrease. Not required for OpenPose, enable it only if you intend to explicitly use this information.) type: bool default: false

类型为`bool`，默认值为`false`

该参数与`write_json`配合使用，用于保存相关信息。参数值为`true`，则openpose会用身体部分的候选数据填充`op::Datum::poseCandidates`数组。候选数据(`candidate`)是指所以后检测到的身体数据，这部分数据还没有被合成到人员图像中。需要注意的是，候选数据的数量会大于等于最终身体区域的数量(例如最终合成的人员图像)。空的身体区域会使用`0`来填充。使用该参数后，会略微降低openpose的运行速度。这部分功能并非openpose必须的，只是在显式使用这部分数据的后才需要打开。

* `-part_to_show`

        -part_to_show (Prediction channel to visualize (default: 0). 0 for all the body parts, 1-18 for each body part heat map, 19 for the background heat map, 20 for all the body part heat maps together, 21 for all the PAFs, 22-40 for each body part pair PAF.) type: int32 default: 0

类型为`int32`，默认值为`0`

该参数用于控制虚拟化的预测通道。参数值为`0`表示所有的身体部分；参数值为`1-18`表示每个身体部分的热力图；参数值`19`表示背景热力图；参数值`20`表示所有身体部分热力图汇总；参数值`21`表示所有`PAFs`；参数值`22-40`表示每个身体部分对应的`PAF`。

* `-process_real_time`

        -process_real_time (Enable to keep the original source frame rate (e.g. for video). If the processing time is too long, it will skip frames. If it is too fast, it will slow it down.) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于控制是否保持输入源的帧率。若处理时间太长，openpose会跳过一些帧，若速度过快，openpose会降低处理速度。

* `-profile_speed`

        -profile_speed (If PROFILER_ENABLED was set in CMake or Makefile.config files, OpenPose will show some runtime statistics at this frame number.) type: int32 default: 1000

类型为`int32`，默认值为`1000`

若编译时在`CMake`或`Makefile.config`中设置了`PROFILER_ENABLED`，则openpose会在帧号中显示一些运行时统计数据。

* `-render_pose`

        -render_pose (Set to 0 for no rendering, 1 for CPU rendering (slightly faster), and 2 for GPU rendering (slower but greater functionality, e.g. `alpha_X` flags). If -1, it will pick CPU if CPU_ONLY is enabled, or GPU if CUDA is enabled. If rendering is enabled, it will render both `outputData` and `cvOutputData` with the original image and desired body part to be shown (i.e. keypoints, heat maps or PAFs).) type: int32 default: -1

类型为`int32`，默认值为`-1`

该参数用于控制选择方式。参数值为`0`表示不渲染，`1`表示CPU渲染(速度稍快)，`2`表示GPU渲染(速度稍慢，功能更强，参见`alpha_x`参数)。若参数值为`-1`，则渲染方式取决于编译参数，若设置了`CPU_ONLY`，则会使用CPU渲染，若设置了`CUDA`，则使用GPU渲染。若启用了渲染，则会对原始图像渲染`outpuData`和`cvOuputData`，显示出期望的身体部分，例如关键点、热力图或PAFs。

* `-render_threshold`

        -render_threshold (Only estimated keypoints whose score confidences are higher than this threshold will be rendered. Generally, a high threshold (> 0.5) will only render very clear body parts; while small thresholds (~0.1) will also output guessed and occluded keypoints, but also more false positives (i.e. wrong detections).) type: double default: 0.050000000000000003

类型为`double`，默认值为`0.050000000000000003`

该参数用于控制渲染标准，只有关键点的置信分数高于这个标志，才会渲染该关键点。一般情况下，设置为`0.5`时，只会渲染置信度很高的身体部分，设置为`0.1`时，会渲染出猜测的和封闭的关键点，但可能会包含一些错误的识别。

* `-sacle_gap`

        -scale_gap (Scale gap between scales. No effect unless scale_number > 1. Initial scale is always 1. If you want to change the initial scale, you actually want to multiply the `net_resolution` by your desired initial scale.) type: double default: 0.29999999999999999

类型为`double`，默认值为`0.29999999999999999`

该参数用于设置缩放间隔的大小，只有当`scale_number`大于`1`时才有效。初始间隔始终为`1`。若想修改初始缩放，实际上是将`net_resolution`的值乘以期望的初始缩放。

* `-scale_numer`

        -scale_number (Number of scales to average.) type: int32 default: 1

类型为`int32`，默认值为`1`

该参数用于设置平均缩放倍数。

* `-tracking`

        -tracking (Not available yet, coming soon. Whether to enable people tracking across frames. The value indicates the number of frames where tracking is run between each OpenPose keypoint detection. Select -1 (default) to disable it or 0 to run simultaneously OpenPose keypoint detector and tracking for potentially higher accurary than only OpenPose.) type: int32 default: -1

类型为`int32`，默认值为`-1`

该参数目前还未实现，后续会加上。

该参数用于控制是否启用人员的跨帧追踪。参数值指定了要跨越的帧的数量。若参数值为`-1`，则会禁用跨帧追踪，若参数值为`0`，则会同时运行关键点检测和追踪提高识别准度。

* `-video`

        -video (Use a video file instead of the camera. Use `examples/media/video.avi` for our default example video.) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定要处理的视频文件的位置，使用该参数后就不会从摄像头获取数据。

* `-write_coco_foot_json`

        -write_coco_foot_json (Full file path to write people foot pose data with JSON COCO validation format.) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定要输出的人员足部姿态数据的写入位置，写入格式是JSON COCO有效格式。

* `-write_coco_json`

        -write_coco_json (Full file path to write people pose data with JSON COCO validation format.) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定要输出的人员姿态数据的写入位置，写入格式是JSON COCO有效格式。

* `-write_heatmaps`

        -write_heatmaps (Directory to write body pose heatmaps in PNG format. At least 1 `add_heatmaps_X` flag must be enabled.) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定要写入的身体姿态热力图的文件路径，写入格式为PNG。使用该参数时，至少要指定一个`add_heatmaps_X`参数。

* `-write_heatmaps_format`

        -write_heatmaps_format (File extension and format for `write_heatmaps`, analogous to `write_images_format`. For lossless compression, recommended `png` for integer `heatmaps_scale` and `float` for floating values.) type: string default: "png"

类型为`string`，默认值为`"png"`

该参数用于指定输出热力图的格式，与参数`write_heatmaps`配合使用，与参数`write_images_format`功能类似。对于无损压缩，推荐使用`png`格式。

* `-write-images`

        -write_images (Directory to write rendered frames in `write_images_format` image format.) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定要渲染的图片的存放目录。

* `write_images_format`

         -write_images_format (File extension and format for `write_images`, e.g. png, jpg or bmp. Check the OpenCV function cv::imwrite for all compatible extensions.) type: string default: "png"

类型为`string`，默认值为`"png"`

该参数用于指定`write_images`参数的文件格式，例如`png` `jpg` `bmp`等。参见OpenCV函数`cv::imwrite`获取所有兼容格式。

* `-write_json`

        -write_json (Directory to write OpenPose output in JSON format. It includes body, hand, and face pose keypoints (2-D and 3-D), as well as pose candidates (if `--part_candidates` enabled).) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定openpose输出json格式数据的位置，输出内容包括身体、手部和面部的关键点数据(2D和3D)，以及姿态候选数据(如果启用了`--part_candidates`参数的话)。

* `-write_keypoint`

        -write_keypoint ((Deprecated, use `write_json`) Directory to write the people pose keypoint data. Set format with `write_keypoint_format`.) type: string default: ""

类型为`string`，默认值为`""`

已废弃，改为使用参数`write_json`。

该参数用于指定要将人员姿态关键点数据写入到哪里。写入的数据格式参见参数`write_keypoint_format`。

* `-write_keypoint_format`

        -write_keypoint_format ((Deprecated, use `write_json`) File extension and format for `write_keypoint`: json, xml, yaml & yml. Json not available for OpenCV < 3.0, use `write_keypoint_json` instead.) type: string default: "yml"

类型为`string`，默认值为`yml`

已废弃，改为使用参数`write_json`。

该参数用于指定`write_keypoint`参数输出内容的格式，支持`json` `xml` `yaml` `yml`。对于3.0版本之前的OpenCV来说，不支持`json`格式，要使用`write_keypoint_json`来设置。

* `-write_keypoint_json`

        -write_keypoint_json ((Deprecated, use `write_json`) Directory to write people pose data in JSON format, compatible with any OpenCV version.) type: string default: ""

类型为`string`，默认值为`""`

已废弃，改为使用参数`write_json`。

该参数用于指定以`JSON`输出人员姿态数据，与所有OpenCV版本兼容。

* `-write_video`

        -write_video (Full file path to write rendered frames in motion JPEG video format. It might fail if the final path does not finish in `.avi`. It internally uses cv::VideoWriter.) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定要写入的视频文件的完整路径，视频写入是以M-JPEG视频格式完成的，若路径没有以`.avi`结尾，可能会写入错误。openpose内部是以`cv::VideoWriter`完成写入的。


# Flags from src/logging.cc:

* `-alsologtoemail`

        -alsologtoemail (log messages go to these email addresses in addition to logfiles) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定将日志写入到指定的邮件地址，同时还会写入到日志文件中。

* `-alsologtostderr`

        -alsologtostderr (log messages go to stderr in addition to logfiles) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于指定，除了将日志写入到日志文件外，是否输出到标准错误中。

* `-colorlogtostderr`

        -colorlogtostderr (color messages logged to stderr (if supported by terminal)) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于指定输出到标准错误中的信息是否有颜色。

* `-drop_log_memory`

        -drop_log_memory (Drop in-memory buffers of log contents. Logs can grow very quickly and they are rarely read before they need to be evicted from memory. Instead, drop them from memory as soon as they are flushed to disk.) type: bool default: true

类型为`bool`，默认值为`false`

该参数用与指定是否释放掉日志内容占用的内存。日志量较大，且很少去读，因此除非特殊需要，还是及时释放掉的好。

* `log_backtrace_at`

        -log_backtrace_at (Emit a backtrace when logging at file:linenum.) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定在打印日志行号时附带的回溯信息。

* `-log_dir`

        -log_dir (If specified, logfiles are written into this directory instead of the default logging directory.) type: string default: ""

类型为`string`，默认值为`""`

该参数用于指定日志文件的存放目录。

* `-log_link`

        -log_link (Put additional links to the log files in this directory) type: string default: ""

类型为`string`，默认值为`""`

该参数用与为日志文件指定额外的链接。

* `-log_prefix`

        -log_prefix (Prepend the log prefix to the start of each log line) type: bool default: true

类型为`bool`，默认值为`true`

该参数用于指定是否在每行日志前面加上前缀。

* `-logbuflevel`

        -logbuflevel (Buffer log messages logged at this level or lower (-1 means don't buffer; 0 means buffer INFO only; ...)) type: int32 default: 0

类型为`int32`，默认值为`0`

该参数用于指定缓冲日志的级别，小于等于该级别才会缓冲。`-1`表示不缓冲，`0`表示只缓冲`INFO`级别...

* `-logbufsecs`

        -logbufsecs (Buffer log messages for at most this many seconds) type: int32 default: 30

类型为`int32`，默认值为`30`

该参数用于指定缓冲日志的时间长度。

* `-logemaillevel`

        -logemaillevel (Email log messages logged at this level or higher (0 means email all; 3 means email FATAL only; ...)) type: int32 default: 999

类型为`int32`，默认值为`999`

该参数用于指定要邮件发送的日志内容的级别，大于等于该级别才会发送。`0`表示全部发送，`3`表示只发送`FATAL`级别...

* `logmailer`

        -logmailer (Mailer used to send logging email) type: string default: "/bin/mail"

类型为`string`，默认值为`"/bin/mail"`

该参数用于指定日志邮件发送程序

* `-logtostderr`

        -logtostderr (log messages go to stderr instead of logfiles) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于指定是否将日志输出到标准错误，注意输出到标准错误后，就不会写入日志文件

* `-max_log_size`

        -max_log_size (approx. maximum log file size (in MB). A value of 0 will be silently overridden to 1.) type: int32 default: 1800

类型为`int32`，默认值为`1800`

该参数用于指定日志文件的最大值(近似)，单位为`MB`。若参数值为`0`，则在内部会被调整为`1`。

* `-minloglevel`

        -minloglevel (Messages logged at a lower level than this don't actually get logged anywhere) type: int32 default: 0

类型为`int32`，默认值为`0`

该参数用于指定日志级别，低于该级别的日志不会被记录。

* `-stderrthreshold`

        -stderrthreshold (log messages at or above this level are copied to stderr in addition to logfiles.  This flag obsoletes --alsologtostderr.) type: int32 default: 2

类型为`int32`，默认值为`2`

该参数用与指定额外输出到日志文件的日志级别，大于等于该级别的日志除了输出到日志文件外，还会输出到标准错误。

使用该参数后就不要使用参数`--alsologtostderr`了

* `-stop_logging_if_full_disk`

        -stop_logging_if_full_disk (Stop attempting to log to disk if the disk is full.) type: bool default: false

类型为`bool`，默认值为`false`

该参数用于指定，当硬盘写满之后，是否还要写日志。

# Flags from src/utilities.cc:

* `-symolize_stacktrace`

        -symbolize_stacktrace (Symbolize the stack trace in the tombstone) type: bool default: true

类型为`bool`，默认值为`false`

该参数用于指定是否要在`tombstone`中对堆栈信息添加标记。

# Flags from src/vlog_is_on.cc:

* `-v`

        -v (Show all VLOG(m) messages for m <= this. Overridable by --vmodule.) type: int32 default: 0

类型为`int32`，默认值为`0`

该参数用与指定要显示的`VLOG(m)`，小于该参数值的才会显示。该参数的效果会被参数`--vmodule`覆盖。

* `-vmodule`

        -vmodule (per-module verbose level. Argument is a comma-separated list of <module name>=<log level>. <module name> is a glob pattern, matched against the filename base (that is, name ignoring .cc/.h./-inl.h). <log level> overrides any value given by --v.) type: string default: ""

类型为`string`，默认值为`""`

该参数用于为每个模块设置显示级别。参数值是以逗号分隔的模块列表，格式为`<module name>=<log level>`，其中`<module name>`是全局模式，与文件名相匹配，即忽略掉`.cc/.h/-inl.h`后缀的文件名。`<log level>`会覆盖掉参数`--v`设置的值。