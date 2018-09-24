defmodule Drizzle.Scheduler do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    IO.puts("Starting scheduler")
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Check current time
    # Is a sprinkler scheduled to start or stop now?
    # if so Drizzle.activate_zone/1 or Drizzle.deactivate_zone/2
    IO.puts("Checking watering schedule for on/off times")
    Drizzle.schedule()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # Every Minute
    Process.send_after(self(), :work, 60 * 1000)
  end

  defp current_day_of_week do
    "America/Denver"
    |> Timex.now()
    |> DateTime.to_date()
    |> Date.day_of_week()
  end

  defp current_time do
    time =
      "America/Denver"
      |> Timex.now()
      |> DateTime.to_time()

    time.hour * 100 + time.minute
  end
end
