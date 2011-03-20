Code.require "os"

module Runner
  def process([])
    process ["test"]
  end

  def process(["setup"])
    execute "git submodule update --init"
    execute "cd deps/mochiweb && make"
    execute "cd deps/ibrowse && make"
  end

  def process(["test"])
    execute "exunit test/*_test.ex test/*/*_test.ex"
  end

  def process(other)
    IO.new('standard_error).puts "Unknown command: #{other}"
    self.exit(1)
  end

  private
  
  def execute command
    IO.puts command
    result = OS.cmd command
    IO.puts result
  end
end

Runner.process(Code.argv)