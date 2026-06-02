class V2::Reports::BaseSummaryBuilder
  include DateRangeHelper

  def build
    load_data
    prepare_report
  end

  private

  def load_data
<<<<<<< HEAD
    @conversations_count = fetch_conversations_count
    @resolved_count = fetch_resolved_count
    @avg_resolution_time = fetch_average_time('conversation_resolved')
    @avg_first_response_time = fetch_average_time('first_response')
    @avg_reply_time = fetch_average_time('reply_time')
  end

  def reporting_events
    @reporting_events ||= account.reporting_events.where(created_at: range)
  end

  def fetch_conversations_count
    # Override this method
  end

  def fetch_average_time(event_name)
    get_grouped_average(reporting_events.where(name: event_name))
  end

  def fetch_resolved_count
    reporting_events.where(name: 'conversation_resolved').group(group_by_key).count
=======
    results = data_source.summary

    @conversations_count = results.transform_values { |data| data[:conversations_count] }
    @resolved_count = results.transform_values { |data| data[:resolved_conversations_count] }
    @avg_resolution_time = results.transform_values { |data| data[:avg_resolution_time] }
    @avg_first_response_time = results.transform_values { |data| data[:avg_first_response_time] }
    @avg_reply_time = results.transform_values { |data| data[:avg_reply_time] }
>>>>>>> upstream/develop
  end

  def group_by_key
    # Override this method
  end

  def prepare_report
    # Override this method
  end

<<<<<<< HEAD
  def get_grouped_average(events)
    events.group(group_by_key).average(average_value_key)
  end

  def average_value_key
    ActiveModel::Type::Boolean.new.cast(params[:business_hours]).present? ? :value_in_business_hours : :value
=======
  def data_source
    @data_source ||= Reports::DataSource.for(
      account: account,
      metric: nil,
      dimension_type: summary_dimension_type,
      dimension_id: nil,
      scope: nil,
      range: range,
      group_by: 'day',
      timezone_offset: params[:timezone_offset],
      business_hours: params[:business_hours]
    )
  end

  def summary_dimension_type
    {
      'account_id' => 'account',
      'user_id' => 'agent',
      'inbox_id' => 'inbox',
      'conversations.team_id' => 'team'
    }.fetch(group_by_key.to_s)
>>>>>>> upstream/develop
  end
end
