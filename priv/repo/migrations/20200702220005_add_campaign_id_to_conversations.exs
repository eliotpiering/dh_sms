defmodule DhSms.Repo.Migrations.AddCampaignIdToConversations do
  use Ecto.Migration

  def change do
    alter table(:conversations) do
      add :campaign_id, references(:campaigns)
    end
  end
end
