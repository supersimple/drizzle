defmodule Drizzle.TodaysEvents do
  @available_watering_times Application.get_env(:drizzle, :available_watering_times, %{})

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link(_args) do
    IO.puts("Initializing todays events")
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def update(today) do
    Agent.update(__MODULE__, fn _state ->
      calculate_start_stop_time(today)
    end)
  end

  def reset do
    Agent.update(__MODULE__, fn _state -> [] end)
  end

  def current_state() do
    Agent.get(__MODULE__, fn state -> state end)
  end

  defp calculate_start_stop_time(today) do
    Enum.group_by(today, fn {_z, avail, _d} -> avail end)
    |> Enum.map(fn {key, list} -> reduce_event_groups(key, list) end)
    |> Enum.reduce([], fn m, acc -> acc ++ m[:events] end)
  end

  defp reduce_event_groups(key, list) do
    factor = Drizzle.Weather.weather_adjustment_factor()
    {start_time, _stop_time} = Map.get(@available_watering_times, key)

    Enum.reduce(list, %{last_time: start_time, events: []}, fn {zone, _grp, duration}, acc ->
      new_start_event = {acc[:last_time], :on, zone}
      acc = update_in(acc[:last_time], &(&1 + duration * factor))
      new_stop_event = {acc[:last_time], :off, zone}
      acc = update_in(acc[:last_time], &(&1 + 1))
      update_in(acc[:events], &(&1 ++ [new_start_event, new_stop_event]))
    end)
  end
end
