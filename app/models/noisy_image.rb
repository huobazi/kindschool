#encoding:utf-8
#验证码处理类
class NoisyImage
  include MiniMagick
  attr_reader :code, :code_image
  def initialize(length = 6)
    validchars = ('a'..'z').to_a + (3..9).to_a - ['o','i','e','v','l']
    #    validchars = "丰 王 井 开 夫 天 无 元 专 云 扎 艺 木 五 支 厅 不 太 犬 区 历 尤 匹 车 巨 牙 屯 比 互 切 瓦 止 少 日 中 冈 贝 内 水 见 午 牛 手 毛 气 升 长 仁 什 片 仆 化 仇 币 仍 仅 斤 爪 反 介 父从 今 凶 分 乏 公 仓 月 氏 勿 欠 风 丹 匀 乌 凤 勾 文 六 方 火 为 斗 忆 订 计 户 认 心 尺 引 丑 巴 孔 队 办 以 允 予 双 书 幻 玉 刊 示 末 未 击 打 巧 正 扑 扒 功 扔 去 甘 世 古 节 本 术 可 左 厉 右 石 布 龙 平 灭 轧 东 卡 北 占 业 旧 帅 归 且 旦 目 叶 甲 申 叮 电 号 田 由 史 只 央 兄 叼 叫 另 叨 叹 四 生 禾 丘 付 仗 代 仙 们 仪 白 仔 他 斥 瓜 乎 丛 令 用 甩 印 乐 句 匆 册 犯 外 处 冬 鸟 务 包 饥 主 市 立 闪 兰 半 汁 汇 头 宁 穴 它 讨 写 让 礼 训 必 议 讯 记 永 司 尼 民 出 辽 奶 奴 加 召 皮 边 发 孕 圣 对 台 矛 纠 母 幼 丝".split(' ')
    chars = []
    length.times {|x|
      chars << validchars[rand(validchars.size).ceil - 1].to_s
    }

    label = chars.join("")
    image = MiniMagick::Image.new('mini_captcha.jpg')
    image.run_command("convert -pointsize 16 -kerning 1 +noise Laplacian -undercolor lightgrey label:#{label} mini_captcha.jpg")
    image.to_blob

    @code = chars.to_s()
    @code_image = image.to_blob{ self.format="GIF" }
  end
end

