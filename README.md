![logo](https://i.imgur.com/6kYR90I.png)

Drizzle is a Nerves-based home sprinkler system.
It is designed to support up to 8 zones, and will automatically adjust watering
times given local weather data.
By default, the watering times will increase gradually as the temperature reaches
a predetermined threshold (90ºF) and will decrease gradually based on recent and
upcoming precipitation.
The system will also shut down when the temperature drops below a predetermined
threshold (40ºF). You also have the option to set "Winter months", which are
months where the system will not run regardless of temperature.

## Configuration

For the system to work properly, you need to export some ENV variables. For weather forecasts, set the following:
- `LATITUDE=<your local latitude>`
- `LONGITUDE=<your local longitude>`
- `DARKSKY_API_KEY=<your 32 character API key>`
_Weather forecasts are retrieved from Dark Sky. You can get a free API key at:
[https://darksky.net/dev](https://darksky.net/dev)._

## First boot
When your device starts up *for its first time* it will need to know the SSID and passphrase (aka PSK, pre-shared key) for the wireless SSID its going to connect to (for weather updates for example). This process is done using the [VintageNetWizard](https://hexdocs.pm/vintage_net_wizard/readme.html), so this means you have to temporarily connect your mobile or laptop to the wireless access point named "nerves_xxxxx" (where xxxxx is an automatically generated ID for your nerves machine) and access a basic web portal to select your home network and provide its password. 

Once you select a wireless network and provide the credentials, just double-check your entered the correct passphrase and click on `Complete without validation` button (as validation involves the AP dropping the connection to test connecting to your home router's AP and then reconnecting it back to the temporary AP later - so I find it error-prone and inconvenient).

After the process is complete, the WiFi card will be automatically configured with the SSID and passphrase upon next boot-ups.

## How It Works

- Starts the weather data agent, which stores state for the previous 12 hours and next 24 hours of weather. Until the system has been online for 12 hours, your previous 12 hours will not be set.
- Registers each of your zones with a corresponding GPIO pin on your device.
- Initializes a schedule of todays events. (This will happen at midnight each day or whenever the schedule for today is empty.) This means starting up a genserver and loading it with the schedule from your config file.
- Starts a recurring genserver that checks the weather each hour and updates the weather data agent.
- Each minute the scheduler checks if there is a scheduled event for the current time. Events are either to activate or deactivate a zone. If an event is scheduled, the GPIO sends the correct signal to the relay board to fulfill the request.  

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Testing
Getting Circuits.GPIO to work in stub mode is tricky, as it needs recompilation. You only need to recompile when you switch mix targets though:
```sh
$ rm -rf _build/
$ MIX_ENV="test" MIX_TARGET="host" CIRCUITS_MIX_ENV="test" mix test
...
```

when done with testing, clean all build artifacts and recompile:
```sh
$ rm -rf _build/
$ MIX_TARGET="rpi3" mix firmware
```

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
