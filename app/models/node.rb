class Node
  include Mongoid::Document
  include Mongoid::Timestamps

  field :n, as: :name, type: String
  field :p, as: :path, type: String # like 'a/b/c', must be unique

  has_many :children, class_name: "Node", inverse_of: :parent
  belongs_to :parent, class_name: "Node", inverse_of: :children
end