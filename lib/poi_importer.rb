require "csv.rb"

class POIImporter
  
  attr_accessor :rows, :points_of_interest, :hierarchy
  
  def initialize
    @points_of_interest = Wordpress::CustomPost.where(post_type: "hl_point_of_interest").where.not(post_title: "Auto Draft")
    @rows = CSV.read("lib/assets/map-data.csv")
    @hierarchy = @rows.shift
  end
  
  def run_import
    @rows.each do |row|
      ActiveRecord::Base.transaction do
        begin
          create_poi_from_row(row)
        rescue
          puts $!, $@, row
          next
        end
      end
    end
  end
  
  def data_obj_from_row(row)
    {
      acf_title: row[0],
      point_type: row[1],
      address: row[2],
      location: row[3],
      phone_number: row[4],
      website: row[5],
      schedule: row[6],
      description: row[7]
    }
  end
  
  def test_run(idx=20)
    create_poi_from_row(@rows[idx])
  end

  def create_poi_from_row(row)
    attrs = data_obj_from_row(row)
    default_vals = {
      post_content: "",
      post_excerpt: "",
      to_ping: "",
      pinged: "",
      post_content_filtered: "",
      post_author: 1,
      post_date: Time.now,
      post_date_gmt: Time.now.getutc,
      post_modified: Time.now,
      post_modified_gmt: Time.now.getutc
    }
    poi = Wordpress::PointOfInterest.find_or_initialize_by(post_title: attrs[:acf_title])
    poi.assign_attributes(default_vals) if poi.new_record?
    poi.save
    poi.assign_attributes(attrs)
    poi.save
  end

end