# frozen_string_literal: true

# Extra validator for slugs that only need to be unique within a section
# e.g. page.slug / page_section.slug / shop_item.slug / etc
module SlugInSection
  extend ActiveSupport::Concern
  include Slug

  included do
    validates :slug, uniqueness: {
      scope: :section,
      message: I18n.t( 'errors.messages.slug_in_section' )
    }
  end
end
