# encoding: utf-8
require 'spec_helper.rb'

# blog class represents active record class
# which should be extended with functionality
# provided by SearchQd module   
ActiveRecord::Base.send(:include, SearchQd)
class Blog < ActiveRecord::Base 
  search_qd_columns :title, :content

end

describe SearchQd do
  describe ".search_qd" do
    before do
      Blog.all.each do |blog|
        blog.delete
      end      
      @blog1 = Blog.create title: "Find important blog using test as query", content: "This is some test text."
      @blog2 = Blog.create title: "Do not find me", content: "This blog should not been found."
      @blog3 = Blog.create title: "Second test", content: "Not very important."
      @blog4 = Blog.create title: "Not important", content: "This is only some test content."

    end

    it "should find all blogs where title or content include test" do
      Blog.search_qd("test").should eq([@blog1, @blog3, @blog4])  
    end

    it "should find all blogs where title or content include blog" do
      Blog.search_qd("blog").should eq([@blog1, @blog2])      
    end

    it "should find all blogs where title includes test" do
      Blog.search_qd("test", ["title"]).should eq([@blog1, @blog3])
    end

    it "should find all blogs where content includes important" do
       Blog.search_qd("important", ["content"]).should eq([@blog3]) 
    end
    
    it "should find all blogs where title or content include not important" do
      Blog.search_qd("not important").should eq([@blog3, @blog4])
    end

  end

  describe ".search_qd_conditions" do
    it "creates SQL LIKE statement for search_qd_columns" do
      search_string = "Test"
      expected_output = " (title LIKE '%test%' OR content LIKE '%test%') "
      Blog.send("search_qd_conditions", search_string).should eq expected_output
    end
   
    it "creates SQL LIKE statement for dynamic fields" do
      search_string = "Test"
      search_fields = %w{ description title }
      expected_output = " (description LIKE '%test%' OR title LIKE '%test%') "
      Blog.send("search_qd_conditions", search_string, search_fields).should eq expected_output
    end 

    it "creates multiple SQL LIKE statements combined with AND for each word in search string" do
      search_string = "Test SearchQd"
      expected_output_word1 = " (title LIKE '%test%' OR content LIKE '%test%') "
      expected_output_word2 = " (title LIKE '%searchqd%' OR content LIKE '%searchqd%') "
      expected_output = [ expected_output_word1, expected_output_word2 ].join(" AND ")
      Blog.send("search_qd_conditions", search_string).should eq expected_output
    end
  end  

  describe ".search_qd_rm_special_chars" do
    it "removes special characters" do
      special_chars = "§$%&/(){}#.,´`!,;@"
      Blog.send("search_qd_rm_special_chars", special_chars).should eq('')
    end

    it "does not remove word characters" do
      word_character = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
      Blog.send("search_qd_rm_special_chars", word_character).should eq(word_character)
    end

    it "does not remove numbers" do
      numbers = "1234567890"
      Blog.send("search_qd_rm_special_chars", numbers).should eq(numbers)
    end

    it "does not remove German umlauts" do
      german_umlauts = "äÄüÜöÖ"
      Blog.send("search_qd_rm_special_chars", german_umlauts).should eq(german_umlauts)
    end
  end
end
