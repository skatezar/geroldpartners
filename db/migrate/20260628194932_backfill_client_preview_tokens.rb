class BackfillClientPreviewTokens < ActiveRecord::Migration[7.2]
  def up
    Client.where(preview_token: nil).find_each do |client|
      client.update_column(:preview_token, SecureRandom.urlsafe_base64(24))
    end
  end

  def down; end
end
