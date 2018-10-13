defmodule Drizzle.Forecaster do
  use GenServer
  alias Drizzle.Weather

  def start_link(_args) do
    IO.puts("INITIALIZING FORECASTER")
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    IO.puts("Starting forecaster")
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    IO.puts("Checking weather forecast")
    # Get the forecast from Darksky and update the Agent
    Weather.get_todays_forecast()

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # Every Hour
    Process.send_after(self(), :work, 60 * 60 * 1000)
  end
end
