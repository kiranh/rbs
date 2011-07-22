module ActiveRecord
  # = Active Record Identity Map
  #
  # Ensures that each object gets loaded only once by keeping every loaded
  # object in a map. Looks up objects using the map when referring to them.
  #
  # More information on Identity Map pattern:
  #   http://www.martinfowler.com/eaaCatalog/identityMap.html
  #
  # == Configuration
  #
  # In order to enable IdentityMap, set <tt>config.active_record.identity_map = true</tt>
  # in your <tt>config/application.rb</tt> file.
  #
  # IdentityMap is disabled by default.
  #
  module IdentityMap
    extend ActiveSupport::Concern

    class << self
      def enabled=(flag)
        Thread.current[:identity_map_enabled] = flag
      end

      def enabled
        Thread.current[:identity_map_enabled]
      end
      alias enabled? enabled

      def repository
        Thread.current[:identity_map] ||= Hash.new { |h,k| h[k] = {} }
      end

      def use
        old, self.enabled = enabled, true

        yield if block_given?
      ensure
        self.enabled = old
        clear
      end

      def without
        old, self.enabled = enabled, false

        yield if block_given?
      ensure
        self.enabled = old
      end

      def get(klass, primary_key)
        record = repository[klass.symbolized_base_class][primary_key]

        if record.is_a?(klass)
          ActiveSupport::Notifications.instrument("identity.active_record",
            :line => "From Identity Map (id: #{primary_key})", 
            :name => "#{klass} Loaded",
            :connection_id => object_id)

          record
        else
          nil
        end
      end

      def add(record)
        repository[record.class.symbolized_base_class][record.id] = record
      end

      def remove(record)
        repository[record.class.symbolized_base_class].delete(record.id)
      end

      def remove_by_id(symbolized_base_class, id)
        repository[symbolized_base_class].delete(id)
      end

      def clear
        repository.clear
      end
    end

    # Reinitialize an Identity Map model object from +coder+.
    # +coder+ must contain the attributes necessary for initializing an empty
    # model object.
    def reinit_with(coder)
      @attributes_cache = {}
      dirty = @changed_attributes.keys
      @attributes.update(coder['attributes'].except(*dirty))
      @changed_attributes.update(coder['attributes'].slice(*dirty))
      @changed_attributes.delete_if{|k,v| v.eql? @attributes[k]}

      set_serialized_attributes

      run_callbacks :find

      self
    end

    class Middleware
      class Body #:nodoc:
        def initialize(target, original)
          @target   = target
          @original = original
        end

        def each(&block)
          @target.each(&block)
        end

        def close
          @target.close if @target.respond_to?(:close)
        ensure
          IdentityMap.enabled = @original
          IdentityMap.clear
        end
      end

      def initialize(app)
        @app = app
      end

      def call(env)
        enabled = IdentityMap.enabled
        IdentityMap.enabled = true
        status, headers, body = @app.call(env)
        [status, headers, Body.new(body, enabled)]
      end
    end
  end
end
