begin
require 'rails/railtie'
rescue LoadError
else

class GlobalID
  # = GlobalID Railtie
  # Set up the signed GlobalID verifier and include Active Record support.
  class Railtie < Rails::Railtie # :nodoc:
    config.global_id = ActiveSupport::OrderedOptions.new

    initializer 'global_id' do |app|
      require 'global_id'

      options = app.config.global_id
      options.app ||= Rails.application.railtie_name.remove('_application')
      GlobalID.app = options.app

      config.after_initialize do
        options.verifier ||= app.message_verifier(:signed_global_ids)
        SignedGlobalID.verifier = options.verifier
      end

      ActiveSupport.on_load(:active_record) do
        require 'global_id/identification'
        send :include, GlobalID::Identification
      end
    end
  end
end

end
