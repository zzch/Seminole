# -*- encoding : utf-8 -*-
class APIException
  @contents = {
    10001 => { message: '数据未找到' },
    10002 => { message: '非法访问' },
    10003 => { message: '网络无响应' },
    10004 => { message: '请求超时' },
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
