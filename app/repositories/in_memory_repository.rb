class InMemoryRepository < BaseRepository

  def initialize
    @records = Hash.new
  end

  def find(code)
    @records[code]
  end

  def create_short_code(code, url)
    @records[code] = {
      url: url,
      start_date: Time.now,
      redirect_count: 0,
      last_seen_date: nil
    }
  end

  def exists?(code)
    @records.has_key?(code)
  end

  def update(code, attributes)
    @records[code] = attributes
  end
end
