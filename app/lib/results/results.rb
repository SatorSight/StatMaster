module Results
  class Result

    def set_params(params)
      @params = params
    end

    def get_results
      raise NotImplementedError
    end

  end
end