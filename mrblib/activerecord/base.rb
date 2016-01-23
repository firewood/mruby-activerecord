module ActiveRecord
  class Base
    def self.table_name=(table_name)
      @table_name = table_name
    end

    def self.table_name
      @table_name
    end

    def self.connection
      @connection
    end

    def self.attributes
      @attributes
    end

    def self.all
      Relation.new(self)
    end

    def self.where(*args)
      Relation.new(self).where(*args)
    end

    def self.string(name)
      @attributes ||= {}
      @attributes[name] = nil
      define_method("#{name}=") { |value| @attributes[name] = value }
      define_method(name) { @attributes[name] }
    end

    def self.integer(name)
      @attributes ||= {}
      @attributes[name] = nil
      define_method("#{name}=") { |value| @attributes[name] = value }
      define_method(name) { @attributes[name] }
    end

    def self.datetime(name)
      @attributes ||= {}
      @attributes[name] = nil
      define_method("#{name}=") { |value| @attributes[name] = value }
      define_method(name) { @attributes[name] }
    end

    def initialize
      @attributes = self.class.attributes.dup
      @attributes['id'] = nil
    end

    def attributes
      @attributes
    end

    def is_a?(kind)
      kind == self.class || kind == Hash
    end

    def each(&block)
      @attributes.each { |k, v| block.call(k, v) }
    end

    def map(&block)
      @attributes.map { |k, v| block.call(k, v) }
    end

    def to_s
      "#<#{self.class.to_s} #{attributes}>"
    end
  end
end
