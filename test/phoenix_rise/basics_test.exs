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

  describe "contacts" do
    alias PhoenixRise.Basics.Contact

    import PhoenixRise.BasicsFixtures

    @invalid_attrs %{name: nil}

    test "list_contacts/0 returns all contacts" do
      contact = contact_fixture() |> Repo.preload(:country)
      assert Basics.list_contacts() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture() |> Repo.preload(:country)
      assert Basics.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      valid_attrs = %{name: "some name", country_id: country_fixture().id}

      assert {:ok, %Contact{} = contact} = Basics.create_contact(valid_attrs)
      assert contact.name == "some name"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Basics.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Contact{} = contact} = Basics.update_contact(contact, update_attrs)
      assert contact.name == "some updated name"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture() |> Repo.preload(:country)
      assert {:error, %Ecto.Changeset{}} = Basics.update_contact(contact, @invalid_attrs)
      assert contact == Basics.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Basics.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Basics.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Basics.change_contact(contact)
    end
  end
end
