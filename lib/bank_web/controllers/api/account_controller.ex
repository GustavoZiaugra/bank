defmodule BankWeb.Api.AccountController do
  use BankWeb, :controller
  alias Bank.Accounts
  alias BankWeb.ErrorView

  @doc """
  Receives a params with this following struct:
      %{
        "account" =>
        %{
          "name" => name,
          "email" => email,
          "password" => password
        }
      }
  """
  def create(conn, %{"account" => account_params}) do
    with {:ok, account} <- Accounts.create(account_params),
         {:ok, account} <- Accounts.format_to_currency(account) do
      conn
      |> put_status(:ok)
      |> json(account)
    else
      {:error, %Ecto.Changeset{valid?: false} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("422.json", changeset: changeset, root_path: "/data")

      _ ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render("400.json")
    end
  end
end
