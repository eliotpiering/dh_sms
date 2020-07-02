defmodule DhSms.Repo.Migrations.CreateCampaigns do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      add :name, :string
      add :send_delay, :integer
      add :intro_message, :string

      timestamps()
    end

  end
end
