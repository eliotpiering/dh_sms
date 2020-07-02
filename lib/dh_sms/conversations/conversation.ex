defmodule DhSms.Conversations.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  alias DhSms.Conversations.{Contact, Message}

  schema "conversations" do
    has_many :messages, Message
    has_one :contact, Contact

    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [])
    |> validate_required([])
  end
end
