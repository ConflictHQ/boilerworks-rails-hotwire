module Versionable
  extend ActiveSupport::Concern
  # lock_version column is automatically managed by ActiveRecord's optimistic locking
end
