defmodule Bank.Transactions.Transactions do
  alias Bank.Repo
  alias Bank.Transactions.Transactions
  alias Bank.Transactions.Transaction

  @doc """
  Creates an transaction.

  Mandatory transactions properties:
    - operation_type (string: [ withdraw or transfer ]
    - amount (float: min 0)
    - payer_id ( UUID )
    - receiver_id ( UUID )
  """

  def create(%{} = transaction_params) do
    changeset =
      %Transaction{}
      |> Transaction.changeset(transaction_params)

    if changeset.valid? do
      Repo.insert(changeset)
    else
      {:error, changeset}
    end
  end
end
