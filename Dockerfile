FROM arm64v8/ubuntu as builder

USER root

# Install pre reqs
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update && apt-get install -y \
      apt-utils \
      psmisc \
      tcl \
      environment-modules \
      nano \
      vim \
      unzip \
      less \
      wget \
      python \
      python3-pip \
      libxext6-dbg \
      libsm-dev \
      libfreetype6-dev \
      libxrender-dev \
      libxrandr-dev \
      libxfixes-dev \
      libxcursor-dev \
      libxinerama-dev \
      libfontconfig-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


WORKDIR /tmp

# Instruction Emulator
RUN bash -c "wget -q -O- https://armkeil.blob.core.windows.net/developer/Files/downloads/hpc/arm-instruction-emulator/20-0/ARM-Instruction-Emulator_20.0_AArch64_Ubuntu_16.04_aarch64.tar.gz | tar zx && ./ARM-Instruction-Emulator_20.0_AArch64_Ubuntu_16.04_aarch64/arm-instruction-emulator-20.0_Generic-AArch64_Ubuntu-16.04_aarch64-linux-deb.sh --accept ; rm -rf /tmp/*"

# Setup modules
RUN echo "/opt/arm/modulefiles" >> /usr/share/modules/init/.modulespath
COPY modulefiles /opt/arm/modulefiles/

# By rebuilding the image from scratch, and copying in the result
# we save image size
FROM arm64v8/ubuntu
COPY --from=builder / /

RUN useradd -ms /bin/bash user
USER user
WORKDIR /home/user

CMD ["bash", "-l"]
