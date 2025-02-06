require 'sinatra'
require 'slim'

enable :sessions



before do
  session["password"] = "abc123"
  session["user"] = "John Smith"
end

#Startsida
get('/') do
  slim(:index)
end

#Visa formulär som lägger till en note
get('/notes/new') do
  slim(:"notes/new")
end


#Skapa note
post('/notes/new') do
  if session["notes"] == nil
    session["notes"] = []
    session["notes"] << params["ny_note"]
  else
    session["notes"] << params["ny_note"]
  end
  redirect('/notes')
end

#Visa alla notes
get('/notes') do
  slim(:"notes/show")
end

#Ta bort note
get('/notes/delete') do
  slim(:"notes/delete")
end

#Tar bort en note
get '/notes/delete/:index' do
  index = params[:index].to_i #gör om :index till en integer, tror den där #{index} i show.slim skapar den som en string eller nåt??

  if session["notes"] && index >= 0 && index < session["notes"].length  #Dubbelkollar både så att listan notes finns och att index är valid (inte under noll och inte över längden på listan)
    session["notes"].delete_at(index)  #tar bort elementet med indexet index
    redirect '/notes'  #tillbaks till notes-sidan med dig
  else
    redirect '/notes'
  end
end