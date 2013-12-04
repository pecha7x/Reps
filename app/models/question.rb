class Question
  include Mongoid::Document
  def as_json(options={})
    attrs = super(options)
    attrs["id"] = attrs["_id"]
    attrs
  end

  field :text, type: String

  has_many :answers
end

