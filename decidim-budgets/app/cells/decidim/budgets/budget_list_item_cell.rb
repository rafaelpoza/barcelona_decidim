# frozen_string_literal: true

module Decidim
  module Budgets
    # This cell renders the budget item list in the budgets list
    class BudgetListItemCell < BaseCell
      include ActiveSupport::NumberHelper
      include Decidim::Budgets::ProjectsHelper

      delegate :voting_finished?, to: :controller
      delegate :highlighted, to: :current_workflow

      property :title, :description, :total_budget
      alias budget model

      private

      def card_class
        ["card--list__item"].tap do |list|
          unless voting_finished?
            list << "card--list__data-added" if voted?
            list << "card--list__data-progress" if progress?
          end
          list << "budget--highlighted" if highlighted?
        end.join(" ")
      end

      def link_class
        "card__link card--list__heading"
      end

      def voted?
        current_user && status == :voted
      end

      def progress?
        current_user && status == :progress
      end

      def highlighted?
        highlighted.include?(budget)
      end

      def status
        @status ||= current_workflow.status(budget)
      end
    end
  end
end
