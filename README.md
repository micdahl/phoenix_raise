# PhoenixRise

This is a project to test Sorting and Pagination with Phoenix LiveView.

We will use a list of countries with their ISO 3116 country code for test data.

Init:
  * Run `mix ecto.create` and `mix ecto.migrate` to initialize the database
  * Run `mix run priv/repo/seeds.exs` to import the country list

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000/countries`](http://localhost:4000/countries) from your browser.

You can test everything when visiting ['http://localhost:4000/countries'](http://localhost:4000/countries).
Clicking on the table headers sorts by the headers column ascending.
Additional clicking switches the sort order. Currently, there is a bug in LiveView which prevents a proper reordering for elements which are allready in the list.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
