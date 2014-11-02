class FolderView < FlippedView

  attr_accessor :rootFolder

  def initWithPath(path)
    init
    self.rootFolder = Folder.alloc.initWithPath(path, key: [0], folderView: self)
    self.addSubview(self.rootFolder)
    setConstraints
  end

  def folders
    [ rootFolder ]
  end

  def addSubfolderView(subfolderView, withKey: folderKey)
    #rootFolder.open? ? [rootFolder.subfolderView] : NilArray
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

    puts "rootFolder: #{rootFolder}"
    puts "folders[0]: #{folders[0]}"

    puts "rootFolder[0]: #{rootFolder[0]}"
    puts "folders[0][0]: #{folders[0][0]}"

    puts "rootFolder[1]: #{rootFolder[1]}"
    puts "folders[0][1]: #{folders[0][1]}"

    puts "rootFolder[0][0]: #{rootFolder[0][0]}"
    puts "folders[0][0][0]: #{folders[0][0][0]}"

    puts "rootFolder[3][1]: #{rootFolder[3][1]}"
    puts "folders[0][3][1]: #{folders[0][3][1]}"

    puts "rootFolder[4][2][1][0]: #{rootFolder[4][2][1][0]}"
    puts "folders[0][4][2][1][0]: #{folders[0][4][2][1][0]}"

    # puts "subfolderViews[0]: #{subfolderViews[0]}"
    # puts "subfolderViews[0][0]: #{subfolderViews[0][0]}"
    # puts "subfolderViews[0][1]: #{subfolderViews[0][1]}"
  end

end
