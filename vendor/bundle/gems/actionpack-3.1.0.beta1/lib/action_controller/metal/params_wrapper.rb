require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/array/wrap'
require 'action_dispatch/http/mime_types'

module ActionController
  # Wraps parameters hash into nested hash. This will allow client to submit
  # POST request without having to specify a root element in it.
  #
  # By default this functionality won't be enabled. You can enable
  # it globally by setting +ActionController::Base.wrap_parameters+:
  #
  #     ActionController::Base.wrap_parameters = [:json]
  #
  # You could also turn it on per controller by setting the format array to
  # non-empty array:
  #
  #     class UsersController < ApplicationController
  #       wrap_parameters :format => [:json, :xml]
  #     end
  #
  # If you enable +ParamsWrapper+ for +:json+ format. Instead of having to
  # send JSON parameters like this:
  #
  #     {"user": {"name": "Konata"}}
  #
  # You can now just send a parameters like this:
  #
  #     {"name": "Konata"}
  #
  # And it will be wrapped into a nested hash with the key name matching
  # controller's name. For example, if you're posting to +UsersController+,
  # your new +params+ hash will look like this:
  #
  #     {"name" => "Konata", "user" => {"name" => "Konata"}}
  #
  # You can also specify the key in which the parameters should be wrapped to,
  # and also the list of attributes it should wrap by using either +:only+ or
  # +:except+ options like this:
  #
  #     class UsersController < ApplicationController
  #       wrap_parameters :person, :only => [:username, :password]
  #     end
  #
  # If you're going to pass the parameters to an +ActiveModel+ object (such as
  # +User.new(params[:user])+), you might consider passing the model class to
  # the method instead. The +ParamsWrapper+ will actually try to determine the
  # list of attribute names from the model and only wrap those attributes:
  #
  #     class UsersController < ApplicationController
  #       wrap_parameters Person
  #     end
  #
  # You still could pass +:only+ and +:except+ to set the list of attributes
  # you want to wrap.
  #
  # By default, if you don't specify the key in which the parameters would be
  # wrapped to, +ParamsWrapper+ will actually try to determine if there's
  # a model related to it or not. This controller, for example:
  #
  #     class Admin::UsersController < ApplicationController
  #     end
  #
  # will try to check if +Admin::User+ or +User+ model exists, and use it to
  # determine the wrapper key respectively. If both of the model doesn't exists,
  # it will then fallback to use +user+ as the key.
  module ParamsWrapper
    extend ActiveSupport::Concern

    EXCLUDE_PARAMETERS = %w(authenticity_token _method utf8)

    included do
      class_attribute :_wrapper_options
      self._wrapper_options = {:format => []}
    end

    module ClassMethods
      # Sets the name of the wrapper key, or the model which +ParamsWrapper+
      # would use to determine the attribute names from.
      #
      # ==== Examples
      #   wrap_parameters :format => :xml
      #     # enables the parmeter wrapper for XML format
      #
      #   wrap_parameters :person
      #     # wraps parameters into +params[:person]+ hash
      #
      #   wrap_parameters Person
      #     # wraps parameters by determine the wrapper key from Person class
      #     (+person+, in this case) and the list of attribute names
      #
      #   wrap_parameters :only => [:username, :title]
      #     # wraps only +:username+ and +:title+ attributes from parameters.
      #
      #   wrap_parameters false
      #     # disable parameters wrapping for this controller altogether.
      #
      # ==== Options
      # * <tt>:format</tt> - The list of formats in which the parameters wrapper
      #   will be enabled.
      # * <tt>:only</tt> - The list of attribute names which parameters wrapper
      #   will wrap into a nested hash.
      # * <tt>:except</tt> - The list of attribute names which parameters wrapper
      #   will exclude from a nested hash.
      def wrap_parameters(name_or_model_or_options, options = {})
        model = nil

        case name_or_model_or_options
        when Hash
          options = name_or_model_or_options
        when false
          options = options.merge(:format => [])
        when Symbol, String
          options = options.merge(:name => name_or_model_or_options)
        else
          model = name_or_model_or_options
        end

        _set_wrapper_defaults(_wrapper_options.slice(:format).merge(options), model)
      end

      # Sets the default wrapper key or model which will be used to determine
      # wrapper key and attribute names. Will be called automatically when the
      # module is inherited.
      def inherited(klass)
        if klass._wrapper_options[:format].present?
          klass._set_wrapper_defaults(klass._wrapper_options)
        end
        super
      end

      protected

      # Determine the wrapper model from the controller's name. By convention,
      # this could be done by trying to find the defined model that has the
      # same singularize name as the controller. For example, +UsersController+
      # will try to find if the +User+ model exists.
      def _default_wrap_model
        model_name = self.name.sub(/Controller$/, '').singularize

        begin
          model_klass = model_name.constantize
        rescue NameError => e
          unscoped_model_name = model_name.split("::", 2).last
          break if unscoped_model_name == model_name
          model_name = unscoped_model_name
        end until model_klass

        model_klass
      end

      def _set_wrapper_defaults(options, model=nil)
        options = options.dup

        unless options[:only] || options[:except]
          model ||= _default_wrap_model
          if model.respond_to?(:column_names)
            options[:only] = model.column_names
          end
        end

        unless options[:name]
          model ||= _default_wrap_model
          options[:name] = model ? model.to_s.demodulize.underscore :
            controller_name.singularize
        end

        options[:only]   = Array.wrap(options[:only]).collect(&:to_s)   if options[:only]
        options[:except] = Array.wrap(options[:except]).collect(&:to_s) if options[:except]
        options[:format] = Array.wrap(options[:format])

        self._wrapper_options = options
      end
    end

    # Performs parameters wrapping upon the request. Will be called automatically
    # by the metal call stack.
    def process_action(*args)
      if _wrapper_enabled?
        wrapped_hash = _wrap_parameters request.request_parameters
        wrapped_filtered_hash = _wrap_parameters request.filtered_parameters

        # This will make the wrapped hash accessible from controller and view
        request.parameters.merge! wrapped_hash
        request.request_parameters.merge! wrapped_hash

        # This will make the wrapped hash displayed in the log file
        request.filtered_parameters.merge! wrapped_filtered_hash
      end
      super
    end

    private

      # Returns the wrapper key which will use to stored wrapped parameters.
      def _wrapper_key
        _wrapper_options[:name]
      end

      # Returns the list of enabled formats.
      def _wrapper_formats
        _wrapper_options[:format]
      end

      # Returns the list of parameters which will be selected for wrapped.
      def _wrap_parameters(parameters)
        value = if only = _wrapper_options[:only]
          parameters.slice(*only)
        else
          except = _wrapper_options[:except] || []
          parameters.except(*(except + EXCLUDE_PARAMETERS))
        end

        { _wrapper_key => value }
      end

      # Checks if we should perform parameters wrapping.
      def _wrapper_enabled?
        ref = request.content_mime_type.try(:ref)
        _wrapper_formats.include?(ref) && !request.request_parameters[_wrapper_key]
      end
  end
end
