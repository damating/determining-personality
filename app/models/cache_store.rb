class CacheStore
  @@instance = Redis.new

  def self.instance
    @@instance
  end

  def self.already_cached?(key)
    get_cache(key).present?
  end

  def self.get_cache(key)
    @@instance.get(key)
  end

  def self.cache_data(key, value, expiration_time)
    @@instance.set(key, value, ex: expiration_time)
  end

  def self.get_or_cache_data(key, expiration_time, &block)
    unless already_cached?(key)
      cache_data(key, block.call, expiration_time)
    end

    get_cache(key)
  end

  private_class_method :new
end
