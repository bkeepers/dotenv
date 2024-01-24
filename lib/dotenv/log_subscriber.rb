require "active_support/log_subscriber"

module Dotenv
  class LogSubscriber < ActiveSupport::LogSubscriber
    attach_to :dotenv

    def logger
      Dotenv::Rails.logger
    end

    def load(event)
      diff = event.payload[:diff]
      env = event.payload[:env]

      # Only show the keys that were added or changed
      changed = env.slice(*(diff.added.keys + diff.changed.keys)).keys.map { |key| color_var(key) }

      info "Set #{changed.to_sentence} from #{color_filename(env.filename)}" if changed.any?
    end

    def save(event)
      info "Saved a snapshot of #{color_env_constant}"
    end

    def restore(event)
      diff = event.payload[:diff]

      removed = diff.removed.keys.map { |key| color(key, :RED) }
      restored = (diff.changed.keys + diff.added.keys).map { |key| color_var(key) }

      if removed.any? || restored.any?
        info "Restored snapshot of #{color_env_constant}"
        debug "Unset #{removed.to_sentence}" if removed.any?
        debug "Restored #{restored.to_sentence}" if restored.any?
      end
    end

    private

    def color_filename(filename)
      color(Pathname.new(filename).relative_path_from(Dotenv::Rails.root.to_s).to_s, :YELLOW)
    end

    def color_var(name)
      color(name, :CYAN)
    end

    def color_env_constant
      color("ENV", :GREEN)
    end
  end
end
