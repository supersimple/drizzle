defmodule Drizzle.WeatherData do
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
    init = for _n <- 1..12, do: nil
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
