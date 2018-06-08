#! /bin/bash

TMP_DIR=$HOME/.install_go/$(date +%Y-%m-%d:%s)

GO_HOST_URL_BASE=https://dl.google.com/go/

set -e
setup() {
    mkdir -p "$TMP_DIR"
}

cleanup() {
    rm -r "$HOME/.install_go"
}

download() {
    local url=$1

    if [[ -d /usr/local/.goconfig/$version/go ]]; then
        echo "version $version already cached, no need to retrieve it again..."
    else
        wget "$url" -P "$TMP_DIR"
    fi
}

unpack() {
    local version=$1
    local arch=$2

    sudo mkdir -p "/usr/local/.goconfig/$version"

    sudo tar -C "/usr/local/.goconfig/$version/" -xf "$TMP_DIR/$version.$arch.tar.gz"
}

remove_old_install() {
    if [[ -L /usr/local/go || -d /usr/local/go ]]; then
        echo "Removing Previous Go installation.."
        sudo rm -rf /usr/local/go        
    fi
}

symlink_to_version() {
    local version=$1

    echo "linking /usr/local/.goconfig/$version/go -> /usr/local/go"
    sudo ln -s "/usr/local/.goconfig/$version/go /usr/local/go"
}

main() {
    local version=$1
    local arch=$2

    setup

    if [[ -d /usr/local/.goconfig/$version/go ]]; then
        echo "version $version already cached, no need to retrieve it again..."
        remove_old_install
        symlink_to_version "$version"
    else
        download "${GO_HOST_URL_BASE}${version}.${arch}.tar.gz"
        unpack "$version" "$arch"
        remove_old_install
        symlink_to_version "$version"
    fi

    cleanup
}


main "$1" "$2"