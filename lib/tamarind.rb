$:.unshift File.dirname(__FILE__)
Dir.glob(File.join(File.dirname(__FILE__), 'tamarind/*.rb')).each { |f| require f }
Dir.glob(File.join(File.dirname(__FILE__), 'tamarind/branches/*/*.rb')).each { |f| require f }

module Tamarind 
  def self.add_ontology_methods_to(klass)
    klass.send :include, Ontology
  end
    
  add_ontology_methods_to DataMapper::Base if defined?(DataMapper::Base)
  add_ontology_methods_to ActiveRecord::Base if defined?(ActiveRecord::Base)
  add_ontology_methods_to Sequel::Base if defined?(Sequel::Base)

end