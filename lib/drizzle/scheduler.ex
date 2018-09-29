defmodule Drizzle.Scheduler do
  use GenServer

  @schedule Application.get_env(:drizzle, :schedule, %{})
  @days_as_atoms {:sun, :mon, :tue, :wed, :thu, :fri, :sat}

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    IO.puts("Starting scheduler")
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    IO.puts("Checking watering schedule for on/off times")
    execute_scheduled_events()
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
    |> day_number_as_atom()
  end

  defp current_time do
    time =
      "America/Denver"
      |> Timex.now()
      |> DateTime.to_time()

    time.hour * 100 + time.minute
  end

  defp execute_scheduled_events do
    if current_time() == 0 || true do
      Drizzle.TodaysEvents.reset()
      Drizzle.TodaysEvents.update(Map.get(@schedule, current_day_of_week()))
    end

    case Enum.find(Drizzle.TodaysEvents.current_state(), fn {time, _a, _z} ->
           time == current_time()
         end) do
      {_time, :on, zone} -> Drizzle.IO.activate_zone(zone)
      {_time, :off, zone} -> Drizzle.IO.deactivate_zone(zone)
      _ -> "Nothing to do right now."
    end
  end

  defp day_number_as_atom(index) do
    elem(@days_as_atoms, index)
  end
end
