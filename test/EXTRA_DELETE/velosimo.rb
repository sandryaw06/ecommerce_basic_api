sources.each do |source|
  Tenant.notify(message:  "Map event to geometry object converter #{source.to_json}" )

  arcgis_ns = Cenit.namespace("ArcGIS")
  accela_ns = Cenit.namespace("Accela")
  auth_id = arcgis_ns.authorization("ArcGIS").id
  event_data = source.metadata["emse_event_data"]
  settings = Cenit.namespace("Accela - ArcGIS").data_type("Setting").where(event: source.metadata["emse_event_name"], geometric_type: event_data["geometry_type"]).first
    
  Cenit.fails "There is not setting defined for #{source.event_name}" if settings.nil?
  
  if event_data["geometry_type"] == "point"
    
    #get address
    locations = []
    addresses = accela_ns.algorithm(:get_record_address).run(source.value)
    Tenant.notify(message: "address #{addresses}")
    if addresses["StatusCode"] != 200
      Cenit.fails "Not able to get address for record #{source.value}"
    end
    Tenant.notify(message: "address #{addresses["StatusDescription"]}")
    addresses["StatusDescription"].each do |address|
      #get geocode address
      a_str = "#{address["addressLine1"]}, #{address["city"]}, #{address["postalCode"]}"
      location = arcgis_ns.algorithm(:get_geocode_address).run(a_str)
      locations.append(location)
    end
    
    Tenant.notify(message: "locations #{locations}")

    #work with the first location
    location = locations[0]
    
    Tenant.notify(message: "location #{location}")
    location_attribute = location["locations"][0]["attributes"]
    
    Tenant.notify(message: "location_attribute #{location_attribute}")
    new_geometric_object = {
        "geometry_type": "point",
        "independent_layer": false,
        "layer": {
            "serviceName": settings.create_in_layer.service_name,
            "serviceType": settings.create_in_layer.service_type,
            "LayerId": settings.create_in_layer.layer_id
        },
        "geometry": {
            "x": location["locations"][0]["location"]["x"],#-118.398162004723,
            "y": location["locations"][0]["location"]["y"],#33.944686019767,
        "spatialReference":
            {
            "wkid": location["spatialReference"]["wkid"]#4326
            }
        },
        "attributes": {
            "City": location_attribute["City"],
            "StreetName": location_attribute["StAddr"],
            "ZipCode": location_attribute["Postal"],
            "FullAdd": location_attribute["LongLabel"],
            #"CountyID": attributes_result["Subregion"],
            #"StreetName": "1 World Way", "City": "Los Angeles", "ZipCode": "90045"
            }
    }
  

  elsif event_data["geometry_type"] == "polygon"
    
    parcels =  accela_ns.algorithm(:get_record_parcels).run(source.value)
    Tenant.notify(message: "parcels #{parcels}")
    if parcels["StatusCode"] != 200
      Cenit.fails "Not able to get parcels for record #{source.value}"
    end
    Tenant.notify(message: "parcels #{parcels["StatusDescription"]}")
    
    query_layer_algorithm = Cenit.namespace('ArcGIS').algorithm('query_by_fields')

    #get addresses per parcel
    parcels["StatusDescription"].each do |parcel|
      parcel_id = parcel["id"]

        #query parcel id in layer_from_settings

      alg_parmas = [
          auth_id,
          settings.query_data_from_layer.layer_id,
          settings.query_data_from_layer.service_name,
          settings.query_data_from_layer.service_type,
          { :where => "PARCEL_ID=#{parcel_id}", :outFields => "*"}
          ]
       result_query_layer = query_layer_algorithm.run(alg_parmas)

       #features to copy 
       #features = geometry + attributes
       features = result_query_layer["features"][0]
       features["geometry"]["spatialReference"] = {"wkid": result_query_layer["spatialReference"]["wkid"]}

       new_geometric_object = {
            "geometry_type": "polygon",
            "independent_layer": false,
            "layer": {
                "serviceName": settings.create_in_layer.service_name,
                "serviceType": settings.create_in_layer.service_type,
                "LayerId": settings.create_in_layer.layer_id
            },
            "geometry":  features["geometry"],
            "attributes": features["attributes"]
        }

    end    

  elsif event_data["geometry_type"] == "buffer"

    parcels =  accela_ns.algorithm(:get_record_parcels).run(source.value)
    Tenant.notify(message: "Inside Buffer parcels #{parcels}")

    if parcels["StatusCode"] != 200
      Cenit.fails "Not able to get parcels for record #{source.value}"
    end
    Tenant.notify(message: "parcels #{parcels["StatusDescription"]}")
    
    query_layer_algorithm = Cenit.namespace('ArcGIS').algorithm('query_by_fields')

    #get addresses per parcel
    parcels["StatusDescription"].each do |parcel|
      parcel_id = parcel["id"]

      new_layer_name = "Parcels_Buffer_#{parcel_id}"

      new_geometric_object = {
            "geometry_type": "buffer",
            "independent_layer": true,
            "layer": {
                "serviceName": new_layer_name,#settings.service_name,
                "serviceType": settings.create_in_layer.service_type,
                "LayerId": settings.create_in_layer.layer_id
            },
            "attributes": {
                "PARCEL_ID": parcel_id
            },
            "metadata": {
              #"buffer_name": new_layer_name,
              #"buffer_url": "https://services3.arcgis.com/cDrtlDG7GRs2MkSk/arcgis/rest/services/#{new_layer_name}/FeatureServer/0"
              }
        }
    end

  end

  new_geometric_object["created"] = false
  new_geometric_object["metadata"] = {
    "description": source["recordId"],
    "accela_record_id": source["recordId"],
    "accela_record_value": source["value"],
    "setting_id": settings.id.to_s,
    "event_data": event_data
  }

  target_data_type.create_from_json!(new_geometric_object)
end            
            
            