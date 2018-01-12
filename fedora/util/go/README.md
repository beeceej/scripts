# Install Go from the command line

## Usage

* `./install_go.sh go1.9.2 linux-amd64`
* `./install_go.sh go1.9 linux-amd64`
* `./install_go.sh go1.8 linux-amd64`

In general...
./install_go.sh $VERSION $ARCH

Utility installs to `/usr/local/.goconfig/$version/go` then symlinks to `/usr/local/go`

Before downloading install_go will check if the requested version is already installed

# Warning....
* This script requires root, and as such always ensure you're running what you think you're running... It hasn't blown up my machine ...yet... but that doesn't mean it won't blow yours up..
* If there are any issues running a go install from a symlink, I haven't found any yet


# Isn't this like [gimme](https://github.com/travis-ci/gimme)?
* yeah... but I wanted to write it myself.


# Contributions?
* Please

