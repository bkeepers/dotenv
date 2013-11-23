module Dotenv
  module EnvironmentExtensions

    module IterpolatedShellCommands

      INTERPOLATED_SHELL_COMMAND = /
        (?<backslash>\\)?
        \$
        (?<cmd>             # collect command content for eval
          \(                # require opening paren
          ([^()]|\g<cmd>)+  # allow any number of non-parens, or balanced parens (by nesting the <cmd> expression recursively)
          \)                # require closing paren
        )
      /x

      def process_interpolated_shell_commands(value)
        # Process interpolated shell commands
        value.gsub(INTERPOLATED_SHELL_COMMAND) do |*|
          command = $~[:cmd][1..-2] # Eliminate opening and closing parentheses

          if $~[:backslash]
            $~[0][1..-1]
          else
            `#{command}`.chomp
          end
        end
      end

    end

  end
end