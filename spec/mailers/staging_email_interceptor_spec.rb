require 'rails_helper'

RSpec.describe StagingEmailInterceptor do
  subject(:interceptor) { described_class }

  describe '#delivering_email' do
    let(:mail) { Mail::Message.new(subject: 'test-subject') }

    it 'prepends [STAGING] to subject' do
      expect do
        interceptor.delivering_email(mail)
      end.to change { mail.subject }.from('test-subject').to('[STAGING] test-subject')
    end
  end
end
