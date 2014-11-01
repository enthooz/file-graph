class Folder < FlippedView

  FOLDER_TOP = 10
  #DEBUG_RECT = true
  FOLDER_SUBFOLDER_VERTICAL_SPACING = 20.0
  LINE_THICKNESS = 1.0

  attr_accessor :is_open, :is_root, :folderPath, :folderName, :folderIcon, :subfolderView
  attr_accessor :layoutConstraints, :subfolderViewConstraints
  attr_accessor :verticalLine, :horizontalLine, :horizontalLineConstraints, :subfolderLines
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
    setConstraints
    self.drawLines
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def close
    self.is_open = false
    @subfolderView.close
    setConstraints
    self.eraseLines
  end


  # TODO: this breaks the ability to add subfolders after drawing line
  def drawLines

    # No subfolders.
    return if self.subfolderView.empty?

    self.verticalLine = Rectangle.alloc.init
    self.addSubview(self.verticalLine)

    firstFolder = self.subfolderView.folders.first

    # Only one subfolder.
    if self.subfolderView.folders.count == 1

      views = { 'folderIcon'      => self.folderIcon,
                'verticalLine'    => self.verticalLine,
                'subfolder'       => firstFolder }

      self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[folderIcon][verticalLine(#{FOLDER_SUBFOLDER_VERTICAL_SPACING})][subfolder]",
                                                                         options: 0, metrics: nil, views: views))

    # More than one subfolder.
    else

      lastFolder = self.subfolderView.folders.last

      self.horizontalLine = Rectangle.alloc.init
      self.addSubview(self.horizontalLine)

      views = { 'folderIcon'      => self.folderIcon,
                'verticalLine'    => self.verticalLine,
                'horizontalLine'  => self.horizontalLine }

      self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[folderIcon][verticalLine(#{((FOLDER_SUBFOLDER_VERTICAL_SPACING - LINE_THICKNESS) / 2.0).floor})][horizontalLine(#{LINE_THICKNESS})]",
                                                                         options: 0, metrics: nil, views: views))

      # horizontalLine.left == firstFolder.centerX
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.horizontalLine,
                                                           attribute: NSLayoutAttributeLeft,
                                                           relatedBy: NSLayoutRelationEqual,
                                                           toItem: firstFolder,
                                                           attribute: NSLayoutAttributeCenterX,
                                                           multiplier: 1.0,
                                                           constant: 0.0))
      # horizontalLine.right == lastFolder.centerX
      self.addConstraint(NSLayoutConstraint.constraintWithItem(self.horizontalLine,
                                                           attribute: NSLayoutAttributeRight,
                                                           relatedBy: NSLayoutRelationEqual,
                                                           toItem: lastFolder,
                                                           attribute: NSLayoutAttributeCenterX,
                                                           multiplier: 1.0,
                                                           constant: 0.0))

      # Draw subfolder lines.
      self.subfolderLines = self.subfolderView.folders.collect { |subfolder| drawLineToSubfolder(subfolder) }
    end

    # At least one subfolder.
    # verticalLine.centerX == folderIcon.centerX
    self.addConstraint(NSLayoutConstraint.constraintWithItem(self.verticalLine,
                                                         attribute: NSLayoutAttributeCenterX,
                                                         relatedBy: NSLayoutRelationEqual,
                                                         toItem: self.folderIcon,
                                                         attribute: NSLayoutAttributeCenterX,
                                                         multiplier: 1.0,
                                                         constant: 0.0))
    # verticalLine.width = 1
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[verticalLine(#{LINE_THICKNESS})]", options: 0, metrics: nil, views: views))
  end

  def drawLineToSubfolder(subfolder)
    subfolderLine = Rectangle.alloc.init
    self.addSubview(subfolderLine)

    views = { 'horizontalLine' => self.horizontalLine, 'subfolderLine' => subfolderLine, 'subfolder' => subfolder }
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[horizontalLine][subfolderLine(#{((FOLDER_SUBFOLDER_VERTICAL_SPACING - LINE_THICKNESS) / 2.0).ceil})][subfolder]",
                                                                       options: 0, metrics: nil, views: views))
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[subfolderLine(#{LINE_THICKNESS})]",
                                                                       options: 0, metrics: nil, views: views))

    self.addConstraint(NSLayoutConstraint.constraintWithItem(subfolderLine,
                                                         attribute: NSLayoutAttributeCenterX,
                                                         relatedBy: NSLayoutRelationEqual,
                                                         toItem: subfolder,
                                                         attribute: NSLayoutAttributeCenterX,
                                                         multiplier: 1.0,
                                                         constant: 0.0))
    # self.addConstraint(NSLayoutConstraint.constraintWithItem(subfolderLine,
    #                                                      attribute: NSLayoutAttributeTop,
    #                                                      relatedBy: NSLayoutRelationEqual,
    #                                                      toItem: self.horizontalLine,
    #                                                      attribute: NSLayoutAttributeCenterY,
    #                                                      multiplier: 1.0,
    #                                                      constant: 0.0))
    # self.addConstraint(NSLayoutConstraint.constraintWithItem(subfolderLine,
    #                                                      attribute: NSLayoutAttributeBottom,
    #                                                      relatedBy: NSLayoutRelationEqual,
    #                                                      toItem: subfolder,
    #                                                      attribute: NSLayoutAttributeTop,
    #                                                      multiplier: 1.0,
    #                                                      constant: 0.0))
    subfolderLine
  end

  def eraseLines
    self.horizontalLine.removeFromSuperview unless self.horizontalLine.nil?
    self.verticalLine.removeFromSuperview unless self.verticalLine.nil?
    self.subfolderLines.each { |subfolderLine| subfolderLine.removeFromSuperview } if self.subfolderLines.respond_to? :each
    self.horizontalLine = nil
    self.verticalLine = nil
    self.subfolderLines = []
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def setConstraints

    unless self.layoutConstraints.nil?
      self.removeConstraints(self.layoutConstraints)
      self.layoutConstraints = nil
    end

    if @subfolderView.isDescendantOf(self) && !@subfolderView.empty?
      self.setConstraintsWithSubfolderView
    else
      self.setConstraintsWithoutSubfolderView
    end
  end


  def setConstraintsWithSubfolderView
    views = { 'folderIcon' => @folderIcon, 'subfolderView' => @subfolderView }

    # Folder icon stuck to top.  Subfolder view stuck to folder icon.
    self.layoutConstraints =  NSLayoutConstraint.constraintsWithVisualFormat("V:|[folderIcon]-(#{FOLDER_SUBFOLDER_VERTICAL_SPACING})-[subfolderView]|",
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

  def setConstraintsWithoutSubfolderView
    views = { 'folderIcon' => @folderIcon}
    self.layoutConstraints =  NSLayoutConstraint.constraintsWithVisualFormat("V:|[folderIcon]|", options: 0, metrics: nil, views: views)
    self.layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[folderIcon]|", options: 0, metrics: nil, views: views)
    self.addConstraints(self.layoutConstraints)
  end

end
