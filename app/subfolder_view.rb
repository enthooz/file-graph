class SubfolderView < FlippedView

  attr_accessor :endConstraint

  def init
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

  def close
    puts "SubfolderView#hide"
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
      thePenultimateView = self.subviews[self.subviews.count - 2]
      self.addConstraint(NSLayoutConstraint.constraintWithItem(subfolder,
                                                     attribute: NSLayoutAttributeLeft,
                                                     relatedBy: NSLayoutRelationEqual,
                                                        toItem: thePenultimateView,
                                                     attribute: NSLayoutAttributeRight,
                                                    multiplier: 1.0,
                                                      constant: 0.0))
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
