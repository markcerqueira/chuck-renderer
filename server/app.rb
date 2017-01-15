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


OUTPUT_FOLDER = 'resources/'
LIMIT_DURATION = 1
DURATION_LIMIT_SECONDS = 30

WAV_EXTENSION = '.wav'
AAC_EXTENSION = '.m4a'

# Main render function that takes source code (params key 'source') or a file (params key 'file')
# and renders the file in ChucK and converts that file from .wav to .m4a
post '/render/?' do    
  # Write our temporary file or source to disk so we can pass it to ChucK below
  chuck_filename = "#{OUTPUT_FOLDER}#{SecureRandom.hex}.ck"
  File.open(chuck_filename, "w") do |f|
    if !params['source'].nil? && params['source'].to_s.strip.length > 0
      f.write(params['source'])
    elsif
      f.write(params['file'][:tempfile].read)
    end
  end

  # Use SHA256 digest of file contents because we may have rendered this file already
  output_filename = Digest::SHA256.hexdigest File.read(chuck_filename)
  
  wav_file = "#{OUTPUT_FOLDER}#{output_filename}#{WAV_EXTENSION}"
  aac_file = "#{OUTPUT_FOLDER}#{output_filename}#{AAC_EXTENSION}"
  
  if !File.exist?(aac_file)
    # Generate .wav file with export.ck script
    `chuck --silent export.ck:"#{chuck_filename}":#{wav_file}:#{LIMIT_DURATION}:#{DURATION_LIMIT_SECONDS}`

    # Convert .wav file to .m4a. More ffmpeg conversion: http://superuser.com/a/370637
    `ffmpeg -i #{wav_file} -c:a libfdk_aac -vbr 4 #{aac_file}`
  end
    
  redirect "/resource/result/#{output_filename}/"
end

# Downloads .m4a resource for resource with given key
get '/resource/download/:key/?' do
  aac_file = "#{OUTPUT_FOLDER}#{params[:key]}#{AAC_EXTENSION}"
  begin
    attachment aac_file
    content_type 'application/octet-stream'
    File.read(aac_file)
  rescue StandardError => error
    error.message
  end
end
