# frozen_string_literal: true

require "decidim/diffy_extension"

module Decidim
  # This cell renders a dismissable overlay to highlight information about the current
  # action being performed by the user
  class FocusModeCell < Decidim::ViewModel
    include Cell::ViewModel::Partial
    include LayoutHelper

    def show(&block)
      render(&block) if current_user
    end

    def title
      options[:title]
    end
  end
end
