require 'sqlite3'

class Seeder
  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS books')
  end

  def self.create_tables
    db.execute('CREATE TABLE books (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                titel TEXT NOT NULL,
                author TEXT NOT NULL,
                pages INTERGER,
                status TEXT NOT NULL)')
  end

  def self.populate_tables
    db.execute('INSERT INTO books (titel, author, pages, status) VALUES ("Lord of the rings",   "J.R.R Tolken", 500, "reading")')
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