load 'lib/languages/java_ant_log_file_analyzer.rb'
load 'lib/languages/java_maven_log_file_analyzer.rb'
load 'lib/languages/java_gradle_log_file_analyzer.rb'

# A wrapper that decides what is the correct sub Java analyzer to call by quickly browsing through its contents.
# This has minimal overhead compared to directly calling the correct sub analyzer through lazy initializing the
# loaded file, and is far better than trying every existing sub-analyzer and seeing which one worked
module JavaLogFileAnalyzerDispatcher

  def init
    if @logFile.scan(/(Reactor Summary|mvn test)/m).size >= 2
      self.extend JavaMavenLogFileAnalyzer
    elsif @logFile.scan(/gradle/m).size >= 2
      self.extend JavaGradleLogFileAnalyzer
    elsif @logFile.scan(/ant/m).size >= 2
      self.extend JavaAntLogFileAnalyzer
    else
      # default back to Ant if nothing else found
      self.extend JavaAntLogFileAnalyzer
    end

    init_deep
  end
end