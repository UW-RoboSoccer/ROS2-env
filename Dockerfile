FROM ros:humble-ros-base

# Install essential packages
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-colcon-common-extensions \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-xacro \
    ros-humble-joint-state-publisher \
    ros-humble-robot-state-publisher \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip3 install pyserial

# Create workspace directory
WORKDIR /ros2_ws
RUN mkdir -p /ros2_ws/src

# Clone waveshare_servos repository
RUN cd /ros2_ws/src && \
    git clone https://github.com/htchr/waveshare_servos.git

# Create missing directories
RUN mkdir -p /ros2_ws/src/waveshare_servos/description/launch

# Fix build configurations
RUN cd /ros2_ws/src/waveshare_servos && \
    sed -i 's/\[IDN\]\[6\]/[253][6]/g' src/SCSCL.cpp && \
    sed -i 's/\[IDN\]\[7\]/[253][7]/g' src/SMSCL.cpp && \
    sed -i 's/\[IDN\]\[7\]/[253][7]/g' src/SMSBL.cpp && \
    sed -i 's/\[IDN\]\[7\]/[253][7]/g' src/SMS_STS.cpp && \
    sed -i 's/\[IDN\]\[2\]/[253][2]/g' src/SMS_STS.cpp

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    ros-humble-controller-manager \
    ros-humble-hardware-interface \
    ros-humble-joint-trajectory-controller \
    ros-humble-velocity-controllers \
    ros-humble-position-controllers \
    && rm -rf /var/lib/apt/lists/*

# Build the workspace
RUN /bin/bash -c '. /opt/ros/humble/setup.bash && \
    cd /ros2_ws && \
    colcon build --merge-install --cmake-args -DCMAKE_BUILD_TYPE=Release'

# Add source commands to bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc

# Keep container running
CMD ["bash"]
