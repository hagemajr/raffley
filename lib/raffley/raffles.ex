defmodule Raffley.Raffles do
  alias Raffley.Raffles.Raffle
  alias Raffley.Repo
  alias Raffley.Charities.Charity
  import Ecto.Query

  def list_raffles do
    Repo.all(Raffle)
  end

  def filter_raffles(filter) do
    Raffle
    |> with_status(filter["status"])
    |> with_charity(filter["charity"])
    |> search_by(filter["q"])
    |> sort(filter["sort_by"])
    |> Repo.all()
    |> Repo.preload(:charity)
  end

  defp with_status(query, status) when status in ~w(open closed upcoming) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  defp with_charity(query, slug) when slug in ["", nil], do: query

  defp with_charity(query, slug) do
    query
    |> join(:inner, [r], c in Charity, on: r.charity_id == c.id)
    |> where([r, c], c.slugh == ^slug)
  end

  defp search_by(query, q) when q in ["", nil] do
    query
  end

  defp search_by(query, q) do
    where(query, [r], ilike(r.prize, ^"%#{q}%"))
  end

  defp sort_option("prize"), do: :prize
  defp sort_option("ticket_price_desc"), do: [desc: :ticket_price]
  defp sort_option("ticket_price_asc"), do: [asc: :ticket_price]
  defp sort_option(_), do: :id

  defp sort(query, sort_by) when sort_by == "charity" do
    from r in query, join: c in Charity, on: r.charity_id == c.id, order_by: c.name
  end

  defp sort(query, sort_by) do
    order_by(query, ^sort_option(sort_by))
  end

  def get_raffle!(id) do
    Repo.get!(Raffle, id)
    |> Repo.preload(:charity)
  end

  def featured_raffles(raffle) do
    Process.sleep(2000)

    Raffle
    |> where(status: :open)
    |> where([r], r.id != ^raffle.id)
    |> order_by(desc: :ticket_price)
    |> limit(3)
    |> Repo.all()
  end
end
