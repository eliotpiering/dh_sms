defmodule DhSmsWeb.ApiContactController do
  use DhSmsWeb, :controller

  alias DhSms.Messaging
  alias DhSms.Messaging.Contact

  action_fallback DhSmsWeb.FallbackController

  def bulk_create(conn, %{"contacts" => contact_params}) do
    with results <- Messaging.create_contacts(contact_params) do
      conn
      |> put_status(:created)
      |> render("bulk_create.json", results)
    end
  end
end
