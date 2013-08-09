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

class Array

  # Chooses a random array element from the receiver based on the weights
  # provided. If _weights_ is nil, then each element is weighed equally.
  #
  #   [1,2,3].random          #=> 2
  #   [1,2,3].random          #=> 1
  #   [1,2,3].random          #=> 3
  #
  # If _weights_ is an array, then each element of the receiver gets its
  # weight from the corresponding element of _weights_. Notice that it
  # favors the element with the highest weight.
  #
  #   [1,2,3].random([1,4,1]) #=> 2
  #   [1,2,3].random([1,4,1]) #=> 1
  #   [1,2,3].random([1,4,1]) #=> 2
  #   [1,2,3].random([1,4,1]) #=> 2
  #   [1,2,3].random([1,4,1]) #=> 3
  #
  # If _weights_ is a symbol, the weight array is constructed by calling
  # the appropriate method on each array element in turn. Notice that
  # it favors the longer word when using :length.
  #
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "hippopotamus"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "dog"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "hippopotamus"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "hippopotamus"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "cat"
  def random(weights=nil)
    return random(map {|n| n.send(weights)}) if weights.is_a? Symbol

    weights ||= Array.new(length, 1.0)
    total = weights.inject(0.0) {|t,w| t+w}
    point = rand * total
    # p total
    # p zip(weights)

    zip(weights).each do |n,w|
      # p "n#{n}   w#{w}  point#{point}"
      return n if w >= point
      point -= w
    end
  end

  # Generates a permutation of the receiver based on _weights_ as in
  # Array#random. Notice that it favors the element with the highest
  # weight.
  #
  #   [1,2,3].randomize           #=> [2,1,3]
  #   [1,2,3].randomize           #=> [1,3,2]
  #   [1,2,3].randomize([1,4,1])  #=> [2,1,3]
  #   [1,2,3].randomize([1,4,1])  #=> [2,3,1]
  #   [1,2,3].randomize([1,4,1])  #=> [1,2,3]
  #   [1,2,3].randomize([1,4,1])  #=> [2,3,1]
  #   [1,2,3].randomize([1,4,1])  #=> [3,2,1]
  #   [1,2,3].randomize([1,4,1])  #=> [2,1,3]
  def randomize(weights=nil)
    return randomize(map {|n| n.send(weights)}) if weights.is_a? Symbol

    weights = weights.nil? ? Array.new(length, 1.0) : weights.dup

    # pick out elements until there are none left
    list, result = self.dup, []
    until list.empty?
      # pick an element
      result << list.random(weights)
      # remove the element from the temporary list and its weight
      weights.delete_at(list.index(result.last))
      list.delete result.last
    end

    result
  end

  #ruby查找数组中重复的项 
  #[1,2,3,2,2,3]=>[2,3]
  def dups
    inject({}) {|h,v| h[v]=h[v].to_i+1; h}.select{|k,v| v > 1}.keys
  end
end

#Standard.rand_password #=>6dsfds
#Standard.rand_password(4) #=>6dsf
class Standard
  def self.rand_password(size=6)
    validchars = ('a'..'z').to_a + (3..9).to_a - ['o','i','e','v','l']
    #    validchars = "丰 王 井 开 夫 天 无 元 专 云 扎 艺 木 五 支 厅 不 太 犬 区 历 尤 匹 车 巨 牙 屯 比 互 切 瓦 止 少 日 中 冈 贝 内 水 见 午 牛 手 毛 气 升 长 仁 什 片 仆 化 仇 币 仍 仅 斤 爪 反 介 父从 今 凶 分 乏 公 仓 月 氏 勿 欠 风 丹 匀 乌 凤 勾 文 六 方 火 为 斗 忆 订 计 户 认 心 尺 引 丑 巴 孔 队 办 以 允 予 双 书 幻 玉 刊 示 末 未 击 打 巧 正 扑 扒 功 扔 去 甘 世 古 节 本 术 可 左 厉 右 石 布 龙 平 灭 轧 东 卡 北 占 业 旧 帅 归 且 旦 目 叶 甲 申 叮 电 号 田 由 史 只 央 兄 叼 叫 另 叨 叹 四 生 禾 丘 付 仗 代 仙 们 仪 白 仔 他 斥 瓜 乎 丛 令 用 甩 印 乐 句 匆 册 犯 外 处 冬 鸟 务 包 饥 主 市 立 闪 兰 半 汁 汇 头 宁 穴 它 讨 写 让 礼 训 必 议 讯 记 永 司 尼 民 出 辽 奶 奴 加 召 皮 边 发 孕 圣 对 台 矛 纠 母 幼 丝".split(' ')
    chars = []
    size.times {|x|
      chars << validchars[rand(validchars.size).ceil - 1].to_s
    }
    chars.join("")
  end
end 