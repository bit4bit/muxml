require 'minitest/autorun'
require 'muxml'

class DocumentTest < Muxml::Base
  xml_document "test/document_test.xml", "document"
  
  has_many :configuraciones, tag: :section, select: {  name: :configuration }, class_name: 'ConfigurationTest'
end

class ConfigurationTest < Muxml::Base
  
  has_one :acl, tag: :configuration, select: { name: 'acl.conf' }, class_name: 'ConfigurationTest::AclTest'
  has_one :modules, tag: :configuration, select: { name: 'modules.conf' }, class_name: 'ConfigurationTest::ModuleTest'
end

class ConfigurationTest::ModuleTest < Muxml::Base
  has_many :loads, tag: "modules/load", class_name: "ConfigurationTest::ModuleTest::ListTest"
end

class ConfigurationTest::ModuleTest::ListTest < Muxml::Base
  
end

class ConfigurationTest::AclTest < Muxml::Base
  has_one :network, tag: 'network-lists', class_name: 'ConfigurationTest::AclTest::NetworkTest'
end

class ConfigurationTest::AclTest::NetworkTest < Muxml::Base
  
  has_many :lists, tag: :list, class_name: 'ConfigurationTest::AclTest::NetworkTest::ListTest'
end

class ConfigurationTest::AclTest::NetworkTest::ListTest < Muxml::Base
  
end


class MuxmlTest < Minitest::Unit::TestCase
  def test_inclusion
    doc = DocumentTest.new()

    conf = doc.configuraciones.first
    assert_equal "acl.conf",conf.acl.attribute_name
    assert_equal "acl.conf",conf.acl.attribute_name
    assert_equal "modules.conf", conf.modules.attribute_name
    assert_equal "modules.conf", conf.modules.attribute_name
    modules = conf.modules.loads.to_a
    assert_equal "fuiia", modules[0].attribute_module
    assert_equal "carajo", modules[1].attribute_module    
  end
    
end
