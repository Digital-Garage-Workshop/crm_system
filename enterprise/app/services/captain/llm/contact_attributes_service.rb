<<<<<<< HEAD
class Captain::Llm::ContactAttributesService < Llm::BaseOpenAiService
=======
class Captain::Llm::ContactAttributesService < Llm::BaseAiService
  include Integrations::LlmInstrumentation

>>>>>>> upstream/develop
  def initialize(assistant, conversation)
    super()
    @assistant = assistant
    @conversation = conversation
    @contact = conversation.contact
    @content = "#Contact\n\n#{@contact.to_llm_text} \n\n#Conversation\n\n#{@conversation.to_llm_text}"
  end

  def generate_and_update_attributes
    generate_attributes
    # to implement the update attributes
  end

  private

  attr_reader :content

  def generate_attributes
<<<<<<< HEAD
    response = @client.chat(parameters: chat_parameters)
    parse_response(response)
  rescue OpenAI::Error => e
    Rails.logger.error "OpenAI API Error: #{e.message}"
    []
  end

  def chat_parameters
    prompt = Captain::Llm::SystemPromptsService.attributes_generator
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

    JSON.parse(content.strip).fetch('attributes', [])
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
      span_name: 'llm.captain.contact_attributes',
      model: @model,
      temperature: @temperature,
      account_id: @conversation.account_id,
      feature_name: 'contact_attributes',
      messages: [
        { role: 'system', content: system_prompt },
        { role: 'user', content: @content }
      ],
      metadata: { assistant_id: @assistant.id, contact_id: @contact.id }
    }
  end

  def system_prompt
    Captain::Llm::SystemPromptsService.attributes_generator
  end

  def parse_response(content)
    return [] if content.nil?

    JSON.parse(sanitize_json_response(content)).fetch('attributes', [])
>>>>>>> upstream/develop
  rescue JSON::ParserError => e
    Rails.logger.error "Error in parsing GPT processed response: #{e.message}"
    []
  end
end
