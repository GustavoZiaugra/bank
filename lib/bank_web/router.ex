defmodule BankWeb.Router do
  use BankWeb, :router
  alias BankWeb.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :basic_auth do
    plug BasicAuth, use_config: {:bank, :bank_basic_auth}
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api", BankWeb do
    pipe_through :api

    post("/account/sign_up", Api.AccountController, :sign_up)
    post("/account/sign_in", Api.AccountController, :sign_in)
  end

  scope "/api/", BankWeb.Api.Report do
    pipe_through [:api, :basic_auth]
    post("/report/transactions", TransactionController, :index)
  end

  scope "/api/", BankWeb do
    pipe_through [:api, :jwt_authenticated]

    post("/transaction/create", Api.TransactionController, :create)
  end
end
