# RoboCup Humanoid ROS2 Control

ROS2 control system for humanoid robots using Waveshare Bus Servo Adapter and Feetech STS3215 servos.

## Quick Start

### Prerequisites
- Windows 10/11 with WSL2 ([Installation Guide](https://learn.microsoft.com/en-us/windows/wsl/install))
- Docker Desktop ([Download](https://www.docker.com/products/docker-desktop/))
- Git ([Download](https://git-scm.com/downloads))

### Setup

1. Install WSL2 if not already installed:
   ```powershell
   # Open Powershell as Administrator
   wsl --install
   wsl --set-default-version 2
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name
   ```

3. Build the Docker container:
   ```bash
   docker-compose build
   ```

4. Start the container:
   ```bash
   docker-compose up -d
   ```

5. Enter the container:
   ```bash
   docker exec -it ros2_waveshare bash
   ```

### Basic Usage

1. Inside the container, source ROS2:
   ```bash
   source /opt/ros/humble/setup.bash
   source /ros2_ws/install/setup.bash
   ```

2. Launch the control system:
   ```bash
   ros2 launch waveshare_servos example.launch.py
   ```

## Workflow

### Development Cycle
```bash
# Stop any running containers
docker-compose down

# Pull latest changes
git pull

# Rebuild and start
docker-compose up -d --build

# Enter container
docker exec -it ros2_waveshare bash
```

### Quick Start (No Rebuilding)
```bash
# Start existing container
docker-compose up -d

# Enter container
docker exec -it ros2_waveshare bash
```

### Stopping Work
```bash
# Exit container (when inside container)
exit

# Stop container
docker-compose down
```

## Common Operations

### Rebuilding After Code Changes
Inside the container:
```bash
cd /ros2_ws
colcon build --merge-install
source install/setup.bash
```

### Managing Docker Resources
```bash
# View running containers
docker ps

# View all containers
docker ps -a

# Remove all stopped containers
docker container prune

# Remove all unused images
docker image prune

# Full cleanup (USE WITH CAUTION)
docker system prune -a
```

## USB Device Setup

1. Plug in Waveshare Bus Servo Adapter

2. Find device name:
   ```bash
   ls /dev/ttyUSB* /dev/ttyACM*
   ```

3. Update config file:
   ```bash
   cd /ros2_ws/src/waveshare_servos/config
   nano example_controllers.yaml  # Update 'port:' to match your device
   ```

## Servo Configuration

### Setting Servo IDs
Connect one servo at a time:
```bash
ros2 run waveshare_servos set_id --ros-args -p start_id:=1 -p new_id:=<new_id>
```

### Calibrating Servo Midpoint
```bash
ros2 run waveshare_servos calibrate_midpoint --ros-args -p id:=<id>
```

## Troubleshooting

### Container Issues

1. "Container not starting"
   ```bash
   docker-compose down
   docker system prune -f
   docker-compose up -d
   ```

2. "USB device not found"
   ```bash
   # Inside container
   chmod 666 /dev/ttyUSB0  # or your port
   ```

3. "Build failures"
   ```bash
   # Inside container
   cd /ros2_ws
   rm -rf build install log
   colcon build --merge-install
   ```

### ROS2 Issues

1. "Controllers not spawning"
   - Check if hardware is connected
   - Verify port configuration
   - Restart the launch file

2. "Communication errors"
   - Check power supply
   - Verify servo IDs
   - Check USB connection
