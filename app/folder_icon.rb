class FolderIcon < FlippedView

  WIDTH = 80
  HEIGHT = 30
  BG_COLOR = '#999999'
  BORDER_COLOR = '#555555'
  TEXT_COLOR = '#333333'

  attr_accessor :folderName, :folderRect, :label

  def initWithName(folder_name)

    initWithFrame([ [0, 0], [WIDTH, HEIGHT] ])

    self.translatesAutoresizingMaskIntoConstraints = false

    self.folderName = folder_name
    self.wantsLayer = true
    self.needsDisplay = true
    drawFolderRect
    drawLabel
    setConstraints
    self.layer.addSublayer(@folderRect)
    self.backgroundColor = NSColorFromHex('#ff0000', 0.5)
    self
  end

  def intrinsicContentSize
    [ WIDTH, HEIGHT ]      
  end                      
                           
  # def setSizeConstraints 
  #   views = { 'self' =>  self }
  #   # self.addConstraint s(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[self(#{HEIGHT})]",
  #   #                                                             options: 0,
  #   #                                                             metrics: nil,
  #   #                                                               views: views))
  #   self.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("H:[self(>=#{WIDTH})]",
  #                                                              options: 0,
  #                                                              metrics: nil,
  #                                                                views: views))
  # end

  def setConstraints
    views = { 'folderIcon' => self }

    # self.height == FolderIcon::HEIGHT
    vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[folderIcon(==#{FolderIcon::HEIGHT})]",
                                                                  options: 0, metrics: nil, views: views)
    # self.width == FolderIcon::WIDTH
    hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[folderIcon(==#{FolderIcon::WIDTH})]",
                                                                  options: 0, metrics: nil, views: views)
    self.addConstraints(vConstraints + hConstraints)
  end

  def drawFolderRect
    @folderRect = CALayer.layer
    @folderRect.tap do |rect|
      rect.bounds = [[0, 0], [WIDTH, HEIGHT]]
      rect.backgroundColor = CGColorCreateHex(BG_COLOR, 1.0)
      rect.borderColor = CGColorCreateHex(BORDER_COLOR, 1.0)
      rect.borderWidth = 1.0
      rect.cornerRadius = 4.0
      rect.position = CGPointMake(CGRectGetMidX(rect.bounds), CGRectGetMidY(rect.bounds))
      rect.opacity = 1.0
      rect.layoutManager = CAConstraintLayoutManager.layoutManager
    end
  end

  def drawLabel
    @label = CATextLayer.layer

    @label.string = self.folderName
    @label.font = NSFont.fontWithName("HelveticaNeue", size: 10)
    @label.fontSize = 10.0
    
    @label.addConstraint(CAConstraint.constraintWithAttribute(KCAConstraintMidY,
              relativeTo: "superlayer",
               attribute: KCAConstraintMidY))

    @label.addConstraint(CAConstraint.constraintWithAttribute(KCAConstraintMidX,
              relativeTo: "superlayer",
               attribute: KCAConstraintMidX))
    @label.foregroundColor = CGColorCreateHex(TEXT_COLOR, 1)

    @label.frame = @folderRect.frame

    @folderRect.addSublayer(@label)
  end

end
