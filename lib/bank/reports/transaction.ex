defmodule Bank.Reports.Transactions do
  alias Bank.Transactions

  @doc """
  Returns a map with this properties:
    - total_by_day when report is by_day
    - total_by_month when report is by_month
    - total_by_year when report is by_year
    - total_amount when report is total
  Returns:
  {:ok, transactions, amount}
  """

  def get_report(:by_day) do
    transactions = Transactions.filter_by_day()
    amount = nil

    {:ok, %{transactions: transactions, amount: amount}}
  end

  def get_report(:by_month) do
    transactions = Transactions.filter_by_month()
    amount = nil

    {:ok, %{transactions: transactions, amount: amount}}
  end

  def get_report(:by_year) do
    transactions = Transactions.filter_by_year()
    amount = nil

    {:ok, %{transactions: transactions, amount: amount}}
  end

  def get_report(:total) do
    transactions = Transactions.all()
    amount = nil

    {:ok, %{transactions: transactions, amount: amount}}
  end
end
