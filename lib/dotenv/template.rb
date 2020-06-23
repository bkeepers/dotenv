module Dotenv
  # Class for creating a template from a env file
  class EnvTemplate
    def initialize(env_file)
      @env_file = env_file
    end

    def create_template
      File.open(@env_file, "r") do |env_file|
        File.open("#{@env_file}.template", "w") do |env_template|
          env_file.each do |line|
            var, value = line.split("=")
            is_a_comment = var.strip[0].eql?("#")
            line_transform = value.nil? || is_a_comment ? line : "#{var}=#{var}"
            env_template.puts line_transform
          end
        end
      end
    end
  end
end
