defmodule BankWeb.Router do
  use BankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :basic_auth do
    plug BasicAuth, use_config: {:bank, :bank_basic_auth}
  end

  scope "/api", BankWeb do
    pipe_through :api

    post("/account/create", Api.AccountController, :create)
  end

  scope "/api/", BankWeb.Api.Report do
    pipe_through [:api, :basic_auth]
    post("/report/transactions", TransactionController, :index)
  end
end
