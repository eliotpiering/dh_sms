defmodule DhSms.Conversations.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias DhSms.Conversations.{Conversation}

  schema "messages" do
    field :body, :string

    belongs_to :conversation, Conversation

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :conversation_id])
    |> validate_required([:body, :conversation_id])
  end
end
