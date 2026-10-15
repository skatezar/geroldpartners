module NewsletterTemplateHelper
  TEMPLATES = {
    "blank" => {
      label: "Blank Template",
      description: "Clean branded shell — write your own content",
      default_subject: ""
    },
    "blog_credit_md_2026" => {
      label: "Blog: Senior MD Comp 2026",
      description: "Pre-filled with the Credit MD compensation report",
      default_subject: "What a Senior MD Earns at a Private Credit Fund in London — 2026"
    }
  }.freeze

  def self.body_for(template_name)
    case template_name
    when "blog_credit_md_2026"
      path = Rails.root.join("public", "credit-md-comp-2026-email.html")
      File.exist?(path) ? File.read(path) : blank_body
    else
      blank_body
    end
  end

  def self.blank_body
    <<~HTML
      <!DOCTYPE html>
      <html lang="en">
      <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body { margin:0; padding:0; background:#f4f4f4; font-family:Arial,Helvetica,sans-serif; }
        table, td { border-collapse:collapse; }
      </style>
      </head>
      <body style="margin:0;padding:0;background:#f4f4f4;">
      <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background:#f4f4f4;">
      <tr><td align="center" style="padding:24px 16px;">
      <table width="600" cellpadding="0" cellspacing="0" border="0" style="max-width:600px;width:100%;background:#ffffff;">
        <tr><td style="background:#000000;padding:32px 40px;">
          <p style="margin:0;font-size:10px;font-weight:600;letter-spacing:0.16em;text-transform:uppercase;color:#666;font-family:Arial,sans-serif;">Gerold &amp; Partners — Market Intelligence</p>
        </td></tr>
        <tr><td style="padding:40px;">
          <p style="margin:0;font-size:16px;color:#333;font-family:Arial,sans-serif;line-height:1.7;">Write your content here.</p>
        </td></tr>
        <tr><td style="background:#000000;padding:20px 40px;">
          <p style="margin:0;font-size:12px;color:#444;font-family:Arial,sans-serif;letter-spacing:0.06em;">Gerold &amp; Partners &nbsp;·&nbsp; Executive Search &amp; Advisory</p>
        </td></tr>
      </table>
      </td></tr>
      </table>
      </body>
      </html>
    HTML
  end
end
