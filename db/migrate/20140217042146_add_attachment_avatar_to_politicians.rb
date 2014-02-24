class AddAttachmentAvatarToPoliticians < ActiveRecord::Migration
  def self.up
    change_table :politicians do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :politicians, :avatar
  end
end
