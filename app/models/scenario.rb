class Scenario
  def initialize(filename)
    @filename = filename
  end

  def name
    File.basename(@filename).sub(/\.scenario$/,'')
  end

  def to_param
    name
  end
  
  def self.all
    Dir[File.join(RAILS_ROOT, 'scenarios', '*.scenario')].map {|x| new(x) }
  end

  def self.find(filename)
    Dir[File.join(RAILS_ROOT, 'scenarios', "#{filename}.scenario")].map {|x| new(x) }.first
  end

  def contents
    @contents ||= File.read(@filename)
  end
end
