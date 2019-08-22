require_relative '04_associatable2.rb'

class Cat < SQLObject
      belongs_to :human, foreign_key: :owner_id
      has_one_through :house, :human, :house

      finalize!
end


class Human < SQLObject
    self.table_name = 'humans'

    has_many :cats, foreign_key: :owner_id
    belongs_to :house

    finalize!
end


class House < SQLObject
    has_many :humans
    has_many_through :cats, :humans, :cats
    
    finalize!
end