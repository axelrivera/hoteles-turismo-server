HOTELS_URL = 'http://64.185.222.206:8080/geoserver/CENTRAL_GIS_PR/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=CENTRAL_GIS_PR:DES_ECON_TURISMO_HOTELES&outputFormat=json'

TOURIST_ZONES_URL = 'http://64.185.222.206:8080/geoserver/CENTRAL_GIS_PR/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=CENTRAL_GIS_PR:DES_ECON_TURISMO_ZONAS_INTERES_TURISTICO&outputFormat=json'

helpers do
  
  def raw_hotels
    # hotels_response = HTTParty.get HOTELS_URL
    # unless hotels_response.code == 200
    #   hotels_response = {}
    # end
    # hotels_response
    hotels_json
  end
  
  def raw_zones
    zones_response = HTTParty.get TOURIST_ZONES_URL
    unless zones_response.code == 200
      zones_response = {}
    end
    zones_response
  end
  
  def hotels
    features = raw_hotels['features']
    
    if features.nil?
      return []
    end
    
    array = []
    features.each do |f|
      next if f['geometry'].nil? && f['geometry']['coordinates'].nil?
      next if f['properties'].nil?
      
      coordinates = f['geometry']['coordinates']
      properties = f['properties']
      
      name = properties['Nombre']
      rooms = properties['Rooms']
      city = properties['Munici']
      zone = properties['Sector']
      region = properties['Region']
      url = properties['Web']
      category = properties['Class']
      
      array << {
        name: name,
        rooms: rooms,
        city: city,
        zone: zone,
        region: region,
        url: url,
        category: category,
        coordinate: {
          latitude: coordinates[0],
          longitude: coordinates[1]
        }
      }
    end
    array 
  end
  
  def hotels_json
    JSON.parse(File.read('./hotels.json'))
  end
  
  def zones
    features = raw_zones['features']
    
    if features.nil?
      return []
    end
    
    array = []
    features.each_with_index do |f, i|
      puts "Index: #{i}"
      next if f['geometry'] == nil || f['geometry']['coordinates'] == nil
      next if f['properties'].nil?
      
      coordinates = f['geometry']['coordinates'][0][0]
      properties = f['properties']
      
      xs = []
      ys = []
      
      coordinates.each do |c|
        next unless c.count == 2
        xs << c[0].to_f
        ys << c[1].to_f
      end
      
      xs.sort!
      ys.sort!
      
      name = properties['Nombre']
      
      array << {
        name: name,
        ne: [ xs.first, ys.last ],
        sw: [ xs.last, ys.first ]
      }
    end
    array.group_by { |item| item[:name] }
  end
  
end