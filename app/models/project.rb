class Project < ActiveRecord::Base
  serialize :saved_state
  serialize :failure

  has_many :project_dependencies, class_name: 'Dependency', foreign_key: 'dependent_id'
  has_many :dependencies, through: :project_dependencies, source: :dependency

  has_many :dependent_projects, class_name: 'Dependency', foreign_key: 'dependency_id'
  has_many :dependents, through: :dependent_projects, source: :dependent

  accepts_nested_attributes_for :dependencies
  accepts_nested_attributes_for :dependents

  before_save :check_if_code_changed

  def check_if_code_changed
    if self.logic_code_changed?
      self.failure = ""
    end
  end

  def emit(data)
    self.dependents.each do |dependent|
      dependent.incoming(self.id, data)
    end
  end

  def incoming(dep, data)
    return if self.reload.failure.is_a? Exception
    begin
      # compile the coffeescript
      context = ExecJS.compile(CoffeeScript.compile(<<-COFFEESCRIPT))
      results =
        emitted: []
        saved: undefined
      @emit = (data) -> results.emitted.push(data)
      @run = (args...) ->
        results.saved = (
#{self.logic_code.indent(10)}
        )(args...)
        return results
      COFFEESCRIPT
      # run javascript code
      results = context.call('run', dep, data, self.reload.saved_state)
    rescue Exception => e
      self.failure = e
      self.save!
    end
    if results.present?
      # save the saved states
      self.update_attribute(:saved_state, results['saved'])
      # emit once for each result
      results['emitted'].each do |result|
        self.emit(result)
      end
    end
  end
end

