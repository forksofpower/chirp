defmodule ChirpWeb.PostLive.PostComponent do
  use ChirpWeb, :live_component

  def render(assigns) do
    ~L"""
    <article class="media">
      <figure class="media-left">
        <p class="image is-64x64">
          <img src="https://bulma.io/images/placeholders/128x128.png">
        </p>
      </figure>
      <div class="media-content">
        <div class="content">
          <p>
            <strong>@<%= @post.username %></strong> <small>31m</small>
            <br>
            <%= @post.body %>
          </p>
        </div>
        <nav class="level is-mobile">
          <div class="level-left">
            <a class="level-item" phx-click="repost" phx-target="<%= @myself %>">
              <span class="icon is-small"><i class="fas fa-retweet"></i><%= @post.reposts_count %></span>
            </a>
            <a class="level-item" phx-click="like" phx-target="<%= @myself %>">
              <span class="icon is-small"><i class="fas fa-heart"></i><%= @post.likes_count %></span>
            </a>
          </div>
        </nav>
      </div>
      <div class="media-right">
        <%= live_patch to: Routes.post_index_path(@socket, :edit, @post.id) do %>
          <span>✏️</span>
        <% end %>
        <span>&nbsp;&nbsp;</span>
        <%= link to: "#", phx_click: "delete", phx_value_id: @post.id, data: [confirm: "Are you sure?"] do %>
          <span>❌</span>
        <% end %>
      </div>
    </article>
    """
  end

  def handle_event("like", _, socket) do
    Chirp.Timeline.inc_likes(socket.assigns.post)
    {:noreply, socket}
  end

  def handle_event("repost", _, socket) do
    Chirp.Timeline.inc_reposts(socket.assigns.post)
    {:noreply, socket}
  end
end
