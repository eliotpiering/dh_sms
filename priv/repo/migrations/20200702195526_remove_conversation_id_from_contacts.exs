defmodule DhSms.Repo.Migrations.RemoveConversationIdFromContacts do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      remove :conversation_id
    end
  end
end
