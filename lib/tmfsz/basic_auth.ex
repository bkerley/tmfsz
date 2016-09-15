defmodule Dmfsz.BasicAuth do
  alias Plug.Conn

  def init(options) do
    options
  end

  def call(conn = %Conn{}, options) do
    case Conn.get_req_header(conn, "authorization") do
      ["Basic " <> encoded_auth_str] ->
        authenticate(encoded_auth_str, conn, options)
      _ -> reject(conn)
    end
  end

  defp authenticate(encoded_auth_str, conn, options)
  when is_binary(encoded_auth_str) do
    case Base.decode64(encoded_auth_str) do
      {:ok, auth_data} ->
        auth_data
        |> String.split(":")
        |> authenticate(conn, options)
      _ -> reject(conn)
    end
  end

  defp authenticate(["admin", password], conn, _options) do
    case Comeonin.Bcrypt.checkpw(password,
                                 System.get_env("ADMIN_PASSWORD")) do
      true -> conn
      _ -> reject(conn)
    end
  end

  defp authenticate(_wrong, conn, options) do
    reject(conn)
  end

  defp reject(conn) do
    conn
    |> Conn.put_resp_header("www-authenticate",
                            "Basic realm=\"#{realm_name}\"")
    |> Conn.send_resp(401, "401 Unauthorized")
    |> Conn.halt
  end

  defp realm_name, do: "da motha fuckin' admin z0ne"
end
