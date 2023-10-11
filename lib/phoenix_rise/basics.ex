defmodule PhoenixRise.Basics do
  @moduledoc """
  The Basics context.
  """

  import Ecto.Query, warn: false
  alias PhoenixRise.Repo

  alias PhoenixRise.Basics.Country

  @doc """
  Returns the list of countries.

  ## Examples

      iex> list_countries()
      [%Country{}, ...]

  """
  def list_countries do
    list_countries([])
  end

  def list_countries(criteria) when is_list(criteria) do
    query = from(p in Country, order_by: [asc: :name])

    Enum.reduce(criteria, [query, 1, 80], fn
      {:page, page}, [query, _page, per_page] ->
        [query, page, per_page]

      {:per_page, per_page}, [query, page, _per_page] ->
        [from(q in query, limit: ^per_page), page, per_page]

      _, [query, page, per_page] ->
        [query, page, per_page]
    end)
    |> (fn
          [query, page, per_page] when page > 0 and per_page > 0 ->
            from(q in query, offset: (^page - 1) * ^per_page)
        end).()
    |> Repo.all()
  end

  @doc """
  Gets a single country.

  Raises `Ecto.NoResultsError` if the Country does not exist.

  ## Examples

      iex> get_country!(123)
      %Country{}

      iex> get_country!(456)
      ** (Ecto.NoResultsError)

  """
  def get_country!(id), do: Repo.get!(Country, id)

  @doc """
  Creates a country.

  ## Examples

      iex> create_country(%{field: value})
      {:ok, %Country{}}

      iex> create_country(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a country.

  ## Examples

      iex> update_country(country, %{field: new_value})
      {:ok, %Country{}}

      iex> update_country(country, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a country.

  ## Examples

      iex> delete_country(country)
      {:ok, %Country{}}

      iex> delete_country(country)
      {:error, %Ecto.Changeset{}}

  """
  def delete_country(%Country{} = country) do
    Repo.delete(country)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking country changes.

  ## Examples

      iex> change_country(country)
      %Ecto.Changeset{data: %Country{}}

  """
  def change_country(%Country{} = country, attrs \\ %{}) do
    Country.changeset(country, attrs)
  end
end
