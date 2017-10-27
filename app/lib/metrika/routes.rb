module Metrika
  module Routes
    def self.metrics
      {
          :visits => 'ym:s:visits',
          :pageviews => 'ym:s:pageviews',
          :bounceRate => 'ym:s:bounceRate',
          :pageDepth => 'ym:s:pageDepth',
          :avgVisitDurationSeconds => 'ym:s:avgVisitDurationSeconds',
          :visitsPerDay => 'ym:s:visitsPerDay',
          :visitsPerHour => 'ym:s:visitsPerHour',
          :visitsPerMinute => 'ym:s:visitsPerMinute',
          :robotPercentage => 'ym:s:robotPercentage',
          :percentNewVisitors => 'ym:s:percentNewVisitors',
          :newUsers => 'ym:s:newUsers',
          :newUserVisitsPercentage => 'ym:s:newUserVisitsPercentage',
          :upToDaySinceFirstVisitPercentage => 'ym:s:upToDaySinceFirstVisitPercentage',
          :upToWeekSinceFirstVisitPercentage => 'ym:s:upToWeekSinceFirstVisitPercentage',
          :upToMonthSinceFirstVisitPercentage => 'ym:s:upToMonthSinceFirstVisitPercentage',
          :upToQuarterSinceFirstVisitPercentage => 'ym:s:upToQuarterSinceFirstVisitPercentage',
          :upToYearSinceFirstVisitPercentage => 'ym:s:upToYearSinceFirstVisitPercentage',
          :overYearSinceFirstVisitPercentage => 'ym:s:overYearSinceFirstVisitPercentage',
          :oneVisitPerUserPercentage => 'ym:s:oneVisitPerUserPercentage',
          :upTo3VisitsPerUserPercentage => 'ym:s:upTo3VisitsPerUserPercentage',
          :upTo7VisitsPerUserPercentage => 'ym:s:upTo7VisitsPerUserPercentage',
          :upTo31VisitsPerUserPercentage => 'ym:s:upTo31VisitsPerUserPercentage',
          :over32VisitsPerUserPercentage => 'ym:s:over32VisitsPerUserPercentage',
          :oneDayBetweenVisitsPercentage => 'ym:s:oneDayBetweenVisitsPercentage',
          :upToWeekBetweenVisitsPercentage => 'ym:s:upToWeekBetweenVisitsPercentage',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',
          # :visits => 'ym:s:visits',

          # :authorize_url => 'https://oauth.yandex.ru/authorize',
          # :token_url => 'https://oauth.yandex.ru/token'
      }
    end

    def base
      'https://api-metrika.yandex.ru'
    end

    def stat_route
      '/stat/v1/data'
    end

    def by_time
      '/bytime'
    end
  end
end