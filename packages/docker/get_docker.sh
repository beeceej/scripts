# Removes current docker installation,
# Installs latest based on your system.
# There is the likelyhood the docker repositories have not been enabled for your OS yet,
# Dec 05. 2017, docker repositories still aren't out for Fedora 27, watch out for this

remove_existing() {
	echo "Removing existing Docker installation"
	sudo dnf -y remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
}


add_stable() {
	echo "adding docker-ce stable to dnf repo's"
	sudo dnf config-manager \
		--add-repo \
		https://download.docker.com/linux/fedora/docker-ce.repo

}

install_docker() {
	echo "installing docker-ce"
	sudo dnf -y install docker-ce
}

# Trick pointed out here,
# https://github.com/docker/for-linux/issues/164
# useful for switching out os versions if docker release isn't up to date
use_os_version() {
	local VERSION=$1
	sudo mkdir -p /etc/dnf/vars
	echo $VERSION | sudo tee /etc/dnf/vars/docker_release_version
	sudo sed -i 's/\$releasever/$docker_release_version/g' /etc/yum.repos.d/docker-ce.repo
}


main() {
	local FEDORA_VERSION=$1
	remove_existing
	add_stable
	use_os_version $FEDORA_VERSION
	install_docker
}

main $1
