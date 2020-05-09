defmodule Drizzle.IO do
  use GenServer

  @zone_pins Application.get_env(:drizzle, :zone_pins, %{})
  @wifi_interface Application.get_env(:nerves, :interface)
  @wifi_ssid Application.get_env(:nerves, :ssid)
  @wifi_psk Application.get_env(:nerves, :psk)
  @wifi_key_mgmt Application.get_env(:nerves, :key_mgmt)

  # Client

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [])
  end

  def activate(zone) do
    IO.puts "activate #{zone}"
    GenServer.call(__MODULE__, {:activate, zone})
  end

  def deactivate(zone) do
    IO.puts "deactivate #{zone}"
    GenServer.call(__MODULE__, {:deactivate, zone})
  end

  def read_soil_moisture(pin) do
    {:ok, gpio} = Circuits.GPIO.open(pin, :input)
    moisture = Circuits.GPIO.read(gpio)
    Circuits.GPIO.close(gpio)
    moisture
  end

  # Server
  def init(_state) do
    # Nerves.Network.setup(
    #   "#{@wifi_interface}",
    #   ssid: @wifi_ssid,
    #   key_mgmt: @wifi_key_mgmt,
    #   psk: @wifi_psk
    # )
    # %{zone_name => %{:gpio =>.. , :currstate => true/false}
    IO.inspect Circuits.GPIO.info, label: "Circuits.GPIO"
    state =
      @zone_pins
      |> Enum.map(fn {name, pin} -> {name, pin |> init_output()} end)

    {:ok, state}
  end

  # turn off all zones that are currently active
  def handle_call(:activate, zone, state) do
    IO.puts "handle activate #{zone}"
    {:ok,
    state |> Enum.map(fn {zone_name, %{gpio: gpio, currstate: _cst}} ->
        {zone_name, %{
          gpio: gpio,
          currstate: cond do
            zone_name == zone -> :ok = Circuits.GPIO.write(gpio, 0); 1
            true              -> :ok = Circuits.GPIO.write(gpio, 1); 0
          end}}
        end)}
  end

  def handle_call(:deactivate, zone, state) do
    IO.puts "handle deactivate #{zone}"
    {:ok,
    state |> Enum.map(fn {zone_name, %{gpio: gpio, currstate: cst}} ->
      {zone_name, %{
        gpio: gpio,
        currstate: cond do
          zone_name == zone -> :ok = Circuits.GPIO.write(gpio, 1); 0
          true              -> cst
        end}}
      end)}
  end


  defp init_output(pin) do
    {:ok, gpio} = Circuits.GPIO.open(pin, :output)
    :ok = Circuits.GPIO.write(gpio, 0)
    %{gpio: gpio, curr_state: false}
  end

end
