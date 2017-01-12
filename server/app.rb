get '/', provides: 'json' do
  json salutation: 'Hello', instruction: 'Mount your app.rb file to /server/app.rb'
end

get '/' do
  'Hello. Mount your app.rb file to /server/app.rb'
end

OUTPUT_FOLDER = ''
LIMIT_DURATION = 1
DURATION_LIMIT_SECONDS = 30

WAV_EXTENSION = '.wav'
AAC_EXTENSION = '.m4a'

get '/render' do
  filename = "#{SecureRandom.hex}"

  # Generate .wav file with export.ck script
  `chuck --silent export.ck:basic.ck:#{OUTPUT_FOLDER}#{filename}#{WAV_EXTENSION}:#{LIMIT_DURATION}:#{DURATION_LIMIT_SECONDS}`

  # Convert .wav file to .m4a. More ffmpeg conversion: http://superuser.com/a/370637
  `ffmpeg -i #{OUTPUT_FOLDER}#{filename}#{WAV_EXTENSION} -c:a libfdk_aac -vbr 4 #{OUTPUT_FOLDER}#{filename}#{AAC_EXTENSION}`

  begin
    attachment "#{OUTPUT_FOLDER}#{filename}#{AAC_EXTENSION}"
    content_type 'application/octet-stream'
    File.read("#{OUTPUT_FOLDER}#{filename}#{AAC_EXTENSION}") 
  rescue StandardError => error
    error.message
  end
end
