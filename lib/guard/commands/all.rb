# required for async_queue_add
require "guard"

module Guard
  module Commands
    class All
      def self.import
        Pry::Commands.create_command "all" do
          group "Guard"
          description "Run all plugins."

          banner <<-BANNER
          Usage: all <scope>

          Run the Guard plugin `run_all` action.

          You may want to specify an optional scope to the action,
          either the name of a Guard plugin or a plugin group.
          BANNER

          def process(*entries)
            scopes, unknown = ::Guard::Interactor.convert_scope(entries)

            unless unknown.empty?
              output.puts "Unknown scopes: #{ unknown.join(", ") }"
              return
            end

            ::Guard.async_queue_add([:guard_run_all, scopes])
          end
        end
      end
    end
  end
end

Guard::Commands::All.import
