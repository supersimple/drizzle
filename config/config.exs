# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

import_config "#{Mix.Project.config()[:target]}.exs"

config :nerves, interface: :wlan0

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :drizzle,
  location: %{latitude: 39.3898838, longitude: -104.8287546},
  winter_months: [:jan, :feb, :nov, :dec],
  zone_pins: %{
    zone1: 4,
    zone2: 17,
    zone3: 18,
    zone4: 27,
    zone5: 22,
    zone6: 23,
    zone7: 24,
    zone8: 25
  },
  schedule: %{
    sun: [
      %{zone: 5, time_on: 2000, time_off: 2020},
      %{zone: 6, time_on: 2030, time_off: 2050},
      %{zone: 7, time_on: 2100, time_off: 2120}
    ],
    mon: [
      %{zone: 1, time_on: 500, time_off: 515},
      %{zone: 3, time_on: 530, time_off: 545},
      %{zone: 4, time_on: 700, time_off: 715}
    ],
    tue: [
      %{zone: 4, time_on: 700, time_off: 715},
      %{zone: 5, time_on: 2000, time_off: 2020},
      %{zone: 6, time_on: 2030, time_off: 2050},
      %{zone: 7, time_on: 2100, time_off: 2120}
    ],
    wed: [
      %{zone: 1, time_on: 500, time_off: 515},
      %{zone: 3, time_on: 530, time_off: 545},
      %{zone: 4, time_on: 700, time_off: 715}
    ],
    thu: [
      %{zone: 4, time_on: 700, time_off: 715},
      %{zone: 5, time_on: 2000, time_off: 2020},
      %{zone: 6, time_on: 2030, time_off: 2050},
      %{zone: 7, time_on: 2100, time_off: 2120}
    ],
    fri: [
      %{zone: 1, time_on: 500, time_off: 515},
      %{zone: 3, time_on: 530, time_off: 545},
      %{zone: 4, time_on: 700, time_off: 715}
    ],
    sat: [
      %{zone: 1, time_on: 500, time_off: 515},
      %{zone: 3, time_on: 530, time_off: 545},
      %{zone: 4, time_on: 700, time_off: 715}
    ]
  }

config :drizzle, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]

config :darkskyx,
  api_key: System.get_env("DARKSKY_API_KEY") || "b684189af566c4f854398b246a54665c",
  defaults: [
    units: "us",
    lang: "en"
  ]

# Customize non-Elixir parts of the firmware.  See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.
config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [:nerves_runtime],
  app: Mix.Project.config()[:app]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
