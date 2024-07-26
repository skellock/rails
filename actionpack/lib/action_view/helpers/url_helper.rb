module ActionView
  module Helpers
    # Provides a set of methods for making easy links and getting urls that depend on the controller and action. This means that
    # you can use the same format for links in the views that you do in the controller. The different methods are even named
    # synchronously, so link_to uses that same url as is generated by url_for, which again is the same url used for
    # redirection in redirect_to.
    module UrlHelper
      # Creates a link tag of the given +name+ using an URL created by the set of +options+. See the valid options in
      # link:classes/ActionController/Base.html#M000021
      def link_to(name, options = {}, html_options = {}, *parameters_for_method_reference)
        content_tag("a", name, html_options.merge({ "href" => url_for(options, *parameters_for_method_reference) }))
      end

      # Returns the URL for the set of +options+ provided. See the valid options in link:classes/ActionController/Base.html#M000021
      def url_for(options = {}, *parameters_for_method_reference)
        if Hash === options then options = { :only_path => true }.merge(options) end
        @controller.send(:url_for, options, *parameters_for_method_reference).gsub("&", "&amp;")
      end
    end
  end
end