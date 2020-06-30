defmodule DhSms.Repo.Migrations.CreatePatients do
  use Ecto.Migration

  def change do
    create table(:patients) do
      add :name, :string
      add :email, :string
      add :phone, :string

      timestamps()
    end

    create unique_index(:patients, [:email])
    create unique_index(:patients, [:phone])
  end
end
