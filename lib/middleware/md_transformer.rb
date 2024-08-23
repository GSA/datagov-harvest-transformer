require 'nokogiri'

class MetadataTransformer
  def initialize(app)
    @app = app
  end

  def determine_fgdc(xfgdc)
    # FGDC CSDGM Version 2.0, 1998 ( FGDC-STD-001-1998)
    # FGDC CSDGM Biological Data Profile (FGDC-STD-001.1-1999)
    # FGDC CSDGM Metadata Profile for Shoreline Data (FGDC-STD-001.2-2001)
    # FGDC Extension for Remote Sensing (FGDC-STD-012-2002)
    # fgdc_standards = { 'FGDC-STD-001-1998' => 'version 2.0', 'FGDC-STD-001.1-1999' }
    fgdc_standard_xpath = 'metainfo//metstdv'

    standard = xfgdc.xpath(fgdc_standard_xpath)[0]
  end

  def determine_iso(x); end

  def determine_schema(xml_str)
    fgdc_root = 'metadata'
    begin
      xDoc = Nokogiri::XML(xml_str, &:strict)
    rescue Nokogiri::XML::SyntaxError => e
      'ERROR: XML file is not well formed'
    end
  end

  def call(env)
    request = Rack::Request.new(env)
    file_param = request.params['file']
    # transform
    # request.update_param('file', transformed_file)

    @app.call(env)
  end
end
