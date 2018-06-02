defmodule SupremeTsuguChanWeb.SupremeChannel do
  use Phoenix.Channel

  def join("supreme:service", _message, socket) do
    {:ok, socket}
  end
  def join("supreme:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info(:after_join, socket) do
    broadcast! socket, "user_count", %{ user_count: 1 }
  end

  def handle_in("get_photo_list", _, socket) do
    {:reply, {:error, %{reasons: "not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. not implemented. "}}, socket}
  end
end