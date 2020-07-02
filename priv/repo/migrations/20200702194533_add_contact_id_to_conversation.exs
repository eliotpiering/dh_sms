defmodule DhSms.Repo.Migrations.AddContactIdToConversation do
  use Ecto.Migration

  def change do
    alter table(:conversations) do
      add :contact_id, references("contacts")
    end
  end
end
