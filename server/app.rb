get '/', provides: 'json' do
  json salutation: 'Hello', instruction: 'Mount your app.rb file to /server/app.rb'
end

get '/' do
  'Hello. Mount your app.rb file to /server/app.rb'
end

# Renders debug.erb
get '/debug/?' do
  erb :debug
end

# Renders resource.erb for the given resource key
get '/resource/result/:key/?' do
  @key = params[:key]
  erb :resource
end


OUTPUT_FOLDER = ''
LIMIT_DURATION = 1
DURATION_LIMIT_SECONDS = 30

WAV_EXTENSION = '.wav'
AAC_EXTENSION = '.m4a'

# Main render function that takes source code (params key 'source') or a file (params key 'file')
# and renders the file in ChucK and converts that file from .wav to .m4a
post '/render/?' do
  output_filename = "#{SecureRandom.hex}"
    
  WAV_FILE = "#{OUTPUT_FOLDER}#{output_filename}#{WAV_EXTENSION}"
  AAC_FILE = "#{OUTPUT_FOLDER}#{output_filename}#{AAC_EXTENSION}"
    
  # Write our temporary file to disk so we can pass it to ChucK below  
  File.open("#{output_filename}.ck", "w") do |f|
    if !params['source'].nil? && params['source'].to_s.strip.length > 0
      f.write(params['source'])
    elsif
      f.write(params['file'][:tempfile].read)
    end  
  end
  
  # Generate .wav file with export.ck script
  `chuck --silent export.ck:"#{output_filename}.ck":#{WAV_FILE}:#{LIMIT_DURATION}:#{DURATION_LIMIT_SECONDS}`

  # Convert .wav file to .m4a. More ffmpeg conversion: http://superuser.com/a/370637
  `ffmpeg -i #{WAV_FILE} -c:a libfdk_aac -vbr 4 #{AAC_FILE}`
  
  redirect "/resource/result/#{output_filename}/"
end

# Downloads .m4a resource for resource with given key
get '/resource/download/:key/?' do
  AAC_FILE = "#{OUTPUT_FOLDER}#{params[:key]}#{AAC_EXTENSION}"
  begin
    attachment AAC_FILE
    content_type 'application/octet-stream'
    File.read(AAC_FILE)
  rescue StandardError => error
    error.message
  end
end
