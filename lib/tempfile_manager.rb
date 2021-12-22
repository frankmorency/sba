# frozen_string_literal: true

class TempfileManager
  def initialize(*keys)
    @tempfiles = {}
    create_and_open(*keys)
  end

  def [](key)
    tempfiles[key]
  end

  def create_and_open(*keys)
    return if keys.blank?

    close_and_unlink(keys)

    keys.each do |key|
      # Keys used as tempfile names cannot have '/'s in them per S3 custom, so remove by hashing
      tempfiles[key] = Tempfile.new(Digest::MD5.hexdigest(key))
    end
  end

  def path(key)
    tempfiles[key]&.path
  end

  def length(key)
    tempfiles[key]&.length || 0
  end

  def close_and_unlink(*keys)
    keys.each do |key|
      next unless tempfiles.key?(key)

      tempfiles[key].close(true)
      tempfiles.delete(key)
    end
  end

  private

  attr_reader :tempfiles
end
