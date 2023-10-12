defmodule PhoenixRiseWeb.Ordering do
  defmacro __using__(opts) do
    list_function = Keyword.get(opts, :list_function, fn _ -> [] end)
    stream_atom = Keyword.get(opts, :stream_atom, :entries)
    default_order_field = Keyword.get(opts, :default_order_field, :name)
    default_order = Keyword.get(opts, :default_order, "asc")

    alternative_order =
      if default_order === "asc" do
        "desc"
      else
        "asc"
      end

    default_page_size = Keyword.get(opts, :default_page_size, 80)
    default_start_page = Keyword.get(opts, :default_start_page, 1)

    quote do
      @impl true
      def mount(_params, _session, socket) do
        {:ok,
         stream(
           socket,
           unquote(stream_atom),
           unquote(list_function).(
             per_page: unquote(default_page_size),
             page: unquote(default_start_page),
             order: unquote(default_order),
             order_by: unquote(default_order_field)
           )
         )
         |> assign(per_page: unquote(default_page_size))
         |> assign(page: unquote(default_start_page))
         |> assign(order_by: unquote(default_order_field))
         |> assign(order: unquote(default_order))}
      end

      def handle_event("load-more", _value, socket) do
        page = socket.assigns.page
        order_by = socket.assigns.order_by
        order = socket.assigns.order
        per_page = socket.assigns.per_page
        new_page = page + 1

        additional_elems =
          unquote(list_function).(
            page: new_page,
            order_by: order_by,
            order: order,
            per_page: per_page
          )

        {:noreply,
         stream(socket, unquote(stream_atom), additional_elems)
         |> assign(page: new_page)}
      end

      def handle_event("order-by", value, socket) do
        new_order_by = String.to_atom(String.downcase(value["order-column"]))
        old_order_by = socket.assigns.order_by
        order = socket.assigns.order
        page = unquote(default_start_page)
        per_page = socket.assigns.per_page

        new_order =
          (fn
             new_order_by, old_order_by, unquote(default_order)
             when new_order_by === old_order_by ->
               unquote(alternative_order)

             _, _, _ ->
               unquote(default_order)
           end).(new_order_by, old_order_by, order)

        elems =
          unquote(list_function).(
            order_by: new_order_by,
            order: new_order,
            page: page,
            per_page: per_page
          )

        {:noreply,
         stream(socket, unquote(stream_atom), elems, reset: true)
         |> assign(page: page)
         |> assign(per_page: per_page)
         |> assign(order_by: new_order_by)
         |> assign(order: new_order)}
      end
    end
  end
end
