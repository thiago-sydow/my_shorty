class ShortCodeService

  CHARSET = [*('A'..'Z'), *('a'..'z'), *('0'..'9'), '_'].freeze
  SHORT_CODE_SIZE = 6
  MAX_ITERATIONS = 10

  def initialize(preferred_code, url = nil, repo = RepositoryRegister.repository_for(:short_code))
    @repo = repo
    @preferred_code = preferred_code
    @url = url
  end

  def create_code
    raise UrlNotPresent if @url.nil?
    raise InvalidShortCode unless valid_preferred_code?

    new_code = generate_or_use_preferred_code

    @repo.create_short_code(new_code, @url)

    new_code
  end

  private

  def generate_or_use_preferred_code
    return generate_new_code if @preferred_code.nil?

    raise ShortCodeAlreadyTaken if @repo.find(@preferred_code)

    @preferred_code
  end

  def generate_new_code
    return_code = nil

    for i in 1..MAX_ITERATIONS
      return_code = Array.new(SHORT_CODE_SIZE) { CHARSET.sample }.join

      if @repo.exists?(return_code)
        return_code = nil
      else
        break
      end
    end

    raise CouldNotGenerateCode unless return_code

    return_code
  end

  def valid_preferred_code?
    @preferred_code.nil? || /^[0-9a-zA-Z_]{4,}$/ =~ @preferred_code
  end

  class UrlNotPresent < StandardError; end
  class InvalidShortCode < StandardError; end
  class ShortCodeAlreadyTaken < StandardError; end
  class CouldNotGenerateCode < StandardError; end
end
