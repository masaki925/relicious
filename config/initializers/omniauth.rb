Rails.application.config.middleware.use OmniAuth::Builder do
  scope = 'read_stream, publish_stream, user_photos'
  #ca_file_centos = "/etc/pki/tls/certs/ca-bundle.crt"
  #ca_file_ubuntu = "/etc/ssl/certs"
  ca_file_mac     = "/System/Library/OpenSSL/certs"

  # relicious
  ### localhost:3000
  provider :facebook, '248317365210855', 'c7460cabf9b7487980c88a36e7cc4354', {
    :scope => scope,
    :client_options => {:ssl => {:ca_file => ca_file_mac }}
  }
end

