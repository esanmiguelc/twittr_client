class MockInteractor

  def execute(on_success)
    on_success.call
  end
end
