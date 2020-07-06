defmodule DhSmsWeb.Webhooks.MessageController do
  use DhSmsWeb, :controller

  alias DhSms.Messaging
  alias DhSms.Messaging.Message

  def create(conn, params) do
    IO.inspect(params, label: "PARAMS:")

    case Messaging.create_message_from_webhook(params) do
      {:ok, message} ->
        Messaging.send_msg_to_liveview(message)
        # TODO send back accepted resp
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "ERROR")
        # TODO send back error resp
    end

    conn
    |> put_status(:created)
    |> html("<Response></Response>")
  end

# PARAMS:: %{
#   "AccountSid" => "AC89ab956dc906d5b6abeeed0d56e15ea9",
#   "ApiVersion" => "2010-04-01",
#   "Body" => "Yo",
#   "From" => "+16179435514",
#   "FromCity" => "BOSTON",
#   "FromCountry" => "US",
#   "FromState" => "MA",
#   "FromZip" => "01570",
#   "MessageSid" => "SM5473dd4e5078d3591b3dc3811571c0ec",
#   "NumMedia" => "0",
#   "NumSegments" => "1",
#   "SmsMessageSid" => "SM5473dd4e5078d3591b3dc3811571c0ec",
#   "SmsSid" => "SM5473dd4e5078d3591b3dc3811571c0ec",
#   "SmsStatus" => "received",
#   "To" => "+12012855544",
#   "ToCity" => "NEWARK",
#   "ToCountry" => "US",
#   "ToState" => "NJ",
#   "ToZip" => "07105"
# }

end
