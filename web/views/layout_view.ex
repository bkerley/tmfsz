defmodule Tmfsz.LayoutView do
  use Tmfsz.Web, :view

  def body_class(conn) do
    controller_name = conn
    |> Phoenix.Controller.controller_module
    |> Phoenix.Naming.resource_name("Controller")

    action_name = conn
    |> Phoenix.Controller.action_name

    "con_#{controller_name} act_#{action_name}"
  end
end
