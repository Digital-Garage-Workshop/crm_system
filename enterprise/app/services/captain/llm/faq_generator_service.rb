<<<<<<< HEAD
class Captain::Llm::FaqGeneratorService < Llm::BaseOpenAiService
  def initialize(content)
    super()
    @content = content
  end

  def generate
    response = @client.chat(parameters: chat_parameters)
    parse_response(response)
  rescue OpenAI::Error => e
    Rails.logger.error "OpenAI API Error: #{e.message}"
=======
class Captain::Llm::FaqGeneratorService < Llm::BaseAiService
  include Integrations::LlmInstrumentation

  def initialize(document:)
    super()
    @document = document
    @content = document.content
    @language = document.account.locale_english_name
    @account_id = document.account_id
  end

  def generate
    response = instrument_llm_call(instrumentation_params) do
      chat
        .with_params(response_format: { type: 'json_object' })
        .with_instructions(system_prompt)
        .ask(@content)
    end

    parse_response(response.content)
  rescue RubyLLM::Error => e
    Rails.logger.error "LLM API Error: #{e.message}"
>>>>>>> upstream/develop
    []
  end

  private

<<<<<<< HEAD
  attr_reader :content

  def chat_parameters
    prompt = Captain::Llm::SystemPromptsService.faq_generator
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

    JSON.parse(content.strip).fetch('faqs', [])
=======
  attr_reader :content, :language

  def system_prompt
    Captain::Llm::SystemPromptsService.faq_generator(language)
  end

  def instrumentation_params
    {
      span_name: 'llm.captain.faq_generator',
      model: @model,
      temperature: @temperature,
      feature_name: 'faq_generator',
      account_id: @account_id,
      messages: [
        { role: 'system', content: system_prompt },
        { role: 'user', content: @content }
      ],
      metadata: document_metadata
    }
  end

  def document_metadata
    @document&.to_llm_metadata || {}
  end

  def parse_response(content)
    return [] if content.nil?

    JSON.parse(sanitize_json_response(content)).fetch('faqs', [])
>>>>>>> upstream/develop
  rescue JSON::ParserError => e
    Rails.logger.error "Error in parsing GPT processed response: #{e.message}"
    []
  end
end
