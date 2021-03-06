if Rails.env.production? or Rails.env.staging?
  CarrierWave.configure do |config|
    config.storage = :fog

    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET'],
      :region                 => 'ap-northeast-1',
    }
    config.fog_directory  = ENV['S3_BUCKET']
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
