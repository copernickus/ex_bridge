% elixir: cache

module ExBridge::Request
  def initialize(request, options := {:})
    @('request: request, 'options: options || {:})
  end

  def memoize!
    memoize!('headers).memoize!('cookies)
  end

  def memoize!('headers)
    @('headers: self.headers)
  end

  def memoize!('cookies)
    @('cookies: self.cookies)
  end

  % Helpers

  def upcase_headers(object)
    if object.__parent_name__ == 'Atom
      object.to_s
    else
      upcase_headers(object.to_char_list, [])
    end
  end

  def upcase_headers([h|t], []) when h >= 97 and h <= 122
    upcase_headers([t], [h-32])
  end

  def upcase_headers([$-,h|t], acc) when h >= 97 and h <= 122
    upcase_headers(t, [h-32,$-|acc])
  end

  def upcase_headers([h|t], acc)
    upcase_headers(t, [h|acc])
  end

  def upcase_headers([], acc)
    String.new acc.reverse
  end
end