module ActiveRecord
  class Relation
    def initialize(klass)
      @klass = klass
      @where = []
      @args = []
    end

    def exec_queries
      sql = "SELECT * FROM #{@klass.table_name}"
      sql += " WHERE #{@where.join(' AND ')}" unless @where.empty?
      @result = []
      @klass.establish_connection()
      @klass.connection.execute(sql, *(@args)) do |values, fields|
        row = @klass.new
        fields.each_with_index { |field, index| row.attributes[field] = values[index] }
        @result << row
      end
    end

    def where(*args)
      @where << args.shift
      @args += args
      self
    end

    def load
      exec_queries unless @result
      self
    end

    def is_a?(kind)
      kind == Relation || kind == Array
    end

    def to_a
      load
      @result
    end

    def [](index)
      to_a[index]
    end

    def each(&block)
      to_a.each { |row| block.call(row) }
    end

    def map(&block)
      to_a.map { |row| block.call(row) }
    end

    def inspect
      load
      "#<#{self.class.to_s} [#{to_a.take(10).join(', ')}]>"
    end
  end
end
