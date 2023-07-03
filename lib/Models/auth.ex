defmodule DreamApp.Auth do

  defp jwt_validity do
    3600 # 1h in seconds.
  end

  defp jwt_algorithm do
    "HS256"
  end

  defp jwt_secret_key do
    "mysecretkey123"
  end


  def decode_token(token) do
    Guardian.decode_and_verify(token)
  end

  def encode_token(user_id) do
    claims = %{ "sub" => user_id }
    Guardian.encode_and_sign(claims, jwt_algorithm(), jwt_secret_key())
  end
end
