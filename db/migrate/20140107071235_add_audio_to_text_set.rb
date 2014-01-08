class AddAudioToTextSet < ActiveRecord::Migration

  def change
    add_column :text_sets, :tp, :integer , :default=>0  #0为默认，是纯文本，1为音频
    add_column :text_sets, :audio, :string
  end
end
