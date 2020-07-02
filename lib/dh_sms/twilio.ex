defmodule DhSms.Twilio do

  @twilio_number "+12012855544"

  def send_message(to, body) do
    ExTwilio.Message.create(to: to, from: @twilio_number, body: body)
  end
end
