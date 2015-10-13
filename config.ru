require 'rack/cors'
require ::File.expand_path('../config/environment', __FILE__)

run Rails.application
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end