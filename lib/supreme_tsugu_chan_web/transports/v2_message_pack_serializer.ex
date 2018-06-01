defmodule SupremeTsuguChanWeb.Transports.V2.MessagePackSerializer do  
    @moduledoc false
  
    @behaviour Phoenix.Transports.Serializer
  
    alias Phoenix.Socket.Reply
    alias Phoenix.Socket.Message
    alias Phoenix.Socket.Broadcast
  
    # only gzip data above 1K
    @gzip_threshold 1024
  
    def fastlane!(%Broadcast{} = msg) do
      {:socket_push, :binary, pack_data({ nil, nil, msg.topic, msg.event, msg.payload })}
    end

    def encode!(%Reply{} = reply) do
      {:socket_push, :binary, pack_data({
        reply.join_ref,
        reply.ref,
        reply.topic,
        "phx_reply",
        %{status: reply.status, response: reply.payload}
      })}
    end
  
    def encode!(%Message{} = msg) do
      data = [msg.join_ref, msg.ref, msg.topic, msg.event, msg.payload]
      {:socket_push, :binary, pack_data(data)}
    end
  
    # messages received from the clients are still in json format;
    # for our use case clients are mostly passive listeners and made no sense
    # to optimize incoming traffic
    def decode!(raw_message, _opts) do
      [join_ref, ref, topic, event, payload | _] = Poison.decode!(raw_message)
      %Phoenix.Socket.Message{
        topic: topic,
        event: event,
        payload: payload,
        ref: ref,
        join_ref: join_ref
      }
    end
  
    defp pack_data(data) do
      msgpacked = Msgpax.pack!(data, iodata: false)
      gzip_data(msgpacked, byte_size(msgpacked))
    end
  
    defp gzip_data(data, size) when size < @gzip_threshold, do: data
    defp gzip_data(data, _size), do: :zlib.gzip(data)
  end  