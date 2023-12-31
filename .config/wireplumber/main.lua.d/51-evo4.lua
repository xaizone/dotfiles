table.insert (alsa_monitor.rules, {
  matches = {
    {
      { "device.name", "matches", "alsa_card.usb-Audient_EVO4-00" },
    },
  },
  apply_properties = {
    ["device.profile-set"] = "audient-evo4.conf",
    ["session.suspend-timeout-seconds"] = 0,
  }
})
