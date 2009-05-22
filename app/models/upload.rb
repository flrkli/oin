class Upload < ActiveRecord::Base
	
	# toDO: more restrictions	
	
	belongs_to :idea
 	has_attachment :content_type => ['application/pdf', 'application/msword', 'text/plain', :image],
								 :storage => :file_system, 
								 :path_prefix => 'public/files',
                 :max_size => 5.megabytes


  validates_as_attachment

end
