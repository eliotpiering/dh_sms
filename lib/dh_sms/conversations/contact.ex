defmodule DhSms.Conversations.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  alias DhSms.Conversations.{Conversation}

  schema "contacts" do
    field :email, :string
    field :name, :string
    field :phone, :string

    belongs_to :conversation, Conversation

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :email, :phone, :conversation_id])
    |> validate_required([:name, :email, :phone, :conversation_id])
    |> unique_constraint(:email)
  end

  def with_timestamps(contact) do
    timestamps = %{created_at: DateTime.utc_now(), updated_at: DateTime.utc_now()}

    contact
    |> cast(timestamps, [:inserted_at, :updated_at])
  end
end
