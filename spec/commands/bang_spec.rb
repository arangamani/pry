require_relative '../helper'

describe "!" do
  before do
    @t = pry_tester
  end

  it 'should correctly clear the input buffer ' do
    @t.push unindent(<<-STR)
      def hello
        puts :bing
    STR

    @t.process_command '!'
    @t.last_output.should =~ /Input buffer cleared!/
    @t.eval_string.should == ''
  end
end
