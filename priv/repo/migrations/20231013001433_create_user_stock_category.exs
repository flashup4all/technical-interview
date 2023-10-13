defmodule BambooInterview.Repo.Migrations.CreateUserStockCategory do
  use Ecto.Migration

  def change do
    create table(:user_stock_category) do
      add :user_id, references(:users)
      add :company_category_id, references(:company_categories)

      timestamps()
    end

    create index(:user_stock_category, [:user_id])
    create index(:user_stock_category, [:company_category_id])
  end
end
