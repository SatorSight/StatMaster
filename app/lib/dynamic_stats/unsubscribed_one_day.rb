module Results
  class UnsubscribedOneDay < DynamicResult

    def get_results

=begin
select *, datediff(end_date, start_date) as dd
from user_subscription
where datediff(end_date, start_date)<2
limit 100
;
=end


      # service = Service.find @params['service_id']
      # subscription = Subscription.find_by domain: service.domain
      #
      #
      #
      # results = UserSubscription.where(sub_id: subscription.id)
      #                           .where()

      []


    end

  end
end