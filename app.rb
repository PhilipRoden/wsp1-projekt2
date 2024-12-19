class App < Sinatra::Base
    def db
        return @db if @db

        @db = SQLite3::Database.new("db/books.sqlite")
        @db.results_as_hash = true

        return @db
    end
    get '/' do
        redirect('/books')
    end

    get '/books' do
        @books = db.execute('SELECT * FROM books')
        erb(:"books/index")
    end

    get '/books/new' do 
        erb(:"books/new")
    end

    post '/books' do
        p params
        titel=params["book_titel"]
        author=params["book_author"]
        pages=params["book_pages"]
        status=["0"]
        db.execute("INSERT INTO books (titel, author, pages, status) VALUES(?,?,?,?)", [titel, author, pages, status])
        redirect "/books"
    end

    get '/new_user' do 
        erb(:"/new_user")
    end
    
    post '/new_user' do
        p params
        password_hashed = BCrypt::Password.create(params["password"])
        user=params["user"]
        db.execute("INSERT INTO users (user, password) VALUES(?,?)", [user, password_hashed])
        redirect "/books"
    end

    post '/books/:id/status_update' do |id| 
        current_status = db.execute('SELECT status FROM books WHERE id = ?', [id]).first['status']
        new_status = current_status == 0 ? 1 : 0
        db.execute('UPDATE books SET status = ? WHERE id = ?', [new_status, id])
            redirect "/books"
    end

    post '/books/:id/delete' do |id| 
        db.execute('DELETE FROM books WHERE id = ?', id)
            redirect "/books"
    end

    post '/books/logout' do 
        session.destroy
        redirect "/books"
    end

    get '/books/:id/edit' do |id| 
        @book = db.execute('SELECT * FROM books WHERE id = ?', id.to_i).first
        erb (:'books/edit')
    end

    post '/books/:id/update' do |id| 
        p params
        titel = params["book_titel"]
        pages= params["book_pages"]
        author = params["book_author"]
        db.execute('UPDATE books SET titel = ?, pages = ?, author = ? WHERE id = ?', [titel, pages, author, id])
        redirect "/books"
    end

    get '/login' do
        erb :"/login"
    end

    post '/login' do
        username = params['user']
        cleartext_password = params['password'] 
        current_user = db.execute('SELECT * FROM users WHERE user = ?', username).first
        if current_user.empty?
            @error_message = "please insert username"
            return erb(:"/login")
        end
        if current_user==nil
            @error_message = "Wrong Username"
            return erb(:"/login")
        end
        password_from_db = BCrypt::Password.new(current_user['password'])
        if current_user.empty?
            @error_message = "please insert password"
            return erb(:"/login")
        end
        if password_from_db == cleartext_password 
            session[:user_id] = current_user['id'] 
            redirect "/books"  
        else
            @error_message = "Wrong password"
            return erb(:"/login")
        end
        p current_user
        p cleartext_password

    end

end

