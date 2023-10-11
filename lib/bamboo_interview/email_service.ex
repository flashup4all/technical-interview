defmodule BambooInterview.EmailService do
  @moduledoc false
  import Swoosh.Email

  defp base_email() do
    new()
    |> from({"Bamboo", "lucky@bamboo.com"})
  end

  def deliver_email_verification(payload) do
    web_endpoint = Application.fetch_env!(:bamboo_interview, :web_endpoint)

    to_email = payload["email"]
    hashed_token = payload["hashed_token"]
    first_name = payload["first_name"]
    # ensure you implement the verification endpoint
    email_verification_url =
      "#{web_endpoint}/account/verification/#{hashed_token}/#{Base.url_encode64(to_email, padding: false)}"

    base_email()
    |> to({first_name, to_email})
    |> subject("Our New Listed Stock")
    |> html_body("<h1>Hello #{first_name}</h1>")
    |> text_body(
      "Welcome to Bamboo\n Please verify your account by clicking the button below \n <a href=#{email_verification_url}>Click here</a>"
    )

    :ok
  end

  def deliver_listed_stock_email(payload) do
    web_endpoint = Application.fetch_env!(:bamboo_interview, :web_endpoint)

    to_email = payload["email"]
    first_name = payload["first_name"]
    stock_name = payload["stock_name"]
    stock_symbol = payload["stock_symbol"]
    stock_address = payload["stock_address"]
    stock_country = payload["stock_country"]
    stock_url = "#{web_endpoint}/view-stock"

    base_email()
    |> to({first_name, to_email})
    |> subject("Our New Listed Stock")
    |> html_body("<h1>Hello #{first_name}</h1>")
    |> text_body(
      "Company name #{stock_name}\n Company symbol #{stock_symbol}\n Company address #{stock_address}\n Country #{stock_country}\n click <a href=#{stock_url}>here</a> to view the listing"
    )

    :ok
  end
end
