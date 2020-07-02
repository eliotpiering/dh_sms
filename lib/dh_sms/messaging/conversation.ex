defmodule DhSms.Messaging.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  alias DhSms.Messaging.{Campaign, Contact, Message}

  schema "conversations" do
    has_many :messages, Message

    belongs_to :contact, Contact
    belongs_to :campaign, Campaign

    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:contact_id, :campaign_id])
    |> validate_required([:contact_id, :campaign_id])
  end
end
