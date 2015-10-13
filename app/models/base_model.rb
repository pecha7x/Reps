class BaseModel
  include Mongoid::Document

  def as_json(options={})
    attrs = super(options)
    attrs["id"] = attrs["_id"]
    attrs
  end
end