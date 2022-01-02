# Include the recipe to install the gems
include_recipe 'acme'

# Set up contact information. Note the mailto: notation
node.set['acme']['contact'] = [ 'mailto:ascorbic@gmail.com' ] 
# Real certificates please...
node.set['acme']['endpoint'] = 'https://acme-v01.api.letsencrypt.org' 

site="beetight.com"
sans=Array[ "www.#{site}" ]

# Set up your server here...

# Generate a self-signed if we don't have a cert to prevent bootstrap problems
# /etc/letsencrypt/live/beetight.com/cert.pem
acme_selfsigned "#{site}" do
    crt     "/etc/letsencrypt/live/#{site}/cert.pem"
    key     "/etc/letsencrypt/live/#{site}/privkey.pem"
    chain    "/etc/letsencrypt/live/#{site}/chain.pem"
    fullchain    "/etc/letsencrypt/live/#{site}/fullchain.pem"
    owner   "apache"
    group   "apache"
    notifies :restart, "service[apache2]", :immediate
    not_if do
        # Only generate a self-signed cert if needed
        ::File.exists?("/etc/letsencrypt/live/#{site}/cert.pem")
    end
end

# Get and auto-renew the certificate from Let's Encrypt
acme_certificate "#{site}" do
    crt     "/etc/letsencrypt/live/#{site}/cert.pem"
    key     "/etc/letsencrypt/live/#{site}/privkey.pem"
    chain    "/etc/letsencrypt/live/#{site}/chain.pem"
    fullchain    "/etc/letsencrypt/live/#{site}/fullchain.pem"
    method   "http"
    wwwroot  "/srv/www/beetight/current/app/webroot/"
    notifies :restart, "service[apache2]"
    alt_names sans
end