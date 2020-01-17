defmodule Bank.Accounts.Accounts do
  alias Bank.Repo
  alias Bank.Accounts.Account

  @moduledoc """
  Holds `Bank.Accounts.Accounts` related functions.
  """

  @doc """
  Creates an account.

  Mandatory account properties:
    - name ( string: up to 255 chars)
    - email ( string: up to 255 chars)
    - password ( password: min 6 chars and max to 100 chars)
  """

  def create(%{} = account_params) do
    changeset =
      %Account{}
      |> Account.changeset(account_params)

    if changeset.valid? do
      Repo.insert(changeset)
    else
      {:error, changeset}
    end
  end

  @doc """
  Updates an account.

  Only update propertie:
    - balance ( float: min 0)
  """

  def update(%Account{} = account \\ %Account{}, attrs \\ %{}) do
    changeset =
      account
      |> Account.change_account(attrs)

    if changeset.valid? do
      Repo.update(changeset)
    else
      {:error, changeset}
    end
  end

  @doc """
  Returns a instance of account by uuid.
  """

  def filter_by_uuid(nil), do: nil

  def filter_by_uuid(uuid), do: Repo.get(Account, uuid)
end
