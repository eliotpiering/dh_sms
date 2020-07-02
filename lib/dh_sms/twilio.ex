defmodule DhSms.Twilio do

  @twilio_number "+12058519333"

  def send_message(to, body) do
    ExTwilio.Message.create([to: to, from: @twilio_number, body: body], ["provideFeedback": true])
  end
end
