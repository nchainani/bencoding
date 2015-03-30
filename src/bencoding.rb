class Bencoding
  def self.decode(input)
    scanner = StringScanner.new(input)
    parse(scanner)
  end

  def self.parse(scanner)
    case (nxt = scanner.next)
    when "i"
      number = ""
      while (val = scanner.next) != "e"
        number << val
      end
      number.to_i
    when /\d/ # can't take more than one, extend StringScanner
      if scanner.next == ":"
        string = scanner.next(nxt.to_i)
        string
      else
        "invalid format"
      end
    when "l"
      list = []
      while scanner.peek != "e"
        list << parse(scanner)
      end
      scanner.next
      list
    when "d"
      hash = {}
      while scanner.peek != "e"
        hash[parse(scanner)] = parse(scanner)
      end
      scanner.next
      hash
    end
  end

  class StringScanner
    def initialize(string)
      @str = string
      @index = 0
    end
    def next(n = 1)
      val = @str[@index,n]
      @index += n
      val
    end
    def peek(n = 1)
      @str[@index,n]
    end
  end
end