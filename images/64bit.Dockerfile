# Stage 1: Base environment setup using Fedora 40
FROM fedora:39 AS base

WORKDIR /root

ENV DOTNET_NOLOGO=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV SCON_VERSION=4.8.0

#RUN dnf update -y

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

RUN dnf install -y \
        pkgconfig \
        libX11-devel \
        libXcursor-devel \
        libXrandr-devel \
        libXinerama-devel \
        libXi-devel \
        wayland-devel \
        mesa-libGL-devel \
        mesa-libGLU-devel \
        alsa-lib-devel \
        pulseaudio-libs-devel \
        libudev-devel \
        gcc-c++ \
        libstdc++-static \
        libatomic-static \
        freetype-devel \
        openssl openssl-devel \
        libcxx-devel libcxx \
        zlib-devel \
        libmpc-devel mpfr-devel gmp-devel clang \
        vulkan xz gcc  \
        parallel \
        libxml2-devel \
        embree3-devel \
        enet-devel \
        glslang-devel \
        graphite2-devel \
        harfbuzz-devel \
        libicu-devel \
        libsquish-devel \
        libtheora-devel \
        libvorbis-devel \
        libwebp-devel \
        libzstd-devel \
        mbedtls-devel \
        miniupnpc-devel \
        embree embree-devel \
        glibc-devel \
        libstdc++ libstdc++-devel


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

ENV GODOT_SDK_VERSIONS="x86_64 aarch64"
ENV BUILDROOT_REPO="https://github.com/godotengine/buildroot.git"

# Clone the buildroot repository
RUN git clone ${BUILDROOT_REPO} buildroot

RUN pwd

# For buildroot
ENV FORCE_UNSAFE_CONFIGURE=1

# Build SDKs for each architecture https://github.com/godotengine/buildroot#using-buildroot-to-generate-sdks


CMD /bin/bash
