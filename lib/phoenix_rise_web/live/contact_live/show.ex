defmodule PhoenixRiseWeb.ContactLive.Show do
  use PhoenixRiseWeb, :live_view

  alias PhoenixRise.Basics

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:contact, Basics.get_contact!(id))}
  end

  defp page_title(:show), do: "Show Contact"
  defp page_title(:edit), do: "Edit Contact"
end
