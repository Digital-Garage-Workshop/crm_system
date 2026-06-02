module Linear::Mutations
  def self.graphql_value(value)
    case value
    when String
<<<<<<< HEAD
      # Strings must be enclosed in double quotes
      "\"#{value.gsub("\n", '\\n')}\""
    when Array
      # Arrays need to be recursively converted
      "[#{value.map { |v| graphql_value(v) }.join(', ')}]"
    else
      # Other types (numbers, booleans) can be directly converted to strings
=======
      value.to_json
    when Array
      "[#{value.map { |v| graphql_value(v) }.join(', ')}]"
    else
>>>>>>> upstream/develop
      value.to_s
    end
  end

  def self.graphql_input(input)
    input.map { |key, value| "#{key}: #{graphql_value(value)}" }.join(', ')
  end

  def self.issue_create(input)
    <<~GRAPHQL
      mutation {
        issueCreate(input: { #{graphql_input(input)} }) {
          success
          issue {
            id
            title
<<<<<<< HEAD
=======
            identifier
>>>>>>> upstream/develop
          }
        }
      }
    GRAPHQL
  end

<<<<<<< HEAD
  def self.issue_link(issue_id, link, title)
    <<~GRAPHQL
      mutation {
        attachmentLinkURL(url: "#{link}", issueId: "#{issue_id}", title: "#{title}") {
=======
  def self.issue_link(params)
    issue_id = params[:issue_id]
    link = params[:link]
    title = params[:title]
    user_name = params[:user_name]
    user_avatar_url = params[:user_avatar_url]

    user_params = []
    user_params << "createAsUser: #{graphql_value(user_name)}" if user_name.present?
    user_params << "displayIconUrl: #{graphql_value(user_avatar_url)}" if user_avatar_url.present?

    user_params_str = user_params.any? ? ", #{user_params.join(', ')}" : ''

    <<~GRAPHQL
      mutation {
        attachmentLinkURL(url: #{graphql_value(link)}, issueId: #{graphql_value(issue_id)}, title: #{graphql_value(title)}#{user_params_str}) {
>>>>>>> upstream/develop
          success
          attachment {
            id
          }
        }
      }
    GRAPHQL
  end

  def self.unlink_issue(link_id)
    <<~GRAPHQL
      mutation {
        attachmentDelete(id: "#{link_id}") {
          success
        }
      }
    GRAPHQL
  end
end
