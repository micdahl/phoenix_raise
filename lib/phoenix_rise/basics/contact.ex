defmodule PhoenixRise.Basics.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :name, :string
    belongs_to :country, PhoenixRise.Basics.Country

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :country_id])
    |> validate_required([:name, :country_id])
  end
end
