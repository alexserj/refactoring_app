# app/models/media_item.rb

class MediaItem < ActiveRecord::Base
  attr_accessor :sync_processing

  attr_accessible :item_type, :file, :attachable_id, :attachable_type,
                  :custom_file_name, :user_id, :image_offset, :original_filename

  mount_uploader :file, MediaItemUploader

  belongs_to :attachable, polymorphic: true, touch: true
  belongs_to :user

  validates :item_type, inclusion: { in: GIGMIT_MEDIA_ITEM_TYPE }
  validates :item_hash, uniqueness: true, allow_nil: true
  validates :user,      presence: true

  before_create :set_content_type, :set_original_filename, :set_item_hash

  # ...

  private

  def set_item_hash
    begin
      self.item_hash = Gigmit::RandomString.generate
    end until MediaItem.where(item_hash: self.item_hash).count == 0

    self.item_hash
  end

  # TODO:
  # this seems like a workaround for carrierwave, because automatic setting of
  # content_type is not working.
  def set_content_type
    if file.present? && file_changed?
      self.content_type = file.file.content_type
    end
  end

  def set_original_filename
    self.original_filename = file.send(:original_filename)
  end
end
