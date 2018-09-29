defmodule Drizzle.Init do
  use GenServer

  @gpio_module Application.get_env(:drizzle, :gpio_module, ElixirALE.GPIO)
  @zone_pins Application.get_env(:drizzle, :zone_pins, %{})

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_state) do
    state =
      Enum.map(@zone_pins, fn {name, pin} ->
        register_pin(name, pin)
      end)

    {:ok, state}
  end

  defp register_pin(name, pin) do
    {:ok, output_pid} = @gpio_module.start_link(pin, :output, name: name)
    output_pid
  end
end
