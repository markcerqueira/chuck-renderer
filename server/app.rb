get '/*', provides: 'json' do
  json salutation: 'Hello', instruction: 'Mount your app.rb file to /server/app.rb'
end

get '/*' do
  'Hello. Mount your app.rb file to /server/app.rb'
end
