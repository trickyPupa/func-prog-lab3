defmodule Interpolator.Application do
  use Application

  @impl true
  def start(_type, _args) do
    # Получаем аргументы командной строки
    args = System.argv()

    # Запускаем в отдельной задаче
    Task.start(fn ->
      Interpolator.main(args)
      System.halt(0)
    end)

    # Supervisor (требуется для Application)`
    children = []
    opts = [strategy: :one_for_one, name: Interpolator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
