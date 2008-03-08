foaf = Builder::XmlMarkup.new

foaf.tag!('rdf:RDF', 'xmlns:rdf' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#', 
                    'xmlns:rdfs' => 'http://www.w3.org/2000/01/rdf-schema#', 
                    'xmlns:foaf' => 'http://xmlns.com/foaf/0.1/', 
                    'xmlns:admin' => 'http://webns.net/mvcb/') do
  foaf.tag!('foaf:PersonalProfileDocument', 'rdf:about' => '') do
    foaf.tag!('foaf:maker', 'rdf:resource' => '#me')
    foaf.tag!('foaf:primaryTopic', 'rdf:resource' => '#me')
    foaf.tag!('admin:generatorAgent', 'rdf:resource' => 'http://www.example.com')
    foaf.tag!('admin:errorReportsTo', 'rdf:resource' => 'mailto:tamarind@example.com')
  end
  foaf.tag!('foaf:Person', 'rdf:ID' => 'me') do
    foaf.tag!('foaf:name', @name) if @name
    foaf.tag!('foaf:title', @title) if @title
    foaf.tag!('foaf:givenname', @given_name) if @given_name
    foaf.tag!('foaf:family_name', @family_name) if @family_name
    foaf.tag!('foaf:nick', @nickname) if @nickname
    foaf.tag!('foaf:mbox', 'rdf:resource' => "mailto:#{@mbox}") if @mbox
    foaf.tag!('foaf:homepage', @homepage) if @homepage
    foaf.tag!('foaf:phone', 'rdf:resource' => "tel:#{@phone}") if @phone
    foaf.tag!('foaf:workplaceHomepage', @workplace_homepage) if @workplace_homepage
    foaf.tag!('foaf:workInfoHomepage', @work_info_homepage) if @work_info_homepage
    foaf.tag!('foaf:schoolHomepage', @school_homepage) if @school_homepage
    # foaf.tag!('foaf:knows') do
    #   foaf.tag!('foaf:Person') do
    #     foaf.tag!('foaf:name', @name) if @name
    #     foaf.tag!('foaf:mbox', 'mailto:friendo@example.com')
    #     foaf.tag!('rdfs:seeAlso', 'rdf:resource' => 'http://www.example.com/friendo')
    #   end
    # end
  end
end