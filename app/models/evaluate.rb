#encoding:utf-8
#评估管理，主表，与幼儿园一对一
class Evaluate < ActiveRecord::Base
  attr_accessible :kindergarten_id, :note
  belongs_to :kindergarten
  has_many :evaluate_entries, :dependent => :destroy
  after_save :export_demo
  def download_package
  @kind=self.kindergarten
  evaluate_vtocs = @kind.evaluate_vtocs
    input_filenames,directory,directory_name = {},{},{}
    (evaluate_vtocs||[]).each do |vtoc|
      assets=vtoc.evaluate_assets
        (assets||[]).each do |asset|
          input_filenames[File.basename(asset.avatar.url)] = [asset.avatar_url.to_s.gsub!(/\/home\/jody\/kinder\/school/, '.'),asset.file_name]
          directory[File.basename(asset.avatar.url)]=vtoc.evaluate_entry.article_case
          directory_name[vtoc.evaluate_entry.article_case] = vtoc.evaluate_entry.article_case
        end
    end
    dir_name="./stuff_to_zip/#{@kind.number}/"
    FileUtils.remove_dir(dir_name,true)
    Dir.mkdir(File.join("./stuff_to_zip", "#{@kind.number}"), 0700) unless File.exists?(dir_name)
    zipfile_name = dir_name+"#{@kind.number}.zip"
    if File.exist?("#{File.dirname(__FILE__)}/../../../stuff_to_zip/#{@kind.number}.zip") 
      File.delete("#{File.dirname(__FILE__)}/../../../stuff_to_zip/#{@kind.number}.zip")  
    end
    directory_name.each do |name,n|
     zipfile_name_ch = dir_name+"#{name}.zip"
     if File.exist?("#{File.dirname(__FILE__)}/../../.#{zipfile_name_ch}") 
      File.delete("#{File.dirname(__FILE__)}/../../.#{zipfile_name_ch}")  
     end
     Zip::ZipFile.open(zipfile_name_ch, Zip::ZipFile::CREATE) do |zipfile|
        input_filenames.each do |filename,filename_url|
          url = filename_url[0]
          if name == directory[filename]
            zipfile.add(filename, "./#{url}")
            zipfile.rename(filename,filename_url[1])
          end
        end
      end
    end
    directory1 = dir_name
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      Dir[File.join(directory1, '**', '**')].each do |file|
        zipfile.add(file.sub(directory1, ''), file)
      end
    end
    directory_name.each do |name,n|
     if File.exist?("#{File.dirname(__FILE__)}/../../.#{dir_name}#{name}.zip") 
      File.delete("#{File.dirname(__FILE__)}/../../.#{dir_name}#{name}.zip")  
     end
    end   
    filepath="#{Rails.root}/config/initializers/session_store.rb"
    ch_files = "#{File.dirname(__FILE__)}/../../stuff_to_zip/"
    data=File.stat(filepath)
    uid=data.uid 
    gid=data.gid 
    filechown = File.chown(uid,gid,"#{ch_files}#{@kind.number}","#{ch_files}#{@kind.number}/#{@kind.number}.zip") 
    @kind.download_package.destroy if @kind.download_package
     package =DownloadPackage.new(:name=>"评估系统")
     package.package = "#{@kind.number}.zip"
     package.kindergarten=@kind
     package.status = false
     package.save! 
  end
  private
  #创建demo项目
  def export_demo
      evaluate = YAML.load_file("#{Rails.root}/db/basic_data/evaluate.yml")
      evaluate.each do |k,evaluate|
        evaluate_entry = EvaluateEntry.new()
      	evaluate_entry.a_indicator = evaluate["a_indicator"]
        evaluate_entry.b_indicator = evaluate["b_indicator"]
        evaluate_entry.name = evaluate["name"]
        evaluate_entry.article_case = evaluate["article_case"] 
        evaluate_entry.sequence = evaluate["sequence"].to_i
        evaluate_entry.note = evaluate["note"]
        (evaluate["evaluate_vtocs"] || []).each do |k,evaluate_vtoc|
           evaluate_vtocs=EvaluateVtoc.new()
           evaluate_vtocs.name = evaluate_vtoc
           evaluate_vtocs.kindergarten=self.kindergarten
           evaluate_entry.evaluate_vtocs<<evaluate_vtocs
        end
        evaluate_entry.kindergarten=self.kindergarten
        self.evaluate_entries << evaluate_entry
      end
  end
end
