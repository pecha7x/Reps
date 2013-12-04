class Answer
  include Mongoid::Document
  def as_json(options={})
    attrs = super(options)
    attrs["id"] = attrs["_id"]
    attrs
  end

  field :answers, type: Array, default: [];

  belongs_to :report
  belongs_to :question

end


