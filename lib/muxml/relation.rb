module Muxml
  class Base
    module Relation
      
      class One
        def initialize(obj, relation, options = {})
          @obj = obj
          @relation = relation
          @tag = options.delete(:tag)
          @class_name = options.delete(:class_name)
          @query = options.delete(:select)
          @options = options

          raise ArgumentError, "#{obj.class.to_s} :class_name is nil" if @class_name.nil?
          raise ArgumentError, "#{obj.class.to_s} :tag is nil" if @tag.nil?
          unless @query.nil?
            attributes = @query.map{|k,v| "@#{k}='#{v}'"}.join
            @find_query = "#{@tag}[#{attributes}]"
          else
            @find_query = "#{@tag}"
          end

          @element =  Object.const_get(@class_name).new(obj.xml.elements[@find_query])
        end

        def method_missing(sym, *args, &block)
          @element.send(sym, *args, &block)
        end
      end
      
      class Many
        include Enumerable
        
        def initialize(obj, relation, options = {})
          @obj = obj
          @relation = relation
          @tag = options.delete(:tag) || relation
          @class_name = options.delete(:class_name)
          @query = options.delete(:select)
          @options = options

          raise ArgumentError, "#{obj.class.to_s} :class_name is nil" if @class_name.nil?
          raise ArgumentError, "#{obj.class.to_s} :tag is nil" if @tag.nil?
          unless @query.nil?
            attributes = @query.map{|k,v| "@#{k}='#{v}'"}.join
            @find_query = "#{@tag}[#{attributes}]"
          else
            @find_query = "#{@tag}"
          end
          
        end

        def each
          @obj.xml.elements.each("#{@find_query}") { |element|
            yield  Object.const_get(@class_name).new(element)
          }
        end

      end

      
    end
  end
end
