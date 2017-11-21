module Metrika
  class Client
    include Request
    DEFAULT_OAUTH_OPTIONS = {
        :site => 'https://api-metrika.yandex.ru/',
        :authorize_url => 'https://oauth.yandex.ru/authorize',
        :token_url => 'https://oauth.yandex.ru/token'
    }

    attr_accessor :application_id, :application_password

=begin
    https://api-metrika.yandex.ru/stat/v1/data?44406319&ym:s:visits&oauth_token=AQAAAAAJroNSAASSMsJ5FtIsfEGZmZgr-3zM-sY
=end

    def initialize(application_id = Metrika.application_id, application_password = Metrika.application_password)
      @application_id = application_id
      @application_password = application_password
    end

    def authorize_token(auth_code)
      @token = self.client.auth_code.get_token(auth_code)
    end

    def authorization_url
      self.client.auth_code.authorize_url
    end

    def restore_token(access_token)
      @token = OAuth2::AccessToken.new(self.client, access_token)
    end


    def set_metric(metric)
      @metric = metric
    end

    def set_counter_id(counter_id)
      @counter_id = counter_id
    end

    def set_date_from(date_from)
      @date_from = date_from
    end

    def set_date_to(date_to)
      @date_to = date_to
    end


    # def test_get
    #   # request = Metrika::Request.new
    #   a = self.get '/management/v1/counters'
    #   pp a
    # end


    def stat_get

      query = '/stat/v1/data'


      # request = Metrika::Request.new

      query << '?ids=' << @counter_id
      query << '&metrics=' << @metric
      query << '&date1=' << @date_from if @date_from.present?
      query << '&date2=' << @date_to if @date_to.present?

      # pp query
      # exit

      self.get query


    end

    def group_data(data)
      all_dates = {}
      grouped_data = []

      data.each do |hash|
        service_id = hash.keys[0]
        value_key = 'metric_value_' << service_id.to_s
        date = hash[service_id][:date]
        value = hash[service_id][:value]
        new_hash = {value_key => hash[service_id][:value]}

        if all_dates.key? date
          all_dates[date][value_key] = value unless all_dates[date].key? value_key
        else
          all_dates[date] = new_hash
        end
      end

      all_dates.each do |key, val|
        element = {'date'.freeze => key}
        val.keys.each {|val_key| element[val_key] = val[val_key]}
        grouped_data.push element
      end

      grouped_data.sort_by {|k| k['date']}
    end


    protected

    def client
      @client ||= OAuth2::Client.new(@application_id, @application_password, DEFAULT_OAUTH_OPTIONS.dup)
    end

    def token
      raise Metrika::Errors::UnauthorizedError.new("Access token is not initialized") if @token.nil?

      @token
    end
  end


end