require "sinatra"
require "open-uri"

get '/md5' do
  content_type 'text/plain'
  if !params[:url].nil?
    identify_with_sha1(params[:url])
  end
end

helpers do
  def identify_with_sha1(url)
    file = open(url) do |io|
      fname = URI.parse(url).path[%r{[^/]+\z}]
      Dir.mktmpdir { |tmp|
        open("#{tmp}/#{fname}", "wb") { |file|
          file.write(io.read)
          file
         }
        $stderr.puts filepath = File.expand_path(file.path)
        result = %x[/usr/bin/md5sum #{filepath}]
        return result.split(" ")[0]
      }
    end
  end
end

