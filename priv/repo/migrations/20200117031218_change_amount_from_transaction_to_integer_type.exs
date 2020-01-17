defmodule Bank.Repo.Migrations.ChangeAmountFromTransactionToIntegerType do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      modify :amount, :integer
    end
  end
end
