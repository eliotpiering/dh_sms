defmodule DhSms.Repo.Migrations.RemoveContactIdFromConversations do
  use Ecto.Migration

  def change do
    alter table(:conversations) do
      remove :contact_id
    end
  end
end
