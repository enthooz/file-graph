#-------------------------------------------------------------
#
#-------------------------------------------------------------
def CGColorCreateHex(hex, alpha = 1.0)
  # yolo
  CGColorCreateGenericRGB(*hex.scan(/[a-f0-9]{2}/i).map do |hex|
    hex.to_i(16) / 255.0
  end, alpha)
end

#-------------------------------------------------------------
#
#-------------------------------------------------------------
def NSColorFromHex(hex, alpha = 1.0)
  r, g, b = hex.scan(/[a-f0-9]{2}/i).map do |hex|
    hex.to_i(16) / 255.0
  end
  NSColor.colorWithSRGBRed(r, green: g, blue: b, alpha: alpha)
end

class NSView
  def allConstraints
    constraints = self.constraints
    self.subviews.each { |view| constraints += view.allConstraints }
    constraints
  end

  def testAmbiguity
    NSLog("<%@:0x%0x>: %@",
        self.class.description, self,
        self.hasAmbiguousLayout ? "Ambiguous" : "Unambiguous")

    self.subviews.each { |view| view.testAmbiguity }
  end
end

#-------------------------------------------------------------
#
#-------------------------------------------------------------
class NSLayoutConstraint

  RELATIONS = { -1 => '<=',
                 0 => '==',
                 1 => '>=' }

  ATTRIBUTES = {  0 => '(none)',
                  1 => 'left',
                  2 => 'right',
                  3 => 'top',
                  4 => 'bottom',
                  5 => 'leading',
                  6 => 'trailing',
                  7 => 'width',
                  8 => 'height',
                  9 => 'centerX',
                 10 => 'centerY',
                 11 => 'baseline' }

  def to_s
    "%s.%s %s %s * %s.%s + %s" % [
      firstItem,
      firstAttributeToString,
      relationToString,
      multiplier,
      secondItem,
      secondAttributeToString,
      constant
    ]
  end

  def relationToString
    RELATIONS[relation]
  end

  def firstAttributeToString
    ATTRIBUTES[firstAttribute]
  end

  def secondAttributeToString
    ATTRIBUTES[secondAttribute]
  end
end

module RectToString
  def to_s
    "[ [ %s, %s ], [ %s, %s ] ]" % [ self.origin.x, self.origin.y, self.size.width, self.size.height ]
  end
end

class NSRect
  include RectToString
end
class CGRect
  include RectToString
end
