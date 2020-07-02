defmodule DhSms.Campaigns.Campaign do
  use Ecto.Schema
  import Ecto.Changeset

  schema "campaigns" do
    field :intro_message, :string
    field :name, :string
    field :send_delay, :integer

    timestamps()
  end

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:name, :send_delay, :intro_message])
    |> validate_required([:name, :send_delay, :intro_message])
  end
end
