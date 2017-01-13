get '/', provides: 'json' do
  json salutation: 'Hello', instruction: 'Mount your app.rb file to /server/app.rb'
end

get '/' do
  'Hello. Mount your app.rb file to /server/app.rb'
end

get '/debug/?' do
  erb :debug
end

OUTPUT_FOLDER = ''
LIMIT_DURATION = 1
DURATION_LIMIT_SECONDS = 30

WAV_EXTENSION = '.wav'
AAC_EXTENSION = '.m4a'

post '/render/?' do
  output_filename = "#{SecureRandom.hex}"
    
  WAV_FILE = "#{OUTPUT_FOLDER}#{output_filename}#{WAV_EXTENSION}"
  AAC_FILE = "#{OUTPUT_FOLDER}#{output_filename}#{AAC_EXTENSION}"
    
  # Write our temporary file to disk so we can pass it to ChucK below  
  File.open("#{output_filename}.ck", "w") do |f|
    if !params['source'].nil?
      f.write(params['source'])
    elsif
      f.write(params['file'][:tempfile].read)
    end  
  end
  
  # Generate .wav file with export.ck script
  `chuck --silent export.ck:"#{output_filename}.ck":#{WAV_FILE}:#{LIMIT_DURATION}:#{DURATION_LIMIT_SECONDS}`

  # Convert .wav file to .m4a. More ffmpeg conversion: http://superuser.com/a/370637
  `ffmpeg -i #{WAV_FILE} -c:a libfdk_aac -vbr 4 #{AAC_FILE}`
  
  @last_render = output_filename
    
  erb :debug
end

get '/resource/:file/?' do
  AAC_FILE = "#{OUTPUT_FOLDER}#{params[:file]}#{AAC_EXTENSION}"
  
  begin
    attachment AAC_FILE
    content_type 'application/octet-stream'
    File.read(AAC_FILE)
  rescue StandardError => error
    error.message
  end
end

