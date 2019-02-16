defmodule Drizzle.IO do
  @gpio_module Application.get_env(:drizzle, :gpio_module, Circuits.GPIO)

  def activate_zone(zone) do
    @gpio_module.write(zone, 0)
  end

  def deactivate_zone(zone) do
    @gpio_module.write(zone, 1)
  end

  def read_soil_moisture(pin) do
    {:ok, gpio} = @gpio_module.open(pin, :input)
    moisture = @gpio_module.read(gpio)
    @gpio_module.close(gpio)
    moisture
  end
end
