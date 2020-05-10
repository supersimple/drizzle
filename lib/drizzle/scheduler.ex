defmodule Drizzle.Scheduler do
  use GenServer

  alias Drizzle.TodaysEvents

  @schedule Application.get_env(:drizzle, :schedule, %{})
  @days_as_atoms {:zero, :sun, :mon, :tue, :wed, :thu, :fri, :sat}
  @utc_offset Application.get_env(:drizzle, :utc_offset, 0)

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    IO.puts("Starting scheduler")
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    #IO.puts("Checking watering schedule for on/off times")
    execute_scheduled_events()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    # Every Minute
    Process.send_after(self(), :work, 60 * 1000)
  end

  defp current_day_of_week do
    DateTime.utc_now()
    |> DateTime.to_date()
    |> Date.day_of_week()
    |> adjust_for_utc_offset()
    |> day_number_as_atom()
  end

  defp current_time do
    time =
      DateTime.utc_now()
      |> DateTime.to_time()
      |> Time.add(60 * 60 * @utc_offset)

    time.hour * 100 + time.minute
  end

  defp execute_scheduled_events do
    if current_time() == 0 || TodaysEvents.current_state() == [] do
      TodaysEvents.reset()
      TodaysEvents.update(Map.get(@schedule, current_day_of_week()))
    end

    case Enum.find(TodaysEvents.current_state(), fn {time, _a, _z} ->
           time == current_time()
         end) do
      {_time, :on, zone} -> Drizzle.IO.activate(zone)
      {_time, :off, zone} -> Drizzle.IO.deactivate(zone)
      _ -> "Nothing to do right now."
    end
  end

  defp day_number_as_atom(index) do
    elem(@days_as_atoms, index)
  end

  defp adjust_for_utc_offset(day_of_week) do
    utc_time = DateTime.utc_now() |> DateTime.to_time()

    case utc_time.hour + @utc_offset do
      time when time < 0 -> -1
      time when time >= 24 -> 1
      _ -> 0
    end
    |> offset_day_of_week(day_of_week)
  end

  defp offset_day_of_week(0, day_of_week), do: day_of_week
  defp offset_day_of_week(1, day_of_week) when day_of_week < 7, do: day_of_week + 1
  defp offset_day_of_week(1, 7), do: 1
  defp offset_day_of_week(-1, day_of_week) when day_of_week > 1, do: day_of_week - 1
  defp offset_day_of_week(-1, 1), do: 7
end
