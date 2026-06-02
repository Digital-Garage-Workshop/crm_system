class Imap::FetchEmailService < Imap::BaseFetchEmailService
  def fetch_emails
    fetch_mail_for_channel
  end

  private

  def authentication_type
<<<<<<< HEAD
    'PLAIN'
=======
    channel.imap_authentication || 'plain'
>>>>>>> upstream/develop
  end

  def imap_password
    channel.imap_password
  end
end
