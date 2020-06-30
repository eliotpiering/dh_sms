defmodule DhSmsWeb.ApiPatientController do
  use DhSmsWeb, :controller

  alias DhSms.Accounts
  alias DhSms.Accounts.Patient

  def bulk_create(conn, %{"patients" => patient_params}) do
    case Accounts.create_patients(patient_params) do
      {:ok, patient} ->
        conn
        |> put_status(201)
        |> json(%{})

      {:error, errors} ->
        conn
        |> put_status(400)
        |> json(%{errors: errors})
    end
  end
end
