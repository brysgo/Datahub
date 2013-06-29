class Project < ActiveRecord::Base
  serialize :saved_state

  has_many :project_dependencies, class_name: 'Dependency', foreign_key: 'dependent_id'
  has_many :dependencies, through: :project_dependencies, source: :dependency

  has_many :dependent_projects, class_name: 'Dependency', foreign_key: 'dependency_id'
  has_many :dependents, through: :dependent_projects, source: :dependent

  accepts_nested_attributes_for :dependencies
  accepts_nested_attributes_for :dependents

  def emit(data)
    self.dependents.each do |dependent|
      dependent.incoming(self.id, data)
    end
  end

  def incoming(dep, data)
    # compile the coffeescript
    context = ExecJS.compile(CoffeeScript.compile(<<-COFFEESCRIPT))
      results =
        emitted: []
        saved: undefined
      @emit = (data) -> results.emitted.push(data)
      @run = (args...) ->
        results.saved = (#{self.logic_code.lstrip})(args...)
        return results
    COFFEESCRIPT
    # run javascript code
    results = context.call('run', dep, data, self.reload.saved_state)
    # save the saved states
    self.update_attribute(:saved_state, results['saved'])
    # emit once for each result
    results['emitted'].each do |result|
      self.emit(result)
    end
  end

end

