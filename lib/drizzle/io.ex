defmodule Drizzle.IO do
  use GenServer

  @zone_pins Application.get_env(:drizzle, :zone_pins, %{})

  # ======
  # Client
  # ======
  def start_link(_args) do
    {:ok, _} = GenServer.start_link(__MODULE__, [], name: DrizzleIO)
  end

  def activate(zone) do
    GenServer.cast(DrizzleIO, {:activate, zone})
  end

  def deactivate(zone) do
    GenServer.cast(DrizzleIO, {:deactivate, zone})
  end

  def read_soil_moisture(pin \\ 2) do
    GenServer.call(DrizzleIO, {:read_soil_moisture, pin})
  end

  # ======
  # Server
  # ======
  def init(_state) do
    IO.puts("Starting Drizzle.IO")
    IO.inspect Circuits.GPIO.info, label: "Circuits.GPIO"
    # %{zone_name => %{:gpio =>.. , :currstate => true/false}
    state =
      @zone_pins
      |> Enum.map(fn {name, pin} -> {name, pin |> init_output()} end)

    {:ok, state}
  end

  defp init_output(pin) do
    {:ok, gpio} = Circuits.GPIO.open(pin, :output)
    :ok = Circuits.GPIO.write(gpio, 1)
    %{gpio: gpio, currstate: 0}
  end

  def handle_cast({:activate, zone}, state) do
    IO.puts "handle activate #{zone}"
    {:noreply,
    state |> Enum.map(fn {zone_name, %{gpio: gpio, currstate: _cst}} ->
      {zone_name, %{
        gpio: gpio,
        currstate: cond do
          zone_name == zone -> :ok = Circuits.GPIO.write(gpio, 0); 1
          # turn off all zones that are currently active
          true              -> :ok = Circuits.GPIO.write(gpio, 1); 0
        end}}
     end)}
  end

  def handle_cast({:deactivate, zone}, state) do
    IO.puts "handle deactivate #{zone}"
    {:noreply,
    state |> Enum.map(fn {zone_name, %{gpio: gpio, currstate: cst}} ->
      {zone_name, %{
        gpio: gpio,
        currstate: cond do
          zone_name == zone -> :ok = Circuits.GPIO.write(gpio, 1); 0
          true              -> cst
        end}}
      end)}
  end

  def handle_call({:read_soil_moisture, pin}, _from, state) do
    {:ok, gpio} = Circuits.GPIO.open(pin, :input)
    moisture = Circuits.GPIO.read(gpio)
    Circuits.GPIO.close(gpio)
    {:reply, moisture, state}
  end

end
