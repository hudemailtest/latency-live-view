defmodule LatencyLive.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :latency, :integer
      add :status, :integer
      add :time, :time
      add :url, :string

      timestamps()
    end

  end
end
