class FolderView < FlippedView

  attr_accessor :rootFolder

  def addRootFolder(folder)
    raise 'InvalidFolder' unless folder.is_a? Folder
    self.rootFolder = folder
    addSubview(folder)
    setConstraints
  end

  def setConstraints
    # Define constraints
    views = { 'rootFolder' => self.rootFolder }

    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[rootFolder]-(>=20)-|",
                                                                       options: 0, metrics: nil, views: views))

    # mainView.width >= rootFolder.width + 40
    self.addConstraint(NSLayoutConstraint.constraintWithItem(self,
                                                   attribute: NSLayoutAttributeWidth,
                                                   relatedBy: NSLayoutRelationGreaterThanOrEqual,
                                                      toItem: self.rootFolder,
                                                   attribute: NSLayoutAttributeWidth,
                                                  multiplier: 1.0,
                                                    constant: 40))

    # rootFolder.centerX == mainView.centerX
    self.addConstraint(NSLayoutConstraint.constraintWithItem(self.rootFolder, 
                                                   attribute: NSLayoutAttributeCenterX,
                                                   relatedBy: NSLayoutRelationEqual,
                                                      toItem: self,
                                                   attribute: NSLayoutAttributeCenterX,
                                                  multiplier: 1.0,
                                                    constant: 0.0))
  end

  def mouseUp(event)
    puts "FolderView#mouseUp"
    puts "rootFolder[0]: #{rootFolder[0]}"
    puts "rootFolder[1]: #{rootFolder[0]}"
    puts "rootFolder[0][0]: #{rootFolder[0][0]}"
    puts "rootFolder[3][1]: #{rootFolder[3][1]}"
    puts "rootFolder[4][2][1][0]: #{rootFolder[4][2][1][0]}"
  end

end
