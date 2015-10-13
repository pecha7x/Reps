class Question < BaseModel
  field :text, type: String

  has_many :answers
end

