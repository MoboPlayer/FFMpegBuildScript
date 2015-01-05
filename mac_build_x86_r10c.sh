#!/bin/bash
######################################################
# Usage:
# put this script in top of FFmpeg source tree
# ./build_android
# It generates binary for following architectures:
# ARMv6 
# ARMv6+VFP 
# ARMv7+VFPv3-d16 (Tegra2) 
# ARMv7+Neon (Cortex-A8)
# Customizing:
# 1. Feel free to change ./configure parameters for more features
# 4. To adapt other ARM variants
# set $CPU and $OPTIMIZE_CFLAGS 
# call build_one
# if not dynamic detect cpu, must      --disable-sse4 \ --disable-sse42 \ --disable-avx \
######################################################

NDK=/data/dev_tools/android-ndk/android-ndk-r10c
PLATFORM=$NDK/platforms/android-19/arch-x86
#PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86
PREBUILT=$NDK/toolchains/x86-4.9/prebuilt/darwin-x86_64
function build_one
{
./configure --target-os=linux \
    --prefix=$PREFIX \
    --enable-cross-compile \
    --extra-libs="-lgcc" \
    --arch=x86 \
    --cc=$PREBUILT/bin/i686-linux-android-gcc \
    --cross-prefix=$PREBUILT/bin/i686-linux-android- \
    --nm=$PREBUILT/bin/i686-linux-android-nm \
    --sysroot=$PLATFORM \
    --extra-cflags=" -O3 -w -fpic -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS " \
    --disable-shared \
    --enable-static \
    --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -llog" \
	--disable-everything \
	--enable-avformat \
	--enable-avcodec \
	--enable-demuxers \
	--enable-decoders \
	--disable-encoders \
	--disable-muxers \
	--disable-avdevice \
	--disable-amd3dnow \
	--disable-amd3dnowext \
    --enable-swscale  \
	--enable-asm \
	--enable-yasm \
	--enable-pic  \
	--enable-parsers  \
	--enable-protocols  \
	--enable-small  \
	--disable-ffplay \
	--disable-ffmpeg \
	--disable-ffprobe \
	--disable-ffserver \
	--disable-bsfs \
	--disable-hwaccels \
	--disable-devices \
	--disable-filters \
 	--disable-postproc
    $ADDITIONAL_CONFIGURE_FLAG

make clean
make  -j4 install
$PREBUILT/bin/i686-linux-android-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -soname libffmpeg_x86.so -shared -nostdlib  -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libswscale/libswscale.a libavformat/libavformat.a libavutil/libavutil.a libswresample/libswresample.a -lc -lm -lz -ldl -llog  --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/i686-linux-android/4.9/libgcc.a
}


#x86
CPU=x86
OPTIMIZE_CFLAGS="-ffast-math -mfpmath=sse"
PREFIX=./android/$CPU
ADDITIONAL_CONFIGURE_FLAG=
build_one

$PREBUILT/bin/i686-linux-android-strip -s $PREFIX/*.so 
