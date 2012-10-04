# encoding: utf-8
require 'search_qd/version'
require 'active_record' unless defined? Rails
require 'search_qd/rails' if defined? Rails

module SearchQd
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # method which can be used inside class definitions
    # to define the default search columns of the class
    # and to extend the class with search_qd singleton method
    def search_qd_columns(*column_names)
      @searchable_columns = []
      [column_names].flatten.each do |column_name|
        @searchable_columns << column_name
      end
      extend SearchQd::SingletonMethods
    end
  end

  module SingletonMethods
    # search method which provides possibility
    # to define search columns (fields) if default
    # columns should not be used 
    def search_qd(query, fields=nil)
      where(search_qd_conditions(query, fields))
    end

    private

    # method to create plain SQL LIKE
    # statements for each search term and search column
    #
    # SQL injection should not be an issue because 
    # query will be converted into LIKE statements word by 
    # word and special characters will be suppressed
    def search_qd_conditions(query, fields=nil)
      return nil if query.blank?
      fields ||= @searchable_columns

      # suppress special characters  
      search_qd_rm_special_chars(query)

      # split the search string by spaces
      words = query.split(' ')

      or_statements = []
      for word in words
        like_statements = []
        for column in fields
          like_statements << "#{column} LIKE '%#{word.downcase}%'"
        end
        or_statements << ' ('+like_statements.join(' OR ')+') '
      end
      or_statements.join(' AND ')
    end

    # German umlauts are the only special characters
    # which won't be removed from the search query
    def search_qd_rm_special_chars(query)
      query.gsub(/[^0-9a-zA-Z\säüöÜÄÖ]/, '')
    end
  end
end
