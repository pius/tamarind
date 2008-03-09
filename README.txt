Tamarind was designed to make it as easy as possible for developers to participate in the Semantic Web by exposing their data 
in accordance with applicable standards and ontologies.  In particular, Tamarind targets developers using Ruby frameworks and ORMs.

Note that this release is not intended for production use.  Please consider all pre-1.0 releases "developer" releases.

Oh, and where does the name come from?  Well, the Old Testament, Koran, and Torah refer to the Tree of Knowledge in the Garden of Eden as a Tamarind tree.  (Book of Enoch 31:4).

==Installation

When Tamarind is ready for production use, the gem will be published on Rubyforge.  Developers who'd like to use it now
should:

1.  Git it.  (git clone git://github.com/pius/tamarind.git)
2.  Install the gem.  (cd tamarind; rake local_deploy)

==Adding New Ontologies

To add an ontology, a developer need only follow these steps:

1.  Under tamarind/branches, create a directory for the ontology along with a module that identifies the data fields
	necessary for filling in the ontology.  (See the FOAF ontology as an example.)
2.  Write the template using Ruby builder syntax and save it under the directory from step 1.  Fields that must come from 
	the database should be prefixed by the "@" sign.  (Again, see the FOAF ontology as an example.)
3.  There is no step three.

==General Process for Using Ontologies In Your Application

To use an ontology, a developer need only follow these steps:

1.  Require the gem in your application
2.  Check out the documentation for the gem to find what ontologies are supported and learn how to use the "offers_*" 
	methods.
3.  In your model file, call offers_<ontology>, where <ontology> is the lowercase RDF type (e.g. offers_foaf).
	
====Instructions for Merb (0.9.1 or greater)

*in config/init.rb

Merb::BootLoader.before_app_loads do
 dependency 'tamarind'
end

Merb::BootLoader.after_app_loads do
  Merb.add_mime_type(:rdf,:to_rdf,%w[application/rdf+xml])
end

*in any controller that's going to use Tamarind, add:

provides :rdf

*in the model (e.g. User), add:
	offers_foaf :name => 'username', 
				:email => 'email',  #takes a hash mapping the ontology's canonical attributes to the model's accessors
							#defaults to using the same names

*in any view (e.g. the User show action) using Tamarind, add this to enable auto-discovery:
<link rel="meta" type="application/rdf+xml" title="foo" href="<%=@user.id%>.rdf" />

==TODO

	Add generator for new ontologies
	Add specs
	Support templating engines besides Builder
	Automatically parse the variables out of the template rather than require them to be explicitly declared
	Improve the documentation
	Firm up support for hashes that bind model attributes to ontology attributes
