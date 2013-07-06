#encoding:utf-8
module Huolg
  #对标准类型的扩展
  module Datetime
    # format datetime with / and  long format
    def to_long_datetime
      self.strftime("%Y-%m-%d %H:%M")
    end

    # format datetime with / and  long format
    def to_all_datetime
      self.strftime("%Y-%m-%d %H:%M:%S")
    end

    # format datetime with - and shor format
    def to_short_datetime
      self.strftime("%Y-%m-%d")
    end
  end
  module Boolean
    def to_zh
      self == true ? "是" : "否"
    end
  end
end
class DateTime
  include Huolg::Datetime
end
class Time
  include Huolg::Datetime
end

class TrueClass
  include Huolg::Boolean
end
class FalseClass
  include Huolg::Boolean
end