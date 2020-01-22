defmodule BankWeb.Router do
  use BankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankWeb do
    pipe_through :api

    post("/account/create", Api.AccountController, :create)
    post("/report/transactions", Api.Report.TransactionController, :index)
  end
end
