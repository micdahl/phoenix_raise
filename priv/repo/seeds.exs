# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixRise.Repo.insert!(%PhoenixRise.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
if not PhoenixRise.Repo.exists?(PhoenixRise.Basics.Country) do
  current_time = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

  File.stream!(Path.join(Path.dirname(__ENV__.file), "./countries.csv"))
  |> CSV.decode(headers: true)
  |> Enum.filter(fn {:ok, row} ->
    row["ISO3166-1-Alpha-2"] != nil and row["CLDR display name"] != nil
  end)
  |> Enum.map(fn {:ok, row} ->
    %{
      code: row["ISO3166-1-Alpha-2"],
      name: row["CLDR display name"],
      inserted_at: current_time,
      updated_at: current_time
    }
  end)
  |> (fn countries -> PhoenixRise.Repo.insert_all(PhoenixRise.Basics.Country, countries) end).()
end
