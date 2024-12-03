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
        status=params["book_status"]
        db.execute("INSERT INTO books (titel, author, pages, status) VALUES(?,?,?,?)", [titel, author, pages, status])
        redirect "/books"
    end

    get '/books/new_user' do 
        erb(:"books/user")
    end
    
    post '/new_users' do
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

end

