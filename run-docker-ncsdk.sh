# sudo nvidia-docker run -it -v /dev/bus/usb:/dev/bus/usb ncsdk:ubuntu16.04 /bin/bash

# sudo nvidia-docker run -it --privileged --network=host -v /dev/bus/usb:/dev/bus/usb -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix${DISPLAY} ncsdk:ubuntu16.04 /bin/bash

# sudo nvidia-docker run -it --privileged --net=host -v /dev/bus/usb:/dev/bus/usb -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix${DISPLAY} ncsdk:ubuntu16.04 /bin/bash

# (Working Syntax!!!)
# tem um link que usava "/dev:/dev:shared" testar depois
sudo nvidia-docker run -it --privileged --net=host -v /dev:/dev -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix${DISPLAY} ncsdk:ubuntu16.04 /bin/bash
