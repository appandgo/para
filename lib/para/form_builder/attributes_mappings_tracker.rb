module Para
  module FormBuilder
    module AttributesMappingsTracker
      def initialize(*) #:nodoc:
        @attributes_mappings = {}

        super
      end

      def input(attribute_name, options = {}, &block)
        store_attribute_mapping_for(attribute_name, options, &block)

        super(attribute_name, options, &block)
      end

      def input_field(attribute_name, options = {})
        store_attribute_mapping_for(attribute_name, options)

        super(attribute_name, options)
      end

      def fields_for(*args, options, &block)
        super(*args, options) do |fields|
          fields_html = @template.capture { block.call(fields) }

          fields_html + fields.attributes_mappings_field
        end
      end

      def attributes_mappings_field
        hidden_field :_attributes_mappings, value: @attributes_mappings.to_json
      end

      private

      def store_attribute_mapping_for(attribute_name, options, &block)
        input = find_input(attribute_name, options, &block)
        type = input.class.name.demodulize.underscore.gsub(/_input\z/, '')

        @attributes_mappings[attribute_name] = type
      end
    end
  end
end