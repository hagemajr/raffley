defmodule RaffleyWeb.AdminRaffleLive.Edit do
  use RaffleyWeb, :live_view
  alias Raffley.Admin
  alias Raffley.Raffles.Raffle
  import RaffleyWeb.CustomComponents

  def mount(%{"id" => id}, _session, socket) do
    raffle = Admin.get_raffle!(id)
    changeset = Admin.change_raffle(raffle)

    socket =
      socket
      |> assign(:page_title, "Edit Raffle")
      |> assign(:raffle, raffle)
      |> assign(:form, to_form(changeset))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>
    <.simple_form for={@form} id="raffle-form" phx-submit="save" phx-change="validate">
      <.input field={@form[:prize]} label="Prize" />
      <.input field={@form[:description]} type="textarea" label="Description" phx-debounce="blur" />
      <.input field={@form[:ticket_price]} type="number" label="Ticket Price" phx-debounce="blur" />
      <.input
        field={@form[:status]}
        type="select"
        label="Status"
        prompt="Choose a status"
        options={[:upcoming, :open, :closed]}
      />
      <.input field={@form[:image_path]} label="Image Path" />
      <:actions>
        <.button phx-disable-with="Saving...">Save Changes</.button>
      </:actions>
    </.simple_form>
    <.back navigate={~p"/admin/raffles"}>
      Back
    </.back>
    """
  end

  def handle_event("save", %{"raffle" => raffle_params}, socket) do
    case Admin.update_raffle(socket.assigns.raffle, raffle_params) do
      {:ok, _raffle} ->
        socket
        |> put_flash(:info, "Raffle updated successfully!")
        |> push_navigate(to: ~p"/admin/raffles")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"raffle" => raffle_params}, socket) do
    changeset = Admin.change_raffle(socket.assigns.raffle, raffle_params)
    socket = assign(socket, :form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end
end
