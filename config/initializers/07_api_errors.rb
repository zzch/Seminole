# -*- encoding : utf-8 -*-
class APIError
  @contents = {
    10001 => { message: '数据未找到' },
    10002 => { status: 401, message: 'Token失效' },
    10003 => { message: '球场未找到' },
    10004 => { message: '非法访问' },
    10005 => { message: '网络无响应' },
    10006 => { message: '请求超时' }
  }

  class << self
    def method_missing(sym, *args, &block)
      if sym =~ /^code_\d{5}$/
        @contents[sym.to_s.scan(/^code_(\d{5})$/)[0][0].to_i].tap do |content|
          content.merge!(status: 200) unless content.has_key?(:status)
        end
      else
        super(sym, *args, &block)
      end
    end

    def message(code)
      @contents[code][:message]
    end
  end
end