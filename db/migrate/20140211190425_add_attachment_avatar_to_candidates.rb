class AddAttachmentAvatarToCandidates < ActiveRecord::Migration
  def self.up
    change_table :candidates do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :candidates, :avatar
  end
end
