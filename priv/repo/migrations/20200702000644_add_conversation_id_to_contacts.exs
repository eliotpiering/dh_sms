defmodule DhSms.Repo.Migrations.AddConversationIdToContacts do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :conversation_id, :integer
    end

    create index(:contacts, [:conversation_id])
  end
end
