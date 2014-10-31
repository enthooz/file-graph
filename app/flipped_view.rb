class FlippedView < NSView
  def isFlipped
    true
  end

  # #-------------------------------------------------------------
  # #
  # #-------------------------------------------------------------
  # def drawRect(dirtyRect)
  #   NSColorFromHex('#0000ff', 0.8).setFill
  #   NSBezierPath.fillRect(dirtyRect)
  #   # NSColorFromHex('#666666', 0.8).setFill
  #   # NSFrameRect(dirtyRect)
  #   super
  # end
end
