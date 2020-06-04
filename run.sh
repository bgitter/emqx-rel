#!/bin/bash

PWD=$(cd `dirname $0`; pwd)
echo "script dir:${PWD}"
# 进入脚步所在目录
cd ${PWD}

DIR="_build/emqx/rel"

SERVERS=("182.92.190.253;jenkins;Q3ADVold7AmUIoDhkQvFBSKVu" "39.96.84.143;jenkins;Q3ADVold7AmUIoDhkQvFBSKVu")

clear(){
  echo "clear..."
  T=${PWD}/${DIR}/target
  rm -rf ${T}
}

## 打包
build() {
  clear
  cd ${DIR}
  echo "build..."
  T="target"
  if [ ! -d ${T} ]; then
    mkdir ${T}
  fi
  echo "目录：${T}创建成功"

  tar -zcf ${T}/emqx.tar.gz emqx/
  echo "打包成功"
}

publish(){
  Host=$1
  User=$2
  Pass=$3
  echo "Server:${Host} Host:${User} User:${Pass}"
  From=${PWD}/${DIR}/target/emqx.tar.gz
  Dist="/" ## UNDONE
}

## 同步至目标服务器
deploy(){
  echo "deploy."
  for S in ${SERVERS[@]};
  do
    echo "${S}"
    Server=(${S//;/ })
    publish ${Server[0]} ${Server[1]} ${Server[2]}
    echo "-----------------------"
  done
}

run(){
  ## build
  deploy
}

run