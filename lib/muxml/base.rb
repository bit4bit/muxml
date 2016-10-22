require 'rexml/document'

module Muxml
  class Base
    attr_reader :xml
    @@xml_files ||= {}
    @@relations ||= {}

    def initialize(document = nil, element = nil)
      if @@xml_files.has_key?(self.class)
        document = @@xml_files[self.class][:file].to_s
        element = @@xml_files[self.class][:root]
      end

      case document
      when String
        xml = REXML::Document.new File.new(document)
      when REXML::Element
        xml = document
      else
        raise ArgumentError, 'invalid element'
      end

      unless element.nil?
        @xml = xml.elements[element]
      else
        @xml = xml
      end
    end

    # for call attributes of xml just prefix with *attribute_*
    def method_missing(sym, *args, &block)
      if sym.to_s.start_with?('attribute_')
        attribute = sym.to_s.sub(/^attribute_/, '')
        return @xml.attributes[attribute]
      elsif @@relations.has_key?(self.class)
        if @@relations[self.class][:many].has_key?(sym)
          return Relation::Many.new(self, sym, @@relations[self.class][:many][sym].dup)
        elsif @@relations[self.class][:one].has_key?(sym)
          return Relation::One.new(self, sym, @@relations[self.class][:one][sym].dup)
        end
      end
      raise NoMethodError, "undefined method `#{sym}' for #{self}"
    end

    class << self
      def xml_document(file, root)
        @@xml_files[self] = {file: file, root: root}
      end
      
      def has_many(relation, options)
        @@relations[self] ||= {many: {}, one: {} }
        @@relations[self][:many][relation] = options
      end

      def has_one(relation, options)
        @@relations[self] ||= {many: {}, one: {} }
        @@relations[self][:one][relation] = options
      end
    end

  end

end
