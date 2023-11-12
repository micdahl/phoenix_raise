defmodule PhoenixRiseWeb.CountryLive.Index do
  use PhoenixRiseWeb, :live_view

  alias PhoenixRise.Basics
  alias PhoenixRise.Basics.Country

  use PhoenixRiseWeb.Ordering, list_function: &Basics.list_countries/2, stream_atom: :countries

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Country")
    |> assign(:country, Basics.get_country!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Country")
    |> assign(:country, %Country{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Countries")
    |> assign(:country, nil)
  end

  @impl true
  def handle_info({PhoenixRiseWeb.CountryLive.FormComponent, {:saved, country}}, socket) do
    {:noreply, stream_insert(socket, :countries, country)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    country = Basics.get_country!(id)
    {:ok, _} = Basics.delete_country(country)

    {:noreply, stream_delete(socket, :countries, country)}
  end
end
