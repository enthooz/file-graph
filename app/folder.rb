class Folder < FlippedView

  FOLDER_TOP = 10
  #DEBUG_RECT = true
  FOLDER_SUBFOLDER_VERTICAL_SPACING = 20.0
  LINE_THICKNESS = 1.0

  attr_accessor :folderPath, :folderKey, :folderView # intialization arguments
  attr_accessor :is_open, :is_root # status booleans
  attr_accessor :folderName # derived
  attr_accessor :folderIcon, :subfolderView # subviews
  attr_accessor :layoutConstraints # constraints
  attr_accessor :verticalLine, :horizontalLine, :subfolderLines # lines to subfolders
  #attr_reader :layer

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------

  def initWithPath(path, key: key, folderView: folderView)

    init

    self.translatesAutoresizingMaskIntoConstraints = false

    self.is_open = false
    self.folderPath = File.expand_path(path)
    self.folderName = File.basename(self.folderPath)
    self.folderKey = key
    self.folderView = folderView

    drawFolderIcon
    #drawSubfolderView
    setConstraints

    self
  end

  def [](index)
    subfolders.fetch(index, NilArray)
  end

  def subfolders
    return NilArray if subfolderView.nil? || subfolderView.empty?
    subfolderView.folders
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
    @subfolderView = SubfolderView.alloc.init
    #self.addSubview(@subfolderView)
    self.folderView.addSubfolderView(@subfolderView, withKey: self.folderKey)
    self.folderView.addConstraint(NSLayoutConstraint.constraintWithItem(@subfolderView,
                                                   attribute: NSLayoutAttributeCenterX,
                                                   relatedBy: NSLayoutRelationEqual,
                                                      toItem: self.folderIcon,
                                                   attribute: NSLayoutAttributeCenterX,
                                                  multiplier: 1.0,
                                                    constant: 0.0))
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def eraseSubfolderView
    self.folderView.removeSubfolderViewAtKey(self.folderKey)
    @subfolderView = nil
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

    self.drawSubfolderView

    subfolderPaths = Dir[File.join(self.folderPath, '*/')]

    subfolderPaths.each_index do |index|
      subfolderPath = subfolderPaths[index]
      key = self.folderKey.dup << index 
      subfolder = Folder.alloc.initWithPath(subfolderPath, key: key, folderView: self.folderView)
      self.subfolderView.addSubview(subfolder)
    end

    setConstraints
    self.drawLines

  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def close
    self.is_open = false
    @subfolderView.close
    self.eraseLines
    self.eraseSubfolderView
    setConstraints
  end


  # TODO: this breaks the ability to add subfolders after drawing line
  def drawLines

    # Closed or no subfolders.
    return unless self.open? && self.subfolders.any?

    self.verticalLine = Rectangle.alloc.init
    self.folderView.addSubview(self.verticalLine)

    firstFolder = self.subfolderView.folders.first

    # Only one subfolder.
    if self.subfolderView.folders.count == 1

      views = { 'folderIcon'      => self.folderIcon,
                'verticalLine'    => self.verticalLine,
                'subfolder'       => firstFolder }

      self.folderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[folderIcon][verticalLine(#{FOLDER_SUBFOLDER_VERTICAL_SPACING})][subfolder]",
        options: 0, metrics: nil, views: views))

    # More than one subfolder.
    else

      lastFolder = self.subfolderView.folders.last

      self.horizontalLine = Rectangle.alloc.init
      self.folderView.addSubview(self.horizontalLine)

      views = { 'folderIcon'      => self.folderIcon,
                'verticalLine'    => self.verticalLine,
                'horizontalLine'  => self.horizontalLine }

      verticalLineHeight = ((FOLDER_SUBFOLDER_VERTICAL_SPACING - LINE_THICKNESS) / 2.0).floor
      self.folderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[folderIcon][verticalLine(#{verticalLineHeight})][horizontalLine(#{LINE_THICKNESS})]",
        options: 0, metrics: nil, views: views))

      # horizontalLine.left == firstFolder.centerX
      self.folderView.addConstraint(NSLayoutConstraint.constraintWithItem(self.horizontalLine,
                                                           attribute: NSLayoutAttributeLeft,
                                                           relatedBy: NSLayoutRelationEqual,
                                                           toItem: firstFolder,
                                                           attribute: NSLayoutAttributeCenterX,
                                                           multiplier: 1.0,
                                                           constant: 0.0))
      # horizontalLine.right == lastFolder.centerX
      self.folderView.addConstraint(NSLayoutConstraint.constraintWithItem(self.horizontalLine,
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
    self.folderView.addConstraint(NSLayoutConstraint.constraintWithItem(self.verticalLine,
                                                         attribute: NSLayoutAttributeCenterX,
                                                         relatedBy: NSLayoutRelationEqual,
                                                         toItem: self.folderIcon,
                                                         attribute: NSLayoutAttributeCenterX,
                                                         multiplier: 1.0,
                                                         constant: 0.0))
    # verticalLine.width = 1
    self.folderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[verticalLine(#{LINE_THICKNESS})]",
                                                                                  options: 0, metrics: nil, views: views))
  end

  def drawLineToSubfolder(subfolder)
    subfolderLine = Rectangle.alloc.init
    self.folderView.addSubview(subfolderLine)

    views = { 'horizontalLine' => self.horizontalLine, 'subfolderLine' => subfolderLine, 'subfolder' => subfolder }
    self.folderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:[horizontalLine][subfolderLine(#{((FOLDER_SUBFOLDER_VERTICAL_SPACING - LINE_THICKNESS) / 2.0).ceil})][subfolder]",
                                                                       options: 0, metrics: nil, views: views))
    self.folderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[subfolderLine(#{LINE_THICKNESS})]",
                                                                       options: 0, metrics: nil, views: views))

    self.folderView.addConstraint(NSLayoutConstraint.constraintWithItem(subfolderLine,
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

    if @subfolderView.respond_to?(:isDescendantOf) && @subfolderView.isDescendantOf(self) && !@subfolderView.empty?
      self.setConstraintsWithSubfolderView
    else
      self.setConstraintsWithoutSubfolderView
    end
  end


  def setConstraintsWithSubfolderView
    views = { 'folderIcon' => @folderIcon, 'subfolderView' => @subfolderView }

    # Folder icon stuck to top.  Subfolder view stuck to folder icon.
    self.layoutConstraints =  NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[folderIcon]-(#{FOLDER_SUBFOLDER_VERTICAL_SPACING})-[subfolderView]|",
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
    self.layoutConstraints =  NSLayoutConstraint.constraintsWithVisualFormat("V:|[folderIcon]|",
                                                                             options: 0, metrics: nil, views: views)
    self.layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[folderIcon]|",
                                                                             options: 0, metrics: nil, views: views)
    self.addConstraints(self.layoutConstraints)
  end

end
