# frozen_string_literal: true

require 'json'

module UKPostcode
  # Retrieves the post-town for the postcode
  module TownFinder
    module_function

    BASE_DIR = File.expand_path('..', __dir__)
    TOWN_DATA = JSON.parse(File.read(File.join(BASE_DIR, 'data', 'towns_outward_postcode_matchers.json')))
    SHARED_TOWN_DATA = JSON.parse(File.read(File.join(BASE_DIR, 'data', 'towns_shared_outward_postcode_matchers.json')))

    def town(postcode)
      return :invalid_postcode unless postcode.valid?

      outcode_result = town_from_outcode(postcode.outcode)
      return outcode_result unless outcode_result == 'Shared'

      town_from_shared_outcode(postcode)
    end

    def town_from_outcode(outcode)
      TOWN_DATA.each do |name, regexp|
        return name if outcode.match(Regexp.new(regexp))
      end
      :unknown_outcode
    end

    def town_from_shared_outcode(postcode)
      matches = SHARED_TOWN_DATA.map { |town, regex| town if normalize_postcode(postcode).match?(regex) }.compact

      return matches.first if matches.count == 1

      :multiple_possible_matches
    end

    def normalize_postcode(postcode)
      inner_code = postcode.incode.nil? ? postcode.sector : postcode.incode

      [postcode.outcode, inner_code].compact.join
    end
  end
end
