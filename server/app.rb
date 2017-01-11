get '/', provides: 'json' do
  json salutation: 'Hello', instruction: 'Mount your app.rb file to /server/app.rb'
end

get '/' do
  'Hello. Mount your app.rb file to /server/app.rb'
end

OUTPUT_FOLDER = ''
LIMIT_DURATION = 1
DURATION_LIMIT_SECONDS = 3

get '/render' do
  filename = "#{SecureRandom.hex}.wav"

  `/bin/chuck export.ck:basic.ck:#{OUTPUT_FOLDER}#{filename}:#{LIMIT_DURATION}:#{DURATION_LIMIT_SECONDS}`

  attachment filename
  content_type 'application/octet-stream'

  begin
    File.read("#{OUTPUT_FOLDER}#{filename}") 
  rescue StandardError => error
    error.message
  end
end
