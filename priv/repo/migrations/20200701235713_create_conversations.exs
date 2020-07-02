defmodule DhSms.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :contact_id, references(:contacts, on_delete: :nothing)

      timestamps()
    end

    create index(:conversations, [:contact_id])
  end
end
