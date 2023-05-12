require 'uri'
require 'net/http'
require 'json'

def request(url_requested)
    url = URI(url_requested)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Get.new(url)
    request["cache-control"] = 'no-cache'
    request["postman-token"] = '5f4b1b36-5bcd-4c49-f578-75a752af8fd5'

    response = http.request(request)
    return JSON.parse(response.body)
end

def  buid_web_page(data)
    photos = data.map{|x| x['img_src']}
    html = ""

    photos.each do |i|
        html += "<img src=\"#{i}\">\n"
    end

    code = "<html>\n
    <head>\n
    </head>\n
    <body>\n
    <ul>\n
    #{html}
    </ul>\n
    </body>\n
    </html>
    "
    File.write('Fotitos-nasa.html', code)
end


def photos_count(data)
    photos = data.map { |x| x['camera'] }
    counts = data.map{|x| x['camera']['full_name']}.each_with_object({}) {|name, hash| hash[name] = 0 }
    
    photos.each do |photo|
      counts[photo['full_name']] += 1
    end
    
    puts "Cantidad de fotos por cámara:"
    
    counts.each do |name, count|
      puts " #{name}: #{count} fotos"
    end
  end
  

# ----- PROGRAMA PRINCIPAL ----- #
data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=IK71l6yyaukCBxJdB1MhRZ4XSvkmdxsRw20535tH').values[0][1..10]

buid_web_page(data)
photos_count(data)