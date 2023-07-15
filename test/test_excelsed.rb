require 'minitest/autorun'
require 'excelsed'

class ExcelsedTest < Minitest::Test
  def test_replace
    scan_mappings = {
      VARIABLE_1: "new value variable 1",
      VARIABLE_2: "new value variable 2",
      VARIABLE_3: "new value variable 3"
    }
    tmp_dir = 'draft/testgem'

    output = Excelsed.new("test/fixtures/example.xlsx", scan_mappings, tmp_dir).perform
    system("unzip #{output[:file_path]} -d #{tmp_dir}")
    replaced_variable_1 = %x[grep -q 'new value variable 1' #{tmp_dir}/xl/sharedStrings.xml && echo 'true' || echo 'false']
    replaced_variable_2 = %x[grep -q 'new value variable 2' #{tmp_dir}/xl/sharedStrings.xml && echo 'true' || echo 'false']
    replaced_variable_3 = %x[grep -q 'new value variable 3' #{tmp_dir}/xl/sharedStrings.xml && echo 'true' || echo 'false']

    assert_equal "true\n", replaced_variable_1
    assert_equal "true\n", replaced_variable_2
    assert_equal "true\n", replaced_variable_3
  ensure
    FileUtils.rm_rf(tmp_dir)
  end
end