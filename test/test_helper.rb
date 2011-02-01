def require_paths( *paths )
  paths.each { |path| $LOAD_PATH << path if ! $LOAD_PATH.member?( path ) }
end

require_paths "#{File.dirname(__FILE__)}"

require "minitest/autorun"
