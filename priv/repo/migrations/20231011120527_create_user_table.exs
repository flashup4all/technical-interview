defmodule BambooInterview.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :password_hash, :string
      add :role, :string
      add :gender, :string
      add :is_active, :boolean
      add :deleted_at, :utc_datetime_usec
      timestamps()
    end

    create unique_index(:users, :email)
  end
end
