# libinput enables touchpad disable-while-typing by default
# In the Gnome desktop environment this will disable said "feature"
# Only needed on some laptops

main() {
  gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
}

main
