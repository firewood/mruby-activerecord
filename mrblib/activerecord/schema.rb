module ActiveRecord
  class Schema
    def self.define(info={}, &block)
      new.define(info, &block)
    end

    def define(info, &block)
      instance_eval(&block)
    end

    def create_table(table_name, options, &block)
      /^(.)/ =~ table_name
      klass_name = $1.upcase + table_name.slice(1, table_name.length - 2)
      klass = Object.const_get klass_name
      klass.table_name = table_name
      block.call(klass)
    end
  end
end
