# frozen_string_literal: true

module Reports::UsersByType
  extend ActiveSupport::Concern

  class_methods do
    def report_users_by_type(report)
      report.data = []

      report.modes = [Report::MODES[:table]]

      report.dates_filtering = false

      report.labels = [
        { property: :x, title: I18n.t("reports.users_by_type.labels.type") },
        { property: :y, type: :number, title: I18n.t("reports.default.labels.count") },
      ]

      label = Proc.new { |x| I18n.t("reports.users_by_type.xaxis_labels.#{x}") }
      url = Proc.new { |key| "/admin/users/list/#{key}" }

      admins = User.real.admins.count
      if admins > 0
        report.data << {
          url: url.call("admins"),
          icon: "shield-halved",
          key: "admins",
          x: label.call("admin"),
          y: admins,
        }
      end

      moderators = User.real.moderators.count
      if moderators > 0
        report.data << {
          url: url.call("moderators"),
          icon: "shield-halved",
          key: "moderators",
          x: label.call("moderator"),
          y: moderators,
        }
      end

      suspended = User.real.suspended.count
      if suspended > 0
        report.data << {
          url: url.call("suspended"),
          icon: "ban",
          key: "suspended",
          x: label.call("suspended"),
          y: suspended,
        }
      end

      silenced = User.real.silenced.count
      if silenced > 0
        report.data << {
          url: url.call("silenced"),
          icon: "ban",
          key: "silenced",
          x: label.call("silenced"),
          y: silenced,
        }
      end
    end
  end
end
