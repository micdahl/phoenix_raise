defmodule PhoenixRiseWeb.CountryLive.Index do
  use PhoenixRiseWeb, :live_view

  alias PhoenixRise.Basics
  alias PhoenixRise.Basics.Country

  @impl true
  def mount(_params, _session, socket) do
    per_page = 80
    page = 1
    order_by = :name
    order = "asc"

    {:ok,
     stream(
       socket,
       :countries,
       Basics.list_countries(per_page: per_page, page: page, order: order, order_by: order_by)
     )
     |> assign(per_page: per_page)
     |> assign(page: page)
     |> assign(order_by: order_by)
     |> assign(order: order)}
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
    order_by = socket.assigns.order_by
    order = socket.assigns.order
    per_page = socket.assigns.per_page
    new_page = page + 1

    additional_countries =
      Basics.list_countries(page: new_page, order_by: order_by, order: order, per_page: per_page)

    {:noreply,
     stream(socket, :countries, additional_countries)
     |> assign(page: new_page)}
  end

  def handle_event("order-by", value, socket) do
    new_order_by = String.to_atom(String.downcase(value["order-column"]))
    old_order_by = socket.assigns.order_by
    order = socket.assigns.order
    page = 1
    per_page = 80

    new_order =
      (fn
         new_order_by, old_order_by, "asc" when new_order_by === old_order_by ->
           "desc"

         _, _, _ ->
           "asc"
       end).(new_order_by, old_order_by, order)

    countries =
      Basics.list_countries(
        order_by: new_order_by,
        order: new_order,
        page: page,
        per_page: per_page
      )

    {:noreply,
     stream(socket, :countries, countries, reset: true)
     |> assign(page: page)
     |> assign(per_page: per_page)
     |> assign(order_by: new_order_by)
     |> assign(order: new_order)}
  end
end
