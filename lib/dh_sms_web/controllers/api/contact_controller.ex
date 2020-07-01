defmodule DhSmsWeb.ApiContactController do
  use DhSmsWeb, :controller

  alias DhSms.Accounts
  alias DhSms.Accounts.Contact

  action_fallback DhSmsWeb.FallbackController

  def bulk_create(conn, %{"contacts" => contact_params}) do
    with results <- Accounts.create_contacts(contact_params) do
      conn
      |> put_status(:created)
      |> render("bulk_create.json", results)
    end
  end
end
