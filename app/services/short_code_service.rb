class ShortCodeService

  CHARSET = [*('A'..'Z'), *('a'..'z'), *('0'..'9'), '_'].freeze
  SHORT_CODE_SIZE = 6
  MAX_ITERATIONS = 10

  def initialize(informed_code, url = nil, repo = RepositoryRegister.repository_for(:short_code))
    @repo = repo
    @informed_code = informed_code
    @url = url
  end

  def create_code
    raise UrlNotPresent if @url.nil?
    raise InvalidShortCode unless valid_informed_code?

    new_code = generate_or_use_informed_code

    @repo.create_short_code(new_code, @url)

    new_code
  end

  def get_redirect_url
    code_attributes = @repo.find(@informed_code)

    raise ShortCodeNotFound unless code_attributes

    code_attributes[:last_seen_date] = Time.now
    code_attributes[:redirect_count] += 1

    @repo.update(@informed_code, code_attributes)

    code_attributes[:url]
  end

  private

  def generate_or_use_informed_code
    return generate_new_code if @informed_code.nil?

    raise ShortCodeAlreadyTaken if @repo.find(@informed_code)

    @informed_code
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

  def valid_informed_code?
    @informed_code.nil? || /^[0-9a-zA-Z_]{4,}$/ =~ @informed_code
  end

  class UrlNotPresent < StandardError; end
  class InvalidShortCode < StandardError; end
  class ShortCodeAlreadyTaken < StandardError; end
  class CouldNotGenerateCode < StandardError; end
  class ShortCodeNotFound < StandardError; end
end
