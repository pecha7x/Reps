class Answer < BaseModel
  field :answers, type: Array, default: [];

  belongs_to :report
  belongs_to :question

end


