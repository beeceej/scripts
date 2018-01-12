#! /bin/bash

TMP_DIR=$HOME/.install_go/$(date +%Y-%m-%d:%s)

GO_HOST_URL_BASE=https://dl.google.com/go/

set -e
setup() {
    mkdir -p $TMP_DIR
}

cleanup() {
    rm -r $HOME/.install_go
}

download() {
    local url=$1
    local version=$2

    if [[ -d /usr/local/.goconfig/$version/go ]]; then
        echo "version $version already cached, no need to retrieve it again..."
    else
        wget $url -P "${TMP_DIR}"
    if    
}

unpack() {
    local version=$1
    local arch=$2

    if [[ -L /usr/local/go || -d /usr/local/go ]]; then
        sudo rm -rf /usr/local/go        
    fi
    sudo mkdir -p /usr/local/.goconfig/$version

    sudo tar -C /usr/local/.goconfig/$version/ -xvf "${TMP_DIR}/${version}.${arch}.tar.gz"
    sudo ln -s /usr/local/.goconfig/$version/go /usr/local/go
}

main() {
    local version=$1
    local arch=$2

    setup
    download "${GO_HOST_URL_BASE}${version}.${arch}.tar.gz" $2
    unpack $version $arch
    cleanup
}


main $1 $2