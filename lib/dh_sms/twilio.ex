defmodule DhSms.Twilio do

  @twilio_number "+12012855544"
  @base_url "https://api.twilio.com"

  def send_message(to, body) do
    ExTwilio.Message.create(to: to, from: @twilio_number, body: body)
  end

  def list_phone_numbers() do
    {:system, name} = Application.get_env(:ex_twilio, :account_sid)
    account_sid = System.get_env(name)

    {:ok, rsp} = ExTwilio.Api.get("#{@base_url}/2010-04-01/Accounts/#{account_sid}/IncomingPhoneNumbers.json")
    {:ok, parsed} = rsp.body |> Poison.decode
    parsed["incoming_phone_numbers"] |> Enum.map (fn p -> p["phone_number"] end)
  end
end
