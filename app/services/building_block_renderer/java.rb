module BuildingBlockRenderer
  class Java
    def self.dependencies(deps)
      {
          'text' => 'Add the following to <code>build.gradle</code>:',
          'code' => deps.map { |d| "compile '#{d}'" }.join('<br />'),
      }
    end

    def self.run_command(_command, filename)
      <<~HEREDOC
        ## Run your code
        We can use the `application` plugin for Gradle to simplify the running of our application.
         Update your `build.gradle` with the following:

         ```groovy
        apply plugin: 'application'
        mainClassName = project.hasProperty('main') ? project.getProperty('main') : ''
        ```

         Run the following command to execute your application replacing `com.nexmo.quickstart.voice` with the package containing `#{filename.gsub('.java', '')}`:

         ```sh
        gradle run -Pmain=com.nexmo.quickstart.voice.#{filename.gsub('.java', '')}
        ```

      HEREDOC
    end
  end
end
