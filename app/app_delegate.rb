class AppDelegate

  def applicationDidFinishLaunching(notification)

    # DEBUG
    # NSUserDefaults.standardUserDefaults.setBool(true,
    #   forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")

    buildMenu
    buildWindow
    buildScrollView
    buildMainView
    buildRootFolder

    # puts "scrollView constraints: #{@scrollView.constraints.count}"
    # puts "scrollView.contentView constraints: #{@scrollView.contentView.constraints.count}"
    # puts "rootFolder constraints: #{@rootFolder.constraints.count}"

    puts "\n\n\n"
    puts "AMBIGUITY TEST"
    puts "=============="
    @scrollView.testAmbiguity
    puts "=============="
    puts "\n\n\n"

    # puts @scrollView._subtreeDescription

    # puts "\n\n\n"

    # puts @mainView.constraintsAffectingLayoutForOrientation(0)
    # puts "\n\n\n"
    # puts @mainView.constraintsAffectingLayoutForOrientation(1)

    # puts "\n\n\n"

    #@rootFolder.open

    # DEBUG
    @mainWindow.visualizeConstraints(@scrollView.constraints)
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false) # true?
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']

    @mainWindow.orderFrontRegardless
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def buildScrollView
    @scrollView = NSScrollView.alloc.initWithFrame(@mainWindow.contentView.bounds)

    @scrollView.translatesAutoresizingMaskIntoConstraints = true
    @scrollView.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable

    @scrollView.backgroundColor = NSColorFromHex('#cccccc')

    # @scrollView.wantsLayer = true
    # @scrollView.needsDisplay = true
    @scrollView.hasVerticalScroller = true
    @scrollView.hasHorizontalScroller = true
    @scrollView.scrollerStyle = NSScrollerStyleOverlay
    @mainWindow.setContentView(@scrollView)

    #views = { 'scrollView' => @scrollView, 'mainWindow' => @mainWindow }
    # TODO: this seems to be assigning constraints on a view against itself
    ## @mainWindow.contentView.tap do |view|
    ##   view.addConstraint(NSLayoutConstraint.constraintWithItem(@scrollView, 
    ##                                                  attribute: NSLayoutAttributeCenterX,
    ##                                                  relatedBy: NSLayoutRelationEqual,
    ##                                                     toItem: view,
    ##                                                  attribute: NSLayoutAttributeCenterX,
    ##                                                 multiplier: 1.0,
    ##                                                   constant: 0.0))
    ##   view.addConstraint(NSLayoutConstraint.constraintWithItem(@scrollView, 
    ##                                                  attribute: NSLayoutAttributeCenterY,
    ##                                                  relatedBy: NSLayoutRelationEqual,
    ##                                                     toItem: view,
    ##                                                  attribute: NSLayoutAttributeCenterY,
    ##                                                 multiplier: 1.0,
    ##                                                   constant: 0.0))
    ##   view.addConstraint(NSLayoutConstraint.constraintWithItem(@scrollView, 
    ##                                                  attribute: NSLayoutAttributeWidth,
    ##                                                  relatedBy: NSLayoutRelationEqual,
    ##                                                     toItem: view,
    ##                                                  attribute: NSLayoutAttributeWidth,
    ##                                                 multiplier: 1.0,
    ##                                                   constant: 0.0))
    ##   view.addConstraint(NSLayoutConstraint.constraintWithItem(@scrollView, 
    ##                                                  attribute: NSLayoutAttributeHeight,
    ##                                                  relatedBy: NSLayoutRelationEqual,
    ##                                                     toItem: view,
    ##                                                  attribute: NSLayoutAttributeHeight,
    ##                                                 multiplier: 1.0,
    ##                                                   constant: 0.0))
    ## end
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def buildMainView
    @mainView = FlippedView.alloc.initWithFrame(@scrollView.contentView.bounds)

    @mainView.translatesAutoresizingMaskIntoConstraints = false
    @mainView.backgroundColor = NSColorFromHex('#99ccff')
    @scrollView.documentView = @mainView

    views = { 'mainView' => @mainView }
    constraints = []

    constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[mainView]|", options: 0, metrics: nil, views: views)
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[mainView]|", options: 0, metrics: nil, views: views)

    @scrollView.addConstraints(constraints)
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def buildRootFolder

    @rootFolder = Folder.alloc.initWithPath('/Users/aashbacher/Documents/')

    @mainView.addSubview(@rootFolder)

    views = { 'rootFolder' => @rootFolder }

    @mainView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[rootFolder]-(>=20)-|", options: 0, metrics: nil, views: views))

    @mainView.addConstraint(NSLayoutConstraint.constraintWithItem(@rootFolder, 
                                                   attribute: NSLayoutAttributeCenterX,
                                                   relatedBy: NSLayoutRelationEqual,
                                                      toItem: @mainView,
                                                   attribute: NSLayoutAttributeCenterX,
                                                  multiplier: 1.0,
                                                    constant: 0.0))

  end

end
