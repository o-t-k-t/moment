# 発行直前に取得していたNonce用タイムスタンプ値をオブジェクトの生成パラメータとすることで、
# このクライアントインスタンスから発行するリクエストが単一のみとなることを保証する(2回目以降はCCサーバで破棄)
class OnetimeCoincheckClient < CoincheckClient
  def self.create_nonce
    (Time.now.to_f * 1_000_000).to_i
  end

  def initialize(timestamp, key = nil, secret = nil, params = {})
    @timestamp = timestamp

    super(key, secret, params)
  end

  # 署名情報生成メソッドをオーバーライドし、Nonce値をインスタンス生成時の指定値に固定
  def get_signature(uri, key, secret, body = '')
    nonce = @timestamp.to_s
    message = nonce + uri.to_s + body
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, message)
    {
      'ACCESS-KEY' => key,
      'ACCESS-NONCE' => nonce,
      'ACCESS-SIGNATURE' => signature
    }
  end
end
