module Metrika
  module Request
    DEFAULT_OPTIONS = {
        :headers => {
            'Accept' => 'application/x-yametrika+json',
            'Content-Type' => 'application/x-yametrika+json'
        }
    }

    def get(path, params = {}, options = {})
      begin
        response = self.token.get(path, DEFAULT_OPTIONS.merge(:params => params).merge(options))
      rescue OAuth2::Error => e
        self.process_oauth2_errors(e.response.status, e.message, path, params)
      end

      JSON.parse response.body
    end

    def post(path, body = {}, options = {})
      encoded_body = Yajl::Encoder.encode(body)
      response = self.token.post(path, DEFAULT_OPTIONS.merge(:body => encoded_body).merge(options))

      JSON.parse response.body
    end

    def put(path, body = {}, options = {})
      encoded_body = Yajl::Encoder.encode(body)
      response = self.token.put(path, DEFAULT_OPTIONS.merge(:body => encoded_body).merge(options))

      JSON.parse response.body
    end

    def delete(path, options={})
      response = self.token.delete(path, DEFAULT_OPTIONS.merge(options))

      JSON.parse response.body
    end

    def process_oauth2_errors(status, message, path = nil, params = {})
      case status
        when 404
          raise Metrika::Errors::NotFoundError.new(:message => message, :path => path, :params => params)
        when 403
          raise Metrika::Errors::AccessDeniedError.new(:message => message, :path => path, :params => params)
        else
          raise Metrika::Errors::MetrikaError.new(:message => message, :path => path, :params => params)
      end
    end
  end
end