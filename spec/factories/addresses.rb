require 'csv'

FactoryGirl.define do
  factory :address do
    sequence(:line_1) { |n| AddressReader.csv_row(n)[:line_1] }
    sequence(:city) { |n| AddressReader.csv_row(n)[:city] }
    sequence(:state) { |n| AddressReader.csv_row(n)[:state] }
    sequence(:zip) { |n| AddressReader.csv_row(n)[:zip] }
  end
end

class AddressReader
  include Singleton

  def self.csv_row(n)
    instance.csv_row(n)
  end

  def csv_row(n)
    @addresses ||= CSV.read(Rails.root.join('spec', 'fixtures', 'addresses.csv'), headers: true, header_converters: :symbol)

    @addresses[n]
  end
end
