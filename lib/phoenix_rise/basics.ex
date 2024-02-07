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
    list_countries(criteria, %{})
  end

  def list_countries(criteria, filters) do
    query = from(p in Country)

    query =
      filters
      |> Map.to_list()
      |> Enum.reduce(query, fn
        {key, value}, query ->
          from(q in query,
            where: ilike(field(q, ^String.to_atom(String.downcase(key))), ^"%#{value}%")
          )
      end)

    Enum.reduce(criteria, [query, 1, 80, "asc", :name], fn
      {:page, page}, [query, _page, per_page, order, order_by] ->
        [query, page, per_page, order, order_by]

      {:per_page, per_page}, [query, page, _per_page, order, order_by] ->
        [from(q in query, limit: ^per_page), page, per_page, order, order_by]

      {:order, order}, [query, page, per_page, _order, order_by] ->
        [query, page, per_page, order, order_by]

      {:order_by, order_by}, [query, page, per_page, order, _order_by] ->
        [query, page, per_page, order, order_by]

      _, [query, page, per_page, order, order_by] ->
        [query, page, per_page, order, order_by]
    end)
    |> (fn
          [query, page, per_page, "desc", order_by] when page > 0 and per_page > 0 ->
            from(q in query,
              limit: ^per_page,
              offset: (^page - 1) * ^per_page,
              order_by: [desc: ^order_by]
            )

          [query, page, per_page, _, order_by] when page > 0 and per_page > 0 ->
            from(q in query,
              limit: ^per_page,
              offset: (^page - 1) * ^per_page,
              order_by: [asc: ^order_by]
            )
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

  alias PhoenixRise.Basics.Contact

  @doc """
  Returns the list of contacts.

  ## Examples

      iex> list_contacts()
      [%Contact{}, ...]

  """
  def list_contacts do
    Repo.all(from c in Contact, preload: :country)
  end

  @doc """
  Gets a single contact.

  Raises `Ecto.NoResultsError` if the Contact does not exist.

  ## Examples

      iex> get_contact!(123)
      %Contact{}

      iex> get_contact!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contact!(id) do
    Repo.get!(Contact, id)
    |> Repo.preload(:country)
  end

  @doc """
  Creates a contact.

  ## Examples

      iex> create_contact(%{field: value})
      {:ok, %Contact{}}

      iex> create_contact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contact.

  ## Examples

      iex> update_contact(contact, %{field: new_value})
      {:ok, %Contact{}}

      iex> update_contact(contact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a contact.

  ## Examples

      iex> delete_contact(contact)
      {:ok, %Contact{}}

      iex> delete_contact(contact)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contact changes.

  ## Examples

      iex> change_contact(contact)
      %Ecto.Changeset{data: %Contact{}}

  """
  def change_contact(%Contact{} = contact, attrs \\ %{}) do
    Contact.changeset(contact, attrs)
  end
end
