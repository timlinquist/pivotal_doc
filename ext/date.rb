class Date
  def standard_format
    self.strftime("%m-%d-%Y")
  end
  
  def fancy_format
    self.strftime("%b %d, %Y")    
  end
end