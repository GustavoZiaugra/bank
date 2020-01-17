defmodule Bank.Transactions.Transactions do
  alias Bank.Repo
  alias Bank.Transactions.Transaction
  alias Bank.Jobs.Transactions.Withdraw.MailerJob
  alias Bank.Accounts.Account
  alias Bank.Accounts.Accounts
  alias Ecto.Multi

  @doc """
  Creates an transaction.

  Mandatory transactions properties:
    - operation_type (string: [ withdraw or transfer ]
    - amount (float: min 0)
    - payer_id ( UUID )
    - receiver_id ( UUID )
  """

  def run_create(multi, %{} = transaction_params) do
    multi
    |> Multi.run(:create_transaction, fn _repo, _changes ->
      changeset =
        %Transaction{}
        |> Transaction.changeset(transaction_params)

      if changeset.valid? do
        {:ok, transaction} = Repo.insert(changeset)
        {:ok, transaction}
      else
        {:error, changeset}
      end
    end)
  end

  def run_account_balance_update(multi) do
    multi
    |> Multi.run(:account_balance_update, fn _repo, %{create_transaction: transaction} ->
      payer = Accounts.filter_by_uuid(transaction.payer_id)
      receiver = Accounts.filter_by_uuid(transaction.receiver_id)

      {:ok, payer_balance: payer_balance, receiver_balance: receiver_balance} =
        Account.calculate_balance(
          String.to_atom(transaction.operation_type),
          payer,
          receiver,
          transaction.amount
        )

      unless Kernel.is_nil(payer) && Kernel.is_nil(payer_balance) do
        payer
        |> Account.change_account(%{balance: payer_balance})
        |> Repo.update()
      end

      unless Kernel.is_nil(receiver) && Kernel.is_nil(receiver_balance) do
        receiver
        |> Account.change_account(%{balance: receiver_balance})
        |> Repo.update()
      end

      {:ok, transaction}
    end)
  end

  def run_notify_by_mail(multi) do
    multi
    |> Multi.run(:notify_by_mail, fn _repo, %{account_balance_update: transaction} ->
      if transaction.operation_type == "withdraw" do
        Rihanna.enqueue({MailerJob, :perform, [transaction]})
      end

      {:ok, transaction}
    end)
  end

  def create_and_update_account_balance(%{} = transaction_params) do
    transaction_result =
      Multi.new()
      |> run_create(transaction_params)
      |> run_account_balance_update()
      |> run_notify_by_mail()
      |> Repo.transaction(timeout: 600_000)

    case transaction_result do
      {:ok, %{notify_by_mail: transaction}} ->
        {:ok, transaction}

      {:error, failed_operation, failed_value, changes_so_far} ->
        {:error, {failed_operation, failed_value, changes_so_far}}
    end
  end
end
