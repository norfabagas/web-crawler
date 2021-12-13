require "sqlite3"

class SQLite3Helper
  
  # Initialize (create or find database with specific name)
  def initialize(db_name = "product.db")
    @db_name = db_name
    initialize_db
  end

  def create_table(table_name, columns)
    begin
      initialize_db
      @db.execute "CREATE TABLE IF NOT EXISTS #{table_name}(#{flatten_columns(columns)})"
    rescue SQLite3::Exception => e
      puts "Error caught => #{e}"
    ensure
      @db.close if @db
    end
  end

  def drop_table(table_name)
    begin
      initialize_db
      @db.execute "DROP TABLE IF EXISTS #{table_name}"
    rescue SQLite3::Exception => e
      puts "Error caught => #{e}"      
    ensure
      @db.close if @db
    end
  end

  def insert_into_table(table_name, columns_and_values)
    begin
      initialize_db
      columns = columns_and_values.keys.join(",")
      questionMarks = questionMarks(columns_and_values)

      @db.execute "INSERT INTO #{table_name} (#{columns}) VALUES (#{questionMarks})", columns_and_values.values
    rescue SQLite3::Exception => e
      puts "Error caught => #{e}"
    ensure
      @db.close if @db
    end
  end

  def get_from_table(table_name)
    initialize_db
    results = @db.query "SELECT * FROM #{table_name}"
      
    return results
  end

  def find_from_table(table_name, column, value)
    initialize_db
    query = "SELECT * FROM #{table_name} WHERE #{column} = ?"
    results = @db.get_first_value query, value
  end

  private

  def initialize_db
    @db = SQLite3::Database.open @db_name
    @db.results_as_hash = true
  end

  def flatten_columns(columns)
    if columns.length < 2
      return "#{columns.keys.first.to_s.downcase} #{columns.values.first.to_s.upcase}"
    else
      str = ""
      columns.each_with_index do |(k, v), index|
        str += "#{k.to_s.downcase} #{v.to_s.upcase}"
        
        if index != columns.size - 1
          str += ","
        end

      end

      return str
    end 
  end

  def questionMarks(columns)
    questionMarks = ""
    columns.length.times do
      questionMarks += "?,"
    end

    return questionMarks[0...-1]
  end

end