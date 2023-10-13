# BambooInterview
This code base shows the implementation of the interview challenge in this [link](https://public.3.basecamp.com/p/LxaEZfRZGCQ7VTy1qwECo1H7)

To start your Phoenix server:
  * Run `mix setup` to install and setup dependencies
  * Update `.env` variables
  ```
    export DB_USERNAME=postgres
    export DB_HOSTNAME=localhost
    export DB_PASSWORD=1234
    export DATABASE=bamboo_interview_dev
    export WEB_ENDPOINT=http://your_frontend.com
  ```

  * Run `mix ecto.setup` to setup database env
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

#### Adopted practice
1. The use of Elixir's `GenServer` for cron job and to subscribe and listen to mock data (assumption is that the mock data it serves as our api/gateway). This implementation can be see in the `BambooInterview.Events.CreateStocksCronJob` module
2. I also used Elixir  `task.async` to handle light gateway tasks (eg. sending of emails). An Improvement here is to use `Oban` to execute the event which also logs the process for you. Oban allows you to trace and retry incase an event fails.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
