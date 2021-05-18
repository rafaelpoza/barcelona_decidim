# frozen_string_literal: true

module Decidim
  module Budgets
    # This cell renders the order progress
    class OrderCell < BaseCell
      include Decidim::Budgets::ProjectsHelper
      include Cell::ViewModel::Partial

      delegate :voting_open?, :voting_finished?, to: :controller

      alias current_order model

      def budget
        options[:budget]
      end

      def title
        return translated_attribute(budget.title) if current_workflow.single?

        t("#{"checked_out." if current_order_checked_out?}title", scope: i18n_scope)
      end

      def subtitle
        translated_attribute(budget.title) unless current_workflow.single?
      end

      def description
        current_order_checked_out? ? checked_out_description : rules_text(:description)
      end

      def checked_out_description
        t("checked_out.description",
          scope: i18n_scope,
          cancel_link: link_to(
            t("cancel_order", scope: i18n_scope),
            budget_order_path(return_to: "budget"),
            method: :delete,
            class: "cancel-order",
            data: { confirm: t("are_you_sure", scope: i18n_scope) }
          ))
      end

      def rules_title
        t("rules.title", scope: i18n_scope)
      end

      def rules_text(text_type)
        if current_order.projects_rule?
          if current_order.minimum_projects.positive? && current_order.minimum_projects < current_order.maximum_projects
            t(
              "projects_rule.#{text_type}",
              minimum_number: current_order.minimum_projects,
              maximum_number: current_order.maximum_projects,
              scope: i18n_scope
            )
          else
            t("projects_rule_maximum_only.#{text_type}", maximum_number: current_order.maximum_projects, scope: i18n_scope)
          end
        elsif current_order.minimum_projects_rule?
          t("minimum_projects_rule.#{text_type}", minimum_number: current_order.minimum_projects, scope: i18n_scope)
        else
          t("vote_threshold_percent_rule.#{text_type}", minimum_budget: budget_to_currency(current_order.minimum_budget), scope: i18n_scope)
        end
      end

      def progress_minimum
        current_order.component.settings.vote_threshold_percent
      end

      def order_total_amount
        current_order.projects_rule? ? current_order.maximum_projects : budget_to_currency(budget.total_budget)
      end

      def order_total_title
        t(current_order.projects_rule? ? "total_projects" : "total_budget", scope: i18n_scope)
      end

      def i18n_scope
        "decidim.budgets.projects.budget_summary"
      end
    end
  end
end
