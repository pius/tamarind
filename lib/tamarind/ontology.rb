module Ontology
  
  def self.names_of_ontologies
    f = File.dirname(__FILE__) + "/branches"
    d = Dir.glob(File.join(File.dirname(__FILE__), '/branches/**'))  
    ontologies = d.collect {|path| path.slice(f.length + 1, path.length)}
  end
  
  def self.ontologies
    Ontology::names_of_ontologies.collect {|ontology_name| eval('::' + ontology_name.capitalize) }
  end
  
  module ClassMethods
    #in the simplest case, the object model uses the same attribute names as the ontology.
    #in this case, do_bindings will simply send each name to the object and bind the instance variables
    
    #define "offers_<ontology>" methods that accept mappings
    # e.g. offers_foaf :given_name => 'firstname', :family_name => 'lastname'

    Ontology::names_of_ontologies.each do |ontology_name|
      method_name = "offers_#{ontology_name}"
      
      module_eval "# #{method_name} decorates the class with a 'to_rdf' method that generates RDF for the #{ontology_name} ontology"
      module_eval "# #{method_name} accepts a mapping hash of the form {:canonical1 => 'model1', . . . :canonicaln => 'modeln'}" 
      module_eval "# that maps the ontology's canonical fields to the model's fields, respectively."
      
      define_method method_name.to_sym do |*mapping|
        mapping = mapping.first || Hash.new
        class_variable_set("@@active_ontology".to_sym, ontology_name)
        class_variable_set("@@#{ontology_name}_ontology_mapping".to_sym, mapping)
        self.send :include, InstanceMethods
      end
    end
  end
  
  module InstanceMethods
    
      # generates RDF for the ontology declared in "offers_<ontology>"
       def to_rdf
         ontology_name = self.class.class_eval("@@active_ontology")
          unless self.class.class_variable_defined? "@@#{ontology_name}_ontology_mapping".to_sym
            CommonMethods::do_bindings(eval(ontology_name.capitalize + '::FIELDS'), self)
          else
            CommonMethods::do_bindings(self.class.class_eval("@@#{ontology_name}_ontology_mapping"), self)
          end
          
          template_path = File.join(File.dirname(__FILE__), "/branches/#{ontology_name}/#{ontology_name}.builder")
          template = File.read(template_path)
          output = eval(template)
          return output
        end
  end
  
  module CommonMethods  
    
    #in the simplest case, the object model uses the same attribute names as the ontology.
    #in this case, do_bindings will simply send each name to the object and bind the instance variables
    
    #there may be a subtle bug here that looks like the following:
      #user has a field firstname that needs to be mapped to the ontology field name
      #instead of just @firstname being defined, both @firstname and @name get defined.
      
      def self.do_bindings(fignames, obj)
        if fignames.class.to_s == "Hash"
          #you've been provided a custom mapping, the key is the canonical field, the value is the model field
          fignames.keys.each { 
            |key| obj.instance_variable_set("@" + key.to_s, obj.send(fignames[key].to_sym))
            #raise "@name = #{@name}, @title = #{@title}" 
            }
        else
          #needs testing
          fignames.each { |name| instance_variable_set("@" + name.to_s, obj.send(name.to_sym)) }
        end
      end
  end

  def self.included(receiver)
    receiver.extend(ClassMethods)
  end
  
end