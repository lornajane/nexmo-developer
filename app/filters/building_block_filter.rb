class BuildingBlockFilter < Banzai::Filter
  def call(input)
    input.gsub(/```single_building_block(.+?)```/m) do |_s|
      config = YAML.safe_load($1)

      @renderer = get_renderer(config['language'])

      lexer = CodeLanguageResolver.find(config['language']).lexer

      application_html = generate_application_block(config['application'])

      # Read the client
      if config['client']
        highlighted_client_source = generate_code_block(config['language'], config['client'], config['unindent'])
      end

      # Read the code
      highlighted_code_source = generate_code_block(config['language'], config['code'], config['unindent'])

      dependency_html = ''
      if config['dependencies']
        dependency_html = generate_dependencies(lexer.tag, config['dependencies'])
      end

      source_url = generate_source_url(config['code'])

      client_html = ''
      if highlighted_client_source
        client_url = generate_source_url(config['client'])
        id = SecureRandom.hex
        erb = File.read("#{Rails.root}/app/views/building_blocks/_configure_client.html.erb")
        client_html = ERB.new(erb).result(binding)
      end

      erb = File.read("#{Rails.root}/app/views/building_blocks/_write_code.html.erb")
      code_html = ERB.new(erb).result(binding)

      run_html = @renderer.run_command(config['run_command'], config['file_name'])

      prereqs = (application_html + dependency_html + client_html).strip
      prereqs = "<h2>Prerequisites</h2>#{prereqs}" unless prereqs.empty?
      prereqs + code_html + run_html
    end
  end

  private

  def highlight(source, lexer)
    formatter = Rouge::Formatters::HTML.new
    formatter.format(lexer.lex(source))
  end

  def generate_code_block(language, input, unindent)
    filename = "#{Rails.root}/#{input['source']}"
    return '' unless input
    raise "BuildingBlockFilter - Could not load #{filename} for language #{language}" unless File.exist?(filename)

    code = File.read(filename)
    lexer = CodeLanguageResolver.find(language).lexer

    total_lines = code.lines.count

    # Minus one since lines are not zero-indexed
    from_line = (input['from_line'] || 1) - 1
    to_line = (input['to_line'] || total_lines) - 1

    code = code.lines[from_line..to_line].join
    code.unindent! if unindent

    highlight(code, lexer)
  end

  def get_renderer(language)
    language = 'dotnet' if language == 'csharp'
    case language
    when 'curl'
      BuildingBlockRenderer::Curl
    when 'node'
      BuildingBlockRenderer::Javascript
    when 'javascript'
      BuildingBlockRenderer::Javascript
    when 'java'
      BuildingBlockRenderer::Java
    when 'dotnet'
      BuildingBlockRenderer::Dotnet
    when 'python'
      BuildingBlockRenderer::Python
    when 'ruby'
      BuildingBlockRenderer::Ruby
    when 'php'
      BuildingBlockRenderer::Php
    else
      raise "Unknown language: #{language}"
    end
  end

  def generate_dependencies(language, dependencies)
    deps = @renderer.dependencies(dependencies)
    id = SecureRandom.hex
    erb = File.read("#{Rails.root}/app/views/building_blocks/_dependencies.html.erb")
    ERB.new(erb).result(binding)
  end

  def generate_application_block(app)
    return '' unless app
    app['name'] = 'ExampleVoiceProject' unless app['name']

    base_url = 'http://demo.ngrok.io'
    base_url = 'https://example.com' if app['disable_ngrok']

    app['event_url'] = "#{base_url}/webhooks/events" unless app['event_url']
    app['answer_url'] = "#{base_url}/webhooks/answer" unless app['answer_url']

    id = SecureRandom.hex

    erb = File.read("#{Rails.root}/app/views/building_blocks/_application.html.erb")
    ERB.new(erb).result(binding)
  end

  def generate_source_url(code)
    # Source example: .repos/nexmo-community/java-quickstart/ExampleClass.java
    # Direct link on GitHub is in form https://github.com/nexmo-community/java-quickstart/blob/master/ExampleClass.java
    start_section = 'https://github.com'

    # Insert "blob/master" and strip ".repos" - except dotnet that needs "blob/ASPNET" instead
    repo_path = '\\0blob/master/'
    repo_path = '\\0blob/ASPNET/' if code['source'].include?('dotnet')
    file_section = code['source'].sub('.repos', '').sub(%r{(-quickstart|-building-blocks)/}, repo_path)

    # Line highlighting
    line_section = ''
    if code['from_line']
      line_section += "#L#{code['from_line']}"
      if code['to_line']
        # If we've provided a to_line, use that
        line_section += "-L#{code['to_line']}" if code['to_line']
      else
        # By default we read to the end of the file
        line_section += "-L#{File.read(code['source']).lines.count}"
      end
    end

    start_section + file_section + line_section
  end
end
