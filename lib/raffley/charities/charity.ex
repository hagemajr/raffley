defmodule Raffley.Charities.Charity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "charities" do
    field :name, :string
    field :slugh, :string

    has_many :raffles, Raffley.Raffles.Raffle

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(charity, attrs) do
    charity
    |> cast(attrs, [:name, :slugh])
    |> validate_required([:name, :slugh])
    |> unique_constraint(:slugh)
    |> unique_constraint(:name)
  end
end
