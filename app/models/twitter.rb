class Twitter < Project
  acts_as_singleton
  after_initialize :setup_model_attributes

  def setup_model_attributes
    self.title = 'Twitter'
  end

end
