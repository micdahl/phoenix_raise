defmodule PhoenixRise.BasicsTest do
  use PhoenixRise.DataCase

  alias PhoenixRise.Basics

  describe "countries" do
    alias PhoenixRise.Basics.Country

    import PhoenixRise.BasicsFixtures

    @invalid_attrs %{code: nil, name: nil}

    test "list_countries/0 returns all countries" do
      country = country_fixture()
      assert Basics.list_countries() == [country]
    end

    test "get_country!/1 returns the country with given id" do
      country = country_fixture()
      assert Basics.get_country!(country.id) == country
    end

    test "create_country/1 with valid data creates a country" do
      valid_attrs = %{code: "some code", name: "some name"}

      assert {:ok, %Country{} = country} = Basics.create_country(valid_attrs)
      assert country.code == "some code"
      assert country.name == "some name"
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Basics.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      update_attrs = %{code: "some updated code", name: "some updated name"}

      assert {:ok, %Country{} = country} = Basics.update_country(country, update_attrs)
      assert country.code == "some updated code"
      assert country.name == "some updated name"
    end

    test "update_country/2 with invalid data returns error changeset" do
      country = country_fixture()
      assert {:error, %Ecto.Changeset{}} = Basics.update_country(country, @invalid_attrs)
      assert country == Basics.get_country!(country.id)
    end

    test "delete_country/1 deletes the country" do
      country = country_fixture()
      assert {:ok, %Country{}} = Basics.delete_country(country)
      assert_raise Ecto.NoResultsError, fn -> Basics.get_country!(country.id) end
    end

    test "change_country/1 returns a country changeset" do
      country = country_fixture()
      assert %Ecto.Changeset{} = Basics.change_country(country)
    end
  end
end
