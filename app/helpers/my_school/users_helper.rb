# encoding: utf-8
module MySchool::UsersHelper

  def download_guides_pdf
    if File.exist?(Rails.root + "public/doc/guides/#{@kind.number}_guides.pdf")
      "/doc/guides/#{@kind.number}_guides.pdf"
    else
      "/doc/guides/huolg_guides.pdf"
    end
  end

end

