defmodule DhSms.Repo.Migrations.CreateAccountPhoneNumbers do
  use Ecto.Migration

  def change do
    create table("account_phone_numbers") do
      add :digits,  :string, size: 12
      add :sid,     :string, size: 34
      add :status,  :string
      timestamps()
    end
  end
end
