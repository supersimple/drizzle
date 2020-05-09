# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

import_config "#{Mix.Project.config()[:target]}.exs"

config :drizzle,
  location: %{latitude: System.get_env("LATITUDE"), longitude: System.get_env("LONGITUDE")},
  utc_offset: 2,
  winter_months: [:jan, :feb, :nov, :dec],
  #soil_moisture_sensor: %{pin: 26, min: 0, max: 539},
  # For Waveshare RPi relay board (B variant, 8 relays)
  # https://www.waveshare.com/rpi-relay-board-b.htm
  zone_pins: %{
    zone1: 5,
    zone2: 6,
    zone3: 13,
    zone4: 16,
    zone5: 19,
    zone6: 20,
    zone7: 21,
    zone8: 26
  },
  # watering times are defined as key {start_time, end_time}
  available_watering_times: %{
    morning: {300, 600}
    #evening: {2100, 2300}
  },
  # schedule is defined as {zone, watering_time_key, duration_in_minutes}
  schedule: %{
    sun: [
      {:zone4, :morning, 20},
      {:zone5, :morning, 20},
      {:zone6, :morning, 20},
      {:zone7, :morning, 10}
    ],
    mon: [
      {:zone1, :morning, 20},
      {:zone3, :morning, 20}
    ],
    tue: [
      {:zone4, :morning, 20},
      {:zone5, :morning, 20},
      {:zone6, :morning, 20},
      {:zone7, :morning, 10}
    ],
    wed: [
      {:zone1, :morning, 20},
      {:zone3, :morning, 20}
    ],
    thu: [
      {:zone4, :morning, 20},
      {:zone5, :morning, 20},
      {:zone6, :morning, 20},
      {:zone7, :morning, 10}
    ],
    fri: [
      {:zone1, :morning, 20},
      {:zone3, :morning, 20},
      {:zone5, :evening, 10}
    ],
    sat: [
      {:zone7, :morning, 10},
      {:zone5, :morning, 10}
    ]
  }

config :darkskyx,
  api_key: System.get_env("DARKSKY_API_KEY"),
  defaults: [
    units: "auto",
    lang: "en"
  ]

# Customize non-Elixir parts of the firmware.  See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.
config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [:nerves_runtime, :nerves_pack],
  app: Mix.Project.config()[:app]

config :mdns_lite,
  # The `host` key specifies what hostnames mdns_lite advertises.  `:hostname`
  # advertises the device's hostname.local. For the official Nerves systems, this
  # is "nerves-<4 digit serial#>.local".  mdns_lite also advertises
  # "nerves.local" for convenience. If more than one Nerves device is on the
  # network, delete "nerves" from the list.

  host: [:hostname, "drizzle"],
  ttl: 120,

  # Advertise the following services over mDNS.
  services: [
    %{
      name: "SSH Remote Login Protocol",
      protocol: "ssh",
      transport: "tcp",
      port: 22
    },
    %{
      name: "Secure File Transfer Protocol over SSH",
      protocol: "sftp-ssh",
      transport: "tcp",
      port: 22
    },
    %{
      name: "Erlang Port Mapper Daemon",
      protocol: "epmd",
      transport: "tcp",
      port: 4369
    }
  ]
# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
