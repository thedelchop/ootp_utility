defmodule OOTPUtilityWeb.Components.Shared.Leaderboard.Leaders do
  @moduledoc """
  A component to represent a leaderboard for a parent, which could
  be a league, conference, division, team, etc..
  """

  use Surface.Component

  prop leaders, :list, default: []
  prop title, :string, default: "HR"

  def leader([leader | _rest] = _leaders), do: leader
  def rest([_leader | rest] = _leaders), do: rest

  def stat([leader | _]) do
    leader.statistic
  end

  def image(leader) do
    leader.picture
  end

  def name(leader) do
    "#{String.slice(leader.first_name, 0, 1)}. #{leader.last_name}"
  end

  def render(assigns) do
    ~F"""
      <div>
        <div>
          <p>{stat(@leaders)}</p>
          <div>
            <img src={leader(@leaders) |> image()}/>
            <h3>{leader(@leaders) |> name()}</h3>
            <a><p>{leader(@leaders) |> name()}</p></a>
          </div>
        </div>
        <ol class="rest" style="display: none;">
          {#for player <- rest(@leaders)}
            <li class="leaders">
              <p>{name(player)}</p>
              <p>{stat(player)}</p>
            </li>
          {/for}
        </ol>
      </div>
    """
  end
end
