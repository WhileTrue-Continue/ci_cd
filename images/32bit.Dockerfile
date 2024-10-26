# Stage 1: Base environment setup using Fedora 40
FROM fedora:39 AS base

WORKDIR /root

ENV DOTNET_NOLOGO=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV SCON_VERSION=4.8.0

#RUN dnf update -y

RUN dnf install -y \
    libX11-devel.i686 \
    libXcursor-devel.i686 \
    libXrandr-devel.i686 \
    libXinerama-devel.i686 \
    libXi-devel.i686 \
    wayland-devel.i686 \
    mesa-libGL-devel.i686 \
    mesa-libGLU-devel.i686 \
    alsa-lib-devel.i686 \
    pulseaudio-libs-devel.i686 \
    gcc-c++.i686 \
    libstdc++-13.2.1-3.fc39.i686 \
    libatomic-static.i686 \
    freetype-devel.i686 \
    openssl-devel.i686 \
    libcxx-devel.i686 libcxx.i686 \
    zlib-devel.i686 \
    libmpc-devel.i686 \
    mpfr-devel.i686 \
    gmp-devel.i686 \
    clang.i686 \
    libxml2-devel.i686 \
    enet-devel.i686 \
    glslang-devel.i686 \
    graphite2-devel.i686 \
    harfbuzz-devel.i686 \
    libicu-devel.i686 \
    libsquish-devel.i686 \
    libtheora-devel.i686 \
    libvorbis-devel.i686 \
    libwebp-devel.i686 \
    libzstd-devel.i686 \
    mbedtls-devel.i686 \
    miniupnpc-devel.i686 \
    glibc-devel.i686 --best

    # Install bash, curl, and other basic utilities
    RUN dnf install -y --setopt=install_weak_deps=False \
        bash bzip2 curl file findutils gettext \
        git make nano patch pkg-config unzip \
        xz cmake gdb ccache patch yasm mold lld
    
    
    # Needed for buildroot
    RUN dnf install -y \
        wget \
        which \
        cpio \
        rsync \
        bc \
        diffutils \
        perl perl-core perl-ExtUtils-MakeMaker 
    
    # Has no i686
    RUN dnf install -y \
        pkgconfig \
        libudev-devel \
        openssl \
        vulkan \
        xz \
        gcc \
        parallel \
        embree3-devel \
        embree

# Install Python and pip for SCons
RUN dnf install -y python3-pip

# Install SCons
RUN pip install scons==${SCON_VERSION}

# Install .NET SDK
RUN dnf install -y dotnet-sdk-8.0

RUN dnf clean all

# Stage 2: Godot SDK setup
FROM base AS godot_sdk

WORKDIR /root

ENV GODOT_SDK_VERSIONS="i686"
ENV BUILDROOT_REPO="https://github.com/godotengine/buildroot.git"

# Clone the buildroot repository
RUN git clone ${BUILDROOT_REPO} buildroot

RUN pwd

# For buildroot
ENV FORCE_UNSAFE_CONFIGURE=1

# Build SDKs for each architecture https://github.com/godotengine/buildroot#using-buildroot-to-generate-sdks


CMD /bin/bash

