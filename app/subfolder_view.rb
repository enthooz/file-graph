class SubfolderView < FlippedView

  attr_accessor :folders, :folderPath, :horizontalLine, :horizontalLineConstraints, :endConstraint

  def initWithPath(path)

    self.folderPath = path
    self.folders = []

    initWithFrame([ [0, 0], [0, 0] ])

    self.translatesAutoresizingMaskIntoConstraints = false

    # low priority constraint setting height to 0 to ensure height is no
    # larger than tallest subview
    constraint = NSLayoutConstraint.constraintWithItem(self,
                                                       attribute: NSLayoutAttributeHeight,
                                                       relatedBy: NSLayoutRelationEqual,
                                                       toItem: nil,
                                                       attribute: 0,
                                                       multiplier: 0,
                                                       constant: 0)
    constraint.priority = NSLayoutPriorityDefaultLow
    self.addConstraint(constraint)

    # self.wantsLayer = true
    # self.needsDisplay = true
    # self.backgroundColor = NSColorFromHex('#ff0000', 0.8)
    self
  end

  # def addFolder(folder)
  #   raise 'InvalidFolder' unless folder.is_a? Folder
  #   #folders << folder
  #   #folder.setFrameOrigin([(folders.count - 1) * (FolderIcon::WIDTH + 10), 10])
  #   #self.setFrameSize([folders.count * (FolderIcon::WIDTH + 10) - 10, FolderIcon::HEIGHT + 10])
  #   self.addSubview(folder)
  # end

  # #-------------------------------------------------------------
  # #
  # #-------------------------------------------------------------
  # def drawRect(dirtyRect)
  #   NSColorFromHex('#ff0000', 0.8).setFill
  #   NSColorFromHex('#cc3333', 1.0).setStroke
  #   NSBezierPath.fillRect(dirtyRect)
  #   NSBezierPath.strokeRect(dirtyRect)
  #   # NSColorFromHex('#666666', 0.8).setFill
  #   # NSFrameRect(dirtyRect)
  #   super
  # end

  def open
    # list subdirectories
    subfolder_paths = Dir[File.join(self.folderPath, '*/')]

    subfolder_paths.each do |subfolder_path|
      self.addSubview(Folder.alloc.initWithPath(subfolder_path))
    end

    #drawLine
  end

  def close
    #puts "SubfolderView#hide"
    #eraseLine
    while self.subviews.any? do
      self.subviews.last.removeFromSuperview
    end
    self.removeFromSuperview
    #self.removeConstraints(self.constraints)
  end

  # def show
  #   puts "SubfolderView#show"
  #   self.wantsLayer = true
  #   self.needsDisplay = true
  # end

  def addFolder(subfolder)
    self.folders << subfolder
    self.addSubview(subfolder)
  end

  def addSubview(subfolder)
    raise 'InvalidFolder' unless subfolder.is_a? Folder
    super

    subfolder.translatesAutoresizingMaskIntoConstraints = false
 
    # # maintain subfolder width
    # self.addConstraint(NSLayoutConstraint.constraintWithItem(subfolder,
    #                                                attribute: NSLayoutAttributeWidth,
    #                                                relatedBy: NSLayoutRelationGreaterThanOrEqual,
    #                                                   toItem: self,
    #                                                attribute: NSLayoutAttributeWidth,
    #                                               multiplier: 0,
    #                                                 constant: FolderIcon::WIDTH))

    # subfolderView.height >= subfolder.height
    self.addConstraint(NSLayoutConstraint.constraintWithItem(self,
                                                   attribute: NSLayoutAttributeHeight,
                                                   relatedBy: NSLayoutRelationGreaterThanOrEqual,
                                                      toItem: subfolder,
                                                   attribute: NSLayoutAttributeHeight,
                                                  multiplier: 1,
                                                    constant: 0))
      
    if (self.subviews.count == 1)
      # subfolder.left == subfolderView.left
      self.addConstraint(NSLayoutConstraint.constraintWithItem(subfolder,
                                                     attribute: NSLayoutAttributeLeft,
                                                     relatedBy: NSLayoutRelationEqual,
                                                        toItem: self,
                                                     attribute: NSLayoutAttributeLeft,
                                                    multiplier: 1.0,
                                                      constant: 0.0))
    else
      # subfolder.left == penultimateSubfolder.right + 10
      thePenultimateFolder = self.subviews[self.subviews.count - 2]
      self.addConstraint(NSLayoutConstraint.constraintWithItem(subfolder,
                                                     attribute: NSLayoutAttributeLeft,
                                                     relatedBy: NSLayoutRelationEqual,
                                                        toItem: thePenultimateFolder,
                                                     attribute: NSLayoutAttributeRight,
                                                    multiplier: 1.0,
                                                      constant: 10.0))
    end
    
    if (self.endConstraint != nil)
      self.removeConstraint(self.endConstraint)
      self.endConstraint = nil
    end

    # subfolder.right == subfolderView.right
    self.endConstraint = NSLayoutConstraint.constraintWithItem(self,
                                                     attribute: NSLayoutAttributeRight,
                                                     relatedBy: NSLayoutRelationEqual,
                                                        toItem: subfolder,
                                                     attribute: NSLayoutAttributeRight,
                                                    multiplier: 1.0,
                                                      constant: 0.0)
    self.addConstraint(self.endConstraint)
  end

  def removeSubviews
    while self.subviews.any? do
      self.subviews.last.removeFromSuperview
    end
  end

  # TODO: this breaks the ability to add subfolders after drawing line
  def drawLine
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
  
  # - (void)willRemoveSubview:(NSView *)subview;
  #   {
  #   const NSLayoutAttribute NSLayoutAttributeRight = self.orientation == NSLayoutConstraintOrientationHorizontal ? NSLayoutAttributeRight : NSLayoutAttributeBottom;
  #  
  #   if (self.endConstraint != nil)
  #     {
  #     [self removeConstraint:self.endConstraint];
  #     self.endConstraint = nil;
  #     }
  #  
  #   if (self.subviews.count > 1)
  #     {
  #     NSView *thePenultimateView = [self.subviews objectAtIndex:self.subviews.count - 2];  
  #  
  #     self.endConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:thePenultimateView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
  #     [self addConstraint:self.endConstraint];
  #     }
  #   }


end
