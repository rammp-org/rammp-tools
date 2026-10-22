# ffmpeg decoder — turns a camera's encoded stream (H.264/H.265 as ffmpeg_image_transport_msgs/FFMPEGPacket on
# <camera>/image_raw/ffmpeg) back into sensor_msgs/Image on <camera>/image_raw, so the camera's link carries only
# the encoded stream and consumers still subscribe to raw. image_transport's republish with the ffmpeg plugin;
# libav's software decoders.
FROM ghcr.io/rammp-org/rammp-base:1.1.0-jp6

RUN apt-get update \
 && apt-get install -y --no-install-recommends ros-humble-ffmpeg-image-transport \
 && rm -rf /var/lib/apt/lists/*

# The deployment remaps in/ffmpeg (the packets) and out (the raw image).
ENTRYPOINT ["/ros_entrypoint.sh", "/opt/ros/humble/lib/image_transport/republish", "ffmpeg", "raw"]
