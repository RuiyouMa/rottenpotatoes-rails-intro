class Movie < ActiveRecord::Base
  def self.ratings()
    to_return = ['G','PG','PG-13','R', 'NC-17']
  end 
end
