defmodule DhSms.Accounts.Patient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "patients" do
    field :email, :string
    field :name, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(patient, attrs) do
    patient
    |> cast(attrs, [:name, :email, :phone])
    |> validate_required([:name, :email, :phone])
    |> unique_constraint(:email)
  end

  def with_timestamps(patient) do
    timestamps = %{created_at: DateTime.utc_now(), updated_at: DateTime.utc_now()}

    patient
    |> cast(timestamps, [:inserted_at, :updated_at])
  end
end
