class BaseRepository

  def find(code)
    raise NotImplementedError
  end

  def create_short_code(code, url)
    raise NotImplementedError
  end

  def exists?(code)
    raise NotImplementedError
  end

end
