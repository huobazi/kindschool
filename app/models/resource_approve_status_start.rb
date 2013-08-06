#encoding:utf-8
module ResourceApproveStatusStart
  
  protected
  def news_approve_status_start
    if kind =  self.kindergarten
      if approve_module=kind.approve_modules.find_by_number(self.class.to_s)
         if approve_module.status
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