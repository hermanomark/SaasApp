class Artifact < ApplicationRecord
  before_save :upload_to_s3
  belongs_to :project

  # this will be file upload for the view
  attr_accessor :upload
  belongs_to :project

  MAX_FILESIZE = 10.megabytes

  validates_presence_of :name, :upload
  validates_uniqueness_of :name

  # custom validation
  validate :uploaded_file_size

  private
    # code here is a combo for uploading files to s3
    # each organization will have a folder name in s3 bucket
    def upload_to_s3
      s3 = Aws::S3::Resource.new
      tenant_name = Tenant.find(Thread.current[:tenant_id]).name
      obj = s3.bucket(ENV['S3_BUCKET']).object("#{tenant_name}/#{upload.original_filename}")
      obj.upload_file(upload.path, acl:'public-read')
      self.key = obj.public_url
    end

    def uploaded_file_size
      if upload
        errors.add(upload, "File size must be less than #{self.class::MAX_FILESIZE}") unless upload.size <= self.class::MAX_FILESIZE
      end
    end
end
