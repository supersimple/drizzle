defmodule Drizzle do
  @moduledoc """
  Documentation for Drizzle.
  """
  use Application
  alias ElixirALE.GPIO

  @zone_pins Application.get_env(:drizzle, :zone_pins, [])
  @schedule Application.get_env(:drizzle, :schedule, %{})

  def start(_type, _args) do
    Enum.map(@zone_pins, fn name, pin ->
      register_pin(name, pin)
    end)
  end

  def activate_zone(zone) do
    IO.puts("activating zone: #{zone}")
    GPIO.write(zone, 1)
  end

  def deactivate_zone(zone) do
    IO.puts("deactivating zone: #{zone}")
    GPIO.write(zone, 0)
  end

  defp register_pin(name, pin) do
    IO.puts("registering: #{name} to pin #{pin}")
    {:ok, output_pid} = GPIO.start_link(pin, :output, name: name)
    output_pid
  end

  def schedule, do: @schedule
end
