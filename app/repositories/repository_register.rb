class RepositoryRegister
  def self.register(type, repo)
    raise ArgumentError, "Repository must inhehrit from BaseRepository" unless repo.class.ancestors.any? {|klass| klass.name == 'BaseRepository' }

    repositories[type] = repo
  end

  def self.repositories
    @repositories ||= {}
  end

  def self.repository_for(type)
    repositories[type]
  end
end
