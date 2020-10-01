defmodule LatencyLiveWeb.PageLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias LatencyLive.Response
  alias LatencyLive.Repo
  import Ecto.Query

  @doc """
  Method for parsing response code,returns 500 if an error occurs, if does not returns status code.
  """
  def get_response_code(url) do
    case HTTPoison.get(url) do
      {:ok,%HTTPoison.Response{status_code: status_code}} ->
        status_code
      {:error, %HTTPoison.Error{reason: reason}} ->
        500
    end 
  end

  @doc """
  Method for getting latency,status_code and time when a request was sent. Save response object to db.
  """
  def get_response_and_save(url) do
    time_now=DateTime.utc_now() |> DateTime.add(7200, :second)
    # do the request and receive response
    {time,status}=:timer.tc(LatencyLiveWeb.PageLive,:get_response_code,[url])
    latency=div(time,1000)
    changeset= Response.changeset(%Response{}, %{latency: latency, status: status,url: url, time: time_now,})
    # save response obj
    Repo.insert(changeset)
  end

  @doc """
  Method for setting variables in socket.
  """
  def mount(params, _session, socket) do    
    url=Map.get(params,"url")
    if url do
    query=from(response in Response, where: response.url == ^url, order_by: [desc: response.time],limit: 20)
    responses=Repo.all(query)
    :timer.send_interval(5000, :update)
    IO.inspect "--------------------------------------------"
    socket = socket
      |> assign(:changeset, Response.changeset(%Response{}, %{}))
      |> assign(:responses, responses)
      |> assign(:url, url)
      |> assign(:timer, 1)
    {:ok, socket}
    end
    socket = socket
      |> assign(:changeset, Response.changeset(%Response{}, %{}))
      |> assign(:responses, [])
      |> assign(:timer, 0)
      |> assign(:url, url)
    {:ok, socket}
    
  end
  @doc """
  Method for getting reponses from db and assign them into socket.
  """
  def handle_info(:update, socket) do
    IO.inspect Map.keys(socket.assigns)
    url=socket.assigns.url    
    get_response_and_save(url)    
    query=from(response in Response, where: response.url == ^url, order_by: [desc: response.time],limit: 20)
    responses=Repo.all(query)  
    socket = socket
      |> assign(:responses, responses)  
      |> assign(:timer, 1)
    {:noreply, socket}
  end 
  @doc """
  Method for getting url from form and handling button submit.
  """
  def handle_event("check", params, socket) do  
    response=Map.get(params,"response")
    url=Map.get(response,"url")    
    #reset url for :update
    if socket.assigns.timer==1 do    
    socket = socket
      |> assign(:url, url)
    {:noreply, socket}
    else
    {ok, timer}=:timer.send_interval(5000, :update)
    end
    socket = socket
      |> assign(:url, url)
    {:noreply, socket}    
  end
  

  def render(assigns) do
  
    ~L"""
<%= f = form_for @changeset, "#", [phx_submit: :check] %>
  <%= url_input f, :url %>
  <%= submit "Save" %>
</form>


<table id="table_result">
  <tr>
    <th>Url</th>
    <th>Latency</th>
    <th>Status</th>
    <th>Time</th>
  </tr>
  <%= for response <- @responses do %>
    <tr>
      <td><%= response.url %></td>
      <td><%= response.latency %></td>
      <td><%= response.status %></td>
      <td><%= response.time %></td>
    </tr>
  <% end %>
</table>

    """
  end
end
