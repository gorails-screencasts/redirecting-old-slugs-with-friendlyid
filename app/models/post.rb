require "friendly_id/slug_generator"

class Post < ApplicationRecord
  class ReusableSlugGenerator < FriendlyId::SlugGenerator
    def available?(slug)
      if @config.uses?(::FriendlyId::Reserved) && @config.reserved_words.present? && @config.treat_reserved_as_conflict
        return false if @config.reserved_words.include?(slug)
      end

      # Look only at the active slugs in use
      !@scope.unscoped.where(slug: slug).exists?
    end
  end

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history], slug_generator_class: ReusableSlugGenerator
end
