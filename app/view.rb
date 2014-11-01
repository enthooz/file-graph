class View < NSView

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def drawRect(dirtyRect)
    if defined?(self.class::DEBUG_RECT) && self.class::DEBUG_RECT
      NSColorFromHex('#999999', 1.0).setFill
      #NSBezierPath.fillRect(dirtyRect)
      #NSColorFromHex("#999999", 1.0).setStroke
      #NSBezierPath.strokeRect(dirtyRect)
      # NSColorFromHex('#666666', 0.8).setFill
      NSFrameRect(dirtyRect)
    end
    super
  end
end
