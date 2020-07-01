defmodule DhSms.Repo.Migrations.RenamePatientsTable do
  use Ecto.Migration

  def change do
    rename table(:patients), to: table(:contacts)
  end
end
