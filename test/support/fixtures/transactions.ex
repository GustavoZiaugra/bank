defmodule Bank.Fixtures.Transactions do
  @moduledoc """
  Module responsible for holding transaction related fixtures.
  """

  alias Bank.Repo
  alias Bank.Transactions.Transaction
  alias Bank.Fixtures
  import Ecto.Query, only: [from: 2]

  def transaction(fixture_name, attrs \\ %{})

  def transaction(:default, attrs) do
    transaction =
      %Transaction{
        id: "ae4aaa13-676e-483e-919e-42fb13e159c7",
        receiver_id: Fixtures.Accounts.account(:joe).id,
        payer_id: Fixtures.Accounts.account(:maria).id
      }
      |> Map.merge(attrs)

    get_or_create_transaction(transaction)
  end

  defp get_or_create_transaction(transaction) do
    query = from(t in Transaction, where: t.id == ^transaction.id, limit: 1)

    case Repo.one(query) do
      nil -> Repo.insert!(transaction)
      _ -> Repo.one(query)
    end
  end
end
