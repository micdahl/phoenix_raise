defmodule PhoenixRiseWeb.CountryLive.Index do
  use PhoenixRiseWeb, :live_view

  alias PhoenixRise.Basics
  alias PhoenixRise.Basics.Country

  @impl true
  def mount(_params, _session, socket) do
    per_page = 80
    page = 1

    {:ok,
     stream(socket, :countries, Basics.list_countries(per_page: per_page, page: page))
     |> assign(per_page: per_page)
     |> assign(page: page)}
  end

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

  def handle_event("load-more", _value, socket) do
    page = socket.assigns.page
    additional_countries = Basics.list_countries(page: page + 1)

    {:noreply,
     stream(socket, :countries, additional_countries)
     |> assign(page: page + 1)}
  end
end
