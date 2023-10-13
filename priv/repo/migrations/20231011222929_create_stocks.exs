defmodule BambooInterview.Repo.Migrations.CreateStocks do
  use Ecto.Migration

  def change do
    create table(:stocks) do
      add :name, :string
      add :symbol, :string
      add :country, :string
      add :stock_exchange_type, :string
      add :company_category_id, references(:company_categories)
      timestamps()
    end

    create index(:stocks, [:company_category_id])
  end
end
