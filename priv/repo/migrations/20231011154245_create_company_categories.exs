defmodule BambooInterview.Repo.Migrations.CreateCompanyCategories do
  use Ecto.Migration

  def change do
    create table(:company_categories) do
      add :name, :string
      add :description, :string

      timestamps()
    end
  end
end
