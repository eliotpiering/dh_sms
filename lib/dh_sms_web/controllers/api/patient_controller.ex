defmodule DhSmsWeb.ApiPatientController do
  use DhSmsWeb, :controller

  alias DhSms.Accounts
  alias DhSms.Accounts.Patient

  action_fallback DhSmsWeb.FallbackController

  def bulk_create(conn, %{"patients" => patient_params}) do
    with results <- Accounts.create_patients(patient_params) do
      conn
      |> put_status(:created)
      |> render("bulk_create.json", results)
    end
  end
end
