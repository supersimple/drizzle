defmodule Drizzle.GPIO do
  @moduledoc """
  This module acts as a mock for the ElixirAle GPIO module and it used strictly
  for running on the host environment.
  """

  def write(name, 0), do: IO.puts("deactivating zone: #{name}")
  def write(name, 1), do: IO.puts("activating zone: #{name}")

  def start_link(pin, direction, name: name) do
    IO.puts("registering: #{name} as #{direction} to pin #{pin}")
    {:ok, :pid}
  end
end
