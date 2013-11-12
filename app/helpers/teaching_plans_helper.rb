module TeachingPlansHelper

  def delete_teaching_plan?(teaching_plan)
    if current_user.get_users_ranges[:tp] == :student
      false
    elsif current_user.get_users_ranges[:tp] == :teachers
      squads = current_user.get_users_ranges[:squads]
      if squads.collect(&:id).include?(teaching_plan.try(:squad_id)) or current_user.id == teaching_plan.creater_id
        true
      else
        false
      end
    else
      true
    end
  end

end
