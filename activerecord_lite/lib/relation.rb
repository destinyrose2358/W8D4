require 'active_support/inflector'

class Relation
    #options:
    #where: where: ["house.id IN [1,2,3]", "houses.color = red"]

    def initialize(class_name)
        @options = { where: {line: [], values: [] }, joins: [] }
        @class_name = class_name
    end

    def model_class
        @class_name.constantize
    end

    def table_name
        model_class.table_name
    end

    def where_line
        @options[:where][:line]
    end

    def where_line=(value)
        @options[:where][:line] = value
    end

    def where_values
        @options[:where][:values]
    end

    def where(params)
        where_line << params.keys.map {|key| "#{key} = ?"}.join(" AND ")
        where_values.concat(params.values)
        self
    end

    def joins(sql)
        @options[:joins] << sql
        self
    end

    def method_missing(name, *args, &prc)
        #do the query, and then call the method on the array
        output = self.query
        output.send(name, *args, &prc)
    end

    def query
        where = "WHERE #{where_line.join(" AND ")}" unless where_line.empty?
        where ||= ""
        results = DBConnection.execute(<<-SQL, *where_values)
            SELECT
                #{table_name}.*
            FROM
                #{table_name}
            #{@options[:joins].join(' ')}
            #{where}
        SQL
        model_class.parse_all(results)
    end
end