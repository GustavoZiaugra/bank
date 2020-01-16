defmodule Bank.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bank.Accounts.Accounts
  alias Bank.Accounts.Account
  alias Bank.Transactions.Transaction

  @operation_types [
    "withdraw",
    "transfer"
  ]

  @moduledoc """
    Specifies the expected struct for Bank.Transactions.Transaction
  """

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "transactions" do
    field(:operation_type, :string)
    field(:amount, :float)
    timestamps(created_at: :created_at, updated_at: :updated_at)

    belongs_to(:receiver, Bank.Accounts.Account, foreign_key: :receiver_id, type: :binary_id)
    belongs_to(:payer, Bank.Accounts.Account, foreign_key: :payer_id, type: :binary_id)
  end

  def changeset(%Transaction{} = transaction, attrs \\ %{}) do
    transaction
    |> cast(attrs, [
      :operation_type,
      :amount,
      :payer_id,
      :receiver_id
    ])
    |> validate_required([
      :operation_type,
      :amount
    ])
    |> validate_inclusion(:operation_type, @operation_types)
    |> validate_valid_amount()
    |> validate_and_put_payer()
    |> validate_and_put_receiver()
    |> validate_account_by_transaction()
    |> unique_constraint(:id)
  end

  defp validate_valid_amount(%Ecto.Changeset{changes: %{amount: amount}} = changeset) do
    if amount < 0 do
      changeset
      |> add_error(:balance, "amount cannot be negative")
    else
      changeset
    end
  end

  defp validate_account_by_transaction(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp validate_account_by_transaction(
         %Ecto.Changeset{changes: %{payer_id: payer_id, receiver_id: receiver_id, amount: amount}} =
           changeset
       ) do
    payer = Accounts.filter_by_uuid(payer_id)
    receiver = Accounts.filter_by_uuid(receiver_id)

    if payer == receiver do
      changeset
      |> add_error(:payer_id, "payer is equal receiver_id")
    else
      case Account.verify_balance(payer, amount) do
        :not_authorized ->
          changeset
          |> add_error(:amount, "this operation cannot be authorized")

        :authorized ->
          changeset
      end
    end
  end

  def validate_and_put_payer(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  def validate_and_put_payer(%Ecto.Changeset{changes: %{payer_id: payer_id}} = changeset) do
    payer = Accounts.filter_by_uuid(payer_id)

    if Kernel.is_nil(payer) do
      changeset
      |> add_error(:payer_id, "payer not exists")
    else
      changeset
      |> put_assoc(:payer, payer)
    end
  end

  def validate_and_put_receiver(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  def validate_and_put_receiver(%Ecto.Changeset{changes: %{receiver_id: receiver_id}} = changeset) do
    receiver = Accounts.filter_by_uuid(receiver_id)

    if Kernel.is_nil(receiver) do
      changeset
      |> add_error(:receiver_id, "receiver not exists")
    else
      changeset
      |> put_assoc(:receiver, receiver)
    end
  end
end
