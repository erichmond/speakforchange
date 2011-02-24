module MessagesHelper

  def get_current_hostname
    if request.port != 80
      @port = request.port
    else
      @port = ""
    end
    request.protocol + request.host + ':' + request.port.to_s
  end

end
