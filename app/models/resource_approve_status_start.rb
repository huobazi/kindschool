#encoding:utf-8
module ResourceApproveStatusStart
  
  protected
  def news_approve_status_start
    if kind =  self.kindergarten
      if approve_module=kind.approve_modules.find_by_number(self.class.to_s)
         if approve_module.status
          #这个里面判断是否是修改要审核的字段
           attr_ab = self.change_arry_approve_record
           flag = false
           attr_ab.each  do |at|
            if self.send("#{at}") != self.send("#{at}_was")
              flag = true
            end
           end
           if flag == true
           if self.approve_status_was == self.approve_status
            self.approve_status = 1
            if  self.approve_record.blank?
            	approve_record = ApproveRecord.new()
            	 self.approve_record = approve_record
               approve_entry=ApproveEntry.new(:note=>"创建了一条记录")
               self.approve_record.approve_entries << approve_entry
            else
               self.approve_record.status = 1
               approve_entry=ApproveEntry.new(:note=>"更新了该条记录")
               self.approve_record.approve_entries << approve_entry
            end
           end
          end
         end
      end
    end    
	end
  def messages_approve_status_start
    if kind =  self.kindergarten
      if approve_module=kind.approve_modules.find_by_number(self.class.to_s)
         if approve_module.status
           if self.approve_status_was == self.approve_status && self.status == true && (self.tp == 0 || self.tp ==1)
            self.approve_status = 1
            if  self.approve_record.blank?
              approve_record = ApproveRecord.new()
               self.approve_record = approve_record
               approve_entry=ApproveEntry.new(:note=>"创建了一条记录")
               self.approve_record.approve_entries << approve_entry
            else
               self.approve_record.status = 1
               approve_entry=ApproveEntry.new(:note=>"更新了该条记录")
               self.approve_record.approve_entries << approve_entry
            end
           end
         end
      end
    end

  end
  private
  # def change_attr_accessible?()

  # end
end