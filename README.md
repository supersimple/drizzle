# Drizzle

## To Do

Make a mock of the GPIO module to use on host.
```
# target config
config :my_app, MyApp.HardwareLayer, [
   implementation: MyApp.HardwareLayer.ElixirAleImplementation
]
# host config
config :my_app, MyApp.HardwareLayer, [
   implementation: MyApp.HardwareLayer.StubImplementation
]
```
Change schedule to allow for flexible watering times.
- ex. instead of setting zone1 to run from 500-515 on monday, set it to run
for 15 minutes on monday, regardless of time. That will allow for the
adjustment factor without overlapping other zone schedules.

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app:
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: http://www.nerves-project.org/
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
