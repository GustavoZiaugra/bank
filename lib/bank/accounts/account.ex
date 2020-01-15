defmodule Bank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bank.Accounts.Account
  alias Comeonin.Bcrypt

  @moduledoc """
    Specifies the expceted struct for Bank.Accounts.Account
  """

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "accounts" do
    field(:name, :string)
    field(:email, :string)
    field(:encrypted_password, :string)
    field(:balance, :float)
    timestamps(created_at: :created_at, updated_at: :updated_at)

    has_many(:made_transactions, Bank.Transactions.Transaction, foreign_key: :payer_id)
    has_many(:received_transactions, Bank.Transactions.Transaction, foreign_key: :receiver_id)
  end

  def changeset(%Account{} = account, attrs \\ %{}) do
    account
    |> cast(attrs, [
      :name,
      :email,
      :encrypted_password,
      :balance
    ])
    |> validate_required([
      :name,
      :email,
      :encrypted_password,
      :balance
    ])
    |> validate_length(:name, max: 255)
    |> validate_length(:email, max: 255)
    |> validate_length(:encrypted_password, min: 6, max: 100)
    |> put_encrypted_password
    |> validate_valid_balance()
    |> unique_constraint(:id)
    |> unique_constraint(:email)
  end

  def change_account(%Account{} = account, attrs \\ %{}) do
    account
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
    |> validate_valid_balance()
  end

  defp put_encrypted_password(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp put_encrypted_password(
         %Ecto.Changeset{changes: %{encrypted_password: password}} = changeset
       ) do
    put_change(changeset, :encrypted_password, Bcrypt.hashpwsalt(password))
  end

  # defp check_password(account) do
  #   if {:ok, _account} = Bcrypt.check_pass(account, account.encrypted_password) do
  #     :ok
  #   else
  #     :invalid_password
  #   end
  # end

  defp validate_valid_balance(%Ecto.Changeset{changes: %{balance: balance}} = changeset) do
    if balance < 0 do
      changeset
      |> add_error(:balance, "balance cannot be negative")
    else
      changeset
    end
  end
end
