defmodule Drizzle.Init do
  use GenServer

  @gpio_module Application.get_env(:drizzle, :gpio_module, ElixirALE.GPIO)
  @zone_pins Application.get_env(:drizzle, :zone_pins, %{})
  @wifi_interface Application.get_env(:nerves, :interface)
  @wifi_ssid Application.get_env(:nerves, :ssid)
  @wifi_psk Application.get_env(:nerves, :psk)
  @wifi_key_mgmt Application.get_env(:nerves, :key_mgmt)

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_state) do
    Nerves.Network.setup(
      "#{@wifi_interface}",
      ssid: @wifi_ssid,
      key_mgmt: @wifi_key_mgmt,
      psk: @wifi_psk
    )

    state =
      Enum.map(@zone_pins, fn {name, pin} ->
        register_pin(name, pin)
        Drizzle.IO.deactivate_zone(name)
      end)

    {:ok, state}
  end

  defp register_pin(name, pin) do
    {:ok, output_pid} = @gpio_module.start_link(pin, :output, name: name)
    output_pid
  end
end
