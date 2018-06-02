defmodule SupremeTsuguChanWeb.Jobs.GetTumblrPostList do
  require Logger

  defp url() do
    Application.fetch_env!(:supreme_tsugu_chan, :tumblr_url)
  end

  defp credentials() do
    Application.fetch_env!(:supreme_tsugu_chan, :tumblr_credentials)
    # conf = Application.fetch_env!(:supreme_tsugu_chan, :tumblr_credentials)
    # creds = OAuther.credentials(
    #   consumer_key: conf[:consumer_key],
    #   consumer_secret: conf[:consumer_secret],
    #   token: conf[:token],
    #   token_secret: conf[:token_secret]
    # )
    # OAuther.header(OAuther.sign("get", url, [{"api_key", conf[:consumer_key]}], creds))
  end

  def get_list() do
    Logger.info "[SupremeTsuguChanWeb.Jobs.GetTumblrPostList] call get_list"
    # { header, req_params } = credentials("https://api.tumblr.com/v2/blog/#{url()}/posts/photo")
    creds = credentials()
    url = "https://api.tumblr.com/v2/blog/#{url()}/posts/photo?api_key=#{creds[:consumer_key]}&limit=20&offset=0"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.warn "Not found :("
      {:ok, %HTTPoison.Response{status_code: 403}} ->
        Logger.warn "Forbidden :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.warn reason
    end
  end

end