defmodule Drizzle.IO do
  @gpio_module Application.get_env(:drizzle, :gpio_module, ElixirALE.GPIO)

  def activate_zone(zone) do
    @gpio_module.write(zone, 0)
  end

  def deactivate_zone(zone) do
    @gpio_module.write(zone, 1)
  end
end
