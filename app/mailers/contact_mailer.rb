class ContactMailer < ApplicationMailer
  default from: 'contact@geroldpartners.com'

  def new_contact(contact)
    @contact = contact

    mail(
      to: 'laurenz@geroldpartners.com',
      subject: "New Contact Form Submission: #{contact.subject}"
    )
  end
end
