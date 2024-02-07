defmodule PhoenixRise.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :name, :string
      add :country_id, references(:countries, on_delete: :nothing)

      timestamps()
    end

    create index(:contacts, [:country_id])
  end
end
