require 'sqlite3'

class Seeder
  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS books')
    db.execute('DROP TABLE IF EXISTS users')

  end

  def self.create_tables
    db.execute('CREATE TABLE books (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titel TEXT NOT NULL,
      author TEXT NOT NULL,
      pages INTEGER NOT NULL                                                                                                   ,
      status INTEGER NOT NULL)')

    puts "create table users"
    
    db.execute('CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user TEXT NOT NULL,
      password TEXT NOT NULL
    )')

  end

  def self.populate_tables
    db.execute('INSERT INTO books (titel, author, pages, status) VALUES ("Lord of the rings",   "J.R.R Tolken", 500, 1)')
    db.execute('INSERT INTO books (titel, author, pages, status) VALUES ("Two towers",   "J.R.R Tolken", 700, 0)')
    db.execute('INSERT INTO users (user, password) VALUES ("philip", "123")')
  end

  private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/books.sqlite')
    @db.results_as_hash = true
    @db
  end
end


Seeder.seed!