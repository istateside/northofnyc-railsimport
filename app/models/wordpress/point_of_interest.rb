module Wordpress
  class PointOfInterest < CustomPost
    default_scope { where( post_type: "hl_point_of_interest" ) }

    def point_type
      @point_type ||= postmetas.find_by(meta_key: "type").try(:meta_value)
    end
    
    def point_type=(value)
      meta_field = postmetas.find_or_initialize_by(meta_key: "_type")
      meta_field.meta_value = "field_570d6840112b7"
      meta_field.post_id = self.id
      meta_field.save
      
      value_field = postmetas.find_or_initialize_by(meta_key: "type")
      value_field.meta_value = value.downcase
      value_field.post_id = self.id
      value_field.save
      
      self.touch
    end
    
    # Renaming to acf_title to avoid conflict
    def acf_title
      @title ||= postmetas.find_by(meta_key: "title").try(:meta_value)
    end
    
    def acf_title=(value)
      meta_field = postmetas.find_or_initialize_by(meta_key: "_title")
      meta_field.meta_value = "field_570d680d112b6"
      meta_field.post_id = self.id
      meta_field.save
      
      value_field = postmetas.find_or_initialize_by(meta_key: "title")
      value_field.meta_value = value
      value_field.post_id = self.id
      value_field.save
      
      self.post_title = title
      self.post_name = title.parameterize.gsub("-", "_")
      self.touch
    end
    
    def description
      @description ||= postmetas.find_by(meta_key: "description").try(:meta_value)
    end
    
    def description=(value)
      meta_field = postmetas.find_or_initialize_by(meta_key: "_description")
      meta_field.meta_value = "field_570d68a7112b8"
      meta_field.post_id = self.id
      meta_field.save
      
      value_field = postmetas.find_or_initialize_by(meta_key: "description")
      value_field.meta_value = value
      value_field.post_id = self.id
      value_field.save
      
      self.touch
    end
    
    def schedule
      #FIXME: Schedule needs to be implemented. Not in the CSV; not a priority.
      @schedule ||= (
        schedule_present = postmetas.find_by(meta_key: "schedule").try(:meta_value)
        if schedule_present.present? && schedule_present.meta_value == "1"
          {}
        else
          nil
        end
      )
    end
    
    def schedule=(value)
    end
    
    def address
      @address ||= postmetas.find_by(meta_key: "address").try(:meta_value)
    end
    
    def address=(value)
      meta_field = postmetas.find_or_initialize_by(meta_key: "_address")
      meta_field.meta_value = "field_570d69e5112bc"
      meta_field.post_id = self.id
      meta_field.save
      
      value_field = postmetas.find_or_initialize_by(meta_key: "address")
      value_field.meta_value = value
      value_field.post_id = self.id
      value_field.save
      
      self.touch
    end
    
    def phone_number
      @phone_number ||= (
        phone_number_set = postmetas.find_by(meta_key: "phone_number")
        if phone_number_set.present? && phone_number_set.meta_value == "1"
          {
            presentation: postmetas.find_by(meta_key: "phone_number_0_presentation").try(:meta_value),
            number: postmetas.find_by(meta_key: "phone_number_0_number").try(:meta_value)
          }
        else
          nil
        end
      )
    end
    
    def phone_number=(string)
      return if string.nil?
      meta_field = postmetas.find_or_initialize_by(meta_key: "_phone_number_0_presentation")
      meta_field.meta_value = "field_570d6ba5112be"
      meta_field.post_id = self.id
      meta_field.save
      
      value_field = postmetas.find_or_initialize_by(meta_key: "phone_number_0_presentation")
      value_field.meta_value = string
      value_field.post_id = self.id
      value_field.save
      
      meta_field = postmetas.find_or_initialize_by(meta_key: "_phone_number_0_number")
      meta_field.meta_value = "field_570d6bcb112bf"
      meta_field.post_id = self.id
      meta_field.save
      
      value_field = postmetas.find_or_initialize_by(meta_key: "phone_number_0_number")
      value_field.meta_value = string.gsub(/\+\s\(\)\-/, "")
      value_field.post_id = self.id
      value_field.save
      
      meta_field = postmetas.find_or_initialize_by(meta_key: "_phone_number")
      meta_field.meta_value = "field_570d6b83112bd"
      meta_field.post_id = self.id
      meta_field.save
      
      value_field = postmetas.find_or_initialize_by(meta_key: "phone_number")
      value_field.meta_value = "1"
      value_field.post_id = self.id
      value_field.save
      
      self.touch
    end
    
    def website
      @website ||= (
        website_set = postmetas.find_by(meta_key: "website")
        if website_set.present? && website_set.meta_value == "1"
          {
            presentation: postmetas.find_by(meta_key: "website_0_presentation").try(:meta_value),
            number: postmetas.find_by(meta_key: "website_0_url").try(:meta_value)
          }
        else
          nil
        end
      )
    end
    
    def website=(string)
      return if string.blank?
      meta_field = postmetas.find_or_initialize_by(meta_key: "_website_0_presentation")
      meta_field.meta_value = "field_570d6c54112c1"
      meta_field.post_id = self.id
      meta_field.save
      
      value_field = postmetas.find_or_initialize_by(meta_key: "website_0_presentation")
      value_field.meta_value = string
      value_field.post_id = self.id
      value_field.save
      
      meta_field = postmetas.find_or_initialize_by(meta_key: "_website_0_url")
      meta_field.meta_value = "field_570d6ca5112c2"
      meta_field.post_id = self.id
      meta_field.save
      
      value_field = postmetas.find_or_initialize_by(meta_key: "website_0_url")
      value_field.meta_value = string.gsub(/\+\s\(\)\-/, "")
      value_field.post_id = self.id
      value_field.save
      
      meta_field = postmetas.find_or_initialize_by(meta_key: "_website")
      meta_field.meta_value = "field_570d6c36112c0"
      meta_field.post_id = self.id
      meta_field.save
      
      value_field = postmetas.find_or_initialize_by(meta_key: "website")
      value_field.meta_value = "1"
      value_field.post_id = self.id
      value_field.save
      
      self.touch
    end
    
    def location
      @location ||= (
        location_set = postmetas.find_by(meta_key: "location_by_coord")
        if location_set.present? && location_set.meta_value == "1"
          {
            latitude: postmetas.find_by(meta_key: "location_by_coord_0_latitude").try(:meta_value),
            longitude: postmetas.find_by(meta_key: "location_by_coord_0_longitude").try(:meta_value)
          }
        else
          nil
        end
      )
    end
    
    def location=(str)
      return if str.empty?
      matches = /(\d+\.\d+), (\-\d+\.\d+)/.match(str)
      return if matches.nil?
      latitude, longitude = [matches[1], matches[2]]
      meta_field = postmetas.find_or_initialize_by(meta_key: "_location_by_coord_0_latitude")
      meta_field.meta_value = "field_570d6974112bb"
      meta_field.post_id = self.id
      meta_field.save
      value_field = postmetas.find_or_initialize_by(meta_key: "location_by_coord_0_latitude")
      value_field.meta_value = latitude
      value_field.post_id = self.id
      value_field.save
      
      meta_field = postmetas.find_or_initialize_by(meta_key: "_location_by_coord_0_longitude")
      meta_field.meta_value = "field_570d6930112ba"
      meta_field.post_id = self.id
      meta_field.save
      value_field = postmetas.find_or_initialize_by(meta_key: "location_by_coord_0_longitude")
      value_field.meta_value = longitude
      value_field.post_id = self.id
      value_field.save
      
      meta_field = postmetas.find_or_initialize_by(meta_key: "_location_by_coord")
      meta_field.meta_value = "field_570d68f7112b9"
      meta_field.post_id = self.id
      meta_field.save
      value_field = postmetas.find_or_initialize_by(meta_key: "location_by_coord")
      value_field.meta_value = "1"
      value_field.post_id = self.id
      value_field.save
      
      self.touch
    end
  end
end