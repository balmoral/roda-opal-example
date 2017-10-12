require 'client/models/foo'

Document.ready? do
  7.times do |i|
    Element['#foo'] << "<li>#{Foo.new.foo} #{i}</li>"
    # `debugger;` if i == 10      
  end
end

