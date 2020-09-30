defmodule LatencyLive.Response do
  use Ecto.Schema
  import Ecto.Changeset

  schema "responses" do
    field :latency, :integer
    field :status, :integer
    field :time, :time
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(response, attrs \\ %{}) do
    response
    |> cast(attrs, [:latency, :status, :time, :url])
  end
end
