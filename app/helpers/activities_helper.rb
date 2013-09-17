module ActivitiesHelper

  def destroy_activity_entry?(activity_entry)
    if current_user.get_users_ranges[:tp] == :all
      true
    elsif current_user.id == activity_entry.creater_id
      true
    elsif current_user.get_users_ranges[:tp] == :teachers
      if activity_entry.activity.squad.present? && current_user.staff.squad_ids.include?(activity_entry.activity.squad_id)
        true
      else
        false
      end
    else
      false
    end
  end

  def edit_activity_entry?(activity_entry)
    if activity_entry.creater_id == current_user.id
      true
    else
      false
    end
  end

  def delete_activity?(activity)
    if current_user.get_users_ranges[:tp] == :student
      false
    elsif current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
      if current_user.get_users_ranges[:squads].collect(&:id).include?(activity.try(:squad_id)) or current_user.id == activity.creater_id
        true
      else
        false
      end
    else
      true
    end
  end

  def edit_activity?(activity)
    if current_user.get_users_ranges[:tp] == :student
      false
    elsif current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
      if current_user.get_users_ranges[:squads].collect(&:id).include?(activity.try(:squad_id)) or current_user.id == activity.creater_id
        true
      else
        false
      end
    else
      true
    end
  end

  def interest_activity_expired?(end_at)
    if Time.now > end_at.tomorrow
      true
    else
      false
    end
  end

end

