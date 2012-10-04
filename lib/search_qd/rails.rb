module SearchQd
  class Railtie < Rails::Railtie
    initializer "search_qd.include" do
      ActiveRecord::Base.send(:include, SearchQd)
    end        
  end
end
