-------------------
---- AUTOSTART ----
-------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'")
  hl.exec_cmd("uwsm app -- gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

  hl.exec_cmd("uwsm app -- fcitx5")
end)
