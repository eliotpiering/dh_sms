defmodule DhSms.Messaging.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :email, :string
    field :name, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :email, :phone])
    |> validate_required([:name, :email, :phone])
    |> unique_constraint(:email)
  end

  def with_timestamps(contact) do
    timestamps = %{created_at: DateTime.utc_now(), updated_at: DateTime.utc_now()}

    contact
    |> cast(timestamps, [:inserted_at, :updated_at])
  end
end
