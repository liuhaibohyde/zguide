defmodule Msreader do
  @moduledoc """
  Generated by erl2ex (http://github.com/dazuma/erl2ex)
  From Erlang source: (Unknown source file)
  At: 2019-12-20 13:57:27

  """

  def main() do
    {:ok, context} = :erlzmq.context()
    {:ok, receiver} = :erlzmq.socket(context, :pull)
    :ok = :erlzmq.connect(receiver, 'tcp://localhost:5557')
    {:ok, subscriber} = :erlzmq.socket(context, :sub)
    :ok = :erlzmq.connect(subscriber, 'tcp://localhost:5556')
    :ok = :erlzmq.setsockopt(subscriber, :subscribe, "10001")
    loop(receiver, subscriber)
    :ok = :erlzmq.close(receiver)
    :ok = :erlzmq.close(subscriber)
    :ok = :erlzmq.term(context)
  end


  def loop(receiver, subscriber) do
    process_tasks(receiver)
    process_weather(subscriber)
    :timer.sleep(1000)
    loop(receiver, subscriber)
  end

  #case(:erlzmq.recv(s, [:noblock])) do

  def process_tasks(s) do
    case(:erlzmq.recv(s, [:dontwait])) do
      {:error, :eagain} ->
        :ok
      {:ok, msg} ->
        :io.format('Procesing task: ~s~n', [msg])
        process_tasks(s)
    end
  end


  def process_weather(s) do
    case(:erlzmq.recv(s, [:dontwait])) do
      {:error, :eagain} ->
        :ok
      {:ok, msg} ->
        :io.format('Processing weather update: ~s~n', [msg])
        process_weather(s)
    end
  end

end

Msreader.main
