require 'pry'

namespace :seed do
  desc "load postgres .dump file"
  task :load_dump, [:file] do |_, dump|
    load_dump("#{dump[:file]}.dump")
  end
end

def load_dump(dump_file)
  db = Rails.configuration.database_configuration['development']['database']
  `pg_restore --verbose --clean -d #{db} < #{File.join(Rails.root, 'db/dumps', dump_file)}`
end
