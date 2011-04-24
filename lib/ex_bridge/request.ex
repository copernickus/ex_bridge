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

  def cookies
    @cookies || begin
      headers = self.headers
      if raw_cookies = headers["Cookie"]
        list = raw_cookies.split(~r";").foldl [], do (cookie, acc)
          case cookie.strip.split(~r"=", 2)
          when [first, second] then [{first,second}|acc]
          else % Nothing
          end
        end
        OrderedDict.from_list list.flatten
      else
        {:}
      end
    end
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
    acc.reverse.to_bin
  end
end