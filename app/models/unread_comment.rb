module UnreadComment

  def unread_comment_count
    if self.accessed_at
      self.comments.where("created_at > ?", self.accessed_at).count
    else
      self.comments.count
    end
  end
end
