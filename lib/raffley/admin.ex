defmodule Raffley.Admin do
  alias Raffley.Raffles.Raffle
  alias Raffley.Repo
  alias Raffley.Raffles
  import Ecto.Query

  def list_raffles do
    Raffle
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create_raffle(attrs \\ %{}) do
    %Raffle{}
    |> Raffle.changeset(attrs)
    |> Repo.insert()
  end

  def change_raffle(%Raffle{} = raffle, attrs \\ %{}) do
    Raffle.changeset(raffle, attrs)
  end

  def get_raffle!(id) do
    Repo.get!(Raffle, id)
  end

  def draw_winner(%Raffle{status: :closed} = raffle) do
    raffle = Repo.preload(raffle, :tickets)

    case raffle.tickets do
      [] ->
        {:error, "No tickets to draw!"}

      tickets ->
        winner = Enum.random(tickets)

        {:ok, _raffle} = update_raffle(raffle, %{winning_ticket_id: winner.id})
    end
  end

  def draw_winner(%Raffle{}) do
    {:error, "Raffle must be closed to draw a winner."}
  end

  # This version does the random selection in the database which can be more performant for large row counts
  def draw_winner_ecto(%Raffle{status: :closed} = raffle) do
    winner =
      raffle
      |> Ecto.assoc(:tickets)
      |> order_by(fragment("RANDOM()"))
      |> limit(1)
      |> Repo.one()

    case winner do
      nil ->
        {:error, "No tickets to draw!"}

      _ ->
        {:ok, _raffle} =
          update_raffle(raffle, %{
            winning_ticket_id: winner.id
          })
    end
  end

  def update_raffle(%Raffle{} = raffle, attrs) do
    raffle
    |> Raffle.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, raffle} ->
        raffle = Repo.preload(raffle, [:charity, :winning_ticket])
        Raffles.broadcast(raffle.id, {:raffle_updated, raffle})
        {:ok, raffle}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_raffle(%Raffle{} = raffle) do
    Repo.delete(raffle)
  end

  def get_raffle_with_tickets!(id) do
    get_raffle!(id)
    |> Repo.preload(tickets: :user)
  end
end
