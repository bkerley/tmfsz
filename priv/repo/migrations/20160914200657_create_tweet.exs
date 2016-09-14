defmodule Tmfsz.Repo.Migrations.CreateTweet do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :id_str, :string
      add :id_number, :decimal
      add :text, :string
      add :body, :map
      add :created_at, :datetime
      add :caption, :text

      timestamps()
    end

  end
end
