module InvalidatesCache
  extend ActiveSupport::Concern

  included do
    after_create :invalidate_cache
    after_update :invalidate_cache
    after_destroy :invalidate_cache

    def invalidate_cache
      Rails.cache.clear
    end
  end
end
