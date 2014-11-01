class Rectangle < FlippedView

  DEFAULT_COLOR = '#555555'

  attr_accessor :color

  def init
    super
    self.translatesAutoresizingMaskIntoConstraints = false
    self.color = DEFAULT_COLOR
    self
  end

  def initWithColor(color)
    init
    self.color = color
    self
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def drawRect(dirtyRect)
    NSColorFromHex(self.color, 1.0).setFill
    NSBezierPath.fillRect(dirtyRect)
    super
  end

end
