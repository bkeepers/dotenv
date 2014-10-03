Dotenv.load Rails.root.join('.env')

Spring.watch Rails.root.join('.env') if defined?(Spring)
