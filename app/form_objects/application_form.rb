# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::API
  include ActiveModel::Attributes

  define_callbacks :save, only: :after
  define_callbacks :commit, only: :after

  class << self
    def after_save(...)
      set_callback(:save, :after, ...)
    end

    def after_commit(...)
      set_callback(:commit, :after, ...)
    end

    def model_name
      @model_name ||= ActiveModel::Name.new(
        nil, nil, name.sub(/Form$/, '')
      )
    end

    def model_name=(name)
      @model_name = ActiveModel::Name.new(nil, nil, name)
    end

    delegate :from, :for, to: :new
  end

  delegate :model_name, to: :class
  delegate :persisted?, :id, to: :model, allow_nil: true

  def model = nil

  def from(params)
    attr_list = self.class.attribute_names.map(&:to_sym)
    assign_attributes(params.permit(*attr_list))
    self
  end

  def for(model)
    assign_model(model)
    self
  end

  def save
    return false unless valid?

    with_transaction do
      AfterCommitEverywhere.after_commit { run_callbacks(:commit) }
      run_callbacks(:save) { submit! }
    end
  end

  def merge_errors!(other)
    other.errors.each do |e|
      errors.add(e.attribute, e.type, message: e.message)
    end
  end

  private

  def with_transaction(&)
    ApplicationRecord.transaction(&)
  end

  def submit!
    raise NotImplementedError
  end

  def assign_model(_model)
    raise NotImplementedError
  end
end
