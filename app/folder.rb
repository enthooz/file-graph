class Folder < FlippedView

  FOLDER_TOP = 10

  attr_accessor :is_open, :is_root, :folderPath, :folderName, :folderIcon, :subfolderView
  attr_accessor :layoutConstraints, :subfolderViewConstraints
  #attr_reader :layer

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def initWithPath(folder_path)

    initWithFrame([ [0, 0], [0, 0] ])

    self.translatesAutoresizingMaskIntoConstraints = false

    self.is_open = false
    self.folderPath = folder_path
    self.folderName = File.basename(self.folderPath)

    drawFolderIcon
    drawSubfolderView
    setConstraints
    #applyConstraints

    #self.setSizeConstraints

    # self.wantsLayer = true
    # self.needsDisplay = true
    # self.backgroundColor = NSColorFromHex('#999999', 1.0)
    # self.borderWidth = 1
    # self.borderColor = NSColorFromHex('#666666', 1.0)

    self
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def drawRect(dirtyRect)
    NSColorFromHex('#999999', 0.8).setFill
    NSColorFromHex('#666666', 1.0).setStroke
    NSBezierPath.fillRect(dirtyRect)
    NSBezierPath.strokeRect(dirtyRect)
    # NSColorFromHex('#666666', 0.8).setFill
    # NSFrameRect(dirtyRect)
    super
  end

  # def setSizeConstraints
  # #   views = { 'self' => self }
  # #   self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[self(#{FolderIcon::HEIGHT})]-|",
  # #                                                              options: 0,
  # #                                                              metrics: nil,
  # #                                                                views: views))
  # #   self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[self(#{FolderIcon::WIDTH})]-|",
  # #                                                              options: 0,
  # #                                                              metrics: nil,
  # #                                                                views: views))
  #   views = { 'self' => self }
  #   self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[folderIcon(#{FolderIcon::HEIGHT})]",
  #                                                              options: 0,
  #                                                              metrics: nil,
  #                                                                views: views))
  #   self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[folderIcon(#{FolderIcon::WIDTH})]",
  #                                                              options: 0,
  #                                                              metrics: nil,
  #                                                                views: views))
  # end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def mouseDown(event)
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def mouseUp(event)
    toggle if event.clickCount % 2 == 0
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
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def close
    self.is_open = false
    @subfolderView.close
    setConstraints
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def drawFolderIcon
    @folderIcon = FolderIcon.alloc.initWithName(self.folderName)
    self.addSubview(@folderIcon)
    #@folderIcon.setConstraints
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
  # def setConstraints
  #   
  #   views = { 'folderIcon' => @folderIcon, 'subfolderView' => @subfolderView }

  #   self.setLayoutConstraints
  #   #self.setSubfolderViewConstraints

  #   # TODO: prevent the following constraints from getting added multiple
  #   # times

  #   # Folder icon is at least as wide as specified.
  #   # constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[folderIcon(>=#{FolderIcon::WIDTH})]",
  #   #                                                               options: 0, metrics: nil, views: views)
  #   # constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=20)-[subfolderView]-(>=20)-|",
  #   #                                                               options: 0, metrics: nil, views: views)
  #   # constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:[subfolderView(>=#{FolderIcon::WIDTH})]",
  #   #                                                               options: 0, metrics: nil, views: views)


  #   # Folder icon is centered in folder view.
  #   constraints << NSLayoutConstraint.constraintWithItem(@folderIcon,
  #                                  attribute: NSLayoutAttributeCenterX,
  #                                  relatedBy: NSLayoutRelationEqual,
  #                                  toItem:    self,
  #                                  attribute: NSLayoutAttributeCenterX,
  #                                  multiplier: 1, constant: 0)

  #   self.addConstraints(constraints)

  # end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def setConstraints
    puts "Folder#setLayoutConstraints"
    views = { 'folderIcon' => @folderIcon, 'subfolderView' => @subfolderView }

    unless self.layoutConstraints.nil?
      self.removeConstraints(self.layoutConstraints)
      self.layoutConstraints = nil
    end

    if @subfolderView.isDescendantOf(self)
      # Folder icon stuck to top.  Subfolder view stuck to folder icon.
      self.layoutConstraints =  NSLayoutConstraint.constraintsWithVisualFormat("V:|-[folderIcon][subfolderView]|",
                                                                                      options: 0, metrics: nil, views: views)
      self.layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[subfolderView(>=folderIcon)]|",
                                                                                      options: 0, metrics: nil, views: views)
      self.layoutConstraints << NSLayoutConstraint.constraintWithItem(@folderIcon,
                                     attribute: NSLayoutAttributeCenterX,
                                     relatedBy: NSLayoutRelationEqual,
                                     toItem:    @subfolderView,
                                     attribute: NSLayoutAttributeCenterX,
                                     multiplier: 1, constant: 0)
      self.layoutConstraints << NSLayoutConstraint.constraintWithItem(@folderIcon,
                                     attribute: NSLayoutAttributeCenterX,
                                     relatedBy: NSLayoutRelationEqual,
                                     toItem:    @subfolderView,
                                     attribute: NSLayoutAttributeCenterX,
                                     multiplier: 1, constant: 0)
    else
      # Folder icon stuck to top.
      self.layoutConstraints =  NSLayoutConstraint.constraintsWithVisualFormat("V:|-[folderIcon]|",
                                                                                      options: 0, metrics: nil, views: views)
      self.layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[folderIcon]|",
                                                                                      options: 0, metrics: nil, views: views)
    end
    self.addConstraints(self.layoutConstraints)
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  # def setSubfolderViewConstraints
  #   unless self.subfolderViewConstraints.nil?
  #     self.removeConstraints(self.subfolderViewConstraints)
  #     self.subfolderViewConstraints = nil
  #   end
  #   if @subfolderView.isDescendantOf(self)
  #     self.subfolderViewConstraints = []
  #     self.subfolderViewConstraints << NSLayoutConstraint.constraintWithItem(@subfolderView,
  #                                                                  attribute: NSLayoutAttributeCenterX,
  #                                                                  relatedBy: NSLayoutRelationEqual,
  #                                                                  toItem:    self,
  #                                                                  attribute: NSLayoutAttributeCenterX,
  #                                                                  multiplier: 1, constant: 0)

  #     self.subfolderViewConstraints << NSLayoutConstraint.constraintWithItem(self,
  #                                                                  attribute: NSLayoutAttributeWidth,
  #                                                                  relatedBy: NSLayoutRelationGreaterThanOrEqual,
  #                                                                  toItem:    @subfolderView,
  #                                                                  attribute: NSLayoutAttributeWidth,
  #                                                                  multiplier: 1, constant: 0)

  #     self.addConstraints(self.subfolderViewConstraints)
  #   end
  # end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  # def applyConstraints
  #   self.translatesAutoresizingMaskIntoConstraints = false
  #   puts "constraints"
  #   puts self.constraints
  #   puts "END constraints"
  #   self.removeConstraints(self.constraints) if self.constraints.any?
  #   self.addConstraints(initializeConstraints)
  # end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  # def initializeConstraints
  #   views = { 'folderIcon' => @folderIcon, 'subfolderView' => @subfolderView }
  #   if @subfolderView.isDescendantOf(self)
  #     c = [
  #       NSLayoutConstraint.constraintsWithVisualFormat("V:|-[folderIcon]-[subfolderView]-|",
  #                                              options: 0,
  #                                              metrics: nil,
  #                                                views: views),
  #       NSLayoutConstraint.constraintsWithVisualFormat("H:|-[subfolderView]-|",
  #                                              options: 0,
  #                                              metrics: nil,
  #                                                views: views)
  #     ].flatten
  #   else
  #     c = [
  #       NSLayoutConstraint.constraintsWithVisualFormat("V:|-[folderIcon]-|",
  #                                              options: 0,
  #                                              metrics: nil,
  #                                                views: views)
  #     ].flatten
  #   end
  #   puts "resultant constraints: #{c.count}"
  #   c.each do |constraint|
  #     puts "CONSTRAINT:"
  #         #multiplier
  #         #constant
  #     %w( firstItem
  #         firstAttribute
  #         relation
  #         secondItem
  #         secondAttribute
  #         identifier ).each do |attr|
  #       puts " |-#{attr}: #{constraint.send(attr)}"
  #     end
  #     puts ""
  #   end
  #   c
  # end

end
