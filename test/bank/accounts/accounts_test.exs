defmodule Bank.Accounts.AccountsTest do
  use Bank.DataCase, async: true

  alias Bank.Accounts
  alias Bank.Accounts.Account
  alias Bank.Fixtures
  alias Comeonin.Bcrypt

  defp account do
    account =
      :maria
      |> Fixtures.Accounts.account()

    account
  end

  describe "accounts" do
    @valid_attrs %{
      name: "Gustavo Ziaugra",
      email: "gustavo.ziaugra@live.com",
      password: "1234567"
    }
    @update_attrs %{
      name: "Maria Vladas 23",
      email: "vladinhas@uol.com.br",
      password: "09876543",
      balance: 750 * 100
    }

    @invalid_update_attrs %{
      email: nil,
      balance: -500 * 100
    }

    @invalid_attrs %{name: nil, balance: -1000 * 100, email: nil, encrypted_password: nil}

    test "create/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create(@valid_attrs)
      assert account.email == "gustavo.ziaugra@live.com"
      assert account.balance == 1_000_00
      assert {:ok, _account} = Bcrypt.check_pass(account, "1234567")
    end

    test "update/1 with valid data returns a account" do
      assert {:ok, %Account{} = account} = Accounts.update(account(), @update_attrs)
      assert account.name == "Maria Vladas"
      assert account.email == "maria@valdirme.com.br"
      assert account.balance == 750_00
    end

    test "updates/1 with invalid data returns errors" do
      assert {:error, changeset} = Accounts.update(account(), @invalid_update_attrs)
      assert changeset.valid? == false
      assert changeset.errors |> Enum.empty?() == false
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, changeset} = Accounts.create(@invalid_attrs)
      assert changeset.valid? == false
      assert changeset.errors |> Enum.empty?() == false
    end
  end
end
