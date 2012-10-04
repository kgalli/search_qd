# SearchQd

## DESCRIPTION

SearchQd extends ActiveRecord and offers a method called search\_qd
for a simple full text search. Simple because the search functionality is
executed as SQL LIKE statements for given (text) columns.

## Quick start


```ruby
gem install search_qd
```

* Rails 3

Add the following line to your Gemfile 

```ruby
gem 'search_qd'
```

* ActiveRecord outside of Rails

```ruby
require 'search_qd'
ActiveRecord::Base.send(:include, SearchQd)
```

## Usage

Assuming your model name is Blog and the model has two text columns title and content:

```ruby
class Blog < ActiveRecord::Base
  search_qd_columns :title, :content
end

Blog.search_qd("some text to seach for") # search for 'some text to search for' in title and content column
Blog.search_qd("some text to search for", "title") # search for 'some text to search for' in title column
Blog.search_qd("some text to search for", "user_name") # search for 'some text to search for' in user_name column
```

As shown in the example above the search\_qd method expects the search query as a string and a list of columns. If no list 
of columns is given, the search\_qd method uses the column list defined by search\_qd\_columns (see class Blog definition).

## REQUIREMENTS

* ActiveRecord
* Ruby 1.9.\*

## License

This gem is created by Karsten Gallinowski and released under the MIT License.
