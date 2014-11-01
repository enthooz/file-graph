class SubfolderView < FlippedView

  FOLDER_SPACING = 10.0

  attr_accessor :folderPath, :horizontalLine, :horizontalLineConstraints, :endConstraint

  alias_method :folders, :subviews

  def initWithPath(path)

    self.folderPath = path

    init

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

    self
  end

  def open
    # list subdirectories
    subfolder_paths = Dir[File.join(self.folderPath, '*/')]

    subfolder_paths.each do |subfolder_path|
      self.addSubview(Folder.alloc.initWithPath(subfolder_path))
    end

    #drawLine
  end

  def close
    #eraseLine
    while self.subviews.any? do
      self.subviews.last.removeFromSuperview
    end
    self.removeFromSuperview
    #self.removeConstraints(self.constraints)
  end

  def empty?
    !self.subviews.any?
  end

  def addSubview(subfolder)
    raise 'InvalidFolder' unless subfolder.is_a? Folder
    super

    subfolder.translatesAutoresizingMaskIntoConstraints = false
 
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
                                                      constant: FOLDER_SPACING))
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
