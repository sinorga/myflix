RSpec.configure do |config|
  config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/tmp/uploads"])
    end
  end
end

VideoLargeCoverUploader
VideoSmallCoverUploader
CarrierWave::Uploader::Base.descendants.each do |klass|
  next if klass.anonymous?
  klass.class_eval do
    def cache_dir
      "#{Rails.root}/tmp/uploads/tmp"
    end

    def store_dir
      "#{Rails.root}/tmp/uploads/files"
    end
  end
end
