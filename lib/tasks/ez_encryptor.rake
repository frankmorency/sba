namespace :ez_encryptor do
  desc "Generate the Secrets for ENV file in production."
  task generate_secrets: :environment do
    puts EzEncryptor.generate_secrets
  end
end