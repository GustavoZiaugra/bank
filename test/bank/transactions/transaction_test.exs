defmodule Bank.Transactions.TransactionsTest do
  use Bank.DataCase

  alias Bank.Transactions.Transaction
  alias Bank.Transactions.Transactions
  alias Bank.Accounts.Accounts
  alias Bank.Fixtures

  describe "transactions" do
    defp valid_attrs(:transfer) do
      %{
        operation_type: "transfer",
        amount: 100.0,
        receiver_id: Fixtures.Accounts.account(:joe).id,
        payer_id: Fixtures.Accounts.account(:maria).id
      }
    end

    defp valid_attrs(:withdraw) do
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

    defp equal_payer_and_receiver_attrs do
      %{
        operation_type: "withdraw",
        amount: 100.0,
        receiver_id: Fixtures.Accounts.account(:joe).id,
        payer_id: Fixtures.Accounts.account(:joe).id
      }
    end

    test "create_and_update_account_balance/1 with valid data (operation: withdraw) creates a transaction and change account balances" do
      maria_account = Fixtures.Accounts.account(:maria)

      assert maria_account.balance == 1000.0

      {:ok, %Transaction{} = transaction} =
        Transactions.create_and_update_account_balance(valid_attrs(:withdraw))

      assert transaction.amount == 100.0
      assert transaction.operation_type == "withdraw"
      assert transaction.payer_id == valid_attrs(:withdraw).payer_id
      assert transaction.receiver_id == valid_attrs(:withdraw).receiver_id

      maria_account = Accounts.filter_by_uuid(maria_account.id)
      assert maria_account.balance == 900.0
    end

    test "create_and_update_account_balance/1 with valid data (operation: transfer) creates a transaction and change account balances" do
      maria_account = Fixtures.Accounts.account(:maria)
      joe_account = Fixtures.Accounts.account(:joe)

      assert maria_account.balance == 1000.0
      assert joe_account.balance == 1000.0

      {:ok, %Transaction{} = transaction} =
        Transactions.create_and_update_account_balance(valid_attrs(:transfer))

      assert transaction.amount == 100.0
      assert transaction.operation_type == "transfer"
      assert transaction.payer_id == valid_attrs(:transfer).payer_id
      assert transaction.receiver_id == valid_attrs(:transfer).receiver_id

      maria_account = Accounts.filter_by_uuid(maria_account.id)
      joe_account = Accounts.filter_by_uuid(joe_account.id)

      assert maria_account.balance == 900.0
      assert joe_account.balance == 1100.0
    end

    test "create_and_update_account_balance/1 with invalid data returns a invalid transaction" do
      {:error, {_action, changeset, _changes_so_far}} =
        Transactions.create_and_update_account_balance(invalid_attrs())

      assert changeset.valid? == false
      assert changeset.errors |> Enum.empty?() == false
    end

    test "create_and_update_account_balance/1 with invalid data (equal receiver and payer) returns a invalid transaction" do
      {:error, {_action, changeset, _changes_so_far}} =
        Transactions.create_and_update_account_balance(equal_payer_and_receiver_attrs())

      assert changeset.valid? == false
      assert changeset.errors |> Enum.empty?() == false
    end
  end
end
