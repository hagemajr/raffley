defmodule Raffley.Admin do
  alias Raffley.Raffles.Raffle
  alias Raffley.Repo
  import Ecto.Query

  def list_raffles do
    Raffle
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create_raffle(attrs \\ %{}) do
    %Raffle{
      prize: attrs["prize"],
      description: attrs["description"],
      ticket_price: attrs["ticket_price"],
      status: attrs["status"],
      image_path: attrs["image_path"]
    }
    |> Repo.insert!()
  end
end
