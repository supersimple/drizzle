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
    # Check current time
    # Is a sprinkler scheduled to start or stop now?
    # if so Drizzle.activate_zone/1 or Drizzle.deactivate_zone/2
    if current_time() == 0 || true do
      Drizzle.TodaysEvents.reset()
      Drizzle.TodaysEvents.update(Map.get(@schedule, current_day_of_week()))
    end

    # read the schedule
    # [
    #   {2100, :on, :zone5},
    #   {2110, :off, :zone5},
    #   {500, :on, :zone1},
    #   {520, :off, :zone1},
    #   {520, :on, :zone3},
    #   {540, :off, :zone3}
    # ]
  end

  defp day_number_as_atom(index) do
    elem(@days_as_atoms, index)
  end
end
