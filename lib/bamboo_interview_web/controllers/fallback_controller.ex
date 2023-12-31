defmodule BambooInterviewWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BambooInterviewWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: BambooInterviewWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: BambooInterviewWeb.ErrorHTML, json: BambooInterviewWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(401)
    |> put_view(BambooInterviewWeb.ErrorJSON)
    |> render("message_error.json", %{message: "Could not perform operation"})
  end
end
