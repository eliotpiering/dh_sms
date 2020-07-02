defmodule DhSms.Repo.Migrations.RemoveContactIdFromMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      remove :contact_id
    end
  end
end
