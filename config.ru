require 'roda'
require 'tilt/opal'

Opal::Config.source_map_enabled = true # check RACK_ENV

builder = Opal::Builder.new(stubs: %w(opal)) # stops opal being reloaded 

builder.append_paths('assets/js', 'lib')
builder.use_gem('opal-jquery')

pwd = Dir.pwd
js_folder = "#{pwd}/assets/js"
lib_folder = "#{pwd}/lib"
client_folder = "#{lib_folder}/client"
shared_folder = "#{lib_folder}/shared"

dependencies = {
  "#{js_folder}/.main.rb" => Dir["#{client_folder}l**/*.rb"] + Dir["#{shared_folder}l**/*.rb"]
}

# puts "dependencies: #{dependencies}"

Roda.plugin(
  :assets,       
  dependencies: dependencies,
  js: %w'.main.rb',
  js_opts: {
    builder: builder
  }
)

Roda.route do |r|
  r.assets

  r.root do
    <<END
<!DOCTYPE html>
<html>
<head>
<title>Roda/Opal Integration Test</title>
<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="http://cdn.opalrb.org/opal/0.10.1/opal.min.js"></script>
#{assets(:js)}
</head>
<body>
 <h1>Roda/Opal Integration Test</h1>
 <ul id="foo">
 </ul>
</body>
</html>
END
  end
end

run Roda.app
