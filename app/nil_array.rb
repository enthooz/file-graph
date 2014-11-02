class NilArray
  class << self
    def [](index)
      self
    end
    def to_s
      ''
    end
    def nil?
      true
    end
    def fetch(index, default)
      self
    end
    def empty?
      true
    end
    def any?
      false
    end
  end
end
