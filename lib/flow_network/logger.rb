module FlowNetwork
  module Logger

    #def enable_trace( it )
    #  @tracing ||= {}
    #  @tracing[ it ] = true
    #end

    private

    def trace( it, *args )
      method = caller[0] =~ /`(.*)'/ && $1 # extract "foo" from /path/file.rb:1:in `foo'
      message = ( [ it ] + [ method ] + args ).map( &:to_s ).join(" ")
      puts( message )
    end

  end
end
