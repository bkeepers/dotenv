guard "bundler" do
  watch("Gemfile")
end

guard "rspec", :cmd => "bundle exec rspec" do
  watch(/^spec\/.+_spec\.rb$/)
  watch(/^spec\/spec_helper.rb$/) { "spec" }
  watch(/^lib\/(.+)\.rb$/)        { |m| "spec/#{m[1]}_spec.rb" }
end
