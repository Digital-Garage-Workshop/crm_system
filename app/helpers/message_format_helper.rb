module MessageFormatHelper
<<<<<<< HEAD
  include RegexHelper

  def transform_user_mention_content(message_content)
    # attachment message without content, message_content is nil
    message_content.presence ? message_content.gsub(MENTION_REGEX, '\1') : ''
=======
  def transform_user_mention_content(message_content)
    # attachment message without content, message_content is nil
    return '' unless message_content.presence

    # Use CommonMarker to convert markdown to plain text for notifications
    # This handles all markdown formatting (links, bold, italic, etc.) not just mentions
    # Converts: [@👍 customer support](mention://team/1/%F0%9F%91%8D%20customer%20support)
    # To: @👍 customer support
    CommonMarker.render_doc(message_content).to_plaintext.strip
>>>>>>> upstream/develop
  end

  def render_message_content(message_content)
    ChatwootMarkdownRenderer.new(message_content).render_message
  end
end
