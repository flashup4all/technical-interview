defmodule BambooInterview.EmailService do
    @moduledoc false
    alias PeerLearning.Mailer
  
    defp base_email() do
    # this is where there will be  base email setup depending on the transactional email gateway eg.
    #   new_email()
    #   |> from("hello@thepeerlearning.com")
    end
  
    def deliver_email_verification(payload) do
      web_endpoint = Application.fetch_env!(:peer_learning, :web_endpoint)
  
      to_email = payload["email"]
      hashed_token = payload["hashed_token"]
      first_name = payload["first_name"]
  
      base_email()
      |> to(to_email)
      |> subject("[The Peer Learning] Account Verification")
      |> template("email-verification")
      |> substitute_variables(%{
        "first_name" => first_name,
        "password_reset_link" =>
          "#{web_endpoint}/account/verification/#{hashed_token}/#{Base.url_encode64(to_email, padding: false)}"
      })
        |> Mailer.deliver_now()
  
      :ok
    end
  end
  