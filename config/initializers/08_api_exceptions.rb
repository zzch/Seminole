# -*- encoding : utf-8 -*-
class APIException
  @contents = {
    20001 => { message: '用户不存在' },
    20002 => { message: '用户未激活' },
    20003 => { message: '验证码不正确' },
    20004 => { message: '重复预约' },
    20005 => { message: '无效的状态' },
    20006 => { message: '课程预约已满' },
    20007 => { message: '请求过于频繁' },
  }

  class << self
    def method_missing(sym, *args, &block)
      if sym =~ /^code_\d{5}$/
        @contents[sym.to_s.scan(/^code_(\d{5})$/)[0][0].to_i]
      else
        super(sym, *args, &block)
      end
    end

    def message(code)
      @contents[code][:message]
    end
  end
end