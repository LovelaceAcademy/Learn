require 'slim'

DEFAULT_TEMPLATE = 'template.slim'

module Jekyll
  module Simple
    module Tab
      class TabsBlock < Liquid::Block
        def initialize(tag, args, _)
          super

          raise SyntaxError.new("#{tag} requires name") if args.empty?

          @tab_name = args.strip
        end

        def template_path(template_name)
          dir = File.dirname(__FILE__)
          File.join(dir, template_name.to_s)
        end

        def render(context)
          @environment = context.environments.first
          super

          templateFilePath = template_path(DEFAULT_TEMPLATE)
          template = Slim::Template.new(templateFilePath)
          template.render(self)
        end
      end

      class TabBlock < Liquid::Block
        def initialize(tag, args, _)
          super

          @tabs_group, @tab = split_params(args.strip)
          raise SyntaxError.new("Block #{tag} requires tabs name") if @tabs_group.empty? || @tab.empty?
        end

        def render(context)
          site = context.registers[:site]
          converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
          content = converter.convert(super)

          environment = context.environments.first
          environment["tabs-#{@tabs_group}"] ||= {}
          environment["tabs-#{@tabs_group}"][@tab] = content
        end

        private

        def split_params(params)
          params.split('#')
        end
      end
    end
  end
end

Liquid::Template.register_tag('tabs', Jekyll::Simple::Tab::TabsBlock)
Liquid::Template.register_tag('tab', Jekyll::Simple::Tab::TabBlock)
