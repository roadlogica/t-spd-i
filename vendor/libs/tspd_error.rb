module TSPDError

  #usage:
  #raise TranslatableError,[translation_key,message]
  class TranslatableError < StandardError
    attr_accessor :translation_key
    def initialize(arr)
      self.translation_key = arr[0]
      super arr[1]
    end
  end

  class OperationError < TranslatableError
  end

end