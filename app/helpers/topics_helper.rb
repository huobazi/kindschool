module TopicsHelper

  def delete_topic?(topic)
    if current_user.get_users_ranges[:tp] == :student
      if current_user.id == topic.creater_id
        true
      else
        false
      end
    elsif current_user.get_users_ranges[:tp] == :teachers
      squads = current_user.get_users_ranges[:squads]
      if squads.collect(&:id).include?(topic.try(:squad_id)) or current_user.id == topic.creater_id
        true
      else
        false
      end
    else
      true
    end
  end

  def can_destroy_index?
    if current_user.get_users_ranges[:tp] == :student
      false
    else
      true
    end
  end

  def destroy_topic_entry?(topic_entry)
    if current_user.get_users_ranges[:tp] == :all
      true
    elsif current_user.id == topic_entry.creater_id
      true
    elsif current_user.get_users_ranges[:tp] == :teachers
      if topic_entry.topic.squad.present? && current_user.staff.squad_ids.include?(topic_entry.topic.squad_id)
        true
      else
        false
      end
    else
      false
    end
  end

  def edit_topic_entry?(topic_entry)
    if topic_entry.creater_id == current_user.id
      true
    else
      false
    end
  end

  def edit_topic?(topic)
    if current_user.get_users_ranges[:tp] == :student
      if current_user.id == topic.creater_id
        true
      else
        false
      end
    elsif current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
      if current_user.get_users_ranges[:squads].collect(&:id).include?(topic.try(:squad_id)) or current_user.id == topic.creater_id
        true
      else
        false
      end
    else
      true
    end
  end

end
