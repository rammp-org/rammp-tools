# Static TF — publishes every transforms file in a directory on /tf_static.
# rammp-base already has rclpy, tf2_ros and PyYAML (from ros:humble); the one
# thing added is the script. The robot's files are bind-mounted at
# /config/robot/transforms by the deployment.
FROM ghcr.io/rammp-org/rammp-base:1.1.0-jp6

COPY static_tf.py /opt/static_tf/static_tf.py

CMD ["python3", "/opt/static_tf/static_tf.py", "/config/robot/transforms"]
