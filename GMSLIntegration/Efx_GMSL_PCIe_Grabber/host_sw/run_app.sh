#!/bin/bash

chmod +x ./driver/driver.sh ./apps/VideoGrabber 2>/dev/null

echo "Make DMA driver..."
(cd ./driver && make)


echo "Run driver.sh..."
(cd ./driver && ./driver.sh)

echo "Driver setup completed. Starting Video Grabber app..."

ver=$(lsb_release -rs | cut -d. -f1)

if [ "$ver" -le 22 ]; then
    echo "Please install QT6..."
else
    echo "Video Grabber app selected..."
    (cd ./apps && sudo ./VideoGrabber)
fi
