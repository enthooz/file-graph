class SpacerView < NSView
  def init
    self.initWithFrame([ [0, 0], [0, 0] ])
    self.translatesAutoresizingMaskIntoConstraints = false
    self
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def drawRect(dirtyRect)
    NSColorFromHex('#ff0000', 1.0).setFill
    NSBezierPath.fillRect(dirtyRect)
    # NSColorFromHex('#666666', 0.8).setFill
    # NSFrameRect(dirtyRect)
    super
  end
end
