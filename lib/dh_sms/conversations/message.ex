defmodule DhSms.Conversations.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias DhSms.Conversations.{Conversation}

  schema "messages" do
    field :body, :string
    field :from_dh, :boolean

    belongs_to :conversation, Conversation

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :conversation_id, :from_dh])
    |> validate_required([:body, :conversation_id, :from_dh])
  end
end
