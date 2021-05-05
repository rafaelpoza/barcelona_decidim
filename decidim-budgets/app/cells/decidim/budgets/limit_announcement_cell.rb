# frozen_string_literal: true

module Decidim
  module Budgets
    # This cell renders information when current user can't create more budgets orders.
    class LimitAnnouncementCell < BaseCell
      include ProjectsHelper

      alias budget model
      delegate :voted?, :vote_allowed?, :discardable, :limit_reached?, to: :current_workflow
      delegate :voting_open?, to: :controller

      def show
        cell("decidim/announcement", announcement_message, callout_class: "warning") if voting_limited?(budget)
      end

      private

      def announcement_message
        if discardable.any?
          t(:limit_reached, scope: i18n_scope,
                            links: budgets_link_list(discardable),
                            landing_path: budgets_path)
        else
          t(:cant_vote, scope: i18n_scope, landing_path: budgets_path)
        end
      end

      def should_discard_to_vote?
        limit_reached? && discardable.any?
      end

      def i18n_scope
        "decidim.budgets.limit_announcement"
      end
    end
  end
end
