class BaseRepository

  def find(_code)
    raise NotImplementedError
  end

  def create_short_code(_code, _url)
    raise NotImplementedError
  end

  def exists?(_code)
    raise NotImplementedError
  end

  def update(_code, _attributes)
    raise NotImplementedError
  end

end
