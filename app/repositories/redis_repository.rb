class RedisRepository < BaseRepository

  def initialize
    @redis = Redis.new(url: ENV['REDIS_URL'])
  end

  def find(code)
    attrs = @redis.get(code)
    return unless attrs

    attrs = JSON.parse(attrs)

    attrs.map { |k,v| [k.to_sym, v] }.to_h
  end

  def create_short_code(code, url)
    code_attrs = {
      url: url,
      start_date: Time.now,
      redirect_count: 0,
      last_seen_date: nil
    }

    @redis.set(code, code_attrs.to_json)

    code_attrs
  end

  def exists?(code)
    @redis.exists(code)
  end

  def update(code, attributes)
    @redis.set(code, attributes.to_json)
  end
end
