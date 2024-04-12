defmodule HouseWeb.MemberLive.Index do
  use HouseWeb, :live_view

  alias House.Warehouses
  alias House.Warehouses.Member

  @impl true
  def mount(params, _session, socket) do
    {:ok, stream(socket, :members, Warehouses.list_members(params.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Member")
    |> assign(:member, Warehouses.get_member!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Member")
    |> assign(:member, %Member{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Members")
    |> assign(:member, nil)
  end

  @impl true
  def handle_info({HouseWeb.MemberLive.FormComponent, {:saved, member}}, socket) do
    {:noreply, stream_insert(socket, :members, member)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    member = Warehouses.get_member!(id)
    {:ok, _} = Warehouses.delete_member(member)

    {:noreply, stream_delete(socket, :members, member)}
  end
end
