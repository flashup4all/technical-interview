defmodule BambooInterview.EmailService do
  @moduledoc false
  import Swoosh.Email

  defp base_email() do
    new()
    |> from({"Bamboo", "lucky@bamboo.com"})
  end

  def deliver_welcome_email(user) do
    web_endpoint = Application.fetch_env!(:bamboo_interview, :web_endpoint)
    url = "#{web_endpoint}"

    base_email()
    |> to({user.first_name, user.email})
    |> subject("Our New Listed Stock")
    |> html_body("<h1>Hello #{user.first_name}</h1>")
    |> text_body(
      "Welcome to Bamboo\n Welcome to Bamboo Interview, visit your account by clicking the button below \n <a href=#{url}>Click here</a>"
    )

    :ok
  end

  def deliver_new_listed_stock_email(user, stock) do
    web_endpoint = Application.fetch_env!(:bamboo_interview, :web_endpoint)

    stock_url = "#{web_endpoint}/view-stock"

    base_email()
    |> to({user.first_name, user.email})
    |> subject("Our New Listed Stock")
    |> html_body("<h1>Hello #{user.first_name}</h1>")
    |> text_body(
      "Company name #{stock.name}\n Company symbol #{stock.symbol}\n Country #{stock.country}\n click <a href=#{stock_url}>here</a> to view the listing"
    )

    :ok
  end
end
