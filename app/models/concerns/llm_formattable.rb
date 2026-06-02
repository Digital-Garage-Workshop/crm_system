module LlmFormattable
  extend ActiveSupport::Concern

<<<<<<< HEAD
  def to_llm_text
    LlmFormatter::LlmTextFormatterService.new(self).format
=======
  def to_llm_text(config = {})
    LlmFormatter::LlmTextFormatterService.new(self).format(config)
>>>>>>> upstream/develop
  end
end
