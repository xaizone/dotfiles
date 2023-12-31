table.insert (alsa_monitor.rules, {
  matches = {
    {
      { "device.name", "matches", "alsa_card.pci-*" },
    },
  },
  apply_properties = {
    ["device.disabled"] = true,
  }
})
