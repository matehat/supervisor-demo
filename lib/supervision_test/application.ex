defmodule SupervisionTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: :child_1,
        start: {Task, :start_link, [__MODULE__, :child_1, []]},
        type: :worker,
        restart: :transient,
      },
      %{
        id: :task_group,
        start: {__MODULE__, :run_all_tasks, []},
        type: :supervisor,
        restart: :permanent,
      },
      %{
        id: :child_4,
        start: {Task, :start_link, [__MODULE__, :child_4, []]},
        type: :worker,
        restart: :transient,
      },
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SupervisionTest.Supervisor]
    Supervisor.start_link(children, opts)
  end


  def child_1() do
    :timer.sleep(1000)
    IO.puts("Completed 1")
  end

  def child_2() do
    :timer.sleep(2000)
    IO.puts("Completed 2")
  end

  def child_3() do
    :timer.sleep(3000)
    IO.puts("Completed 3")
  end

  def child_4() do
    IO.puts("Completed 4")
  end

  def run_all_tasks() do
    {:ok, pid} = Task.Supervisor.start_link()

    [:child_2, :child_3]
      |> Enum.map(&Task.Supervisor.async(pid, __MODULE__, &1, []))
      |> Enum.each(&Task.await/1)

    IO.puts("Finished waiting")

    {:ok, pid}
  end
end
