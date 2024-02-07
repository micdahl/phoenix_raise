defmodule PhoenixRise.BasicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixRise.Basics` context.
  """

  @doc """
  Generate a country.
  """
  def country_fixture(attrs \\ %{}) do
    {:ok, country} =
      attrs
      |> Enum.into(%{
        code: "some code",
        name: "some name"
      })
      |> PhoenixRise.Basics.create_country()

    country
  end

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    {:ok, contact} =
      attrs
      |> Enum.into(%{
        name: "some name",
        country_id: country_fixture().id
      })
      |> PhoenixRise.Basics.create_contact()

    contact
  end
end
