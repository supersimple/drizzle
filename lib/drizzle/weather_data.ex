defmodule Drizzle.WeatherData do
  def start_link do
    init = for n <- 1..12, do: nil
    Agent.start_link(fn -> init end, name: __MODULE__)
  end

  def update(next_24_hours) do
    Agent.update(__MODULE__, fn state ->
      Enum.slice(state, 1..12) ++ next_24_hours
    end)
  end

  def reset do
    Agent.update(__MODULE__, fn _state -> [] end)
  end

  def current_state() do
    Agent.get(__MODULE__, fn state -> state end)
  end
end
