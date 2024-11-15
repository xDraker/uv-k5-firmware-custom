#!/bin/sh
#export DOCKER_DEFAULT_PLATFORM=linux/amd64
IMAGE_NAME="uvk5"
rm "${PWD}/compiled-firmware/*"
docker build -t $IMAGE_NAME .

bandscope() {
    echo "Bandscope compilation..."
    docker run --rm -v "${PWD}/compiled-firmware/:/app/compiled-firmware" $IMAGE_NAME /bin/bash -c "rm ./compiled-firmware/*; cd /app && make -s \
        ENABLE_SPECTRUM=1 \
        ENABLE_FMRADIO=0 \
        ENABLE_AIRCOPY=1 \
        ENABLE_NOAA=0 \
        TARGET=f4hwn.bandscope \
        && cp f4hwn.bandscope* compiled-firmware/"
}

broadcast() {
    echo "Broadcast compilation..."
    docker run --rm -v "${PWD}/compiled-firmware:/app/compiled-firmware" $IMAGE_NAME /bin/bash -c "cd /app && make -s \
        ENABLE_SPECTRUM=0 \
        ENABLE_FMRADIO=1 \
        ENABLE_AIRCOPY=1 \
        ENABLE_NOAA=0 \
        TARGET=f4hwn.broadcast \
        && cp f4hwn.broadcast* compiled-firmware/"
}

voxless() {
    echo "Voxless compilation..."
    docker run --rm -v "${PWD}/compiled-firmware:/app/compiled-firmware" $IMAGE_NAME /bin/bash -c "cd /app && make -s \
        ENABLE_SPECTRUM=1 \
        ENABLE_FMRADIO=1 \
        ENABLE_VOX=0 \
        ENABLE_AIRCOPY=0 \
        ENABLE_AUDIO_BAR=0 \
        ENABLE_FEAT_F4HWN_SPECTRUM=0 \
        ENABLE_NOAA=0 \
        ENABLE_FEAT_F4HWN_RESTORE_SCAN=0 \
        ENABLE_FEAT_F4HWN_CHARGING_C=0 \
        ENABLE_FEAT_F4HWN_NARROWER=0 \
        TARGET=f4hwn.voxless \
        && cp f4hwn.voxless* compiled-firmware/"
}

case "$1" in
    bandscope)
        bandscope
        ;;
    broadcast)
        broadcast
        ;;
    voxless)
        voxless
        ;;
    all)
        bandscope
        broadcast
        voxless
        ;;
    *)
        echo "Usage: $0 {bandscope|broadcast|voxless|all}"
        exit 1
        ;;
esac