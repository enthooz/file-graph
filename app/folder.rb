class Folder < FlippedView

  FOLDER_TOP = 10

  attr_accessor :is_open, :is_root, :folderPath, :folderName, :folderIcon, :subfolderView
  attr_accessor :layoutConstraints, :subfolderViewConstraints
  attr_accessor :rankLine
  #attr_reader :layer

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def initWithPath(folder_path)

    init

    self.translatesAutoresizingMaskIntoConstraints = false

    self.is_open = false
    self.folderPath = folder_path
    self.folderName = File.basename(self.folderPath)

    drawFolderIcon
    drawSubfolderView
    setConstraints

    self
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def drawRect(dirtyRect)
    NSColorFromHex('#999999', 1.0).setFill
    #NSBezierPath.fillRect(dirtyRect)
    #NSColorFromHex("#999999", 1.0).setStroke
    #NSBezierPath.strokeRect(dirtyRect)
    # NSColorFromHex('#666666', 0.8).setFill
    NSFrameRect(dirtyRect)
    super
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def drawFolderIcon
    @folderIcon = FolderIcon.alloc.initWithName(self.folderName)
    self.addSubview(@folderIcon)
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def drawSubfolderView
    @subfolderView = SubfolderView.alloc.initWithPath(self.folderPath)
  end


  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def toggle
    open? ? close : open
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def open?
    is_open
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def open
    self.is_open = true
    self.addSubview(@subfolderView)
    @subfolderView.open
    #self.drawLines
    setConstraints
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def close
    self.is_open = false
    @subfolderView.close
    setConstraints
  end


  # TODO: this breaks the ability to add subfolders after drawing line
  def drawLines
    return unless self.folders.any?
    self.horizontalLine = Line.alloc.initFrom([0, 0], to: [self.bounds.size.width, 1])
    self.addSubview(self.horizontalLine)
    self.horizontalLineConstraints = []
    self.horizontalLineConstraints.tap do |c|
      c << NSLayoutConstraint.constraintWithItem(self.horizontalLine,
                                                           attribute: NSLayoutAttributeLeft,
                                                           relatedBy: NSLayoutRelationEqual,
                                                           toItem: self.folders.first,
                                                           attribute: NSLayoutAttributeCenterX,
                                                           multiplier: 1.0,
                                                           constant: 0.0)
      c << NSLayoutConstraint.constraintWithItem(self.horizontalLine,
                                                           attribute: NSLayoutAttributeRight,
                                                           relatedBy: NSLayoutRelationEqual,
                                                           toItem: self.folders.last,
                                                           attribute: NSLayoutAttributeCenterX,
                                                           multiplier: 1.0,
                                                           constant: 0.0)
      c << NSLayoutConstraint.constraintWithItem(self.horizontalLine,
                                                           attribute: NSLayoutAttributeTop,
                                                           relatedBy: NSLayoutRelationEqual,
                                                           toItem: self.folders.first,
                                                           attribute: NSLayoutAttributeTop,
                                                           multiplier: 0.5,
                                                           constant: 0.0)
      c << NSLayoutConstraint.constraintWithItem(self.horizontalLine,
                                                           attribute: NSLayoutAttributeBottom,
                                                           relatedBy: NSLayoutRelationEqual,
                                                           toItem: self.folders.first,
                                                           attribute: NSLayoutAttributeTop,
                                                           multiplier: 0.5,
                                                           constant: 2.0)
      views = { 'line' => self.horizontalLine }
      c += NSLayoutConstraint.constraintsWithVisualFormat("V:[line(==2)]", options: 0, metrics: nil, views: views)
      c += NSLayoutConstraint.constraintsWithVisualFormat("H:[line(>=1)]", options: 0, metrics: nil, views: views)
    end
    #puts self.horizontalLineConstraints
    self.addConstraints(self.horizontalLineConstraints)
  end

  def eraseLine
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def setConstraints

    unless self.layoutConstraints.nil?
      self.removeConstraints(self.layoutConstraints)
      self.layoutConstraints = nil
    end

    if @subfolderView.isDescendantOf(self)
      self.setConstraintsWithSubfolderView
    else
      self.setConstraintsWithoutSubfolderView
    end
  end

  private

  def setConstraintsWithoutSubfolderView
    views = { 'folderIcon' => @folderIcon, 'subfolderView' => @subfolderView }

    # Folder icon stuck to top.  Subfolder view stuck to folder icon.
    self.layoutConstraints =  NSLayoutConstraint.constraintsWithVisualFormat("V:|-[folderIcon][subfolderView]|",
                                                                                    options: 0, metrics: nil, views: views)
    self.layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[subfolderView(>=folderIcon)]|",
                                                                                    options: 0, metrics: nil, views: views)
    # folderIcon.centerX == subfolderView.centerX
    self.layoutConstraints << NSLayoutConstraint.constraintWithItem(@folderIcon,
                                   attribute: NSLayoutAttributeCenterX,
                                   relatedBy: NSLayoutRelationEqual,
                                   toItem:    @subfolderView,
                                   attribute: NSLayoutAttributeCenterX,
                                   multiplier: 1, constant: 0)
    self.addConstraints(self.layoutConstraints)
  end

  def setConstraintsWithSubfolderView
    views = { 'folderIcon' => @folderIcon}
    self.layoutConstraints =  NSLayoutConstraint.constraintsWithVisualFormat("V:|-[folderIcon]|", options: 0, metrics: nil, views: views)
    self.layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[folderIcon]|", options: 0, metrics: nil, views: views)
    self.addConstraints(self.layoutConstraints)
  end

end
