defmodule Drizzle do
  @moduledoc """
  Documentation for Drizzle.
  """
  use Application
  alias ElixirALE.GPIO

  @zone_pins Application.get_env(:drizzle, :zone_pins, [
               {:zone1, 0},
               {:zone3, 1},
               {:zone4, 2},
               {:zone5, 11},
               {:zone6, 12},
               {:zone7, 13}
             ])
  @schedule %{
    zone1: [
      %{day: 1, time_on: 500, time_off: 515},
      %{day: 3, time_on: 500, time_off: 515},
      %{day: 5, time_on: 500, time_off: 515}
    ],
    zone3: [
      %{day: 1, time_on: 530, time_off: 545},
      %{day: 3, time_on: 530, time_off: 545},
      %{day: 5, time_on: 530, time_off: 545}
    ],
    zone4: [
      %{day: 1, time_on: 700, time_off: 715},
      %{day: 2, time_on: 700, time_off: 715},
      %{day: 3, time_on: 700, time_off: 715},
      %{day: 4, time_on: 700, time_off: 715},
      %{day: 5, time_on: 700, time_off: 715}
    ],
    zone5: [
      %{day: 0, time_on: 2000, time_off: 2020},
      %{day: 2, time_on: 2000, time_off: 2020},
      %{day: 4, time_on: 2000, time_off: 2020}
    ],
    zone6: [
      %{day: 0, time_on: 2030, time_off: 2050},
      %{day: 2, time_on: 2030, time_off: 2050},
      %{day: 4, time_on: 2030, time_off: 2050}
    ],
    zone7: [
      %{day: 0, time_on: 2100, time_off: 2120},
      %{day: 2, time_on: 2100, time_off: 2120},
      %{day: 4, time_on: 2100, time_off: 2120}
    ]
  }

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
    {:ok, output_pid} = GPIO.start_link(pin, :output, name: name)
    output_pid
  end

  def schedule, do: @schedule
end
