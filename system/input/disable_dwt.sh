# libinput enables touchpad disable-while-typing by default
# In the Gnome desktop environment this will disable said "feature" 

main() {
  local INPUT_TOGGLE=$1
  gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
}

main
