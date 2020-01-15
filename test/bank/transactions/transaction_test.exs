defmodule Bank.Transactions.TransactionsTest do
  use Bank.DataCase

  alias Bank.Transactions.Transaction
  alias Bank.Transactions.Transactions
  alias Bank.Fixtures

  describe "transactions" do
    defp valid_attrs do
      %{
        operation_type: "withdraw",
        amount: 100.0,
        receiver_id: Fixtures.Accounts.account(:joe).id,
        payer_id: Fixtures.Accounts.account(:maria).id
      }
    end

    defp invalid_attrs do
      %{
        operation_type: "joelzinho",
        amount: -500.0,
        receiver_id: Fixtures.Accounts.account(:joe).id,
        payer_id: nil
      }
    end

    test "create/1 with valid data creates a transaction" do
      {:ok, %Transaction{} = transaction} = Transactions.create(valid_attrs())
      assert transaction.amount == 100.0
      assert transaction.operation_type == "withdraw"
      assert transaction.payer_id == valid_attrs().payer_id
      assert transaction.receiver_id == valid_attrs().receiver_id
    end

    test "create/1 with invalid data returns a invalid transaction" do
      {:error, changeset} = Transactions.create(invalid_attrs())
      assert changeset.valid? == false
      assert changeset.errors |> Enum.empty?() == false
    end
  end
end
