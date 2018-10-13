defmodule Drizzle.Init do
  use GenServer

  @gpio_module Application.get_env(:drizzle, :gpio_module, ElixirALE.GPIO)
  @zone_pins Application.get_env(:drizzle, :zone_pins, %{})

  def start_link(_args) do
    IO.puts("INITIALIING")
    GenServer.start_link(__MODULE__, [])
  end

  def init(_state) do
    Nerves.Network.setup("wlan0", ssid: "p00p", key_mgmt: "WPA-PSK", psk: "auto-ax-warhorse")
    IO.puts("INIT is IN INIT")

    state =
      Enum.map(@zone_pins, fn {name, pin} ->
        register_pin(name, pin)
        Drizzle.IO.deactivate_zone(name)
      end)

    {:ok, state}
  end

  defp register_pin(name, pin) do
    IO.puts("REGISTERING PIN #{pin}")
    {:ok, output_pid} = @gpio_module.start_link(pin, :output, name: name)
    output_pid
  end
end
