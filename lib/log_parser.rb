require 'csv'
require 'set'

class LogParser
  attr_reader :message

  def initialize(log_file)
    @log_file = log_file
    @success = true
    @message = nil
  end

  def parse
    make_fail("ERROR: '#{@log_file}' do not exists") || return unless File.file?(@log_file)

    visit_count, unique_visit_count = get_counts

    # combine count and unique count in single array
    result = []
    visit_count.each do |key, value|
      result << {uri: key, count: value, unique_count: unique_visit_count[key].count}
    end

    # sort by count in descending order before return
    (result.sort_by { |hsh| hsh[:count] }).reverse
  end

  def success?
    @success
  end

  private

  def get_counts
    visit_count = {}
    unique_visit_count = {}
    CSV.foreach(@log_file, headers: false) do |row|
      uri, ip = row[0].split
      visit_count.key?(uri) ? visit_count[uri] += 1 : visit_count[uri] = 1
      # Set acts like array but keeps only unique items
      unique_visit_count.key?(uri) ? unique_visit_count[uri].add(ip)  : unique_visit_count[uri] = Set[ip]
    end
    [ visit_count, unique_visit_count ]
  end

  def make_fail(message)
    @message = message
    @success = false
  end

end