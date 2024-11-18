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

    get '/books/user' do 
        erb(:"books/user")
    end
    
    post '/users' do
        p params
        password_hashed = BCrypt::Password.create(params["password"])
        user=params["user"]
        db.execute("INSERT INTO users (user, password) VALUES(?,?)", [user, password_hashed])
        redirect "/books"
    end
end