defmodule DhSms.Repo.Migrations.AddSenderBoolToMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :from_dh, :boolean
    end
  end
end
