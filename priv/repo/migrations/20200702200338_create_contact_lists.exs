defmodule DhSms.Repo.Migrations.CreateContactLists do
  use Ecto.Migration

  def change do
    create table(:campaigns_contacts) do
      add :contact_id, references(:contacts)
      add :campaign_id, references(:campaigns)
    end

    create unique_index(:campaigns_contacts, [:contact_id, :campaign_id])
  end
end
