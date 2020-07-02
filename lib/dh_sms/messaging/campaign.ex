defmodule DhSms.Messaging.Campaign do
  use Ecto.Schema
  import Ecto.Changeset

  alias DhSms.Messaging.{Contact, Conversation}

  schema "campaigns" do
    field :intro_message, :string
    field :name, :string
    field :send_delay, :integer

    has_many :conversations, Conversation

    many_to_many :contacts, Contact, join_through: "campaigns_contacts"

    timestamps()
  end

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:name, :send_delay, :intro_message])
    |> validate_required([:name, :send_delay, :intro_message])
  end
end
