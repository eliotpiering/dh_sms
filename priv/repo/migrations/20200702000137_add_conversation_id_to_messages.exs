defmodule DhSms.Repo.Migrations.AddConversationIdToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :conversation_id, :integer
    end

    create index(:messages, [:conversation_id])
  end
end
