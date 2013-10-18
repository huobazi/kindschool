class AccessStatu < ActiveRecord::Base
  attr_accessible :accessed_at, :module_name, :user_id, :kindergarten_id

  belongs_to :kindergarten


  def self.records(kind, module_name, user, search, tp)
    if search
      records = search
    else
      if module_name == "Topic"
        if user.get_users_ranges[:tp] == :student
          records = kind.topics.where("creater_id = ? or squad_id = ? or squad_id is null", user.id, user.student_info.squad_id)
        elsif user.get_users_ranges[:tp] == :teachers
          records = kind.topics.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", user.staff.id, user.id)
        else
          records = kind.topics
        end
      elsif module_name == "GrowthRecord"

        if tp
          if user.get_users_ranges[:tp] == :student
            records = GrowthRecord.where("tp = ? and (creater_id = ? or student_info_id = ?)", tp, user.id, user.student_info.id)
          elsif user.get_users_ranges[:tp] == :teachers
            records = GrowthRecord.joins("INNER JOIN student_infos as s on(s.id = growth_records.student_info_id)").where("s.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?) and growth_records.tp=?",user.staff.id,tp)
          else
            records = kind.growth_records.where("tp = ?", tp)
          end
        else
          if user.get_users_ranges[:tp] == :student
            records = GrowthRecord.where("creater_id = ? or student_info_id = ?", user.id, user.student_info.id)
          elsif user.get_users_ranges[:tp] == :teachers
            records = GrowthRecord.joins("INNER JOIN student_infos as s on(s.id = growth_records.student_info_id)").where("s.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?)",user.staff.id)
          else
            records = kind.growth_records
          end
        end

      elsif module_name == "TeachingPlan"
        if user.get_users_ranges[:tp] == :student
          records = kind.teaching_plans.where("squad_id = ? or squad_id is null", user.student_info.squad_id)
        elsif user.get_users_ranges[:tp] == :teachers  
          records = kind.teaching_plans.where("squad_id in (select squad_id from teachers where staff_id = ?) or squad_id is NULL", user.staff.id)
        else
          records = kind.teaching_plans
        end

      elsif module_name == "Activity"

        if tp
          if user.get_users_ranges[:tp] == :student
            records = kind.activities.where(:tp => tp, :squad_id => user.student_info.squad_id)
          elsif user.get_users_ranges[:tp] == :teachers
            records = kind.activities.where("tp = ? and (squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL)", tp, user.staff.id, user.id)
          else
            records = kind.activities.where(:tp => tp)
          end
        else
          if user.get_users_ranges[:tp] == :student
            records = kind.activities.where(:squad_id => user.student_info.squad_id)
          elsif user.get_users_ranges[:tp] == :teachers
            records = kind.activities.where("(squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL)", user.staff.id, user.id)
          else
            records = kind.activities
          end
        end


      elsif module_name == "Album"

        if user.get_users_ranges[:tp] == :student
          records = kind.albums.where("is_show = 1 and (squad_id = ? or squad_id is null)", user.student_info.squad_id)
        elsif user.get_users_ranges[:tp] == :teachers
          records = kind.albums.where("is_show = 1 and ( squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL )", user.staff.id, user.id)
        else
          records = kind.albums.where(:is_show=> 1)
        end

      elsif module_name == "PersonalSet"

        records = user.personal_sets

      elsif module_name == "CookBook"

        records = kind.cook_books

      elsif module_name == "WeixinShareUser"

        records = WeixinShareUser.where("visible=1 AND user_id=? AND weixin_shares.send_date < ?" ,user.id, Time.zone.now).joins("LEFT JOIN weixin_shares ON(weixin_shares.id = weixin_share_users.weixin_share_id)")

      elsif module_name == "News"

        records = News.where("kindergarten_id = ? and approve_status = 0",kind.id)

      end



    end
    records
  end

  def self.unread_count(kind, module_name, user, search, tp)

    records = self.records(kind, module_name, user, search, tp)

    if statu = kind.access_status.find_by_module_name_and_user_id(module_name, user.id)
      access_time = statu.accessed_at
    else
      begin
        records.total_count
      rescue NoMethodError
        return records.count
      else
        return records.total_count
      end
    end

    if access_time
      count = 0
      (records || []).each do |record|
        if record.created_at > access_time
          count += 1
        end
      end
      count
    end
  end

  def self.update_unread(kind, module_name, user)
    if as = kind.access_status.find_by_module_name_and_user_id(module_name, user.id)
      as.accessed_at = Time.now.utc
      as.save
    else
      as = AccessStatu.new
      as.kindergarten_id = kind.id
      as.module_name = module_name
      as.user_id = user.id
      as.accessed_at = Time.now.utc
      as.save
    end
  end

end
