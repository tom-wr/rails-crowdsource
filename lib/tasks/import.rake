require 'awesome_print'

namespace :import do
  desc "Import aam media from csv"
  task :aam_media, [:file] => [:environment] do |t, args|
    puts "starting import..."
    file = args[:file]
    csv = CSV.read(file, encoding: "bom|utf-8", :headers => true)

    csv.each do |row|
      if row['file'] then file_name = row['file'].split('/')[-1] else file_name = nil end
      medium = { 'aam_id' => row['id'].to_i,
        'media_type_id' => row['media_type_id'].to_i,
        'mime_type' => row['mime_type'],
        'file' => file_name,
        'accession_number' => row['accession_number'],
        'caption' => row['caption'],
        'caption_alt' => row['caption_alt'],
        'identifier' => row['identifier'],
        'place' => row['place'],
        'place_id' => row['place_id'],
        'object_id' => row['object_id'],
        'object_note' => row['object_note'],
        'actor_appellation' => row['actor_appellation'],
        'collection' => row['collection']
      }
      Medium.create!(medium)
    end

  end
end
