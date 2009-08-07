require 'sinatra'
require 'primer_design'
require 'ape'
require 'cgi'

# gem 'wbzyl-sinatra-static-assets'
require 'sinatra/static_assets'

layout 'default.erb'


before do
  # request.env['PATH_INFO'] = '/' if request.env['PATH_INFO'].empty?
  # kill trailing slashes for all requests except '/'
  # request.env['PATH_INFO'].gsub!(/\/$/, '') if request.env['PATH_INFO'] != '/'
end

get '/?' do 
  erb :index
end

post '/download' do
  # This requires a form to pass a plasmid like so:
  # :construct
  #   :sequence
  #   :part[]
  #     :start
  #     :end
  #     :name
  
  @construct = params[:construct]
  content_type 'text/ape'
  attachment('construct.ape')
  erb :ape, {:layout => :none}
end

post '/upload' do
  # params[:parts] contains the uploaded parts
  # we want to design primers and return an annotated sequence file
  
  # first, convert the params hash into an array of parts objects
  @parts = params[:parts].map{|key,value| value}
  
  order = CGI.parse(params[:partsOrder])
  
  order['parts[]'].each_with_index do |value,index|
    @parts[index]['order'] = value
  end
  
  @parts.each {|x| x['prefix'] ||= '' }
  @parts.each {|x| x['suffix'] ||= '' }
  
  # second, add an full sequence attribute that includes part prefix and suffix
  @parts.each {|x| x['fullsequence'] = x['prefix']+x['sequence']+x['suffix'] }
  
  # third, sort the parts based on the order parameter  
  @parts.sort! {|a,b| a['order'] <=> b['order']}
  
  # fourth, reverse complement anything that needs to be. create 'shortsequence' 
  @parts.each do |x|
    if x['rc'] == 'on'
      x['fullsequence'] = reversecomplement(x['fullsequence'])
      x['shortsequence'] = reversecomplement(x['sequence'])
      x['fixedsuffix'] = reversecomplement(x['prefix'])
      x['fixedprefix'] = reversecomplement(x['suffix'])
    else
      x['shortsequence'] = x['sequence']
      x['fixedsuffix'] = x['suffix']
      x['fixedprefix'] = x['prefix']
    end
  end
  
  obj = Hash.new
  obj['annotations'] = Array.new
  @parts.each {|x| obj['annotations'] << {:sequence => x['fullsequence']}}

  @formatted = format_annotated_sequence(obj,{ :size => 80, :delimiter => '<br/>'})
  
  # fifth, determine the full sequence of the construction
  @full = @parts.map{|x| x['fullsequence'] }.join

  # sixth, calculate the primers needed
  @primers = findPrimers(@parts)
  
  # add location to parts
  @parts = addLocations(@parts)
  
  @sequencing = findSequencingPrimers(@full, @parts.map{|x| x['end']-50})

  erb :results
end


# http://sinatra.rubyforge.org/api/classes/Sinatra/Streaming.html
# response.headers['Content-Type'] = 'text/csv' # I've also seen this for CSV files: 'text/csv; charset=iso-8859-1; header=present'
# response.headers['Content-Disposition'] = 'attachment; filename=thefile.csv'