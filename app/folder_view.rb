class FolderView < FlippedView

  attr_accessor :rootFolder, :subfolderViews, :subfolderLayerConstraints

  def initWithPath(path)
    init
    self.subfolderViews = {}
    self.subfolderLayerConstraints = {}
    self.rootFolder = Folder.alloc.initWithPath(path, key: [0], folderView: self)
    self.addSubview(self.rootFolder)
    setConstraints
  end

  def folders
    [ rootFolder ]
  end

  # def subfolderViews
  #   rootFolder.open? ? [rootFolder.subfolderView] : NilArray
  # end

  def addSubfolderView(subfolderView, withKey: folderKey)

    # store reference in subfolderViews hash
    layer = folderKey.length - 1
    self.subfolderViews[layer] ||= {}
    self.subfolderViews[layer][folderKey] = subfolderView

    # determine the parent
    parent = self.rootFolder
    if layer > 0
      parentLevel = layer - 1
      parentKey = folderKey.dup
      parentKey.pop
      parent = self.subfolderViews[parentLevel][parentKey]
    end

    # add view
    self.addSubview(subfolderView)

    # add vertical constraint against parent
    views = { 'parent' => parent, 'subfolderView' => subfolderView }
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[parent]-(20)-[subfolderView]",
                                                                       options: 0, metrics: nil, views: views))

    setConstraintsForSubfolderViewLayer(layer)
  end

  def removeSubfolderViewAtKey(folderKey)
    # store reference in subfolderViews hash
    layer = folderKey.length - 1
    self.subfolderViews[layer] ||= {}
    subfolderView = self.subfolderViews[layer].delete(folderKey)

    subfolderView.removeFromSuperview unless subfolderView.nil?
    setConstraintsForSubfolderViewLayer(layer)
  end

  def setConstraints
    # Define constraints
    views = { 'rootFolder' => self.rootFolder }

    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[rootFolder]",
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

  def setConstraintsForSubfolderViewLayer(layer)

    self.removeConstraints(self.subfolderLayerConstraints[layer]) unless self.subfolderLayerConstraints[layer].nil?

    return if self.subfolderViews[layer].empty?

    subfolderViewKeys = self.subfolderViews[layer].keys.sort

    views = {}
    visualFormat = "H:|-(>=20)"
    abc = ('a'..'z').to_a
      
    subfolderViewKeys.each do |key|
      subfolderView = self.subfolderViews[layer][key]
      viewKey = abc.shuffle[0,8].join
      views[viewKey] = subfolderView
      visualFormat += "-[#{viewKey}]"
    end

    visualFormat += "-(>=20)-|"
    self.subfolderLayerConstraints[layer] = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
                                                                                           options: 0, metrics: nil, views: views)
    self.addConstraints(self.subfolderLayerConstraints[layer])
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
