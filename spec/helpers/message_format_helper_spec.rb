require 'rails_helper'

describe MessageFormatHelper do
  describe '#transform_user_mention_content' do
    context 'when transform_user_mention_content called' do
<<<<<<< HEAD
      it 'return transormed text correctly' do
        expect(helper.transform_user_mention_content('[@john](mention://user/1/John%20K), check this ticket')).to eq '@john, check this ticket'
      end
=======
      it 'return transformed text correctly' do
        expect(helper.transform_user_mention_content('[@john](mention://user/1/John%20K), check this ticket')).to eq '@john, check this ticket'
      end

      it 'handles emoji in display names correctly' do
        content = '[@👍 customer support](mention://team/1/%F0%9F%91%8D%20customer%20support), please help'
        expected = '@👍 customer support, please help'
        expect(helper.transform_user_mention_content(content)).to eq expected
      end

      it 'handles multiple mentions with emojis and spaces' do
        content = 'Hey [@John Doe](mention://user/1/John%20Doe) and [@🚀 Dev Team](mention://team/2/%F0%9F%9A%80%20Dev%20Team)'
        expected = 'Hey @John Doe and @🚀 Dev Team'
        expect(helper.transform_user_mention_content(content)).to eq expected
      end

      it 'handles emoji-only team names' do
        expect(helper.transform_user_mention_content('[@🔥](mention://team/3/%F0%9F%94%A5) urgent')).to eq '@🔥 urgent'
      end

      it 'handles special characters in names' do
        expect(helper.transform_user_mention_content('[@user@domain.com](mention://user/4/user%40domain.com) check')).to eq '@user@domain.com check'
      end

      it 'returns empty string for nil content' do
        expect(helper.transform_user_mention_content(nil)).to eq ''
      end

      it 'returns empty string for empty content' do
        expect(helper.transform_user_mention_content('')).to eq ''
      end
>>>>>>> upstream/develop
    end
  end

  describe '#render_message_content' do
    context 'when render_message_content called' do
      it 'render text correctly' do
        expect(helper.render_message_content('Hi *there*, I am mostly text!')).to eq "<p>Hi <em>there</em>, I am mostly text!</p>\n"
      end
    end
  end
end
