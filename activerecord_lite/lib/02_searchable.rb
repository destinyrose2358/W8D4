require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    Relation.new(self.class_name).where(params)
  end
end

class SQLObject
  extend Searchable
end
