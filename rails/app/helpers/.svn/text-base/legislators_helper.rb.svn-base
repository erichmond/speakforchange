module LegislatorsHelper
  def legislator_url 
    request.path =~ /senator/ ? senator_url(@legislator.id, :rss) : representative_url(@legislator.id, :rss)
  end
end
