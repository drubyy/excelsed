class Excelsed
  attr_reader :file_path, :scan_mappings, :output_dir, :tmp_dir, :file_name

  def initialize file_path, scan_mappings, output_dir, file_name: 'output'
    @file_path = file_path
    @scan_mappings = scan_mappings
    @output_dir = output_dir
    @tmp_dir = "#{output_dir}/tmp"
    @file_name = file_name

    FileUtils.mkdir_p(tmp_dir)
  end

  def perform
    perform_unzip
    sed_mappings
    export_result

    {file_path: "#{output_dir}/#{file_name}.xlsx"}
  ensure
    FileUtils.rm_rf(tmp_dir)
  end

  private

  def perform_unzip
    system("unzip #{file_path} -d #{tmp_dir}")
  end

  def sed_mappings
    scan_mappings.each do |(key, value)|
      system("sed -i 's/#{key}/#{value}/g' #{tmp_dir}/xl/sharedStrings.xml")
    end
  end

  def export_result
    system("cd #{tmp_dir} && zip -r #{file_name}.zip _rels docProps xl [Content_Types].xml")
    system("cd #{tmp_dir} && mv #{file_name}.zip ../#{file_name}.xlsx")
  end
end