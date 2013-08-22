# encoding: utf-8
module HarmoniousDictionary
  module ModelAdditions
    def validate_harmonious_of(*attr_names)
      configuration = {:message=>"不能含有敏感词"}
      configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
      validates_each attr_names do |model, attribute, value|
        unless value.blank?
          unless HarmoniousDictionary.clean?(value)
            words_array = HarmoniousDictionary.harmonious_words(value)
            words_array.uniq!
            model.errors.add(attribute, "#{configuration[:message]}:#{words_array.join(',')}")
          end
        end
      end
    end
  end
end