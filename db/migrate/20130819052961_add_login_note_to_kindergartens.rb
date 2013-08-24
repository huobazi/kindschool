class AddLoginNoteToKindergartens < ActiveRecord::Migration
  def change
    add_column :kindergartens, :login_note, :string, :default => "这是幼儿园为您的孩子注册的家园互动账号，请勿删除。如有疑问请咨询幼儿园。"  #注册
  end
end
