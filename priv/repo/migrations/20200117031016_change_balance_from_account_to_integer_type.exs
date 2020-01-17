defmodule Bank.Repo.Migrations.ChangeBalanceFromAccountToIntegerType do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      modify :balance, :integer
    end
  end
end
