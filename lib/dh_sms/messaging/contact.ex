defmodule DhSms.Messaging.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  alias DhSms.Messaging.{Conversation, Campaign}

  schema "contacts" do
    field :email, :string
    field :name, :string
    field :phone, :string

    has_many :conversations, Conversation

    many_to_many :campaigns, Campaign, join_through: "campaigns_contacts"

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
