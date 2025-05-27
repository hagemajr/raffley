defmodule RaffleyWeb.CustomComponents do
  use RaffleyWeb, :html

  attr :status, :atom, required: true, values: [:open, :closed, :pending]
  attr :class, :string, default: nil
  attr :rest, :global

  def badge(assigns) do
    ~H"""
    <div
      class={[
        "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
        @status == :open && "text-lime-600 border-lime-600",
        @status == :upcoming && "text-amber-600 border-amber-600",
        @status == :closed && "text-gray-600 border-gray-600",
        @class
      ]}
      {@rest}
    >
      {@status}
    </div>
    """
  end

  slot :inner_block, required: true
  slot :details

  def banner(assigns) do
    assigns = assign(assigns, :emoji, ~w(🎉 🎊 🎈) |> Enum.random())

    ~H"""
    <div class="banner">
      <h1>
        {render_slot(@inner_block)}
      </h1>
      <div :for={details <- @details} class="details">
        {render_slot(details, @emoji)}
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :label, :string, required: true
  attr :options, :list, required: true
  attr :selected, :any, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def dropdown(assigns) do
    ~H"""
    <div class={["dropdown-container", @class]}>
      <label for={@id} class="block text-sm font-medium text-gray-700 mb-1">
        <%= @label %>
      </label>
      <div class="relative">
        <select
          id={@id}
          class="block w-full rounded-md border border-gray-300 bg-white py-2 px-3 shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm"
          {@rest}
        >
          <option :if={@selected == nil} value="" disabled selected>Select an option</option>
          <%= for {label, value} <- @options do %>
            <option value={value} selected={value == @selected}>
              <%= label %>
            </option>
          <% end %>
        </select>
        <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
          <svg class="h-4 w-4 fill-current" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
            <path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" />
          </svg>
        </div>
      </div>
    </div>
    """
  end
end
