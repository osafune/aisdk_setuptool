#!/bin/bash
set -e

# help

if [ "$1" != "run" ] && [ "$1" != "setup" ]; then
  echo "v2h-aisdk run [local_dir]"
  echo "  * Run TVM docker image"
  echo "    [local_dir] : The local folder to mount into the docker container."
  echo ""
  echo "v2h-aisdk setup [aisdk_zip] [--install-docker] [--cleanup]"
  echo "  * Setup RZ/V2H DRP-AI TVM"
  echo "    [aisdk_zip] : AI-SDK zip archive file (ver5.00 or later.)"
  echo "    --install-docker : Install docker."
  echo "    --cleanup : Clean up after the installation is complete."
  echo ""
  exit
fi


# Run

if [ "$1" = "run" ]; then
  if [ -z "$2" ]; then
    mnt_local="$(pwd)/work:/drp-ai_tvm/work"
    if [ ! -d $(pwd)/work ]; then
      mkdir work
    fi
  else
    IFS='/' read -r -a str_array <<< "$2"
    dir_name=${str_array[-1]}
    mnt_local="${2}:/drp-ai_tvm/${dir_name}"
  fi

  docker run -it --rm -e TZ=Asia/Tokyo -v ${mnt_local} drp-ai_tvm_v2h_image_${USER}
  exit
fi


# Installing 

echo "* Installing RZ/V2H DRP-AI TVM with Docker ..."
read -sp "sudo password: " pwrd
tty -s && echo

echo ${pwrd} | sudo -kS apt update
echo ${pwrd} | sudo -kS DEBIAN_FRONTEND=noninteractive apt install -y wsl curl wget unzip


# * RZ/V2H AI SDK
#     https://www.renesas.com/en/software-tool/rzv2h-ai-software-development-kit
#     RTK0EF0180F05000SJ.zip or later.

if [ ! -z "$2" ] && [ "${2:0:1}" != "-" ]; then
  aisdk_zip=$2
else
  aisdk_zip=RTK0EF0180F0???0SJ.zip
fi


# Install Docker (if the parameter has "--install-docker", install it.)

if [[ "--install-docker" =~ ^("$2"|"$3"|"$4")$ ]]; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  echo ${pwrd} | sudo -kS sh get-docker.sh
  echo ${pwrd} | sudo -kS usermod -aG docker ${USER}
fi


# Extract a DRP-AI installer

if [ ! -f ${aisdk_zip} ]; then
  echo ""
  echo "[!] Before running this command, download the following files and store them in the same folder."
  echo " * RZ/V2H AI SDK"
  echo "     https://www.renesas.com/en/software-tool/rzv2h-ai-software-development-kit"
  echo "     RTK0EF0180F05000SJ.zip or later."
  echo ""
  exit
fi

unzip -o ${aisdk_zip} */DRP-AI_Translator_i8-*-Install
unzip -o ${aisdk_zip} */poky*.sh
mv -f ai_sdk_setup/* .
rmdir ai_sdk_setup

str=$(basename DRP-AI_Translator_i8-*-Install)
IFS='-' read -r -a str_array <<< "${str}"
tvm_ver=${str_array[2]}

str=$(basename poky*.sh .sh)
IFS='-' read -r -a str_array <<< "${str}"
sdk_ver=${str_array[-1]}


# Build Docker image

wget https://raw.githubusercontent.com/renesas-rz/rzv_drp-ai_tvm/main/DockerfileV2H -O DockerfileV2H

echo "DRP-AI Translator : ${tvm_ver}"
echo "Poky v2h toolchain : ${sdk_ver}"
docker --version

echo ${pwrd} | sudo -kS docker image build -t drp-ai_tvm_v2h_image_${USER} --build-arg SDK="/opt/poky/${sdk_ver}" --build-arg PRODUCT="V2H" -f DockerfileV2H .


# Cleanup

if [[ "--cleanup" =~ ^("$2"|"$3"|"$4")$ ]]; then
  echo ${pwrd} | sudo -kS docker builder prune --force
  echo ${pwrd} | sudo -kS apt clean
  echo ${pwrd} | sudo -kS apt autoremove
fi
rm -f get-docker.sh DRP-AI_Translator_i8-*-Install poky*.sh DockerfileV2H
sudo -k

echo "* Installation complete."
echo ""
exit
