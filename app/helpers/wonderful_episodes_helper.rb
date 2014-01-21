module WonderfulEpisodesHelper
  def can_edit?(wonderful_episode)
    basic?(wonderful_episode)
  end

  def can_destroy?(wonderful_episode)
    basic?(wonderful_episode)
  end

  def can_add_index?
    basic_index?
  end

  def can_destroy_index?
    basic_index?
  end

  protected
  def basic?(wonderful_episode)
    result = false
    if current_user.get_users_ranges[:tp] == :teachers
      squads = current_user.get_users_ranges[:squads]
    end
    if current_user.get_users_ranges[:tp] == :all || ((squads && wonderful_episode.squad) && (squads.collect.include?(wonderful_episode.squad) || wonderful_episode.creater == current_user))
      result = true
    end
    result
  end

  def basic_index?
true
  end
end
