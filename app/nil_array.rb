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
  end
end
