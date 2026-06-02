<<<<<<< HEAD
class Captain::Llm::ContactNotesService < Llm::BaseOpenAiService
=======
class Captain::Llm::ContactNotesService < Llm::BaseAiService
  include Integrations::LlmInstrumentation

>>>>>>> upstream/develop
  def initialize(assistant, conversation)
    super()
    @assistant = assistant
    @conversation = conversation
    @contact = conversation.contact
    @content = "#Contact\n\n#{@contact.to_llm_text} \n\n#Conversation\n\n#{@conversation.to_llm_text}"
  end

  def generate_and_update_notes
    generate_notes.each do |note|
      @contact.notes.create!(content: note)
    end
  end

  private

  attr_reader :content

  def generate_notes
<<<<<<< HEAD
    response = @client.chat(parameters: chat_parameters)
    parse_response(response)
  rescue OpenAI::Error => e
    Rails.logger.error "OpenAI API Error: #{e.message}"
    []
  end

  def chat_parameters
    account_language = @conversation.account.locale_english_name
    prompt = Captain::Llm::SystemPromptsService.notes_generator(account_language)

    {
      model: @model,
      response_format: { type: 'json_object' },
      messages: [
        {
          role: 'system',
          content: prompt
        },
        {
          role: 'user',
          content: content
        }
      ]
    }
  end

  def parse_response(response)
    content = response.dig('choices', 0, 'message', 'content')
    return [] if content.nil?

    JSON.parse(content.strip).fetch('notes', [])
=======
    response = instrument_llm_call(instrumentation_params) do
      chat
        .with_params(response_format: { type: 'json_object' })
        .with_instructions(system_prompt)
        .ask(@content)
    end
    parse_response(response.content)
  rescue RubyLLM::Error => e
    ChatwootExceptionTracker.new(e, account: @conversation.account).capture_exception
    []
  end

  def instrumentation_params
    {
      span_name: 'llm.captain.contact_notes',
      model: @model,
      temperature: @temperature,
      account_id: @conversation.account_id,
      conversation_id: @conversation.display_id,
      feature_name: 'contact_notes',
      messages: [
        { role: 'system', content: system_prompt },
        { role: 'user', content: @content }
      ],
      metadata: { assistant_id: @assistant.id, contact_id: @contact.id }
    }
  end

  def system_prompt
    account_language = @conversation.account.locale_english_name
    Captain::Llm::SystemPromptsService.notes_generator(account_language)
  end

  def parse_response(response)
    return [] if response.nil?

    JSON.parse(sanitize_json_response(response)).fetch('notes', [])
>>>>>>> upstream/develop
  rescue JSON::ParserError => e
    Rails.logger.error "Error in parsing GPT processed response: #{e.message}"
    []
  end
end
