defmodule HouseWeb.ProductLive.Index do
  use HouseWeb, :live_view

  alias House.Warehouses
  alias House.Warehouses.Product

  @impl true
  def mount(params, _session, socket) do
    socket = socket |> assign(:warehouseId, params["warehouseId"])
    {:ok, stream(socket, :products, Warehouses.list_products(params["warehouseId"]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Warehouses.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({HouseWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Warehouses.get_product!(id)
    {:ok, _} = Warehouses.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end
end
