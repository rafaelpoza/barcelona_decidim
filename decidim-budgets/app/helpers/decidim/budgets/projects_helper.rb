# frozen_string_literal: true

module Decidim
  module Budgets
    # A helper to render order and budgets actions
    module ProjectsHelper
      include ActiveSupport::NumberHelper
      # Determine whether a budget has limits on voting
      #
      # budget - A budget object
      def voting_limited?(budget)
        return unless voting_open?
        return unless current_user
        return if current_workflow.vote_allowed?(budget)
        return if current_workflow.voted?(budget)

        current_workflow.discardable.any? || !current_workflow.vote_allowed?(budget, consider_progress: false)
      end

      # Render a budget as a currency
      #
      # budget - A integer to represent a budget
      def budget_to_currency(budget)
        number_to_currency budget, unit: Decidim.currency_unit, precision: 0
      end

      # Return a percentage of the current order budget from the total budget
      def current_order_budget_percent
        [current_order&.budget_percent.to_f.floor, 100].min
      end

      # Return the minimum percentage of the current order budget from the total budget
      def current_order_budget_percent_minimum
        return 0 if current_order.minimum_projects_rule?

        if current_order.projects_rule?
          (current_order.minimum_projects.to_f / current_order.maximum_projects)
        else
          component_settings.vote_threshold_percent
        end
      end

      def budget_confirm_disabled_attr
        return if current_order_can_be_checked_out?

        %( disabled="disabled" ).html_safe
      end

      # Return true if the current order is checked out
      delegate :checked_out?, to: :current_order, prefix: true, allow_nil: true

      # Return true if the user can continue to the checkout process
      def current_order_can_be_checked_out?
        current_order&.can_checkout?
      end
    end
  end
end
