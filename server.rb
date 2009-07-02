require 'sinatra'
require 'primer_design'
require 'ape'
layout 'default.erb'


before do
  request.env['PATH_INFO'] = '/' if request.env['PATH_INFO'].empty?
end

get '/' do 
  erb :index
end

post '/upload' do
  @parts = sortParts(params[:parts])
  @full = fullSequence(@parts)
  @annotated = annotatedSequence(@parts)
  @primers = findPrimers(@parts)
  erb :results
end

get '/download' do
  send_data render_ape(params[:parts]), :filename => 'assembled.ape'
end

# http://sinatra.rubyforge.org/api/classes/Sinatra/Streaming.html
# response.headers['Content-Type'] = 'text/csv' # I've also seen this for CSV files: 'text/csv; charset=iso-8859-1; header=present'
# response.headers['Content-Disposition'] = 'attachment; filename=thefile.csv'