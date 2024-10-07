#!/bin/bash
set -e
echo "* Installing RZ/V2H DRP-AI TVM with Docker ..."
read -sp "sudo password: " pwrd
tty -s && echo

echo ${pwrd} | sudo -kS apt update
echo ${pwrd} | sudo -kS DEBIAN_FRONTEND=noninteractive apt install -y wget unzip curl


# * RZ/V2H AI SDK
#     https://www.renesas.com/en/software-tool/rzv2h-ai-software-development-kit
#     RTK0EF0180F05000SJ.zip or later.

aisdk_zip=RTK0EF0180F0???0SJ.zip


# Install Docker (If docker is not installed or if the parameter has "install-docker", install it.)

docker --version>/dev/null
if [ $? -eq 127 ] || [ "$1" = "install-docker" ]; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  echo ${pwrd} | sudo -kS sh get-docker.sh
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
IFS='-' read -r -a str_array <<< "$str"
tvm_ver=${str_array[2]}

str=$(basename poky*.sh .sh)
IFS='-' read -r -a str_array <<< "$str"
sdk_ver=${str_array[-1]}


# Build Docker image

wget https://raw.githubusercontent.com/renesas-rz/rzv_drp-ai_tvm/main/DockerfileV2H -O DockerfileV2H

echo "DRP-AI Translator : ${tvm_ver}"
echo "Poky v2h toolchain : ${sdk_ver}"
docker --version

echo ${pwrd} | sudo -kS docker image build -t drp-ai_tvm_v2h_image_${USER} --build-arg SDK="/opt/poky/${sdk_ver}" --build-arg PRODUCT="V2H" -f DockerfileV2H .


# Cleanup

#echo ${pwrd} | sudo -kS docker builder prune
rm -f get-docker.sh DRP-AI_Translator_i8-*-Install poky*.sh DockerfileV2H
sudo -k

echo "* Installation complete."
echo ""

