require 'sinatra'
require 'slim'

enable :sessions

before do
  session["username_list"] ||= ["a"]
  session["a"] ||= "a"
  session["user"] ||= nil
  puts session["user"]
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

#Login sida
get '/account' do
  slim(:"account/account")
end

#Inloggning
post '/account/login' do
  username_list = session["username_list"] || []
  username_login = params["username_login"]
  password_login = params["password_login"]

  username_list.each do |username|
    if username_login == username && password_login == session[username]
      puts "Login successful"
      session["user"] = username
      redirect '/account'
      break
    else
      puts "Invalid username or password"
    end
  end
end