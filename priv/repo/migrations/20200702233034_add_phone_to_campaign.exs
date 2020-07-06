defmodule DhSms.Repo.Migrations.AddPhoneToCampaign do
  use Ecto.Migration

  def change do
    alter table("campaigns") do
      add :phone, :string
    end
  end
end
