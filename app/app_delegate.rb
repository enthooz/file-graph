class AppDelegate

  DEBUG = false

  def applicationDidFinishLaunching(notification)

    # DEBUG
    # NSUserDefaults.standardUserDefaults.setBool(true,
    #   forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")

    buildMenu
    buildWindow
    buildScrollView
    buildMainView
    buildRootFolder

    if DEBUG
      puts "\n\n\n"
      puts "AMBIGUITY TEST"
      puts "=============="
      @scrollView.testAmbiguity
      puts "=============="
      puts "\n\n\n"

      @mainWindow.visualizeConstraints(@scrollView.constraints)
    end
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
    @scrollView = NSScrollView.alloc.init

    @scrollView.translatesAutoresizingMaskIntoConstraints = false
    #@scrollView.autoresizingMask = NSViewHeightSizable | NSViewWidthSizable

    @scrollView.backgroundColor = NSColorFromHex('#cccccc')

    # @scrollView.wantsLayer = true
    # @scrollView.needsDisplay = true
    @scrollView.hasVerticalScroller = true
    @scrollView.hasHorizontalScroller = true
    @scrollView.scrollerStyle = NSScrollerStyleOverlay
    @mainWindow.setContentView(@scrollView)
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def buildMainView
    @mainView = FlippedView.alloc.init

    @mainView.translatesAutoresizingMaskIntoConstraints = false
    @mainView.backgroundColor = NSColorFromHex('#99ccff')
    @scrollView.documentView = @mainView


    views = { 'mainView' => @mainView, 'scrollView' => @scrollView.contentView }
    constraints = []

    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:[mainView(>=scrollView)]", options: 0, metrics: nil, views: views)
    @scrollView.addConstraint(NSLayoutConstraint.constraintWithItem(@mainView,
                                                                   attribute: NSLayoutAttributeWidth,
                                                                   relatedBy: NSLayoutRelationGreaterThanOrEqual,
                                                                   toItem: @scrollView.contentView,
                                                                   attribute: NSLayoutAttributeWidth,
                                                                   multiplier: 1.0,
                                                                   constant: -1.0)) # avoid pixel wiggle caused by rounding

    @scrollView.addConstraints(constraints)
  end

  #-------------------------------------------------------------
  #
  #-------------------------------------------------------------
  def buildRootFolder

    @rootFolder = Folder.alloc.initWithPath('/Users/aashbacher/Documents/')
    @mainView.addSubview(@rootFolder)

    # Define constraints
    views = { 'mainView' => @mainView, 'rootFolder' => @rootFolder }

    @mainView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[rootFolder]-(>=20)-|", options: 0, metrics: nil, views: views))

    # mainView.width >= rootFolder.width + 40
    @mainView.addConstraint(NSLayoutConstraint.constraintWithItem(@mainView,
                                                                   attribute: NSLayoutAttributeWidth,
                                                                   relatedBy: NSLayoutRelationGreaterThanOrEqual,
                                                                   toItem: @rootFolder,
                                                                   attribute: NSLayoutAttributeWidth,
                                                                   multiplier: 1.0,
                                                                   constant: 40))

    # rootFolder.centerX == mainView.centerX
    @mainView.addConstraint(NSLayoutConstraint.constraintWithItem(@rootFolder, 
                                                   attribute: NSLayoutAttributeCenterX,
                                                   relatedBy: NSLayoutRelationEqual,
                                                      toItem: @mainView,
                                                   attribute: NSLayoutAttributeCenterX,
                                                  multiplier: 1.0,
                                                    constant: 0.0))

  end

end
