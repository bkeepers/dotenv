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
            env_template.puts template_line(line)
          end
        end
      end
    end

    def template_line(line)
      var, value = line.split("=")
      template = var.delete_prefix "export "
      is_a_comment = var.strip[0].eql?("#")
      value.nil? || is_a_comment ? line : "#{var}=#{template}"
    end
  end
end
